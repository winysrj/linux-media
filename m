Return-path: <linux-media-owner@vger.kernel.org>
Received: from 18.mo3.mail-out.ovh.net ([87.98.172.162]:44977 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752147Ab2AGQXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2012 11:23:14 -0500
Received: from mail191.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo3.mail-out.ovh.net (Postfix) with SMTP id 3ABF61008840
	for <linux-media@vger.kernel.org>; Sat,  7 Jan 2012 14:58:38 +0100 (CET)
Message-ID: <4F084F40.3070703@ventoso.org>
Date: Sat, 07 Jan 2012 14:57:20 +0100
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Antti Palosaari <crope@iki.fi>,
	Johannes Stezenbach <js@sig21.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] af9005, af9015: use symbolic names for USB
 id table indices
References: <20111222215356.GA4499@rotes76.wohnheim.uni-kl.de> <20111222234446.GB10497@elie.Belkin> <201112231820.03693.pboettcher@kernellabs.com> <20111223230045.GE21769@elie.Belkin> <4F06F512.9090704@redhat.com> <20120107080136.GA10247@elie.hsd1.il.comcast.net> <20120107081127.GC10247@elie.hsd1.il.comcast.net>
In-Reply-To: <20120107081127.GC10247@elie.hsd1.il.comcast.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Al 07/01/12 09:11, En/na Jonathan Nieder ha escrit:
> The af9005_properties and af9015_properties tables make use of USB ids
> from the USB id tables with hardcoded indices, as in
> "&af9015_usb_table[30]".  Adding new entries before the end breaks
> such references, so everyone has had to carefully tiptoe to only add
> entries at the end of the list.
> 
> In the spirit of "dw2102: use symbolic names for dw2102_table
> indices", use C99-style initializers with symbolic names for each
> index to avoid this.  In the new regime, properties tables referring
> to the USB ids have names like "&af9015_usb_table[CINERGY_T_STICK_RC]"
> that do not change meaning when items in the USB id table are
> reordered.
> 
> Encouraged-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>

Seems good to me, didn't know you could do that in C.

Acked-by: Luca Olivetti <luca@ventoso.org>

Bye
-- 
Luca
