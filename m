Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:43301 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbaKSJPh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Nov 2014 04:15:37 -0500
Received: by mail-ig0-f176.google.com with SMTP id l13so2735487iga.15
        for <linux-media@vger.kernel.org>; Wed, 19 Nov 2014 01:15:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141119094656.5459258b@crow>
References: <20141119094656.5459258b@crow>
Date: Wed, 19 Nov 2014 10:15:36 +0100
Message-ID: <CAPW4HR0RS3oPRLKRiD-h0e-xbK95ODFur1_VtD2aTFwZ6NEjBQ@mail.gmail.com>
Subject: Re: Help required for TVP5151 on Overo
From: =?UTF-8?Q?Carlos_Sanmart=C3=ADn_Bustos?= <carsanbu@gmail.com>
To: Francesco Marletta <fmarletta@movia.biz>
Cc: Linux Media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Francesco,

Yesterday I sent a mail asking about similar behaviour in another
OMAP3 board [1], I'm starting to think that OMAP3 ISP is broken in
latest kernel versions.

I hope someone give us a solution.

Regards,

Carlos

[1] http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/84744

2014-11-19 9:46 GMT+01:00 Francesco Marletta <fmarletta@movia.biz>:
> Hello to everyone,
> I'd like to know who have used the TVP5151 video decoder with the OMAP3
> Overo module.
>
> I'm trying to have the processor to capture the video from a TVP5151
> boarda, but without success (both gstreamer and yavta wait forever the
> data from the V4L2 subsystem).
>
> Thanks in advance!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
