Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:50858 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbaAHNJK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 08:09:10 -0500
Received: by mail-ie0-f172.google.com with SMTP id u16so1179448iet.31
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 05:09:08 -0800 (PST)
MIME-Version: 1.0
From: Markus Partheymueller <mail@klee-parthy.de>
Date: Wed, 8 Jan 2014 14:08:37 +0100
Message-ID: <CAGLQ9fS67CqeVWGf3HamgV1zZXnpKSfOSru0aHRPGxejaqKGRw@mail.gmail.com>
Subject: [media] em28xx: IR codes for Terratec H5 Stick
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

with my Terratec H5 Stick, the remote control wasn't working, so I
started to dig around and found this thread:

http://www.spinics.net/lists/linux-media/msg48499.html

Basically, just adding the IR codes map of the Cinergy XS did the
trick there and in fact also worked for me. As far as I can tell from
the git repository
(https://git.kernel.org/cgit/linux/kernel/git/mchehab/linux-media.git/tree/drivers/media/usb/em28xx/em28xx-cards.c#n962),
the H5 still lacks the IR map.

Should I prepare a patch for that line or does anyone feel like adding
it? (Sorry, you might have guessed it, I'm new here...)

Cheers

Markus
