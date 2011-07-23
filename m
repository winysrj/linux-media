Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:56653 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab1GWLYd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 07:24:33 -0400
Received: by fxd18 with SMTP id 18so6471908fxd.11
        for <linux-media@vger.kernel.org>; Sat, 23 Jul 2011 04:24:32 -0700 (PDT)
Date: Sat, 23 Jul 2011 13:24:37 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Hans Petter Selasky <hselasky@c2i.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Igor M. Liplianin" <liplianin@tut.by>, dkuhlen@gmx.net
Subject: Re: [PATCH] Add support for PCTV452E.
Message-ID: <20110723132437.7b8add2c@grobi>
In-Reply-To: <201105242151.22826.hselasky@c2i.net>
References: <201105242151.22826.hselasky@c2i.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 24 May 2011 21:51:22 +0200
Hans Petter Selasky <hselasky@c2i.net> wrote:

> NOTES:
> 
> Sources were taken from the following repositorium as of today:
> http://mercurial.intuxication.org/hg/s2-liplianin/
> 
> And depend on the zig-zag fix posted today.

Did a first test on the patch. 
[   96.780040] usb 1-8: new high speed USB device using ehci_hcd and address 5
[   97.376058] dvb_usb_pctv452e: Unknown symbol ttpci_eeprom_decode_mac (err 0)

Looks like this patch didn't make it into patchwork - Mauro can you
check that ?


I think the patch for ttpci-eeprom.c is missing this: 

--- linux/drivers/media/dvb/ttpci/ttpci-eeprom.c.orig	2011-07-23 11:00:49.000000000 +0000
+++ linux/drivers/media/dvb/ttpci/ttpci-eeprom.c	2011-07-23 11:04:00.000000000 +0000
@@ -165,6 +165,7 @@ int ttpci_eeprom_parse_mac(struct i2c_ad
 }
 
 EXPORT_SYMBOL(ttpci_eeprom_parse_mac);
+EXPORT_SYMBOL(ttpci_eeprom_decode_mac);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ralph Metzler, Marcus Metzler, others");
