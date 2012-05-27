Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab2E0Oir (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 10:38:47 -0400
Message-ID: <4FC23C6C.8040002@redhat.com>
Date: Sun, 27 May 2012 11:38:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: RC-core ".driver_name"
References: <4FC0BF3E.2080509@iki.fi>
In-Reply-To: <4FC0BF3E.2080509@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-05-2012 08:32, Antti Palosaari escreveu:
> Is there any reason RC-core .driver_name should be set as a module name which registers remote?
> 
> http://lxr.free-electrons.com/source/drivers/media/rc/rc-main.c
> 
> I see .driver_name is passed to the hotplug:
> if (dev->driver_name)
>     ADD_HOTPLUG_VAR("DRV_NAME=%s", dev->driver_name);
> 
> 
> ir-keytable command shows that name:
> # ir-keytable
>     Driver af9015, table rc-digitalnow-tinytwin
> 
> 
> I would like to use set name same as the device name - not the driver name. And af9015 is not the module name, correct is IMHO dvb_usb_af9015.


The RC hot-plug logic was conceived to use 2 parameters to decide what's the
right keytable to be loaded on userspace:
	- an unique per-driver string;
	- an unique per-board string.

On your above example, the per-driver string is "af9015", and the per-board one is "rc-digitalnow-tinytwin".

With those two strings, userspace can uniquely associate a keytable with the driver.

The ir-keytable tool also allows saying that everything on with "af9015" will use a
certain keytable, with this syntax at /etc/rc_maps.cfg:

af9015	*				./keycodes/rc5_hauppauge

So, I don't see any reason to change.

Also, changing it will break userspace API, as an old ir-keytable won't properly
handle the tables on a new Kernel. So, it is too late to change it.

Regards,
Mauro
