Return-path: <linux-media-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:36939 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab0EJSs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 14:48:56 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Status of the patches under review (85 patches) and some misc notes about the devel procedures
Date: Mon, 10 May 2010 15:46:39 -0300
Cc: LMML <linux-media@vger.kernel.org>, awalls@md.metrocast.net,
	moinejf@free.fr, g.liakhovetski@gmx.de, pboettcher@dibcom.fr,
	awalls@radix.net, crope@iki.fi, davidtlwong@gmail.com,
	liplianin@tut.by, isely@isely.net, tobias.lorenz@gmx.net,
	hdegoede@redhat.com, abraham.manu@gmail.com,
	u.kleine-koenig@pengutronix.de, stoth@kernellabs.com,
	henrik@kurelid.se
References: <20100507093916.2e2ef8e3@pedra> <201005080234.05889.herton@mandriva.com.br> <4BE5E89C.2090405@redhat.com>
In-Reply-To: <4BE5E89C.2090405@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005101546.39596.herton@mandriva.com.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sáb 08 Mai 2010, às 19:41:32, Mauro Carvalho Chehab escreveu:
> Herton Ronaldo Krzesinski wrote:
> > Em Sex 07 Mai 2010, às 09:39:16, Mauro Carvalho Chehab escreveu:
> >> 		== Patch(broken) - waiting for Herton Ronaldo Krzesinski <herton@mandriva.com.br> new submission == 
> >>
> >> Apr, 5 2010: saa7134: add support for Avermedia M733A                               http://patchwork.kernel.org/patch/90692
> > 
> > Hi, I submitted now a new fixed version of the patch to mailing list, under
> > title "[PATCH v2] saa7134: add support for Avermedia M733A"
> 
> OK, thanks!
> 
> >> Mar,19 2010: saa7134: add support for one more remote control for Avermedia M135A   http://patchwork.kernel.org/patch/86989
> > 
> > This was the addition of RM-K6 remote control to M135A too, I think we can drop
> > this, since adding this to the kernel is deprecated now in favour of assigning
> > keymaps in userspace (keytable tool from v4l-utils), right?
> 
> For now, I prefer to add the keytab there, since there are some scripts that syncs v4l-util
> keytables with the kernel ones. If you prefer, you may the put RM-K6 table together
> with the other M135A keytable. I intend to group the non-conflicting keytables soon,
> and it makes kense to group both the original and the RM-K6 into the same table, in order to 
> provide an easier hot-plug support for this device.

Ok, I updated and tested a new patch now, and sent with title
"[PATCH] saa7134: add RM-K6 remote control support for Avermedia M135A"

--
[]'s
Herton
