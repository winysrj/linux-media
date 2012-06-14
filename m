Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50163 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2FNAoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 20:44:17 -0400
Received: by wibhn6 with SMTP id hn6so1268410wib.1
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 17:44:15 -0700 (PDT)
Message-ID: <1339634648.3833.37.camel@Route3278>
Subject: Re: [PATCH 1/2] [BUG] dvb_usb_v2:  return the download ret in
 dvb_usb_download_firmware
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Thu, 14 Jun 2012 01:44:08 +0100
In-Reply-To: <4FD9224F.7050809@iki.fi>
References: <1339626272.2421.74.camel@Route3278> <4FD9224F.7050809@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2012-06-14 at 02:29 +0300, Antti Palosaari wrote:
> Hi Malcolm,
> I was really surprised someone has had interest to test that stuff at 
> that phase as I did not even advertised it yet :) It is likely happen 
> next Monday or so as there is some issues I would like to check / solve.
> 
> 
> On 06/14/2012 01:24 AM, Malcolm Priestley wrote:
> > Hi antti
> >
> > There some issues with dvb_usb_v2 with the lmedm04 driver.
> >
> > The first being this patch, no return value from dvb_usb_download_firmware
> > causes system wide dead lock with COLD disconnect as system attempts to continue
> > to warm state.
> 
> Hmm, I did not understand what you mean. What I looked lmedm04 driver I 
> think it uses single USB ID (no cold + warm IDs). So it downloads 
> firmware and then reconnects itself from the USB bus?
> For that scenario you should "return RECONNECTS_USB;" from the driver 
> .download_firmware().
> 
If the device disconnects from the USB bus after the firmware download.

In most cases the device is already gone.

There is currently no way to insert RECONNECTS_USB into the return.


> I tested it using one non-public Cypress FX2 device - it was changing 
> USB ID after the FX download, but from the driver perspective it does 
> not matter. It is always new device if it reconnects USB.
> 

Have double checked that the thread is not continuing to write on the
old ID?

The zero condition will lead to dvb_usb_init.

> PS. as I looked that driver I saw many different firmwares. That is now 
> supported and you should use .get_firmware_name() (maybe you already did 
> it).
> 
Yes, I have supported this in the driver.




Regards


Malcolm



