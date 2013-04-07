Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33620 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165Ab3DGTcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Apr 2013 15:32:22 -0400
Received: by mail-ie0-f172.google.com with SMTP id c10so6036514ieb.17
        for <linux-media@vger.kernel.org>; Sun, 07 Apr 2013 12:32:21 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 7 Apr 2013 21:32:21 +0200
Message-ID: <CAFW1BFxJ-fe8N-=LSKUfRP=-R+XUY_it3miEUKKJ6twkZa1wZA@mail.gmail.com>
Subject: vivi kernel driver
From: Michal Lazo <michal.lazo@mdragon.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
V4L2 driver vivi
generate 25% cpu load on raspberry pi(linux 3.6.11) or 8% on x86(linux 3.2.0-39)

player
GST_DEBUG="*:3,v4l2src:3,v4l2:3" gst-launch-0.10 v4l2src
device="/dev/video0" norm=255 ! video/x-raw-rgb, width=720,
height=576, framerate=30000/1001 ! fakesink sync=false

Anybody can answer me why?
And how can I do it better ?

I use vivi as base example for my driver
