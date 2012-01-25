Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-n.franken.de ([193.175.24.27]:37072 "EHLO
	mail-n.franken.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2AYWY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 17:24:29 -0500
Received: from aqua.hirmke.de (aquarius.franken.de [193.175.24.89])
	by mail-n.franken.de (Postfix) with ESMTP id 0F8841C0B4611
	for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 23:24:27 +0100 (CET)
Date: Wed, 25 Jan 2012 23:24:25 +0100
From: Corinna Vinschen <vinschen@redhat.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] imon: don't wedge hardware after early callbacks
Message-ID: <20120125222425.GY2456@calimero.vinschen.de>
References: <20120124203605.GQ2456@calimero.vinschen.de>
 <1327524982-26593-1-git-send-email-jarod@redhat.com>
 <20120125221136.GX2456@calimero.vinschen.de>
 <4F207E2B.7060307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F207E2B.7060307@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jan 25 17:11, Jarod Wilson wrote:
> Corinna Vinschen wrote:
> >Hi Jarod,
> >
> >On Jan 25 15:56, Jarod Wilson wrote:
> >>This patch is just a minor update to one titled "imon: Input from ffdc
> >>device type ignored" from Corinna Vinschen. An earlier patch to prevent
> >>an oops when we got early callbacks also has the nasty side-effect of
> >>wedging imon hardware, as we don't acknowledge the urb. Rework the check
> >>slightly here to bypass processing the packet, as the driver isn't yet
> >>fully initialized, but still acknowlege the urb and submit a new rx_urb.
> >>Do this for both interfaces -- irrelevant for ffdc hardware, but
> >>relevant for newer hardware, though newer hardware doesn't spew the
> >>constant stream of data as soon as the hardware is initialized like the
> >>older ffdc devices, so they'd be less likely to trigger this anyway...
> >
> >just a question, wouldn't it make sense to bump the version number of the
> >module to 0.9.4?  Or do you do that for functional changes only?
> 
> I've not been terribly consistent with it, but it does seem the last
> time I bumped the version number *was* to have an easy way to tell
> if a particular fix was included or not. We can bump it here too,
> doesn't really matter to me.

Could be helpful here, too, I guess.


Corinna

-- 
Corinna Vinschen
Cygwin Project Co-Leader
Red Hat
