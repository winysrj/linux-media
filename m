Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:50089 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbeJXHwM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Oct 2018 03:52:12 -0400
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 01/16] media: imx: add mem2mem device
To: Philipp Zabel <pza@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>
CC: Tim Harvey <tharvey@gateworks.com>, <nicolas@ndufresne.ca>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
 <20180918093421.12930-2-p.zabel@pengutronix.de>
 <CAJ+vNU2vraT=vUwS+1TYKuX50OsjZsNaN220y1kz8XgHvC48Sg@mail.gmail.com>
 <1539942796.3395.8.camel@pengutronix.de>
 <1f090c65-342a-fb43-c274-935cbf78fdd4@gmail.com>
 <20181021174348.3gmiqtrboraknktn@pengutronix.de>
Message-ID: <e967a28c-320c-8f62-6b65-4a2804863a3b@mentor.com>
Date: Tue, 23 Oct 2018 16:23:56 -0700
MIME-Version: 1.0
In-Reply-To: <20181021174348.3gmiqtrboraknktn@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(resending as plain text)


On 10/21/18 10:43 AM, Philipp Zabel wrote:
> On Fri, Oct 19, 2018 at 01:19:10PM -0700, Steve Longerbeam wrote:
>> On 10/19/18 2:53 AM, Philipp Zabel wrote:
>>> Hi Tim,
>>>
>>> On Thu, 2018-10-18 at 15:53 -0700, Tim Harvey wrote:
>>> [...]
>>>> Philipp,
>>>>
>>>> Thanks for submitting this!
>>>>
>>>> I'm hoping this lets us use non-IMX capture devices along with the IMX
>>>> media controller entities to so we can use hardware
>>>> CSC,scaling,pixel-format-conversions and ultimately coda based encode.
>>>>
>>>> I've built this on top of linux-media and see that it registers as
>>>> /dev/video8 but I'm not clear how to use it? I don't see it within the
>>>> media controller graph.
>>> It's a V4L2 mem2mem device that can be handled by the GstV4l2Transform
>>> element, for example. GStreamer should create a v4l2video8convert
>>> element of that type.
>>>
>>> The mem2mem device is not part of the media controller graph on purpose.
>>> There is no interaction with any of the entities in the media controller
>>> graph apart from the fact that the IC PP task we are using for mem2mem
>>> scaling is sharing hardware resources with the IC PRP tasks used for the
>>> media controller scaler entitites.
>> It would be nice in the future to link mem2mem output-side to the ipu_vdic:1
>> pad, to make use of h/w VDIC de-interlace as part of mem2mem operations.
>> The progressive output from a new ipu_vdic:3 pad can then be sent to the
>> image_convert APIs by the mem2mem driver for further tiled scaling, CSC,
>> and rotation by the IC PP task. The ipu_vdic:1 pad makes use of pure
>> DMA-based de-interlace, that is, all input frames (N-1, N, N+1) to the
>> VDIC are sent from DMA buffers, and this VDIC mode of operation is
>> well understood and produces clean de-interlace output. The risk is
>> that this would require iDMAC channel 5 for ipu_vdic:3, which IFAIK is
>> not verified to work yet.
> Tiled mem2mem deinterlacing support would be nice, I'm not sure yet how
> though. I'd limit media controller links to marking VDIC as unavailable
> for the capture pipeline. The V4L2 subdev API is too lowlevel for tiling
> mem2mem purposes, as we'd need to change the subdev format multiple
> times per frame.


I wasn't considering tiled deinterlacing, only deinterlacing at the 
hardware limited input frame size to the VDIC.


> Also I'd like to keep the option of scheduling tile jobs to both IPUs on
> i.MX6Q, which will become difficult to describe via MC, as both IPUs'
> ipu_vdics would have to be involved.

Agreed, it would be good to add to the mem2mem driver the ability to 
schedule jobs to whichever IPU is least busy.


>> The other problem with that currently is that mem2mem would have to be split
>> into separate device nodes: a /dev/videoN for output-side (linked to
>> ipu_vdic:1), and a /dev/videoM for capture-side (linked from
>> ipu_vdic:3). And then it no longer presents to userspace as a mem2mem
>> device with a single device node for both output and capture sides.
> I don't understand why we'd need separate video devices for output and
> capture, deinterlacing is still single input single (double rate)
> output. As soon as we begin tiling, we are one layer of abstraction
> away from the hardware pads anyway. Now if we want to support combining
> on the other hand...


