Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:36525 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948AbZLWOfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 09:35:11 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NNSIs-0008Nr-1B
	for linux-media@vger.kernel.org; Wed, 23 Dec 2009 15:35:06 +0100
Received: from upc.si.94.140.72.111.dc.cable.static.telemach.net ([94.140.72.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 15:35:06 +0100
Received: from prusnik by upc.si.94.140.72.111.dc.cable.static.telemach.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 15:35:06 +0100
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Alja=C5=BE?= Prusnik <prusnik@gmail.com>
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
Date: Wed, 23 Dec 2009 15:30:16 +0100
Message-ID: <1261578615.8948.4.camel@slash.doma>
References: <4B1D6194.4090308@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4B1D6194.4090308@freenet.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the same vein, I'm interested in this one, namely:

I have tried the http://jusst.de/hg/v4l-dvb, since recently the
liplianin mantis driver is not working (unknown symbols...). 

However, the problems I have as opposed to the previously working driver
are:
- the module does not install in a way it gets autoloaded on startup - I
have to manually add it (modprobe) or put it into /etc/modules (debian)
- while the card itself works, I don't have IR functionality anymore.
>From what I gather from the kernel log, the input line

input: Mantis VP-2040 IR Receiver as /devices/virtual/input/input4

just doesn't exist anymore. Further more the whole bunch is missing:

mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
input: Mantis VP-2040 IR Receiver as /devices/virtual/input/input4
Creating IR device irrcv0


I tried 2.6.32 kernel which worked before, now I'm using 2.6.33-rc1
where I had to comment out #include <linux/autoconf.h> the from the
v4l-dvb/v4l/config-compat.h.


Any ideas how to get the comfort back? ;)

Regards,
Aljaz



