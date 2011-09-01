Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50529 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab1IARY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 13:24:56 -0400
Received: by bke11 with SMTP id 11so1932669bke.19
        for <linux-media@vger.kernel.org>; Thu, 01 Sep 2011 10:24:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7uT0ZGV9Drc-8V1vRB0o3gyKhyX8=f+Crsn7vtDGpem=Q@mail.gmail.com>
References: <4E56734A.3080001@mlbassoc.com>
	<CA+2YH7t9K6PFW-4YvLUx-BfteJ8ORujHppM+iesn4u2qP-Of=w@mail.gmail.com>
	<4E5F7FB3.8020405@mlbassoc.com>
	<201109011526.29507.laurent.pinchart@ideasonboard.com>
	<4E5FA1B3.9050005@mlbassoc.com>
	<CA+2YH7uT0ZGV9Drc-8V1vRB0o3gyKhyX8=f+Crsn7vtDGpem=Q@mail.gmail.com>
Date: Thu, 1 Sep 2011 19:24:54 +0200
Message-ID: <CA+2YH7ucT=Q8_Q=_HEuBNYF9d7dvOFX8ma7yLD1=6DijnUAE+w@mail.gmail.com>
Subject: Re: Getting started with OMAP3 ISP
From: Enrico <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Gary Thomas <gary@mlbassoc.com>, linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 1, 2011 at 6:14 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Thu, Sep 1, 2011 at 5:16 PM, Gary Thomas <gary@mlbassoc.com> wrote:
>>
>> - entity 16: tvp5150m1 2-005c (1 pad, 1 link)
>>             type V4L2 subdev subtype Unknown
>>             device node name /dev/v4l-subdev8
>>        pad0: Output [unknown 720x480 (1,1)/720x480]
>>                -> 'OMAP3 ISP CCDC':pad0 [ACTIVE]
>>
>> Ideas where to look for the 'unknown' mode?
>
> I didn't notice that, if you are using UYVY8_2X8 the reason is in
> media-ctl main.c:
>
> { "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
>
> You can add a line like:
>
> { "UYVY2X8", V4L2_MBUS_FMT_UYVY8_2X8 },
>
> recompile and it should work, i'll try it now.

That worked, but now there is another problem.

yavta will set UYVY (PIX_FMT), this will cause a call to
ispvideo.c:isp_video_pix_to_mbus(..), that will do this:

for (i = 0; i < ARRAY_SIZE(formats); ++i) {
                if (formats[i].pixelformat == pix->pixelformat)
                        break;
}

that is it will stop at the first matching array item, and that's:

{ V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
          V4L2_MBUS_FMT_UYVY8_1X16, 0,
          V4L2_PIX_FMT_UYVY, 16, 16, },


but you wanted this:

{ V4L2_MBUS_FMT_UYVY8_2X8, V4L2_MBUS_FMT_UYVY8_2X8,
          V4L2_MBUS_FMT_UYVY8_2X8, 0,
          V4L2_PIX_FMT_UYVY, 8, 16, },

so a better check could be to check for width too, but i don't know if
it's possibile to pass a width requirement or if it's already there in
some struct passed to the function.

Enrico
