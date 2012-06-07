Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54221 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab2FGS0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 14:26:06 -0400
Received: by lbbgm6 with SMTP id gm6so760973lbb.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2012 11:26:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Jun 2012 15:26:04 -0300
Message-ID: <CALF0-+VmR6izw6zXj+kOsrQDPN94v8jqhoRmeYp1vvexuoFJ1Q@mail.gmail.com>
Subject: [Q] Why is it needed to add an alsa module to v4l audio capture devices?
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

(I hope this is a genuine question, and I'm not avoiding my own homework here.)

I'm trying to support the audio part of the stk1160 usb bridge
(similar to em28xx).
Currently, the snd-usb-audio module is being loaded when I physically
plug my device,
but I can't seem to capture any sound with vlc.

I still have to research and work a lot to understand the connection
between my device
and alsa, and altough I could write a working module similar to
em28xx-alsa.ko, I still
can't figure out why do I need to write one in the first place.

Why is this module suffficient for gspca microphone devices (gspca, to name one)
and why is a new alsa driver needed for em28xx (or stk1160)?

Hope my question is clear enough,
Thanks in advance,
Ezequiel.
