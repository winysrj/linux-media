Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:49495 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760181AbaGYVVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 17:21:12 -0400
Message-ID: <53D2CA45.6040001@mentor.com>
Date: Fri, 25 Jul 2014 14:21:09 -0700
From: Steve Longerbeam <steve_longerbeam@mentor.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/28] IPUv3 prep for video capture
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com> <53C7AF39.20608@xs4all.nl> <53C8359C.1030005@mentor.com> <351532437.crZknhrhTe@avalon>
In-Reply-To: <351532437.crZknhrhTe@avalon>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2014 06:17 AM, Laurent Pinchart wrote:
> Hi Steve,
>
> On Thursday 17 July 2014 13:44:12 Steve Longerbeam wrote:
>> On 07/17/2014 04:10 AM, Hans Verkuil wrote:
>>> Hi Steve,
>>>
>>> I don't know what your plan is, but when you want to mainline this it is
>>> the gpu subsystem that needs to review it. I noticed it wasn't
>>> cross-posted
>>> to the dri-devel mailinglist.
>> Hi Hans,
>>
>> I'm reworking these patches, I've merged in some of the changes
>> posted by Philip Zabel ("[RFC PATCH 00/26] i.MX5/6 IPUv3 CSI/IC"),
>> specifically I've decided to use their version of ipu-ic.c, and
>> also brought in their video-mux subdev driver. So I'm fine with
>> cancelling this patch set.
>>
>> When/if I post the reworked v4l2 drivers that implement the media
>> entity/device framework I will post the ipu-v3 specific changes
>> to dri-devel as well.
>>
>> The reason I like Philip's version of ipu-ic is that it implements
>> tiling to allow resizing output frames larger than 1024x1024. We
>> (Mentor Graphics) did the same IC tiling, but it was done inside
>> a separate mem2mem driver. By moving the tiling into ipu-ic, it
>> allows >1024x1024 resizing to be part of an imx-ipuv3-ic media
>> entity, and this entity can be part of multiple video pipelines
>> (capture, video output, mem2mem).
>>
>>> I am a bit worried about the amount of v4l2-specific stuff that is going
>>> into drivers/gpu/ipu-v3. Do things like csc and csi really belong there
>>> instead of under drivers/media?
>> The current philosophy of the ipu-v3 driver seems to be that it is a
>> library of IPU register-level primitives, so ipu-csi and ipu-ic follow
>> that model. There will be nothing v4l2-specific in ipu-csi and ipu-ic,
>> although the v4l2 subdev's will be the only clients of ipu-csi and
>> ipu-ic.

Hi Laurent,

> I have a bit of trouble following up, due to my lack of knowledge of the 
> Freescale platforms. It would help if you could explain briefly how the 
> various IPU modules interact with each other at the hardware and software 
> level, and what the acronyms stand for (I assume IPU means Image Processing 
> Unit, CSI means Camera Serial Interface, but I don't know what IC is in this 
> context).

Yes, IPU and CSI are acronyms as you describe. IC stands for Image
Converter. The IC carries out scaling, color-space conversion, and
rotation. The IC has three independent task sub-blocks that can carry
out those three operations concurrently using some kind of task time-
sharing mechanism. The three IC tasks are referred to as "pre-processing
for encode" (PRP ENC), "pre-processing for viewfinder" (PRP VF) and
"post-processing" (PP). So for example, a video capture pipeline could
be actively streaming the PRP ENC task while a mem2mem pipeline
could concurrently be using the PP task.

>
> Are the CSI receivers linked to the graphics IP cores at the hardware level ?]

Yes, the raw frames from the CSI can be directed to either memory, the
IC, or to a video deinterlacing controller (VDIC).

The IPU contains a custom DMA controller (the IDMAC). There is a set
of ~64 IDMAC channels that are dedicated to specific video pipelines.
IDMAC channels can be linked together in hardware (a frame-completion
signal from a source channel can trigger start of DMA in a sink channel).

Here is one example hardware video pipeline in i.MX6 (there are many
more). This example is to send raw interlaced frames from the CSI to
the VDIC, and then the progressive frames to IC PRP VF task for additional
scaling/CSC/rotation:

CSI0 --> VDIC --> IC PRP VF --- idmac channel 21 ---> memory


If you're interested in knowing more about the i.MX6 you can pick
up Freescale's TRM at:

http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=i.MX6Q&fpsp=1&tab=Documentation_Tab

The i.MX6 TRM is of poor quality, not good enough for actual register-level
programming in many areas, especially the IPU chapter. But good enough for
getting a general overview.

Steve

