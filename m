Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38355 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0GFNx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jul 2010 09:53:27 -0400
Received: by gye5 with SMTP id 5so1742964gye.19
        for <linux-media@vger.kernel.org>; Tue, 06 Jul 2010 06:53:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C332A5F.4000706@redhat.com>
References: <4C332A5F.4000706@redhat.com>
Date: Tue, 6 Jul 2010 09:53:26 -0400
Message-ID: <AANLkTilUdPjgVJdKFGoXqgN5AvoHG_j_TpJWNVioeUdd@mail.gmail.com>
Subject: Re: Status of the patches under review at LMML (60 patches)
From: Steven Toth <stoth@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>, awalls@md.metrocast.net,
	moinejf@free.fr, g.liakhovetski@gmx.de, jarod@redhat.com,
	corbet@lwn.net, rz@linux-m68k.org, pboettcher@dibcom.fr,
	awalls@radix.net, crope@iki.fi, davidtlwong@gmail.com,
	laurent.pinchart@ideasonboard.com, eduardo.valentin@nokia.com,
	p.osciak@samsung.com, liplianin@tut.by, isely@isely.net,
	tobias.lorenz@gmx.net, hdegoede@redhat.com,
	u.kleine-koenig@pengutronix.de, abraham.manu@gmail.com,
	henrik@kurelid.se
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>                == Waiting for Steven Toth <stoth@kernellabs.com> review ==
>
> Feb, 6 2010: cx23885: Enable Message Signaled Interrupts(MSI).                      http://patchwork.kernel.org/patch/77492
> May, 5 2010: tda10048: fix the uncomplete function tda10048_read_ber                http://patchwork.kernel.org/patch/97058
> May, 6 2010: tda10048: fix bitmask for the transmission mode                        http://patchwork.kernel.org/patch/97340
> May, 6 2010: tda10048: clear the uncorrected packet registers when saturated        http://patchwork.kernel.org/patch/97341
> May, 6 2010: dvb_frontend: fix typos in comments and one function                   http://patchwork.kernel.org/patch/97343

Mauro,

I'm fine with all of these.

Signed-off-by: Steven Toth <stoth@kernellabs.com>

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
