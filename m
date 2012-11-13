Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41840 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab2KMOKu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 09:10:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TYHCc-0007ty-DZ
	for linux-media@vger.kernel.org; Tue, 13 Nov 2012 15:10:58 +0100
Received: from 84-72-11-174.dclient.hispeed.ch ([84.72.11.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 15:10:58 +0100
Received: from auslands-kv by 84-72-11-174.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 15:10:58 +0100
To: linux-media@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Color problem with MPX-885 card (cx23885)
Date: Tue, 13 Nov 2012 15:10:40 +0100
Message-ID: <k7tkcu$m6j$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

First of all, I don't know, if this is the right mailing list. I haven't
found any other. The video4linux list seems to be abandoned.

I am testing a Commell MPX-885 mini-pcie card, which is based on a
cx23885 chip. There is "initial" support in the linux kernel for this card:

http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=2cb9ccd4612907c0a30de9be1c694672e0cd8933

My system is based on Ubuntu 12.04LTS amd64 with kernel 3.2.0.32.

The driver in general works. There are a couple of problems, however,
which to my mind are probably easy to fix for someone understanding the
driver:

1.) MINOR PROBLEM: The card is not auto-recognized. The module needs to be
loaded with the option "card=32" to get it recognized.
2.) MINOR PROBLEM: With PAL camera, there is a black left border of
about 20-30 pixel. No border on the right side.
3.) MAJOR PROBLEM: The image is mainly black & white only with some
green and red information. There are vertical light green and red stripes

I have attached a captured image demonstrating the color problem (and
also the border) to a bug report here:
https://bugzilla.kernel.org/show_bug.cgi?id=50411

I would really like to get this card fully working. Is there anybody
here who can help me or direct me to a place where someone can help me.

Thanks a lot

Michael

