Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:34021 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZA2HoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 02:44:23 -0500
Received: by rv-out-0506.google.com with SMTP id k40so7377918rvb.1
        for <linux-media@vger.kernel.org>; Wed, 28 Jan 2009 23:44:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233206626-19157-1-git-send-email-hardik.shah@ti.com>
References: <1233206626-19157-1-git-send-email-hardik.shah@ti.com>
Date: Thu, 29 Jan 2009 16:44:20 +0900
Message-ID: <5e9665e10901282344v38999d5bvdc5530dd4151f869@mail.gmail.com>
Subject: Re: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
From: DongSoo Kim <dongsoo.kim@gmail.com>
To: Hardik Shah <hardik.shah@ti.com>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

> +#define VIDIOC_S_COLOR_SPACE_CONV      _IOW('V', 83, struct v4l2_color_space_conversion)
> +#define VIDIOC_G_COLOR_SPACE_CONV      _IOR('V', 84, struct v4l2_color_space_conversion)

Do you mind if I ask a question about those ioctls?
Because as far as I understand, we can use VIDIOC_S_FMT ioctl to convert
colorspaces. Setting through colorspace member in v4l2_pix_format, we
could change output colorspace.
If there is some different use, can you tell me what it is?

Regards,
Nate

-- 
========================================================
Dong Soo, Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
           dongsoo45.kim@samsung.com
========================================================
