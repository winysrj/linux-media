Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110810.mail.gq1.yahoo.com ([67.195.13.233]:24153 "HELO
	web110810.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752465AbZESNep (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 09:34:45 -0400
Message-ID: <556889.38477.qm@web110810.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 06:34:46 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH] [0905_14] Siano: USB - move the device id table to the cards module
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Mon, 5/18/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> Subject: Re: [PATCH] [0905_14] Siano: USB - move the device id table to the cards module
> To: "Uri Shkolnik" <urishk@yahoo.com>
> Cc: "LinuxML" <linux-media@vger.kernel.org>
> Date: Monday, May 18, 2009, 9:41 AM
> Em Thu, 14 May 2009 12:29:35 -0700
> (PDT)
> Uri Shkolnik <urishk@yahoo.com>
> escreveu:
> 
> The idea of moving it to sms-cards.c is interesting,
> however, I don't think
> this will work fine, since having the usb probing code at
> one module and the
> table on another will break for udev.
> 
> Also, by applying this patch, module loader would be
> broken:
> 
> WARNING: "smsusb_id_table" [/home/v4l/master/v4l/smsusb.ko]
> undefined!
> 
> I can see a few alternatives:
> 
> 1) keep as-is;
> 2) move usb init code to sms-cards;
> 3) break sms-cards into smaller files, like sms-cards-usb
> (for usb devices);
> 4) having the table declared as static into some header
> file.
> 


Mauro,

That patch has been suppressed by me @ the patchwork shortly after I submit it.

The ID tables (for USB and for SDIO) devices will remain in their corresponding interfaces drivers.

The cards/targets will keep to be managed by board ID (sms-cards.h), no need to further break the sms-cards to mini-modules, there is nothing to gain with that architecture. 


10x,

Uri


      
