Return-path: <mchehab@pedra>
Received: from yop.chewa.net ([91.121.105.214]:43674 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932248Ab1FVTSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 15:18:18 -0400
Received: from basile.remlab.net (cs27062010.pp.htv.fi [89.27.62.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by yop.chewa.net (Postfix) with ESMTPSA id DC9AE16C6
	for <linux-media@vger.kernel.org>; Wed, 22 Jun 2011 21:18:15 +0200 (CEST)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
Date: Wed, 22 Jun 2011 22:18:12 +0300
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com> <BANLkTikmbVj1t7w3XmHXW58Kpvv0M_jbnQ@mail.gmail.com> <4E01DD57.3080508@redhat.com>
In-Reply-To: <4E01DD57.3080508@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106222218.14268.remi@remlab.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Le mercredi 22 juin 2011 15:17:27 Mauro Carvalho Chehab, vous avez écrit :
> > My very little opinion is that waving GPL is way to the hell. Nobody told
> > me why similar technologies, in different kernel parts are acceptable,
> > but not here.
> 
> If you want to do the networking code at userspace, why do you need a
> kernel driver after all?

Are you seriously asking why people write tunneling drivers in user-space? Or 
why they want to use the kernel-space socket API and protocol stack?

> The proper solution is to write an userspace
> library for that, and either enclose such library inside the applications,
> or use LD_PRELOAD to bind the library to handle the open/close/ioctl glibc
> calls. libv4l does that. As it proofed to be a good library, now almost
> all V4L applications are using it.

No. Set aside the problem of licensing, the correct way is to reuse existing 
code, which means the layer-3/4 stacks and the socket API in net/*. That 
avoids duplicating efforts (and bugs) and allows socket API apps to run 
unchanged and without brittle hacks like LD_PRELOAD.

And indeed, that's what the Linux ecosystem does, thanks to the tuntap network 
device driver.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
