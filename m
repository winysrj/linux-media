Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:40422 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737Ab2BTFDr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 00:03:47 -0500
Received: by mail-qw0-f54.google.com with SMTP id a17so6035033qae.20
        for <linux-media@vger.kernel.org>; Sun, 19 Feb 2012 21:03:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANMsd0272pwvdd35QJGpDJLH=MtMdXxHYygXdL_PSaPHpav2Xg@mail.gmail.com>
References: <CANMsd02vLtdmrV-eHuBJ4SAc6PiYG8tw1+OvSXYAJ83zcoe7Hw@mail.gmail.com>
 <2215470.hR2vMaHYCK@avalon> <CANMsd03DFeLKWCHYAyQmuiCsBwmXGisOmt7OrAvR0=RDrdh3RA@mail.gmail.com>
 <CANMsd0272pwvdd35QJGpDJLH=MtMdXxHYygXdL_PSaPHpav2Xg@mail.gmail.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Sun, 19 Feb 2012 23:03:26 -0600
Message-ID: <CAKnK67SorCABsq7MiNiCe6X59osfwrmWLj9d1oVvdOehjar1qQ@mail.gmail.com>
Subject: Re: omap4 v4l media-ctl usage
To: Ryan <ryanphilips19@googlemail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

H Ryan,

On Sun, Feb 19, 2012 at 10:04 AM, Ryan <ryanphilips19@googlemail.com> wrote:
> Hi Laurent,
>
> It actually blocks at VIDIOC_DQBUF ioctl and not in STREAMON ioctl.
> Looks like the data is not available.
>
> Any way of verifying if OMAP is receiving data. Wonder why i keep
> interrupts though?

Can you try again after cherry-picking these 3 commits?:

7ea3af1 ov5640: Move initial config to registering callback
dbe85fd ov5640: Fix s_fmt behaviour
522e30a panda: camera: Fix ddr_freq for OV5640 selection

I'll suggest you to try keeping on latest "devel" branch head, since
there's many fixes and cleanups I have been pushing in the tree.

Regards,
Sergio

> Is my media-ctl setting up things correctly?
>
> Thank you.
>
> Regards,
> Ryan
>
>
> On Sun, Feb 19, 2012 at 7:47 PM, Ryan <ryanphilips19@googlemail.com> wrote:
>> Hi Laurent,
>>
>> On Sun, Feb 19, 2012 at 2:27 PM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>>> Hi Ryan,
>>>
>>> On Saturday 18 February 2012 20:59:57 Ryan wrote:
>>>> hello,
>>>> I am using media-ctl on the panda board. The sensor gets detected. But
>>>> media-ctl doesnt print anything.
>>>> The kernel is cloned from omap4 v4l git tree: commit id:
>>>> 3bc023462a68f78bb0273848f5ab08a01b434ffa
>>>>
>>>> what could be wrong in here?
>>>>
>>>> ~ # ./media-ctl -p
>>>> Opening media device /dev/media0
>>>> Enumerating entities
>>>> Found 0 entities
>>>> Enumerating pads and links
>>>> Device topology
>>>>
>>>> What steps i need to follow get output from sensor in terms of
>>>> arguments to media-ctl and yavta.
>>>
>>> Could you please first make sure that media-ctl has be compiled against header
>>> files from the kernel running on your board ?
>>>
>>
>> Thank you, That did the trick, Now i am able to run media-ctl. I am
>> trying to capture YUV422.
>> When i run yavta, It blocks infinitely at STREAM ON, I see that the
>> ISS interrupts keeps incrementing.
>> Am i missing something?
>>
>> #yavta /dev/video0  -n1 -c5 -s640x480 -fUYVY -Ftest.yuv
>> Device /dev/video0 opened: OMAP4 ISS CSI2a output (media).
>> Video format set: width: 640 height: 480 buffer size: 614400
>> Video format: UYVY (59565955) 640x480
>> 1 buffers requested.
>> length: 614400 offset: 0
>> Buffer 0 mapped at address 0x4028e000.
>> [  577.605590] Enable STREAM ON>..
>>
>>
>> After configuring using the media-ctl, This is how my device topology
>> looks like:
>> Is this okay?
>>
>> Device topology
>> - entity 1: OMAP4 ISS CSI2a (2 pads, 2 links)
>>            type V4L2 subdev subtype Unknown
>>            device node name /dev/v4l-subdev0
>>        pad0: Sink [UYVY 640x480]
>>                <- "ov5640 3-0036":0 [ENABLED,IMMUTABLE]
>>        pad1: Source [UYVY 640x480]
>>                -> "OMAP4 ISS CSI2a output":0 [ENABLED]
>>
>> - entity 2: OMAP4 ISS CSI2a output (1 pad, 1 link)
>>            type Node subtype V4L
>>            device node name /dev/video0
>>        pad0: Sink
>>                <- "OMAP4 ISS CSI2a":1 [ENABLED]
>>
>> - entity 3: ov5640 3-0036 (1 pad, 1 link)
>>            type V4L2 subdev subtype Unknown
>>            device node name /dev/v4l-subdev1
>>        pad0: Source [UYVY 640x480]
>>                -> "OMAP4 ISS CSI2a":0 [ENABLED,IMMUTABLE]
>>
>>
>>
>> Thank you,
>>
>> Regards,
>> Ryan
>>
>>
>>> --
>>> Regards,
>>>
>>> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
