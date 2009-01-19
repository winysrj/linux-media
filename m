Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60023 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZASUxw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 15:53:52 -0500
Date: Mon, 19 Jan 2009 18:53:26 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: haupauge remote keycode for av7110_loadkeys
Message-ID: <20090119185326.29da37da@caramujo.chehab.org>
In-Reply-To: <4974E428.7020702@free.fr>
References: <4974E428.7020702@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Jan 2009 21:35:52 +0100
matthieu castet <castet.matthieu@free.fr> wrote:

> Hi,
> 
> I attached keycodes for 
> http://www.hauppauge.eu/boutique_us/images_produits/1111111.jpg remote.
> 
> Can it be added to dvb-apps/util/av7110_loadkeys/ repo.
> 
> Matthieu
> 
> PS : this is more or less a duplicate of keycode in 
> ir_codes_hauppauge_new (ir-kbd-i2c.c) and it could be useful to merge 
> them. But I like better the av7110_loadkeys approch, because with 
> ir-kbd-i2c you can't use other remote without modifying the source code.

Matthieu,

You can replace the ir-kbd-i2c keys using the standard input ioctls for it.
Take a look at v4l2-apps/util/keycode app. It allows you to read and replace
any IR keycodes on the driver that properly implements the event support
(including ir-kbd-i2c).

Cheers,
Mauro
