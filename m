Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3488 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbZDEFrS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 01:47:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding model
Date: Sun, 5 Apr 2009 07:46:47 +0200
Cc: Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20090404142427.6e81f316@hyperion.delvare> <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net> <20090405010539.187e6268@hyperion.delvare>
In-Reply-To: <20090405010539.187e6268@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904050746.47451.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 05 April 2009 01:05:39 Jean Delvare wrote:
> Hi Mike,
>
> On Sat, 4 Apr 2009 10:51:01 -0500 (CDT), Mike Isely wrote:
> > Nacked-by: Mike Isely <isely@pobox.com>
> >
> > This will interfere with the alternative use of LIRC drivers (which
> > work in more cases that ir-kbd).
>
> Why then is ir-kbd in the kernel tree and not LIRC drivers?
>
> > It will thus break some peoples' use of the driver.
>
> Do you think it will, or did you test and it actually does? If it
> indeed breaks, please explain why, so that a solution can be found.
>
> > Also we have better information on what i2c addresses needed to
> > be probed based on the model of the device
>
> This is excellent news. As I said in the header comment of the patch,
> avoiding probing when we know what the IR receiver is and at which
> address it sits is the way to go. Please send me all the information
> you have and I'll be happy to add a patch to the series, that skips
> probing whenever possible. Or write that patch yourself if you prefer.
>
> > - and some devices supported
> > by this device are not from Hauppauge so you are making a too-strong
> > assumption that IR should be probed this way in all cases.
>
> I didn't make any assumption, sorry. I simply copied the code from
> ir-kbd-i2c. If my code does the wrong thing for some devices, that was
> already the case before. And this will certainly be easier to fix after
> my changes than before.
>
> On top of that, the "Hauppauge trick" is really only the order in which
> the addresses are probed. Just because a specific order is better for
> Hauppauge boards, doesn't mean it won't work for non-Hauppauge boards.
>
> > Also, unless
> > ir-kbd has suddenly improved, this will not work at all for HVR-1950
> > class devices nor MCE type PVR-24xxx devices (different incompatible IR
> > receiver).
>
> I'm sorry but you can't blame me for ir-kbd-i2c not supporting some
> devices. I updated the driver to make use of the new binding model, but
> that's about all I did.
>
> > This is why the pvrusb2 driver has never directly attempted to load
> > ir-kbd.
>
> The pvrusb2 driver however abuses the bttv driver's I2C adapter ID
> (I2C_HW_B_BT848) and was thus affected when ir-kbd-i2c is loaded. This
> is the only reason why my patch touches the pvrusb2 driver. If you tell
> me you want the ir-kbd-i2c driver to leave pvrusb2 alone, I can drop
> all the related changes from my patch, that's very easy.

Let's keep it simple: add a 'load_ir_kbd_i2c' module option for those 
drivers that did not autoload this module. The driver author can refine 
things later (I'll definitely will do that for ivtv).

It will be interesting if someone can find out whether lirc will work at all 
once autoprobing is removed from i2c. If it isn't, then perhaps that will 
wake them up to the realization that they really need to move to the 
kernel.

The new mechanism is the right way to do it: the adapter driver has all the 
information if, where and what IR is used and so should be the one to tell 
the kernel what to do. Attempting to autodetect and magically figure out 
what IR might be there is awkward and probably impossible to get right 
100%.

Hell, it's wrong already: if you have another board that already loads 
ir-kbd-i2c then if you load ivtv or pvrusb2 afterwards you get ir-kbd-i2c 
whether you like it or not, because ir-kbd-i2c will connect to your i2c 
adapter like a leech. So with the addition of a module option you at least 
give back control of this to the user.

When this initial conversion is done I'm pretty sure we can improve 
ir-kbd-i2c to make it easier to let the adapter driver tell it what to do. 
So we don't need those horrible adapter ID tests and other magic that's 
going on in that driver. But that's phase two.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
