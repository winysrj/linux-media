Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323Ab0J2PLm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 11:11:42 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9TFBgGX011425
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 11:11:42 -0400
Date: Fri, 29 Oct 2010 11:11:41 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101029151141.GA21604@redhat.com>
References: <20101029031131.GE17238@redhat.com>
 <20101029031530.GH17238@redhat.com>
 <4CCAD01A.3090106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCAD01A.3090106@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Oct 29, 2010 at 11:46:02AM -0200, Mauro Carvalho Chehab wrote:
> Em 29-10-2010 01:15, Jarod Wilson escreveu:
> > On Thu, Oct 28, 2010 at 11:11:31PM -0400, Jarod Wilson wrote:
> >> I've got one of those tiny little 6-button Apple remotes here, now it can
> >> be decoded in-kernel (tested w/an mceusb transceiver).
> > 
> > Oh yeah, RFC, because I'm not sure if we should have a more generic "skip
> > the checksum check" support -- I seem to recall discussion about it in the
> > not so recent past. And a decoder hack for one specific remote is just
> > kinda ugly...
> 
> Yeah, I have the same doubt. One possibility would be to simply report a 32 bits
> code, if the check fails. I don't doubt that we'll find other remotes with
> a "NEC relaxed" protocol, with no checksum at all.

So the Apple remotes do something funky... One of the four bytes is a
remote identifier byte, which is used for pairing the remote to a specific
device, and you can change the ID byte by simply holding down buttons on
the remote. We could ignore the ID byte, and just match all Apple remotes,
or we could add some sort of pairing support where we require the right ID
byte in order to do scancode -> keycode mapping... But in the match all
case, I think we need the NEC extended scancode (e.g. 0xee8703 for KEY_MENU
on my remote), while in the match paired case, we need the full
4-byte/32-bit code... Offhand, I'm not quite sure how to cleanly handle
both cases. When using lirc, the full 32-bits are used, and you either
have your config with exact matches (remote ID byte included), or you add
an ignore mask, which tells scancode matching to just ignore the ID byte.

-- 
Jarod Wilson
jarod@redhat.com