Again I wasn't thinking of doing tiled deinterlace.


>> Or is there another way? I recall work to integrate mem2mem with media
>> control. There is v4l2_m2m_register_media_controller(), but that
>> create three
>> entities:
>> source, processing, and sink. The VDIC entity would be part of mem2mem
>> processing but this entity already exists for the current graph. This
>> function could however be used as a guide to incorporate the VDIC
>> entity into m2m device.
> I'm not sure if this is the right abstraction. Without tiling or
> multi-IPU scheduling, sure. But the mem2mem driver does not directly
> describe hardware operation anyway.


What I'm thinking is separate mem2mem devices from this proposed 
tiled-scaling post-processing mem2mem, that solely do motion compensated 
deinterlace using the VDIC as the processing entity.

[1] is the dot graph that demonstrates the idea, on imx6q SabreSD. Two 
new mem2mem devices are attached to VDIC sink and source IDMAC pads. 
Also the PP tiled scaling mem2mem is shown in the graph.

As of now, the VDIC is only available for video capture pipelines, so 
the advantage would be to allow the use of hardware deinterlace 
gstreamer pipelines from other types of interlaced sources like file or 
network streams.

So something like the following example which would do hardware 
deinterlace, followed by tiled scaling/CSC/rotation, then h.264 encode, 
the VDIC mem2mem device is at /dev/video0, and the PP mem2mem device is 
at /dev/video12 in this example:

gst-launch-1.0 \
v4l2src ! \
v4l2video0convert output-io-mode=dmabuf-import ! \
v4l2video12convert output-io-mode=dmabuf-import ! \
v4l2h264enc output-io-mode=dmabuf-import ! \
h264parse ! \
matroskamux ! \
filesink

I'm probably missing some stream properties in that example, but you get 
the idea.

Steve

[1]

