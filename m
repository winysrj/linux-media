Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826Ab0F0ML5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 08:11:57 -0400
Message-ID: <4C273FFE.4090300@redhat.com>
Date: Sun, 27 Jun 2010 09:11:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/8] ir-core: partially convert bt8xx to not use ir-functions.c
References: <20100607192830.21236.69701.stgit@localhost.localdomain> <20100607193238.21236.72227.stgit@localhost.localdomain>
In-Reply-To: <20100607193238.21236.72227.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-06-2010 16:32, David Härdeman escreveu:
> Partially convert drivers/media/video/bt8xx/bttv-input.c to
> not use ir-functions.c.
> 
> Since the last user is gone with this patch, also remove a
> bunch of code from ir-functions.c.

This patch breakd mceusb driver:

drivers/media/IR/mceusb.c: In function ‘mceusb_init_input_dev’:
drivers/media/IR/mceusb.c:774: error: invalid application of ‘sizeof’ to incomplete type ‘struct ir_input_state’ 
drivers/media/IR/mceusb.c:785: error: implicit declaration of function ‘ir_input_init’
make[1]: ** [drivers/media/IR/mceusb.o] Erro 1
make[1]: ** Esperando que outros processos terminem.
make: ** [drivers/media/IR/] Erro 2

Also, the description is wrong, since it changes not only bttv, but also cx23885 and saa7134.

Cheers,
Mauro
