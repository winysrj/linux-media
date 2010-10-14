Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58251 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab0JNTeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 15:34:12 -0400
Received: by wyb28 with SMTP id 28so2476947wyb.19
        for <linux-media@vger.kernel.org>; Thu, 14 Oct 2010 12:34:10 -0700 (PDT)
Subject: Re: [PATCH] Support or LME2510(C) DM04/QQBOX USB DVB-S BOXES.
From: tvbox <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
In-Reply-To: <4CB72D01.3060106@gmail.com>
References: <1283459370.3368.23.camel@canaries-desktop>
	 <4CB60433.2010105@iki.fi>  <4CB72D01.3060106@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 20:34:03 +0100
Message-ID: <1287084843.4268.6.camel@canaries-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2010-10-14 at 13:17 -0300, Mauro Carvalho Chehab wrote:
> Em 13-10-2010 16:10, Antti Palosaari escreveu:
> > On 09/02/2010 11:29 PM, tvbox wrote:
> >> DM04/QQBOX DVB-S USB BOX with LME2510C+SHARP:BS2F7HZ7395 or LME2510+LGTDQT-P001F tuner.
> > 
> >> +config DVB_USB_LME2510
> >> +    tristate "LME DM04/QQBOX DVB-S USB2.0 support"
> >> +    depends on DVB_USB
> >> +    select DVB_TDA10086 if !DVB_FE_CUSTOMISE
> >> +    select DVB_TDA826X if !DVB_FE_CUSTOMISE
> >> +    select DVB_STV0288 if !DVB_FE_CUSTOMISE
> >> +    select DVB_IX2505V if !DVB_FE_CUSTOMISE
> >> +    select IR_CORE
> >> +    help
> >> +      Say Y here to support the LME DM04/QQBOX DVB-S USB2.0 .
> > 
> > Just for curious, is IR_CORE and DVB_USB both needed? DVB_USB also depends on IR_CORE ? This was only DVB-USB driver which does that.
> 
> The IR_CORE dependency is already there, so, DVB_USB_LME2510 shouldn't need do use dependency
> related to IR.
I have an update patch pending final test for this driver. I will remove
it in the patch.

Malcolm


