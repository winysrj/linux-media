Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59951 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbZIGWki (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 18:40:38 -0400
Date: Mon, 7 Sep 2009 19:40:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: Andy Walls <awalls@radix.net>, linuxtv-commits@linuxtv.org,
	Jarod Wilson <jarod@wilsonet.com>,
	Hans Verkuil via Mercurial <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] cx25840: fix determining the
 firmware name
Message-ID: <20090907194007.37c222cc@caramujo.chehab.org>
In-Reply-To: <37219a840909071521j67e9c3d6h1e9b2e1a8ded45cd@mail.gmail.com>
References: <E1MiTfS-0001LQ-SU@mail.linuxtv.org>
	<37219a840909041105u7fe714aala56893566d93cdc3@mail.gmail.com>
	<20090907021002.2f4d3a57@caramujo.chehab.org>
	<37219a840909062220p3ae71dc0t4df96fd140c5c7b4@mail.gmail.com>
	<20090907030652.04e2d2a3@caramujo.chehab.org>
	<1252340384.3146.52.camel@palomino.walls.org>
	<37219a840909070925k25ed146bn9c3725596c9490b9@mail.gmail.com>
	<20090907183632.195dc3e5@caramujo.chehab.org>
	<37219a840909071521j67e9c3d6h1e9b2e1a8ded45cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 7 Sep 2009 18:21:01 -0400
Michael Krufky <mkrufky@kernellabs.com> escreveu:
 
> Mauro,
> 
> For the Conexant *reference designs* the firmwares are identical, yes.
> 
> If you look at the windows drivers, there are some additional bits
> used for separate firmwares depending on which actual silicon is
> present.  This is specific to the implementation by the vendors.

If firmware versions are vendor-specific, then the patch "cx25840: fix
determining the  firmware name" doesn't work, since people may have two boards
with the same silicon from different vendors, each requiring his own
vendor-specific firmware.

The solution seems to have a setup parameter with the firmware name, adding the
firmware name at the *-cards.c, like what's done with xc3028 firmwares. This
also means that we need vendor's rights to distribute the specific firmwares.
> 
> Not everybody is using the firmware images that you are pointing at...
>  There is in fact a need to keep the filenames separate.  Some
> firmware for one silicon may conflict with firmware for other silicon.
> 
> -Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
