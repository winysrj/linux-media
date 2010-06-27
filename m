Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:21320 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683Ab0F0POj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 11:14:39 -0400
Subject: Re: [PATCH 5/8] ir-core: partially convert bt8xx to not use
 ir-functions.c
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
In-Reply-To: <4C273FFE.4090300@redhat.com>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
	 <20100607193238.21236.72227.stgit@localhost.localdomain>
	 <4C273FFE.4090300@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Jun 2010 11:14:54 -0400
Message-ID: <1277651694.2329.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-06-27 at 09:11 -0300, Mauro Carvalho Chehab wrote:
> Em 07-06-2010 16:32, David Härdeman escreveu:
> > Partially convert drivers/media/video/bt8xx/bttv-input.c to
> > not use ir-functions.c.
> > 
> > Since the last user is gone with this patch, also remove a
> > bunch of code from ir-functions.c.
> 
> This patch breakd mceusb driver:
> 
> drivers/media/IR/mceusb.c: In function ‘mceusb_init_input_dev’:
> drivers/media/IR/mceusb.c:774: error: invalid application of ‘sizeof’ to incomplete type ‘struct ir_input_state’ 
> drivers/media/IR/mceusb.c:785: error: implicit declaration of function ‘ir_input_init’
> make[1]: ** [drivers/media/IR/mceusb.o] Erro 1
> make[1]: ** Esperando que outros processos terminem.
> make: ** [drivers/media/IR/] Erro 2
> 
> Also, the description is wrong, since it changes not only bttv, but also cx23885 and saa7134.

Mauro,

I'll be removing the RC5 and NEC decoding from the cx23885 driver
hopefully by the end of the day.  That will make parts of David's patch
obsolete.

I'll be developing off of the v4l-dvb.git staging/rc branch.  Is that
the right branch to use?

Also the IR registration Ooops is not patched in staging/rc, so the
cx23885 driver Oops-es on load.  Is it OK if I pull in (fetch & merge)
the patch from some other branch, or would it be easier for you if I
just use an uncommitted patch in my working tree?

Regards,
Andy

Mauro



> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


