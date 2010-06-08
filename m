Return-path: <linux-media-owner@vger.kernel.org>
Received: from 149.Red-80-37-155.staticIP.rima-tde.net ([80.37.155.149]:61659
	"EHLO mail.claunia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab0FHAYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 20:24:43 -0400
Subject: Re: [Linux-uvc-devel] cam max width and height
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=iso-8859-1
From: Natalia Portillo <claunia@claunia.com>
In-Reply-To: <AANLkTimh-FVg9yspF6ASGrlY5kd5Puppa7VlKA6NljQ5@mail.gmail.com>
Date: Tue, 8 Jun 2010 01:17:17 +0100
Cc: Linux-media <linux-media@vger.kernel.org>,
	linux-uvc-devel@lists.berlios.de
Content-Transfer-Encoding: 8BIT
Message-Id: <E009656A-B664-4339-B127-B6A71EC13192@claunia.com>
References: <AANLkTimh-FVg9yspF6ASGrlY5kd5Puppa7VlKA6NljQ5@mail.gmail.com>
To: linux newbie <linux.newbie79@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

El 08/06/2010, a las 01:09, linux newbie escribió:

> Hi,
> 
> I am using linux 2.6.26.3. I connected "microsoft live cam" and its
> max supported resolution is 1280x800. If I use VIDIOC_G_FMT,
> fmt.fmt.pix.width, fmt.fmt.pix.height returns 640x480.
> 
> How to get the maximum supported resolution??

You should check in Microsoft's webpage or included documentation that 1280x800 is a video resolution and not only a still image resolution.

It is common for many cameras to do that.

> Thanks
> _______________________________________________
> Linux-uvc-devel mailing list
> Linux-uvc-devel@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/linux-uvc-devel

