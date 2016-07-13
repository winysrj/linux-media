Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipv4.connman.net ([82.165.8.211]:41316 "EHLO mail.holtmann.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751145AbcGMK4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 06:56:16 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH] drivers: misc: ti-st: Use int instead of fuzzy char for callback status
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20160713074114.76c35d04@recife.lan>
Date: Wed, 13 Jul 2016 11:56:02 +0100
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Pavan Savoy <pavan_savoy@ti.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
	linux-media@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <32897348-2AC5-4AB7-BF58-B1E36FC19CF2@holtmann.org>
References: <1465203723-16928-1-git-send-email-geert@linux-m68k.org> <20160713074114.76c35d04@recife.lan>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

>> On mips and parisc:
>> 
>>    drivers/bluetooth/btwilink.c: In function 'ti_st_open':
>>    drivers/bluetooth/btwilink.c:174:21: warning: overflow in implicit constant conversion [-Woverflow]
>>       hst->reg_status = -EINPROGRESS;
>> 
>>    drivers/nfc/nfcwilink.c: In function 'nfcwilink_open':
>>    drivers/nfc/nfcwilink.c:396:31: warning: overflow in implicit constant conversion [-Woverflow]
>>      drv->st_register_cb_status = -EINPROGRESS;
>> 
>> There are actually two issues:
>>  1. Whether "char" is signed or unsigned depends on the architecture.
>>     As the completion callback data is used to pass a (negative) error
>>     code, it should always be signed.
>>  2. EINPROGRESS is 150 on mips, 245 on parisc.
>>     Hence -EINPROGRESS doesn't fit in a signed 8-bit number.
>> 
>> Change the callback status from "char" to "int" to fix these.
>> 
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Patch looks sane to me, but who will apply it?
> 
> Anyway:
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

I can take it through bluetooth-next if there is no objection.

Samuel, are you fine with that?

Regards

Marcel

