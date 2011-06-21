Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63186 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1FURMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 13:12:01 -0400
Received: by gyh3 with SMTP id 3so1902238gyh.19
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2011 10:12:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E00B1D0.5080101@redhat.com>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>
	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>
	<BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>
	<BANLkTimg0X5H5T8CsSR5Tr0CZbCZKiDEEA@mail.gmail.com>
	<4DFFB1DA.5000602@redhat.com>
	<BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com>
	<4DFFF56D.5070602@redhat.com>
	<4E007AA7.7070400@linuxtv.org>
	<BANLkTik3ACfDwkyKVU2eZtxBeLH_mGh7pg@mail.gmail.com>
	<4E00B1D0.5080101@redhat.com>
Date: Tue, 21 Jun 2011 19:12:00 +0200
Message-ID: <BANLkTim12gAKsK7OXMw3eTcEq6ds1cYuYA@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: Markus Rechberger <mrechberger@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andreas Oberritter <obi@linuxtv.org>, HoP <jpetrous@gmail.com>,
	=?ISO-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>,
	=?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/21 Mauro Carvalho Chehab <mchehab@redhat.com>:
> Em 21-06-2011 10:44, Devin Heitmueller escreveu:
>
>> Mauro, ultimately it is your decision as the maintainer which drivers
>> get accepted in to the kernel.  I can tell you though that this will
>> be a very bad thing for the driver ecosystem as a whole - it will
>> essentially make it trivial for vendors (some of which who are doing
>> GPL work now) to provide solutions that reuse the GPL'd DVB core
>> without having to make any of their stuff open source.
>
> I was a little faster to answer to my previous emails. I'm not feeling
> well today due to a strong pain on my backbone.
>
> So, let me explain what would be ok, from my POV:
>
> A kernelspace driver that will follow DVBv5 API and talk with wit another
> device via the Kernel network stack, in order to access a remote Kernel board,
> or a kernel board at the physical machine, for virtual machines. That means that
> the dvb stack won't be proxied to an userspace application.
>
> Something like:
>
> Userspace app (like kaffeine, dvr, etc) -> DVB net_tunnel driver -> Kernel Network stack
>
> Kernel Network stack -> DVB net_tunnel driver -> DVB hardware
>

for such a design a developer should be fired ^^
Everything back to ring 0, however I guess that particular developer
who "designed" this does not
know about that security concept, otherwise he wouldn't propose to put
such things into kernelspace.

and from the kernel network stack you go via TCP and connect to
whoever you want (particular userspace
daemon with all the implementation).
Aside of the security issue which it introduces you won't even protect
what you try to protect because you
cannot control the connection.

It would be interesting if someone would implement it that way now, so
Mauro disqualified himself with this proposal.

Although please continue I'll keep watching, either result (supporting
or not supporting it) is fine with me.

Markus
> In other words, the "DVB net_tunnel" driver will take care of using the
> network stack, implement Kernel namespaces, etc, in order to allow virtualizing
> a remote hardware, without needing any userspace driver for doing that
> (well, except, of course, for the standard network userspace applications for
> DNS solving, configuring IP routes, etc).
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
