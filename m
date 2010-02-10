Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32701.mail.mud.yahoo.com ([68.142.207.245]:42674 "HELO
	web32701.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755456Ab0BJSxS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 13:53:18 -0500
Message-ID: <311770.77952.qm@web32701.mail.mud.yahoo.com>
Date: Wed, 10 Feb 2010 10:53:16 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Re: [Patch] Kworld 315U remote support
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Douglas Schilling <dougsland@gmail.com>,
	maillist <linux-media@vger.kernel.org>
In-Reply-To: <4B700DFA.2010902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, 

I tried out the ir_type change to the code and when I set it to IR_TYPE_NEC, I see messages in the log indicating that the key was not recognized.  Using IR_TYPE_OTHER seems to work ok.

My guess is that if I modify the keycodes IR_TYPE_NEC will work as well.  Can I just use IR_TYPE_OTHER?  That seems like the most straight forward approach with the least amount of changes.  

Thanks,
Franklin Meng

--- On Mon, 2/8/10, Mauro Carvalho Chehab <maurochehab@gmail.com> wrote:

> From: Mauro Carvalho Chehab <maurochehab@gmail.com>
> Subject: Re: [Patch] Kworld 315U remote support
> To: "Franklin Meng" <fmeng2002@yahoo.com>
> Cc: "Douglas Schilling" <dougsland@gmail.com>, "maillist" <linux-media@vger.kernel.org>
> Date: Monday, February 8, 2010, 5:13 AM
> Franklin Meng wrote:
> > This patch adds remote support for the Kworld 315U
> device
> > 
> > Note: I believe I got most of the mappings
> correct.  Though the
> > source and shutdown button probably could be mapped to
> something
> > better.  
> > 
> > To be done: Still need to get the Kworld analog patch
> resubmitted.
> > There are still some stuff I want to test with the
> analog patch before
> > I resubmit it.  Hopefully this patch will work
> ok.
> > 
> > Please let me know if there are any issues applying
> the patch
> 
> Hi Franklin,
> 
> Could you please add a table with the full scan code?
> 
> There are currently two examples of such tables:
>     ir_codes_rc5_hauppauge_new_table - for
> RC5 keycodes
>     ir_codes_nec_terratec_cinergy_xs_table -
> for NEC keycodes
> 
> 
> Basically, a full scan code has a 2-byte code instead of
> 1-byte,
> and you need to specify the protocol at the table, like:
> 
> struct ir_scancode_table
> ir_codes_nec_terratec_cinergy_xs_table = {
>         .scan =
> ir_codes_nec_terratec_cinergy_xs,
>         .size =
> ARRAY_SIZE(ir_codes_nec_terratec_cinergy_xs),
>         .ir_type = IR_TYPE_NEC,
> };
> 
> The em28xx is already prepared to properly handle the
> protocol.
> 
> the advantage of using a full table is that it is easy to
> replace
> the keytable and even the protocol if someone wants to use
> a different
> Remote Controller to control the device.
> 
> As you've declared this xclk:
> 
>                
> .xclk           =
> EM28XX_XCLK_FREQUENCY_12MHZ,
> 
> I suspect that your keycode is of the type NEC.
> 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


      
