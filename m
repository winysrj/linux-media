Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57974 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZKZXOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 18:14:34 -0500
Date: Thu, 26 Nov 2009 15:14:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091126231436.GC6936@core.coreip.homeip.net>
References: <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <4B0AC65C.806@redhat.com> <m3zl6dq8ig.fsf@intrepid.localdomain> <4B0E765C.2080806@redhat.com> <m3iqcxuotd.fsf@intrepid.localdomain> <4B0ED238.6060306@redhat.com> <m3pr75rpqa.fsf@intrepid.localdomain> <4B0EED7D.90204@redhat.com> <m3ljhtrn83.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3ljhtrn83.fsf@intrepid.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 26, 2009 at 10:27:08PM +0100, Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
> > No. All the other API functions there work with 32 bits for scancodes.
> 
> We don't need them, do we? We need a new ioctl for changing key mappings
> anyway (a single ioctl for setting the whole table I think), and we can
> have arbitrary length of scan codes there.

Unless we determine that we 100% need bigger size of scancode then the
current ioctls are just fine. Why do we _need_ an ioctl to load the whole
tabe? Are you concerned about speed with which the keymap is populated?
I don't think it would be an issue.

-- 
Dmitry
