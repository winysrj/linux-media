Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:38870 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab1HaMBL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 08:01:11 -0400
Message-ID: <4E5E2283.9030100@mlbassoc.com>
Date: Wed, 31 Aug 2011 06:01:07 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: Getting started with OMAP3 ISP
References: <4E56734A.3080001@mlbassoc.com> <201108311013.52490.laurent.pinchart@ideasonboard.com> <4E5E135D.1010500@mlbassoc.com> <201108311300.30808.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108311300.30808.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-08-31 05:00, Laurent Pinchart wrote:
> Hi Gary,
>
> On Wednesday 31 August 2011 12:56:29 Gary Thomas wrote:
>> On 2011-08-31 02:13, Laurent Pinchart wrote:
>>> On Wednesday 31 August 2011 02:07:36 Gary Thomas wrote:
>>>> On 2011-08-30 16:50, Laurent Pinchart wrote:
>>>>> On Wednesday 31 August 2011 00:45:39 Gary Thomas wrote:
>>>>>> On 2011-08-29 04:49, Laurent Pinchart wrote:
>>>>>>> On Thursday 25 August 2011 18:07:38 Gary Thomas wrote:
>>>>>>>> Background:  I have working video capture drivers based on the
>>>>>>>> TI PSP codebase from 2.6.32.  In particular, I managed to get
>>>>>>>> a driver for the TVP5150 (analogue BT656) working with that kernel.
>>>>>>>>
>>>>>>>> Now I need to update to Linux 3.0, so I'm trying to get a driver
>>>>>>>> working with the rewritten ISP code.  Sadly, I'm having a hard
>>>>>>>> time with this - probably just missing something basic.
>>>>>>>>
>>>>>>>> I've tried to clone the TVP514x driver which says that it works
>>>>>>>> with the OMAP3 ISP code.  I've updated it to use my decoder device,
>>>>>>>> but I can't even seem to get into that code from user land.
>>>>>>>>
>>>>>>>> Here are the problems I've had so far:
>>>>>>>>        * udev doesn't create any video devices although they have
>>>>>>>>        been
>>>>>>>>
>>>>>>>>          registered.  I see a full set in /sys/class/video4linux
>>>>>>>>
>>>>>>>>             # ls /sys/class/video4linux/
>>>>>>>>             v4l-subdev0  v4l-subdev3  v4l-subdev6  video1
>>>>>>>>             video4 v4l-subdev1  v4l-subdev4  v4l-subdev7  video2
>>>>>>>>               video5 v4l-subdev2  v4l-subdev5  video0       video3
>>>>>>>>                 video6
>>>>>>>
>>>>>>> It looks like a udev issue. I don't think that's related to the
>>>>>>> kernel drivers.
>>>>>>>
>>>>>>>>          Indeed, if I create /dev/videoX by hand, I can get
>>>>>>>>          somewhere, but I don't really understand how this is
>>>>>>>>          supposed to work. e.g.
>>>>>>>>
>>>>>>>>            # v4l2-dbg --info /dev/video3
>>>>>>>>
>>>>>>>>            Driver info:
>>>>>>>>                Driver name   : ispvideo
>>>>>>>>                Card type     : OMAP3 ISP CCP2 input
>>>>>>>>                Bus info      : media
>>>>>>>>                Driver version: 1
>>>>>>>>                Capabilities  : 0x04000002
>>>>>>>>
>>>>>>>>                        Video Output
>>>>>>>>                        Streaming
>>>>>>>>
>>>>>>>>        * If I try to grab video, the ISP layer gets a ton of
>>>>>>>>        warnings, but
>>>>>>>>
>>>>>>>>          I never see it call down into my driver, e.g. to check the
>>>>>>>>          current format, etc.  I have some of my own code from before
>>>>>>>>          which fails miserably (not a big surprise given the hack
>>>>>>>>          level of those programs).
>>>>>>>>
>>>>>>>>          I tried something off-the-shelf which also fails pretty bad:
>>>>>>>>            # ffmpeg -t 10 -f video4linux2 -s 720x480 -r 30 -i
>>>>>>>>            /dev/video2
>>>>>>>>
>>>>>>>> junk.mp4
>>>>>>>>
>>>>>>>> I've read through Documentation/video4linux/omap3isp.txt without
>>>>>>>> learning much about what might be wrong.
>>>>>>>>
>>>>>>>> Can someone give me some ideas/guidance, please?
>>>>>>>
>>>>>>> In a nutshell, you will first have to configure the OMAP3 ISP
>>>>>>> pipeline, and then capture video.
>>>>>>>
>>>>>>> Configuring the pipeline is done through the media controller API and
>>>>>>> the V4L2 subdev pad-level API. To experiment with those you can use
>>>>>>> the media-ctl command line application available at
>>>>>>> http://git.ideasonboard.org/?p=media- ctl.git;a=summary. You can run
>>>>>>> it with --print-dot and pipe the result to dot -Tps to get a
>>>>>>> postscript graphical view of your device.
>>>>>>>
>>>>>>> Here's a sample pipeline configuration to capture scaled-down YUV
>>>>>>> data from a sensor:
>>>>>>>
>>>>>>> ./media-ctl -r -l '"mt9t001 3-005d":0->"OMAP3 ISP CCDC":0[1], "OMAP3
>>>>>>> ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3
>>>>>>> ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer
>>>>>>> output":0[1]' ./media-ctl -f '"mt9t001 3-005d":0[SGRBG10 1024x768],
>>>>>>> "OMAP3 ISP CCDC":2[SGRBG10 1024x767], "OMAP3 ISP preview":1[YUYV
>>>>>>> 1006x759], "OMAP3 ISP resizer":1[YUYV 800x600]'
>>>>>>>
>>>>>>> After configuring your pipeline you will be able to capture video
>>>>>>> using the V4L2 API on the device node at the output of the pipeline.
>>>>>>
>>>>>> Getting somewhere now, thanks.  When I use this full pipeline, I can
>>>>>> get all the way into my driver where it's trying to start the data.
>>>>>>
>>>>>> What if I want to use less of the pipeline?  For example, I'd normally
>>>>>> be happy with just the CCDC output.  How would I do that?
>>>>>
>>>>> Then connect CCDC's pad 1 to the CCDC output video node and capture on
>>>>> that video node.
>>>>>
>>>>>> What pixel format would I use with ffmpeg?
>>>>>
>>>>> What does your subdev deliver ?
>>>>
>>>> It's a BT656 encoder - 8-bit UYVY 4:2:2
>>>
>>> Then you will first have to add YUV support to the CCDC. It wouldn't be
>>> fun if it worked out of the box, would it ? :-)
>>
>> So, functionality that was present in 2.6.32 (TI PSP version at least)
>> is not currently available?
>
> That's right. You can blame TI for not pushing it to mainline :-)
>

Is this only important if I want to push data past the CCDC?  In the past, we were
happy with just using the CCDC like a frame grabber which delivered YUV data to memory
[raw data from /dev/videoN]  Is this possible with the CCDC support as is?  The only
discussion I could find about this on this list was in early March 2011 and I think
you implied that it should work. I'm a bit concerned that it won't as the BT656 data
has embedded syncs that the CCDC needs to be set up for.

I saw a reference to 'Add YUV support to CCDC' on 2010-11-15, but no followup.
That work seemed to be for a much older driver and not applicable to the current
work, or am I missing something?

Has there been other discussion on this topic (I didn't see it in onthis list which
I've been quietly monitoring for two years)?  Is the lack of YUV support in CCDC
for this current driver (drivers/media/video/omap3isp) a concious decision, or just
a lack of movement?  Is there someone at TI that I should contact?

I'm just trying to understand what I have to do to move forward on this.  I really
hadn't planned/scheduled a large effort to recreate functionality that we've already
been using for years when we moved to a newer kernel.

That said though I can see that this new driver structure (with the flexible elements
and connections, etc) is a vast improvement on the old, hard-wired stuff.  I only hope
I can figure out how to make it work with my sensor.

Thanks

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
