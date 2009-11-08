Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34584 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZKHPQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 10:16:07 -0500
Received: by yxe17 with SMTP id 17so1991567yxe.33
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 07:16:12 -0800 (PST)
Subject: Looking for a DVB-S2 card which would work as an IRD
From: Leszek Koltunski <leszek@koltunski.pl>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Nov 2009 23:17:26 +0800
Message-ID: <1257693446.32643.15.camel@leszek-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello LinuxTV gurus,

Please excuse me if this list is not the best place to ask this. 

I am looking for a DVB-S2 card which:

- is well supported by current kernel
- does not have to support CI

My goal is to build a simple digital TV headend. We have an encrypted
signal ( 5 transponders, MPEG-4, h264 ). Basically we want to grab the
existing signal, re-multiplex it (for example to add a few local
channels), modulate it back and feed it to small SOs.

I am aiming to build a PC equipped with a DVB-S2 card which will tune to
1 transponder , demodulate it and stream it (via Gig ethernet! ) as an
MPTS to our software multiplexer. (so basically I hope to build an IRD
with IP output) Once I have it in my MUX, I know what to do with it. 

Does the above make sense? Which card would you recommend?

best,

Leszek


