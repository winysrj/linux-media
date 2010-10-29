Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:35275 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab0J2TRP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 15:17:15 -0400
Date: Fri, 29 Oct 2010 21:17:11 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101029191711.GA12136@hardeman.nu>
References: <20101029031131.GE17238@redhat.com>
 <20101029031530.GH17238@redhat.com>
 <4CCAD01A.3090106@redhat.com>
 <20101029151141.GA21604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101029151141.GA21604@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Oct 29, 2010 at 11:11:41AM -0400, Jarod Wilson wrote:
> So the Apple remotes do something funky... One of the four bytes is a
> remote identifier byte, which is used for pairing the remote to a specific
> device, and you can change the ID byte by simply holding down buttons on
> the remote.

How many different ID's are possible to set on the remote?

> We could ignore the ID byte, and just match all Apple remotes,
> or we could add some sort of pairing support where we require the right ID
> byte in order to do scancode -> keycode mapping... But in the match all
> case, I think we need the NEC extended scancode (e.g. 0xee8703 for KEY_MENU
> on my remote), while in the match paired case, we need the full
> 4-byte/32-bit code... Offhand, I'm not quite sure how to cleanly handle
> both cases.

If the number of possible ID values is not obscene, you could report the 
full 32 bit scancode and have a keymap with all the different 
variations.

-- 
David Härdeman
