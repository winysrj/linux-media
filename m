Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55895 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab0F1Dei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 23:34:38 -0400
Received: by vws19 with SMTP id 19so626444vws.19
        for <linux-media@vger.kernel.org>; Sun, 27 Jun 2010 20:34:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277680645.3347.7.camel@localhost>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
	<20100607193238.21236.72227.stgit@localhost.localdomain>
	<4C273FFE.4090300@redhat.com>
	<AANLkTimDJAyvowo_1bLhKPhlDWzzMeF87or4MriJ_UT8@mail.gmail.com>
	<1277680645.3347.7.camel@localhost>
Date: Sun, 27 Jun 2010 23:34:36 -0400
Message-ID: <AANLkTinda8JSa3XRZSSbEuj9JKVkLnRNwnW4YGBtDfWj@mail.gmail.com>
Subject: Re: MCEUSB memory leak and how to tell if ir_register_input() failure
	registered input_dev?
From: Jarod Wilson <jarod@wilsonet.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 27, 2010 at 7:17 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>
> Jarrod,
>
> Looking at the patches branch from your WIP git tree:
>
> Is mceusb_init_input_dev() supposed to allocate a struct ir_input_dev?
> It looks like ir_register_input() handles that, and it is trashing your
> pointer (memory leak).

Eep, crap, you're right. Fixed locally (I think), will test it out and
ship off the patch probably tomorrow (exhausting weekend of watching
futbol and some heavy-duty bbq'ing, need to turn in early... ;).

Just double-checked, I actually cribbed that incorrectness from
imon.c, so I'll need to fix it there too. D'oh.

> Mauro and Jarrod,
>
> When ir_register_input() fails, it doesn't indicate whether or not it
> was able to register the input_dev or not.  To me it looks like it can
> return with failure with the input_dev either way depending on the case.
> This makes proper cleanup of the input_dev in my cx23885_input_init()
> function difficult in the failure case, since the input subsystem has
> two different deallocators depending on if the device had been
> registered or not.

Hm. I've done a double-take a few times now, but if
input_register_device is successful, and something later in
__ir_input_register fails, input_unregister_device *does* get called
within __ir_input_register, so all you should have to do is call
input_free_device in your init function's error path, no?

-- 
Jarod Wilson
jarod@wilsonet.com
