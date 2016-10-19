Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46596
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942678AbcJSPIe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 11:08:34 -0400
Date: Wed, 19 Oct 2016 08:20:45 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux1394-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 53/58] firewire: don't break long lines
Message-ID: <20161019082045.00576ed0@vento.lan>
In-Reply-To: <20161019095625.4f3579ad@kant>
References: <cover.1476822924.git.mchehab@s-opensource.com>
        <bce754e03eef20b560c05a33d7cf68f6030e68e7.1476822925.git.mchehab@s-opensource.com>
        <84c06fb2-d147-689d-8d42-ce6b1f400a1f@sakamocchi.jp>
        <20161019095625.4f3579ad@kant>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Oct 2016 09:56:25 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> escreveu:

> On Oct 19 Takashi Sakamoto wrote:
> > --- a/drivers/media/firewire/firedtv-rc.c
> > +++ b/drivers/media/firewire/firedtv-rc.c
> > @@ -184,8 +184,9 @@ void fdtv_handle_rc(struct firedtv *fdtv, unsigned
> > int code)
> >  	else if (code >= 0x4540 && code <= 0x4542)
> >  		code = oldtable[code - 0x4521];
> >  	else {
> > -		printk(KERN_DEBUG "firedtv: invalid key code 0x%04x "
> > -		       "from remote control\n", code);
> > +		dev_dbg(fdtv->device,
> > +			"invalid key code 0x%04x from remote control\n",
> > +			code);
> >  		return;
> >  	}
> >   
> 
> Yes, dev_XYZ(fdtv->device, ...) is better here and is already used this
> way throughout the firedtv driver.  firedtv-rc.c somehow fell through the
> cracks when firedtv was made to use dev_XYZ().
> 
> (On an unrelated note, this reminds me that I still need to take care of
> Mauro's patches "Add a keymap for FireDTV board" and "firedtv: Port it to
> use rc_core" from May 28, 2012.)

Oh! I forgot about those a long time ago ;) Yeah, it would be great if
you could look into those patches when you have some time.

Thanks,
Mauro
