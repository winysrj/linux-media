Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58661 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab1DLC0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 22:26:13 -0400
Received: by qyk7 with SMTP id 7so1703352qyk.19
        for <linux-media@vger.kernel.org>; Mon, 11 Apr 2011 19:26:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1104101751380.12697@axis700.grange>
References: <201104090158.04827.jkrzyszt@tis.icnet.pl>
	<Pine.LNX.4.64.1104101751380.12697@axis700.grange>
Date: Tue, 12 Apr 2011 10:26:12 +0800
Message-ID: <BANLkTimut-G1YXFU+4gqiCij-RLu-Vn4-Q@mail.gmail.com>
Subject: Re: [PATCH 2.6.39] soc_camera: OMAP1: fix missing bytesperline and
 sizeimage initialization
From: Kassey Lee <kassey1216@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

hi, Guennadi:
    a lot of sensors support JPEG output.
    1) bytesperline is defined by sensor timing.
    2) and sizeimage is unknow for jpeg.

  how about for JPEG
   1) host driver gets bytesperline from sensor driver.
   2) sizeimage refilled by host driver after dma transfer done( a
frame is received)
  thanks.


2011/4/11 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> Hi Janusz
>
> On Sat, 9 Apr 2011, Janusz Krzysztofik wrote:
>
>> Since commit 0e4c180d3e2cc11e248f29d4c604b6194739d05a, bytesperline and
>> sizeimage memebers of v4l2_pix_format structure have no longer been
>> calculated inside soc_camera_g_fmt_vid_cap(), but rather passed via
>> soc_camera_device structure from a host driver callback invoked by
>> soc_camera_set_fmt().
>>
>> OMAP1 camera host driver has never been providing these parameters, so
>> it no longer works correctly. Fix it by adding suitable assignments to
>> omap1_cam_set_fmt().
>
> Thanks for the patch, but now it looks like many soc-camera host drivers
> are re-implementing this very same calculation in different parts of their
> code - in try_fmt, set_fmt, get_fmt. Why don't we unify them all,
> implement this centrally in soc_camera.c and remove all those
> calculations? Could you cook up a patch or maybe several patches - for
> soc_camera.c and all drivers?
>
> Thanks
> Guennadi
>
>>
>> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
>> ---
>>  drivers/media/video/omap1_camera.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> --- linux-2.6.39-rc2/drivers/media/video/omap1_camera.c.orig  2011-04-06 14:30:37.000000000 +0200
>> +++ linux-2.6.39-rc2/drivers/media/video/omap1_camera.c       2011-04-09 00:16:36.000000000 +0200
>> @@ -1292,6 +1292,12 @@ static int omap1_cam_set_fmt(struct soc_
>>       pix->colorspace  = mf.colorspace;
>>       icd->current_fmt = xlate;
>>
>> +     pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
>> +                                                 xlate->host_fmt);
>> +     if (pix->bytesperline < 0)
>> +             return pix->bytesperline;
>> +     pix->sizeimage = pix->height * pix->bytesperline;
>> +
>>       return 0;
>>  }
>>
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
