Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:32847 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbbETJJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 05:09:04 -0400
Date: Wed, 20 May 2015 06:08:53 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] [media] rc: teach lirc how to send scancodes
Message-ID: <20150520060853.5d3a5e0d@recife.lan>
In-Reply-To: <d83477bae9a733323fd072def6384a3b@hardeman.nu>
References: <cover.1426801061.git.sean@mess.org>
	<985a9b11e5e02eb43e16d27db23086528434be24.1426801061.git.sean@mess.org>
	<d83477bae9a733323fd072def6384a3b@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 May 2015 10:53:59 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On 2015-03-19 22:50, Sean Young wrote:
> > The send mode has to be switched to LIRC_MODE_SCANCODE and then you can
> > send one scancode with a write. The encoding is the same as for 
> > receiving
> > scancodes.
> 
> Why do the encoding in-kernel when it can be done in userspace?
> 
> I'd understand if it was hardware that accepted a scancode as input, but 
> that doesn't seem to be the case?

IMO, that makes the interface clearer. Also, the encoding code is needed
anyway, as it is needed to setup the wake up keycode on some hardware.
So, we already added encoder capabilities at some decoders:

0d830b2d1295 [media] rc: rc-core: Add support for encode_wakeup drivers
cf257e288ad3 [media] rc: ir-rc6-decoder: Add encode capability
a0466f15b465 [media] rc: ir-rc5-decoder: Add encode capability
1d971d927efa [media] rc: rc-ir-raw: Add Manchester encoder (phase encoder) helper
9869da5bacc5 [media] rc: rc-ir-raw: Add scancode encoder callback

> 
> > FIXME: Currently only the nec encoder can encode IR.

We actually need to be sure that the NEC encoder is doing the same
way as the RC5/RC6 encoders.

Regards,
Mauro
