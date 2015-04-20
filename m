Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:41985 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbbDTG1W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2015 02:27:22 -0400
Date: Mon, 20 Apr 2015 08:27:20 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Jemma Denson <jdenson@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for TechniSat Skystar S2
Message-ID: <20150420082720.40dbbb7a@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <5530F2E6.3070301@gmail.com>
References: <201504122132.t3CLW6fQ018555@jemma-pc.denson.org.uk>
	<552B62EF.8050705@gmail.com>
	<20150417110630.554290f5@dibcom294.coe.adi.dibcom.com>
	<5530F2E6.3070301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jemma,

On Fri, 17 Apr 2015 12:47:50 +0100 Jemma Denson <jdenson@gmail.com>
wrote:

> > To prepare an integration into 4.2 (or at least 4.3) I suggest
> > using my media_tree on linuxtv.org .
> >
> > http://git.linuxtv.org/cgit.cgi/pb/media_tree.git/ cx24120-v2
> >
> > I added a checkpatch-patch on top of it. If you can, please base any
> > future work of yours on this tree until is has been integrated.
> Will do! If I can work out the SNR scale I have got plans to have
> this work in the new way of doing this. Did you ever manage to obtain
> a datasheet for this demod? I have tried contacting NXP but haven't 
> received anything back.

What can I say: it works. I'm just using it as a DVB-S2 receiver for my
vdr-installation and I can successfully zap and vdr is doing its
background/epg scanning.

I consider it OK for inclusion. Any fixes, if any, can be later on.

regards,
--
Patrick.