digraph board {
     rankdir=TB
     n00000001 [label="{{<port0> 0 | <port1> 1} | 
ipu1_vdic\n/dev/v4l-subdev0 | {<port2> 2 | <port3> 3}}", shape=Mrecord, 
style=filled, fillcolor=green]
     n00000001:port3 -> n00000008 [style=dashed]
     n00000001:port2 -> n00000021:port0 [style=dashed]
     n00000006 [label="ipu_vdic mem2mem-source\n/dev/video0", shape=box, 
style=filled, fillcolor=yellow]
     n00000006 -> n00000001:port1 [style=dashed]
     n00000008 [label="ipu_vdic mem2mem-sink\n/dev/video0", shape=box, 
style=filled, fillcolor=yellow]
     n00000011 [label="{{<port0> 0 | <port1> 1} | 
ipu2_vdic\n/dev/v4l-subdev1 | {<port2> 2 | <port3> 3}}", shape=Mrecord, 
style=filled, fillcolor=green]
     n00000011:port3 -> n00000018 [style=dashed]
     n00000011:port2 -> n00000037:port0 [style=dashed]
     n00000016 [label="ipu_vdic mem2mem-source\n/dev/video1", shape=box, 
style=filled, fillcolor=yellow]
     n00000016 -> n00000011:port1 [style=dashed]
     n00000018 [label="ipu_vdic mem2mem-sink\n/dev/video1", shape=box, 
style=filled, fillcolor=yellow]
     n00000021 [label="{{<port0> 0} | ipu1_ic_prp\n/dev/v4l-subdev2 | 
{<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
     n00000021:port1 -> n00000025:port0 [style=dashed]
     n00000021:port2 -> n0000002e:port0 [style=dashed]
     n00000025 [label="{{<port0> 0} | ipu1_ic_prpenc\n/dev/v4l-subdev3 | 
{<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
     n00000025:port1 -> n00000028 [style=dashed]
     n00000028 [label="ipu1_ic_prpenc capture\n/dev/video2", shape=box, 
style=filled, fillcolor=yellow]
     n0000002e [label="{{<port0> 0} | ipu1_ic_prpvf\n/dev/v4l-subdev4 | 
{<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
     n0000002e:port1 -> n00000031 [style=dashed]
     n00000031 [label="ipu1_ic_prpvf capture\n/dev/video3", shape=box, 
style=filled, fillcolor=yellow]
     n00000037 [label="{{<port0> 0} | ipu2_ic_prp\n/dev/v4l-subdev5 | 
{<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
     n00000037:port1 -> n0000003b:port0 [style=dashed]
     n00000037:port2 -> n00000044:port0 [style=dashed]
     n0000003b [label="{{<port0> 0} | ipu2_ic_prpenc\n/dev/v4l-subdev6 | 
{<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
     n0000003b:port1 -> n0000003e [style=dashed]
     n0000003e [label="ipu2_ic_prpenc capture\n/dev/video4", shape=box, 
style=filled, fillcolor=yellow]
     n00000044 [label="{{<port0> 0} | ipu2_ic_prpvf\n/dev/v4l-subdev7 | 
{<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
     n00000044:port1 -> n00000047 [style=dashed]
     n00000047 [label="ipu2_ic_prpvf capture\n/dev/video5", shape=box, 
style=filled, fillcolor=yellow]
     n0000004d [label="{{<port0> 0} | ipu1_csi0\n/dev/v4l-subdev8 | 
{<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
     n0000004d:port2 -> n00000051 [style=dashed]
     n0000004d:port1 -> n00000021:port0 [style=dashed]
     n0000004d:port1 -> n00000001:port0 [style=dashed]
     n00000051 [label="ipu1_csi0 capture\n/dev/video6", shape=box, 
style=filled, fillcolor=yellow]
     n00000057 [label="{{<port0> 0} | ipu1_csi1\n/dev/v4l-subdev9 | 
{<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
     n00000057:port2 -> n0000005b [style=dashed]
     n00000057:port1 -> n00000021:port0 [style=dashed]
     n00000057:port1 -> n00000001:port0 [style=dashed]
     n0000005b [label="ipu1_csi1 capture\n/dev/video7", shape=box, 
style=filled, fillcolor=yellow]
     n00000061 [label="{{<port0> 0} | ipu2_csi0\n/dev/v4l-subdev10 | 
{<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
     n00000061:port2 -> n00000065 [style=dashed]
     n00000061:port1 -> n00000037:port0 [style=dashed]
     n00000061:port1 -> n00000011:port0 [style=dashed]
     n00000065 [label="ipu2_csi0 capture\n/dev/video8", shape=box, 
style=filled, fillcolor=yellow]
     n0000006b [label="{{<port0> 0} | ipu2_csi1\n/dev/v4l-subdev11 | 
{<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
     n0000006b:port2 -> n0000006f [style=dashed]
     n0000006b:port1 -> n00000037:port0 [style=dashed]
     n0000006b:port1 -> n00000011:port0 [style=dashed]
     n0000006f [label="ipu2_csi1 capture\n/dev/video9", shape=box, 
style=filled, fillcolor=yellow]
     n00000075 [label="{{<port0> 0} | imx6-mipi-csi2\n/dev/v4l-subdev12 
| {<port1> 1 | <port2> 2 | <port3> 3 | <port4> 4}}", shape=Mrecord, 
style=filled, fillcolor=green]
     n00000075:port2 -> n00000057:port0 [style=dashed]
     n00000075:port3 -> n00000061:port0 [style=dashed]
     n00000075:port1 -> n0000007b:port0 [style=dashed]
     n00000075:port4 -> n0000007f:port0 [style=dashed]
     n0000007b [label="{{<port0> 0 | <port1> 1} | 
ipu1_csi0_mux\n/dev/v4l-subdev13 | {<port2> 2}}", shape=Mrecord, 
style=filled, fillcolor=green]
     n0000007b:port2 -> n0000004d:port0 [style=dashed]
     n0000007f [label="{{<port0> 0 | <port1> 1} | 
ipu2_csi1_mux\n/dev/v4l-subdev14 | {<port2> 2}}", shape=Mrecord, 
style=filled, fillcolor=green]
     n0000007f:port2 -> n0000006b:port0 [style=dashed]
     n00000083 [label="{{} | ov5640 1-003c\n/dev/v4l-subdev15 | {<port0> 
0}}", shape=Mrecord, style=filled, fillcolor=green]
     n00000083:port0 -> n00000075:port0 [style=dashed]
     n000000cf [label="ipu_ic_pp mem2mem-proc\n", shape=box, 
style=filled, fillcolor=yellow]
     n000000cf -> n000000d4 [style=bold]
     n000000d2 [label="ipu_ic_pp mem2mem-source\n/dev/video12", 
shape=box, style=filled, fillcolor=yellow]
     n000000d2 -> n000000cf [style=bold]
     n000000d4 [label="ipu_ic_pp mem2mem-sink\n/dev/video12", shape=box, 
style=filled, fillcolor=yellow]
}
