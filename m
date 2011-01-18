Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41656 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1ARJUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 04:20:44 -0500
Received: by pzk35 with SMTP id 35so936624pzk.19
        for <linux-media@vger.kernel.org>; Tue, 18 Jan 2011 01:20:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101141801.01125.laurent.pinchart@ideasonboard.com>
References: <AANLkTimec2+VyO+iRSx1PYy3btOb6RbHt0j3ytmnykVo@mail.gmail.com>
	<201101121339.10758.laurent.pinchart@ideasonboard.com>
	<AANLkTikOC_zYiyK+8r44Rdp=wigHXZwSmvPgEmBAEqDs@mail.gmail.com>
	<201101141801.01125.laurent.pinchart@ideasonboard.com>
Date: Tue, 18 Jan 2011 10:20:43 +0100
Message-ID: <AANLkTi=ipwaYj=Be+fqAKhKbaMdR-u8cEquUwapuHYcs@mail.gmail.com>
Subject: Re: OMAP3 ISP and tvp5151 driver.
From: =?UTF-8?Q?Enric_Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

2011/1/14 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Enric,
>
> On Thursday 13 January 2011 13:27:43 Enric Balletbò i Serra wrote:
>> 2011/1/12 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> > On Wednesday 12 January 2011 12:58:04 Enric Balletbò i Serra wrote:
>> >> Hi all,
>> >>
>> >> As explained in my first mail I would like port the tvp515x driver to
>> >> new media framework, I'm a newbie with the v4l2 API and of course with
>> >> the new media framework API, so sorry if next questions are stupid or
>> >> trivial (please, patience with me).
>> >>
>> >> My idea is follow this link schem:
>> >>
>> >> ---------------------------------------
>> >> --------------------------------------------
>> >>  ---------------------         |    |                              | 1
>> >>
>> >> | ----------> | OMAP3 ISP CCDC OUTPUT |
>> >> | TVP515x  | 0 | -----> | 0 | OMAP3 ISP CCDC  --- |
>> >>
>> >> --------------------------------------------
>> >>  --------------------          |    |                              | 2 |
>> >>                                 ---------------------------------------
>> >
>> > ASCII art would look much better if you drew it in a non-proportional
>> > font, with 80 character per line at most.
>> >
>> >> Where:
>> >>  * TVP515x is /dev/v4l-subdev8 c 81 15
>> >>  * OMAP3 ISP CCDC is /dev/v4l-subdev2 c 81 4
>> >>  * OMAP3 ISP CCDC OUTPUT is /dev/video2 c 81 5
>> >>
>> >> Then activate these links with
>> >>
>> >>  ./media-ctl -r -l '"tvp5150 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3
>> >> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>> >>  Resetting all links to disabled
>> >>  Setting up link 16:0 -> 5:0 [1]
>> >>  Setting up link 5:1 -> 6:0 [1]
>> >>
>> >> I'm on the right way or I'm completely lost ?
>> >
>> > That's correct.
>> >
>> >> I think the next step is adapt the tvp515x driver to new media
>> >> framework, I'm not sure how to do this, someone can give some points ?
>> >
>> > You need to implement subdev pad operations. get_fmt and set_fmt are
>> > required.
>>
>> I configured the TVP5151 to  8-bit 4:2:3 YCbCr output format. Is 8-bit
>> 4:2:3 YCbCr output format implemented in OMAP3 ISP CCDC  ?
>
> I suppose you mean 4:2:2. The CCDC doesn't support that yet.
>
>> >> Once this is done, I suppose I can test using gstreamer, for example
>> >> using something like this.
>> >>
>> >>    gst-launch v4l2src device=/dev/video2 ! ffmpegcolorspace !
>> >> xvimagesink
>> >>
>> >> I'm right in this point ?
>> >
>> > You need to specify the format explicitly. It must be identical to the
>> > format configured on pad CCDC:1.
>>
>> Can you give me an example using gstreamer ?
>
> I'm not a gstreamer expert, sorry.
>
>> Running yavta I get
>>
>> # ./yavta -f SGRBG10 -s 720x525 -n 4 --capture=4 --skip 3 -F /dev/video2
>> Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
>> Video format set: width: 720 height: 525 buffer size: 756000
>> Video format: BA10 (30314142) 720x525
>> 4 buffers requested.
>> length: 756000 offset: 0
>> Buffer 0 mapped at address 0x400f2000.
>> length: 756000 offset: 757760
>> Buffer 1 mapped at address 0x40385000.
>> length: 756000 offset: 1515520
>> Buffer 2 mapped at address 0x40466000.
>> length: 756000 offset: 2273280
>> Buffer 3 mapped at address 0x405ed000.
>> Unable to start streaming: 22.
>> Unable to dequeue buffer (22).
>> 4 buffers released.
>>
>> I know the format is not correct, but, is the "Unable to start
>> streaming: 22" error related to the format or is related to another
>> problem ?
>
> That usually means that the format configured on the video device node
> (SGRBG10 720x525 in this case) is different than the format setup on the
> connected subdev output (CCDC pad 1 in this case). My guess is that you
> probably forgot to setup formats on the subdev pads (using media-ctl -f).

Right and solved, thanks, one little step more.

Now seems yavta is blocked dequeuing a buffer ( VIDIOC_DQBUF ), with
strace I get

$ strace ./yavta -f SGRBG10 -s 720x525 -n 1 --capture=1 -F /dev/video2

mmap2(NULL, 756000, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0x4011f000
write(1, "Buffer 0 mapped at address 0x401"..., 39Buffer 0 mapped at
address 0x4011f000.
) = 39
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbede36cc) = 0
ioctl(3, VIDIOC_STREAMON, 0xbede365c)   = 0
gettimeofday({10879, 920196}, NULL)     = 0
ioctl(3, VIDIOC_DQBUF

and the code where stops is here

ispqueue.c
913	buf = list_first_entry(&queue->queue, struct isp_video_buffer, stream);
914	ret = isp_video_buffer_wait(buf, nonblocking);

Any idea ?

Thanks in advance
   Enric

>
> --
> Regards,
>
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
