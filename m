Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0G1U63 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 16:58:29 -0400
Date: Wed, 28 Jul 2010 16:47:47 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 5/9] IR: extend interfaces to support more device settings
Message-ID: <20100728204747.GH26480@redhat.com>
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>
 <1280330051-27732-6-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280330051-27732-6-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 06:14:07PM +0300, Maxim Levitsky wrote:
> Also reuse LIRC_SET_MEASURE_CARRIER_MODE as LIRC_SET_LEARN_MODE
> (LIRC_SET_LEARN_MODE will start carrier reports if possible, and
> tune receiver to wide band mode)
> 
> This IOCTL isn't yet used by lirc, so this won't break userspace.

Plus, once lirc 0.8.7 is released (Real Soon Now), we'll start working on
lirc 0.9.0 with the express goal of it being built against lirc.h as
provided by the kernel.

These all generally look good and sane to me, and I'll make use of the
LEARN_MODE bits for mceusb after something along these lines is committed.

I like the simplifications Mauro suggested for the ioctl handling. In
addition to those, there's a bit of whitespace damage in lirc.h that I'd
like to see cleaned up for v2.

-- 
Jarod Wilson
jarod@redhat.com

