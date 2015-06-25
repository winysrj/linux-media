Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback5.mail.ru ([94.100.181.253]:57038 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbFYVBG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 17:01:06 -0400
Received: from smtp20.mail.ru (smtp20.mail.ru [94.100.179.251])
	by fallback5.mail.ru (mPOP.Fallback_MX) with ESMTP id 1367887E7724
	for <linux-media@vger.kernel.org>; Thu, 25 Jun 2015 23:58:58 +0300 (MSK)
Message-ID: <DB7ACFD5239247FCB3C1CA323B56E88D@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: <linux-media@vger.kernel.org>,
	"Devin Heitmueller" <dheitmueller@kernellabs.com>
Subject: XC5000C 0x14b4 status
Date: Fri, 26 Jun 2015 03:58:48 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="koi8-r";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I was working on a Linux driver for a hybrid TV-tuner with SAA7134 PCI bridge, XC5000C RF tuner and Si2168 DVB demodulator by a
"combining" all existent at that time drivers together.
During that work, I had an issue with XC5000C.
Episodically, after attaching to DVB and reading XREG_PRODUCT_ID register, it
was possible to receive 0x14b4 instead of usual 0x1388 status. And as a result get a "xc5000: Device not found at addr 0x%02x 
(0x%x)\n" in dmesg.
To workaround these, I added a few strings to a source of a driver to make it's behaviour the same for 0x14b4, as for 0x1388.
After that RF tuner identification became always successful.
I had a conversation with a hardware vendor.
Now I can say, that such behaviour, most likely, because of  "early" firmware for XC5000C.
This hardware vendor is using for his Windows driver a latest firmware, and reading Product ID register always gives 0x14b4 status.
As he says, 0x1388 status is only for previous XC5000 IC. (Without C at end of a P/N)
Is this possible to patch xc5000.c with something like this:

 #define XC_PRODUCT_ID_FW_LOADED 0x1388
+#define XC_PRODUCT_ID_FW_LOADED_XC5000C 0x14b4

  case XC_PRODUCT_ID_FW_LOADED:
+ case XC_PRODUCT_ID_FW_LOADED_XC5000C:
   printk(KERN_INFO
    "xc5000: Successfully identified at address 0x%02x\n",

Or to try to get a chip vendor's permission for using a latest firmware for XC5000C in Linux, and then anyway, patch the driver?

Best regards. 

