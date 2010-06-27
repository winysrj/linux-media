Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53204 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713Ab0F0Vhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 17:37:42 -0400
Subject: Re: [PATCH 5/8] ir-core: partially convert bt8xx to not use
 ir-functions.c
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
In-Reply-To: <AANLkTimDJAyvowo_1bLhKPhlDWzzMeF87or4MriJ_UT8@mail.gmail.com>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
	 <20100607193238.21236.72227.stgit@localhost.localdomain>
	 <4C273FFE.4090300@redhat.com>
	 <AANLkTimDJAyvowo_1bLhKPhlDWzzMeF87or4MriJ_UT8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Jun 2010 17:37:51 -0400
Message-ID: <1277674672.5091.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-06-27 at 16:17 -0400, Jarod Wilson wrote:
> On Sun, Jun 27, 2010 at 8:11 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Em 07-06-2010 16:32, David Härdeman escreveu:
> >> Partially convert drivers/media/video/bt8xx/bttv-input.c to
> >> not use ir-functions.c.
> >>
> >> Since the last user is gone with this patch, also remove a
> >> bunch of code from ir-functions.c.
> >
> > This patch breakd mceusb driver:
> >
> > drivers/media/IR/mceusb.c: In function ‘mceusb_init_input_dev’:
> > drivers/media/IR/mceusb.c:774: error: invalid application of ‘sizeof’ to incomplete type ‘struct ir_input_state’
> > drivers/media/IR/mceusb.c:785: error: implicit declaration of function ‘ir_input_init’
> > make[1]: ** [drivers/media/IR/mceusb.o] Erro 1
> > make[1]: ** Esperando que outros processos terminem.
> > make: ** [drivers/media/IR/] Erro 2
> 
> The mceusb driver doesn't actually need ir_input_state at all, 

I just came to that conclusion 5 minutes ago for the cx23885 driver as
well.  Right now it does use it, but once I get this conversion
complete, it won't need it either AFAICT.

I guess Mauro's build never got to the cx23885 driver.

Regards,
Andy


