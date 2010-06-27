Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45623 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0F0URO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 16:17:14 -0400
Received: by vws19 with SMTP id 19so283451vws.19
        for <linux-media@vger.kernel.org>; Sun, 27 Jun 2010 13:17:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C273FFE.4090300@redhat.com>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
	<20100607193238.21236.72227.stgit@localhost.localdomain>
	<4C273FFE.4090300@redhat.com>
Date: Sun, 27 Jun 2010 16:17:11 -0400
Message-ID: <AANLkTimDJAyvowo_1bLhKPhlDWzzMeF87or4MriJ_UT8@mail.gmail.com>
Subject: Re: [PATCH 5/8] ir-core: partially convert bt8xx to not use
	ir-functions.c
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 27, 2010 at 8:11 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 07-06-2010 16:32, David Härdeman escreveu:
>> Partially convert drivers/media/video/bt8xx/bttv-input.c to
>> not use ir-functions.c.
>>
>> Since the last user is gone with this patch, also remove a
>> bunch of code from ir-functions.c.
>
> This patch breakd mceusb driver:
>
> drivers/media/IR/mceusb.c: In function ‘mceusb_init_input_dev’:
> drivers/media/IR/mceusb.c:774: error: invalid application of ‘sizeof’ to incomplete type ‘struct ir_input_state’
> drivers/media/IR/mceusb.c:785: error: implicit declaration of function ‘ir_input_init’
> make[1]: ** [drivers/media/IR/mceusb.o] Erro 1
> make[1]: ** Esperando que outros processos terminem.
> make: ** [drivers/media/IR/] Erro 2

The mceusb driver doesn't actually need ir_input_state at all, and one
of my pending patches removes it.

https://patchwork.kernel.org/patch/106549/


-- 
Jarod Wilson
jarod@wilsonet.com
