Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab1FUO7k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 10:59:40 -0400
Message-ID: <4E00B1D0.5080101@redhat.com>
Date: Tue, 21 Jun 2011 11:59:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Andreas Oberritter <obi@linuxtv.org>, HoP <jpetrous@gmail.com>,
	=?ISO-8859-1?Q?=22S=E9bastien_RAILLARD_=28COEXSI=29=22?=
	<sr@coexsi.fr>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] vtunerc - virtual DVB device driver
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>	<201106202037.19535.remi@remlab.net>	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>	<BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>	<BANLkTimg0X5H5T8CsSR5Tr0CZbCZKiDEEA@mail.gmail.com>	<4DFFB1DA.5000602@redhat.com>	<BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com>	<4DFFF56D.5070602@redhat.com>	<4E007AA7.7070400@linuxtv.org> <BANLkTik3ACfDwkyKVU2eZtxBeLH_mGh7pg@mail.gmail.com>
In-Reply-To: <BANLkTik3ACfDwkyKVU2eZtxBeLH_mGh7pg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-06-2011 10:44, Devin Heitmueller escreveu:

> Mauro, ultimately it is your decision as the maintainer which drivers
> get accepted in to the kernel.  I can tell you though that this will
> be a very bad thing for the driver ecosystem as a whole - it will
> essentially make it trivial for vendors (some of which who are doing
> GPL work now) to provide solutions that reuse the GPL'd DVB core
> without having to make any of their stuff open source.

I was a little faster to answer to my previous emails. I'm not feeling
well today due to a strong pain on my backbone.

So, let me explain what would be ok, from my POV:

A kernelspace driver that will follow DVBv5 API and talk with wit another
device via the Kernel network stack, in order to access a remote Kernel board,
or a kernel board at the physical machine, for virtual machines. That means that
the dvb stack won't be proxied to an userspace application.

Something like:

Userspace app (like kaffeine, dvr, etc) -> DVB net_tunnel driver -> Kernel Network stack

Kernel Network stack -> DVB net_tunnel driver -> DVB hardware

In other words, the "DVB net_tunnel" driver will take care of using the
network stack, implement Kernel namespaces, etc, in order to allow virtualizing
a remote hardware, without needing any userspace driver for doing that
(well, except, of course, for the standard network userspace applications for
DNS solving, configuring IP routes, etc).

Cheers,
Mauro
