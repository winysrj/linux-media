Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46894 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590AbcB0SFa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 13:05:30 -0500
Date: Sat, 27 Feb 2016 15:05:24 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem since commit c73bbaa4ec3e [rc-core: don't lock device
 at rc_register_device()]
Message-ID: <20160227150524.7d8d6fbb@recife.lan>
In-Reply-To: <56D1CA81.10802@gmail.com>
References: <56D19314.3050409@gmail.com>
	<56D1CA81.10802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 27 Feb 2016 17:10:41 +0100
Heiner Kallweit <hkallweit1@gmail.com> escreveu:

> Am 27.02.2016 um 13:14 schrieb Heiner Kallweit:
> > Since this commit I see the following error when the Nuvoton RC driver is loaded:
> > 
> > input: failed to attach handler kbd to device input3, error: -22
> > 
> > Error 22 (EINVAL) comes from the new check in rc_open().
> >   
> 
> Complete call chain seems to be:
>   rc_register_device
>   input_register_device
>   input_attach_handler
>   kbd_connect
>   input_open_device
>   ir_open
>   rc_open
> 
> rc_register_device calls input_register_device before dev->initialized = true,
> therefore the new check in rc_open fails. At a first glance I'd say that we have
> to remove this check from rc_open.

Hmm... maybe we could, instead, do:

	if (!rdev->initialized) {
		rval = -ERESTARTSYS;
		goto unlock;
	}



> 
> Regards, Heiner
> 


-- 
Thanks,
Mauro
