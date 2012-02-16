Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59626 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754254Ab2BPSnY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 13:43:24 -0500
Received: by lagu2 with SMTP id u2so2769422lag.19
        for <linux-media@vger.kernel.org>; Thu, 16 Feb 2012 10:43:22 -0800 (PST)
Message-ID: <4F3D4E42.8040808@gmail.com>
Date: Thu, 16 Feb 2012 19:43:14 +0100
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/35] Add a driver for Terratec H7
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab skrev 2012-01-21 17:04:
> Terratec H7 is a Cypress FX2 device with a mt2063 tuner and a drx-k
> demod. This series add support for it. It started with a public
> tree found at:
> 	 http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
>
> The driver were almost completely re-written, and it is now working,
> at least with DVB-C. I don't have a DVB-T signal here for testing,
> but I suspect it should also work fine.
>
> The FX2 firmware has a NEC IR decoder. The driver has support for
> it. The default keytable has support for the black Terratec IR
> and for the grey IR with orange keys.
>
> The CI support inside the driver is similar to the one found at the
> az6027 driver. I don't have a CI module here, so it is not tested.
>
> Tests and feedback are welcome.

A small feedback report.

I've tested with the latest media_build and can watch unencrypted 
channels on the DVB-C network I'm connected to.

It seems that the CI-module doesn't work. Nothing happens when I insert 
a CAM-module with our without a programme card.
I haven't tried to use the IR yet.

  * Okänt - identifierat
  * Engelska
  * Svenska
  * Franska
  * Tyska

  * Engelska
  * Svenska
  * Franska
  * Tyska

<javascript:void(0);>
