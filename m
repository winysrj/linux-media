Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42281 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab0BHNNl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 08:13:41 -0500
Received: by vws20 with SMTP id 20so2117477vws.19
        for <linux-media@vger.kernel.org>; Mon, 08 Feb 2010 05:13:40 -0800 (PST)
Message-ID: <4B700DFA.2010902@gmail.com>
Date: Mon, 08 Feb 2010 11:13:30 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Franklin Meng <fmeng2002@yahoo.com>
CC: Douglas Schilling <dougsland@gmail.com>,
	maillist <linux-media@vger.kernel.org>
Subject: Re: [Patch] Kworld 315U remote support
References: <19431.32442.qm@web32702.mail.mud.yahoo.com>
In-Reply-To: <19431.32442.qm@web32702.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Franklin Meng wrote:
> This patch adds remote support for the Kworld 315U device
> 
> Note: I believe I got most of the mappings correct.  Though the
> source and shutdown button probably could be mapped to something
> better.  
> 
> To be done: Still need to get the Kworld analog patch resubmitted.
> There are still some stuff I want to test with the analog patch before
> I resubmit it.  Hopefully this patch will work ok.
> 
> Please let me know if there are any issues applying the patch

Hi Franklin,

Could you please add a table with the full scan code?

There are currently two examples of such tables:
	ir_codes_rc5_hauppauge_new_table - for RC5 keycodes
	ir_codes_nec_terratec_cinergy_xs_table - for NEC keycodes


Basically, a full scan code has a 2-byte code instead of 1-byte,
and you need to specify the protocol at the table, like:

struct ir_scancode_table ir_codes_nec_terratec_cinergy_xs_table = {
        .scan = ir_codes_nec_terratec_cinergy_xs,
        .size = ARRAY_SIZE(ir_codes_nec_terratec_cinergy_xs),
        .ir_type = IR_TYPE_NEC,
};

The em28xx is already prepared to properly handle the protocol.

the advantage of using a full table is that it is easy to replace
the keytable and even the protocol if someone wants to use a different
Remote Controller to control the device.

As you've declared this xclk:

                .xclk           = EM28XX_XCLK_FREQUENCY_12MHZ,

I suspect that your keycode is of the type NEC.


Cheers,
Mauro
