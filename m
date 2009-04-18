Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:33453 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbZDRNQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Apr 2009 09:16:42 -0400
Date: Sat, 18 Apr 2009 15:16:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mike Isely <isely@pobox.com>
Cc: isely@isely.net, LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/6] ir-kbd-i2c: Switch to the new-style device binding
  model
Message-ID: <20090418151625.254e466b@hyperion.delvare>
In-Reply-To: <20090418112519.774e0dae@hyperion.delvare>
References: <20090417222927.7a966350@hyperion.delvare>
	<20090417223105.28b8957e@hyperion.delvare>
	<Pine.LNX.4.64.0904171831300.19718@cnc.isely.net>
	<20090418112519.774e0dae@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again Mike,

On Sat, 18 Apr 2009 11:25:19 +0200, Jean Delvare wrote:
> On Fri, 17 Apr 2009 18:35:55 -0500 (CDT), Mike Isely wrote:
> > I thought we were going to leave the pvrusb2 driver out of this since 
> > I've already got a change ready that also includes additional logic to 
> > take into account the properties of the hardware device (i.e. only 
> > activate ir-kbd-i2c when we know it has a chance of working).
> 
> Hmm, I thought that our latest discussions had (at least partly)
> obsoleted your patches. Remember that we want to always instantiate
> ir_video I2C devices even when ir-kbd-i2c can't driver them, otherwise
> lirc won't be able to bind to the devices in question as soon as the
> legacy binding model is gone. So the conditionals in your second patch
> (which is all that makes it differ from mine) are no longer desirable.
> 
> I'll work on lirc patches today or tomorrow, so that lirc doesn't break
> when my patches hit mainline.

Speaking of this: do you know all the I2C addresses that can host IR
devices on pvrusb2 cards? I understand that the only address supported
by ir-kbd-i2c is 0x18, but I also need to know the addresses supported
by lirc_i2c and possibly lirc_zilog, if you happen to know this.

Thanks,
-- 
Jean Delvare
