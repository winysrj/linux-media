Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:56893 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZKZSNE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 13:13:04 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, jarod@wilsonet.com,
	awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDcbizrJjFB@christoph> <4B0EABF8.9000902@redhat.com>
Date: Thu, 26 Nov 2009 19:13:08 +0100
In-Reply-To: <4B0EABF8.9000902@redhat.com> (Mauro Carvalho Chehab's message of
	"Thu, 26 Nov 2009 14:25:28 -0200")
Message-ID: <m3r5rlupcb.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> 1) the developer that adds the hardware also adds the IR code. He has
> the hardware and the IR for testing, so it means a faster development
> cycle than waiting for someone else with the same hardware and IR to
> recode it on some other place. You should remember that not all
> developers use lirc;

It's fine, but please - no keymaps in the kernel (except for fixed
receivers, i.e. the ones which can only work with their own dedicated
remote, and which don't pass RC5/etc. code).

The existing keymaps (those which can be used with lirc) have to be
moved to userspace as well.
-- 
Krzysztof Halasa
