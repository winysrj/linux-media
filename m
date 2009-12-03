Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:45837 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZLCIVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 03:21:22 -0500
Received: by iwn1 with SMTP id 1so747468iwn.33
        for <linux-media@vger.kernel.org>; Thu, 03 Dec 2009 00:21:29 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 3 Dec 2009 16:21:29 +0800
Message-ID: <8cd7f1780912030021q182347ebr6bc8be8536c5d53@mail.gmail.com>
Subject: /dev/dvb/adapter0/net0 <-- what is this for and how to use it?
From: Leszek Koltunski <leszek@koltunski.pl>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello DVB gurus,

I've got a TwinHan DVB-S2 card. I compiled the 'liplianin' drivers and
it's working nicely; thanks for all your work!

One question: in /dev/dvb/adapter0 I can see

leszek@satellite:~$ ls -l /dev/dvb/adapter0/
total 0
crw-rw----+ 1 root video 212, 4 2009-12-02 18:22 ca0
crw-rw----+ 1 root video 212, 0 2009-12-02 18:22 demux0
crw-rw----+ 1 root video 212, 1 2009-12-02 18:22 dvr0
crw-rw----+ 1 root video 212, 3 2009-12-02 18:22 frontend0
crw-rw----+ 1 root video 212, 2 2009-12-02 18:22 net0

What is this 'net0' device and how do I use it? Can I use it to
directly multicast my (FTA) satellite stream to my lan by any chance?

I have found no documentation about this...
