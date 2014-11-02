Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:63897 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaKBCDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Nov 2014 22:03:55 -0400
Received: by mail-oi0-f51.google.com with SMTP id g201so7273143oib.24
        for <linux-media@vger.kernel.org>; Sat, 01 Nov 2014 19:03:55 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 2 Nov 2014 04:03:55 +0200
Message-ID: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
Subject: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

There is periodic stutter (seen in vlc, for example) since 3.9 where
the stream stops for around half a second every 3-5 seconds or so.
Bisecting points to 1b18e7a0be859911b22138ce27258687efc528b8 "v4l:
Tell user space we're using monotonic timestamps". I've verified the
problem is there on stock Ubuntu 14.04 kernel, 3.16.7 from kernel.org
and when using media_build.git . The commit does not revert on newer
kernels as that code changed, but checking out a commit before the one
mentioned gives properly working kernel.

I'm using Logitech C920 which can do h264 compression and playing the
video using vlc:
cvlc v4l2:///dev/video0:chroma=h264:width=1280:height=720

-- 
Gražvydas
