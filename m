Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:64522 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZHSEQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 00:16:49 -0400
Received: by gxk1 with SMTP id 1so5695723gxk.17
        for <linux-media@vger.kernel.org>; Tue, 18 Aug 2009 21:16:50 -0700 (PDT)
MIME-Version: 1.0
From: treblid <treblid@gmail.com>
Date: Wed, 19 Aug 2009 12:09:24 +0800
Message-ID: <941593fd0908182109p22e5e5f0i6959369c9ac7c12f@mail.gmail.com>
Subject: help: Can't get DViCO FusionHDTV DVB-T Dual Digital 4 to work with
	new kernels
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Been grappling with this problem for a while now..
I am using stock linux kernel 2.6.28.9 together with Mythtv (SVN trunk)

For some reason I cannot use 2.6.29.x or 2.6.30.x (latest version I
tried is 2.6.30.5).

Everytime i start mythbackend, the console is littered with the
following messages, and the keyboard input freezes sporadically.
the messages as below:

dvb-usb: recv bulk message failed: -110
cxusb: i2c read failed

i googled for a solution and it seems some got around this by inserted
the IR receiver, I tried but it still doesn't work.

is this a mythtv problem or cxusb issue?

Please help, any pointers appreciated.

regards,
