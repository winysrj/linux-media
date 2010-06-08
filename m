Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f185.google.com ([209.85.222.185]:50405 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0FHAJj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 20:09:39 -0400
Received: by pzk15 with SMTP id 15so79160pzk.15
        for <linux-media@vger.kernel.org>; Mon, 07 Jun 2010 17:09:39 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 8 Jun 2010 10:09:39 +1000
Message-ID: <AANLkTimh-FVg9yspF6ASGrlY5kd5Puppa7VlKA6NljQ5@mail.gmail.com>
Subject: cam max width and height
From: linux newbie <linux.newbie79@gmail.com>
To: Linux-media <linux-media@vger.kernel.org>,
	linux-uvc-devel@lists.berlios.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am using linux 2.6.26.3. I connected "microsoft live cam" and its
max supported resolution is 1280x800. If I use VIDIOC_G_FMT,
fmt.fmt.pix.width, fmt.fmt.pix.height returns 640x480.

How to get the maximum supported resolution??

Thanks
