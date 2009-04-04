Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:20329 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbZDDXFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 19:05:53 -0400
Date: Sun, 5 Apr 2009 01:05:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mike Isely <isely@pobox.com>
Cc: isely@isely.net, LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
  model
Message-ID: <20090405010539.187e6268@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
	<20090404142837.3e12824c@hyperion.delvare>
	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

On Sat, 4 Apr 2009 10:51:01 -0500 (CDT), Mike Isely wrote:
> 
> Nacked-by: Mike Isely <isely@pobox.com>
> 
> This will interfere with the alternative use of LIRC drivers (which work 
> in more cases that ir-kbd).

Why then is ir-kbd in the kernel tree and not LIRC drivers?

> It will thus break some peoples' use of the driver.

Do you think it will, or did you test and it actually does? If it
indeed breaks, please explain why, so that a solution can be found.

> Also we have better information on what i2c addresses needed to 
> be probed based on the model of the device

This is excellent news. As I said in the header comment of the patch,
avoiding probing when we know what the IR receiver is and at which
address it sits is the way to go. Please send me all the information
you have and I'll be happy to add a patch to the series, that skips
probing whenever possible. Or write that patch yourself if you prefer.

> - and some devices supported 
> by this device are not from Hauppauge so you are making a too-strong 
> assumption that IR should be probed this way in all cases.

I didn't make any assumption, sorry. I simply copied the code from
ir-kbd-i2c. If my code does the wrong thing for some devices, that was
already the case before. And this will certainly be easier to fix after
my changes than before.

On top of that, the "Hauppauge trick" is really only the order in which
the addresses are probed. Just because a specific order is better for
Hauppauge boards, doesn't mean it won't work for non-Hauppauge boards.

> Also, unless 
> ir-kbd has suddenly improved, this will not work at all for HVR-1950 
> class devices nor MCE type PVR-24xxx devices (different incompatible IR 
> receiver).

I'm sorry but you can't blame me for ir-kbd-i2c not supporting some
devices. I updated the driver to make use of the new binding model, but
that's about all I did.

> This is why the pvrusb2 driver has never directly attempted to load 
> ir-kbd.

The pvrusb2 driver however abuses the bttv driver's I2C adapter ID
(I2C_HW_B_BT848) and was thus affected when ir-kbd-i2c is loaded. This
is the only reason why my patch touches the pvrusb2 driver. If you tell
me you want the ir-kbd-i2c driver to leave pvrusb2 alone, I can drop
all the related changes from my patch, that's very easy.

-- 
Jean Delvare
