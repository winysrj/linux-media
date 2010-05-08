Return-path: <linux-media-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:44603 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0EHFeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 May 2010 01:34:31 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Status of the patches under review (85 patches) and some misc notes about the devel procedures
Date: Sat, 8 May 2010 02:34:05 -0300
Cc: LMML <linux-media@vger.kernel.org>, awalls@md.metrocast.net,
	moinejf@free.fr, g.liakhovetski@gmx.de, pboettcher@dibcom.fr,
	awalls@radix.net, crope@iki.fi, davidtlwong@gmail.com,
	liplianin@tut.by, isely@isely.net, tobias.lorenz@gmx.net,
	hdegoede@redhat.com, abraham.manu@gmail.com,
	u.kleine-koenig@pengutronix.de, stoth@kernellabs.com,
	henrik@kurelid.se
References: <20100507093916.2e2ef8e3@pedra>
In-Reply-To: <20100507093916.2e2ef8e3@pedra>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005080234.05889.herton@mandriva.com.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sex 07 Mai 2010, às 09:39:16, Mauro Carvalho Chehab escreveu:
> 		== Patch(broken) - waiting for Herton Ronaldo Krzesinski <herton@mandriva.com.br> new submission == 
> 
> Apr, 5 2010: saa7134: add support for Avermedia M733A                               http://patchwork.kernel.org/patch/90692

Hi, I submitted now a new fixed version of the patch to mailing list, under
title "[PATCH v2] saa7134: add support for Avermedia M733A"

> Mar,19 2010: saa7134: add support for one more remote control for Avermedia M135A   http://patchwork.kernel.org/patch/86989

This was the addition of RM-K6 remote control to M135A too, I think we can drop
this, since adding this to the kernel is deprecated now in favour of assigning
keymaps in userspace (keytable tool from v4l-utils), right?

--
[]'s
Herton
