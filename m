Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49861 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411Ab2A2VSw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jan 2012 16:18:52 -0500
Received: by lagu2 with SMTP id u2so1868858lag.19
        for <linux-media@vger.kernel.org>; Sun, 29 Jan 2012 13:18:51 -0800 (PST)
Message-ID: <4F25B7B2.6020300@gmail.com>
Date: Sun, 29 Jan 2012 22:18:42 +0100
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/35] Add a driver for Terratec H7
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab skrev 2012-01-21 17:04:
> Terratec H7 is a Cypress FX2 device with a mt2063 tuner and a drx-k
> demod. This series add support for it. It started with a public
> tree found at:
> 	 http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz

I hope this driver is for the device found here: 
http://www.terratec.net/en/products/TERRATEC_H7_91101.html?premium=1
I'm in need of a CI-capable device that I can use in my DVB-C network 
since my current device seems to have serious problems with the CAM-card 
installed.

Do you have access to a DVB-C with encrypted channels or do you know if 
someone is testing this driver in such environment?
Otherwise I'm thinking of buying this device. Is the driver available in 
the media_build bundle?

I can probably test DVB-T with encrypted channels too if needed but it's 
nothing I have at the moment but can possible invest in.

PS.
The device I have problems with is named like this with lspci. The 
problems starts when I insert the CAM-card. dmesg says it's inserted but 
the stream sometimes starts out ok but within a minute I see artifacts 
and it becomes worse after that. Without card inserted the free channels 
works like a charm.  That's why I'm interested to switch to this device.
08:01.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
         Subsystem: KNC One Device 0028

/Yours,
Roger.M
