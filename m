Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:51818 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754068AbcIFItt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 04:49:49 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v5 00/13] pxa_camera transition to v4l2 standalone device
References: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
        <cb7496b2-cc64-7c6e-71b3-6c56e596c8dc@xs4all.nl>
Date: Tue, 06 Sep 2016 10:49:44 +0200
In-Reply-To: <cb7496b2-cc64-7c6e-71b3-6c56e596c8dc@xs4all.nl> (Hans Verkuil's
        message of "Mon, 5 Sep 2016 14:40:05 +0200")
Message-ID: <87inu9if9z.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 08/29/2016 07:55 PM, Robert Jarzmik wrote:
>> There is no change between v4 and v5, ie. the global diff is empty, only one
>> line was shifted to prevent breaking bisectablility.
>
> Against which tree do you develop? Unfortunately this patch series doesn't apply
> to the media_tree master branch anymore due to conflicts with a merged patch that
> converts s/g_crop to s/g_selection in all subdev drivers.
v4.8-rc1 is their base, so Linus's master.

> When you make the new patch series, please use the -M option with git send-email so
> patches that move files around are handled cleanly. That makes it much easier
> to review.
Ok.

> BTW, checkpatch reported issues in a switch statement in function
> pxa_camera_get_formats():
Yep, I noticed.

>         switch (code.code) {
>         case MEDIA_BUS_FMT_UYVY8_2X8:
>                 formats++;
>                 if (xlate) {
>                         xlate->host_fmt = &pxa_camera_formats[0];
>                         xlate->code     = code.code;
>                         xlate++;
>                         dev_dbg(dev, "Providing format %s using code %d\n",
>                                 pxa_camera_formats[0].name, code.code);
>                 }
>         case MEDIA_BUS_FMT_VYUY8_2X8:
>         case MEDIA_BUS_FMT_YUYV8_2X8:
>         case MEDIA_BUS_FMT_YVYU8_2X8:
>         case MEDIA_BUS_FMT_RGB565_2X8_LE:
>         case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
>                 if (xlate)
>                         dev_dbg(dev, "Providing format %s packed\n",
>                                 fmt->name);
>                 break;
>         default:
>                 if (!pxa_camera_packing_supported(fmt))
>                         return 0;
>                 if (xlate)
>                         dev_dbg(dev,
>                                 "Providing format %s in pass-through mode\n",
>                                 fmt->name);
>         }
>
> Before 'case MEDIA_BUS_FMT_VYUY8_2X8' should there be a break? If not, then
> there should be a '/* fall through */' comment.
There should have been a '/* fall through */' in the original code, even if that
was not strictly "required" at the time of writing.
>
> At the end of the default case there should also be a break statement.
>
> This is already in the existing code, so just make a separate patch fixing
> this.
Ok, will do.

Cheers.

--
Robert
