Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f224.google.com ([209.85.217.224]:53152 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab0BJU5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 15:57:32 -0500
Received: by gxk24 with SMTP id 24so474470gxk.1
        for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 12:57:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197381002101120v76e5ad9w28283bbaafc941c4@mail.gmail.com>
References: <f535cc5a1002100021u37bf47a5y50a0a90873a082e2@mail.gmail.com>
	<f535cc5a1002101058h4d8e4bd1p6fd03abd4f724f52@mail.gmail.com>
	<f535cc5a1002101101k709bbe9bv504cf33fab14dedc@mail.gmail.com>
	<f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com>
	<829197381002101120v76e5ad9w28283bbaafc941c4@mail.gmail.com>
From: Carlos Jenkins <carlos.jenkins.perez@gmail.com>
Date: Wed, 10 Feb 2010 14:57:11 -0600
Message-ID: <f535cc5a1002101257h1e1fd500q97e234f05d03212e@mail.gmail.com>
Subject: Re: Want to help in MSI TV VOX USB 2.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, thanks for the replies.
> Try card=9,

Ok, done:

sudo modprobe em28xx card=9

[  385.566364] Linux video capture interface: v2.00
[  385.593590] usbcore: registered new interface driver em28xx
[  385.593599] em28xx driver loaded
[  400.104029] usb 1-6: new high speed USB device using ehci_hcd and address 5
[  400.237357] usb 1-6: configuration #1 chosen from 1 choice
[  400.238278] em28xx: New device @ 480 Mbps (eb1a:2820, interface 0, class 0)
[  400.238429] em28xx #0: chip ID is em2820 (or em2710)
[  400.329049] em28xx #0: board has no eeprom
[  400.330173] em28xx #0: Identified as Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
(card=9)
[  400.705185] saa7115 5-0021: saa7114 found (1f7114d0e000000) @ 0x42
(em28xx #0)
[  402.852932] em28xx #0: Config register raw data: 0x00
[  402.984028] em28xx #0: v4l2 driver version 0.1.2
[  403.380126] em28xx #0: V4L2 video device registered as video0

Still nothing.

> and make sure you have tvtime configured to the correct
> video standard *before* starting it up (you may need to run the
> tvtime-configure command line tool).

Already done before.
