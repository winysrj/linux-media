Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42139 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaI3Iux (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 04:50:53 -0400
Received: by mail-ie0-f179.google.com with SMTP id tp5so16351676ieb.24
        for <linux-media@vger.kernel.org>; Tue, 30 Sep 2014 01:50:52 -0700 (PDT)
MIME-Version: 1.0
From: Paulo Assis <pj.assis@gmail.com>
Date: Tue, 30 Sep 2014 09:50:32 +0100
Message-ID: <CAPueXH4puHLAPWpBS9gjGHd5AGb1gAxZqSggXDaGEJ3WYC_nMA@mail.gmail.com>
Subject: uvcvideo fails on 3.16 and 3.17 kernels
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I referring to the following bug:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1362358

I've run some tests and after increasing verbosity for uvcvideo, I get:
EOF on empty payload

this seems consistent with the zero size frames returned by the driver.
After VIDIOC_DQBUF | VIDIOC_QBUF, I get buf.bytesused=0

Testing with an eye toy 2 (gspca), everything works fine, so this is
definitly related to uvcvideo.
This happens on all available formats (YUYV and MJPEG)

Regards,
Paulo
