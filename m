Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39431 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2C2G2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Mar 2012 02:28:13 -0400
Received: by vbbff1 with SMTP id ff1so1252260vbb.19
        for <linux-media@vger.kernel.org>; Wed, 28 Mar 2012 23:28:12 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Rafa=C5=82_Rzepecki?= <divided.mind@gmail.com>
Date: Thu, 29 Mar 2012 08:27:51 +0200
Message-ID: <CAJu-Zix22G3WbCCJ1h7P7+9naEU0XkYNDELTk9hCzMQ8UYB-gQ@mail.gmail.com>
Subject: Startup delay needed for a Sonix camera
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've tried to reach Jean-Francois with this a week ago, but I still
haven't received an answer, so I'm sending it to the mailing list. I'd
appreciate a CC of any follow-ups.

I've been having problems with my ID 0c45:6128 Microdia PC Camera
(SN9C325 + OM6802) using driver gspca_sonixj. Specifically, launching
command:
$ gst-launch-0.10 v4l2src ! ffmpegcolorspace ! pngenc ! filesink \
location=/tmp/file.png
gave a file that is all black. This is problematic because at least
one program (odeskteam) uses a similar method to grab camshots.

I thought it looked like as though the camera hasn't got enough time
to initialize, and indeed, adding an msleep(30) near the end of
sd_start() in sonixj.c solved the problem.
-- 
Rafał Rzepecki
