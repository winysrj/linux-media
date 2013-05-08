Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:56154 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3EHTgA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 15:36:00 -0400
Received: by mail-ve0-f176.google.com with SMTP id db10so564373veb.7
        for <linux-media@vger.kernel.org>; Wed, 08 May 2013 12:36:00 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 May 2013 21:35:59 +0200
Message-ID: <CACi0n_gEumMkj0t7ge2J-iFfwOgN2xBqwdxBhBGWvc=0whL6KA@mail.gmail.com>
Subject: Capturing Nikon D7000 LiveView
From: Federico Prades Illanes <fprades@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm trying to connect a Nikon D7000 to my Linux box (a bit old Pentium
IV) via USB. And I know from the camera spec and other software that
it's able to send the Live View back to the computer. Obviously it's
is working, I frankly have no idea how to debug this issue.

I would expect to see the /dev/video0 device to be created on camera
connection. (Done this with a Canon D5 previously). I only get to see
the device recognition on the 'dmesg'.

I'm not sure if the camera is supported by V4L2, or if this is a
miss-configuration on my system. I done my best to read the wiki, but
all I find is low level API calls and so. No simple-enough breakdown
on architecture, so I will appreciate any help or right directions to
continue.

Thanks!

Ps: For the record I have ubuntu 11.10, kernel 2.6.38-13-generic, i686
