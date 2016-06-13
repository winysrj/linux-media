Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59999 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbcFMTBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 15:01:13 -0400
Subject: Re: LinuxTv doesn't build anymore after upgrading Ubuntu to 3.13.0-88
To: Andreas Matthies <a.matthies@gmx.net>, linux-media@vger.kernel.org
References: <575EE9D9.3030502@gmx.net> <575EF39A.4010609@xs4all.nl>
 <575F00DA.2020009@gmx.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <575F02F4.2000501@xs4all.nl>
Date: Mon, 13 Jun 2016 21:01:08 +0200
MIME-Version: 1.0
In-Reply-To: <575F00DA.2020009@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2016 08:52 PM, Andreas Matthies wrote:
> But now I get
> ...
>    CC [M]  /home/andreas/Downloads/media_build/v4l/uvc_v4l2.o
>    CC [M]  /home/andreas/Downloads/media_build/v4l/uvc_video.o
> /home/andreas/Downloads/media_build/v4l/uvc_video.c: In function 
> 'uvc_endpoint_max_bpi':
> /home/andreas/Downloads/media_build/v4l/uvc_video.c:1473:7: error: 
> 'USB_SPEED_SUPER_PLUS' undeclared (first use in this function)
>    case USB_SPEED_SUPER_PLUS:
>         ^

When building for 4.6? I know this fails for older kernels but it should be fine
for the 4.6 kernel.

I'll make a patch fixing this some time this week though.

Regards,

	Hans

> /home/andreas/Downloads/media_build/v4l/uvc_video.c:1473:7: note: each 
> undeclared identifier is reported only once for each function it appears in
> make[3]: *** [/home/andreas/Downloads/media_build/v4l/uvc_video.o] Fehler 1
> make[2]: *** [_module_/home/andreas/Downloads/media_build/v4l] Error 2
> ...
> 
> Am 13.06.2016 um 19:55 schrieb Hans Verkuil:
>> On 06/13/2016 07:14 PM, Andreas Matthies wrote:
>>> Hi.
>>>
>>> Seems that there's a problem in v4.6_i2c_mux.patch. After Ubuntu was
>>> upgraded to 3.13.0-88 I tried to rebuild the tv drivers and get
>>>
>>> make[2]: Entering directory `/home/andreas/Downloads/media_build/linux'
>>> Applying patches for kernel 3.13.0-88-generic
>>> patch -s -f -N -p1 -i ../backports/api_version.patch
>>> patch -s -f -N -p1 -i ../backports/pr_fmt.patch
>>> patch -s -f -N -p1 -i ../backports/debug.patch
>>> patch -s -f -N -p1 -i ../backports/drx39xxj.patch
>>> patch -s -f -N -p1 -i ../backports/v4.6_i2c_mux.patch
>>> 2 out of 23 hunks FAILED
>>> make[2]: *** [apply_patches] Error 1
>> Fixed. Thanks for reporting this.
>>
>> Regards,
>>
>> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
