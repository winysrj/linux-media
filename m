Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab0G1Rdo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 13:33:44 -0400
Date: Wed, 28 Jul 2010 13:23:03 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/9] IR: minor fixes:
Message-ID: <20100728172303.GC26480@redhat.com>
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>
 <1280330051-27732-3-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280330051-27732-3-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 06:14:04PM +0300, Maxim Levitsky wrote:
> * lirc: Don't propagate reset event to userspace
> * lirc: Remove strange logic from lirc that would make first sample always be pulse
> * Make TO_US macro actualy print what it should.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

For the ir-lirc-codec-specific bits:

Acked-by: Jarod Wilson <jarod@redhat.com>

I'm inclined to pull them into my tree now, and the IR_dprintk and TO_US
portions can be handled separately.

-- 
Jarod Wilson
jarod@redhat.com

