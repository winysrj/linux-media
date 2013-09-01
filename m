Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58889 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3IAUzM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Sep 2013 16:55:12 -0400
Received: by mail-wi0-f175.google.com with SMTP id ez12so591622wid.8
        for <linux-media@vger.kernel.org>; Sun, 01 Sep 2013 13:55:11 -0700 (PDT)
MIME-Version: 1.0
From: Dark Shadow <shadowofdarkness@gmail.com>
Date: Sun, 1 Sep 2013 14:54:51 -0600
Message-ID: <CAMXzSMoSe5HMFgt0SrbqEh+CyxhB5BH-FtdS5yhn9x2eWCc8PA@mail.gmail.com>
Subject: Can't get cx23885 IR to work after kernel update.
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a Hauppauge HVR-1270 tuner card that comes with a IR remote
that seems to have problems with newer kernels.

Under my previous 3.2.0 kernel everything works perfect if I boot the
same system with kernel 3.10.10 the remote doesn't completely work.

It can't be a configuration problem since I am just swapping kernels.
Under 3.2 XBMC gets all the key presses and works like a dream.

Under 3.10 the only response to key presses comes from mode2 which
receives them fine but nothing else. no irw or XBMC response

I have tried other kernels in the past that had the problem so I don't
know exactly when it started. In the past I got tired of Googling and
just left my system working but I would like toget it working more now
for other hardware support in the kernel.


After Google searches I have tried making sure nothing like evdev is
trying for conflicting access but that didn't work and like I say it
has to be in the kernel itself since that is the only thing changed
and I can use the remote again by just choosing the old kernel from
Grub during boot.

I can't find anything in the logs that shows any errors.
