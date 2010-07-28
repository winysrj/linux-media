Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0G1VIg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 17:08:36 -0400
Date: Wed, 28 Jul 2010 16:57:55 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 4/9] IR: add helper functions for ir input devices that
 send ir timing data in small chunks, and alternation between pulses and
 spaces isn't guaranteed.
Message-ID: <20100728205755.GI26480@redhat.com>
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>
 <1280330051-27732-5-git-send-email-maximlevitsky@gmail.com>
 <20100728174626.GE26480@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728174626.GE26480@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 01:46:27PM -0400, Jarod Wilson wrote:
> On Wed, Jul 28, 2010 at 06:14:06PM +0300, Maxim Levitsky wrote:
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> With the caveat of requiring an improved changelog, per Mauro's suggestion:
> 
> Acked-by: Jarod Wilson <jarod@redhat.com>
> 
> I suspect at least some of this code may be of use to the streamzap driver
> as well (which I started looking at porting last night, despite my
> insistence that I was going to work on lirc_zilog first...).

One other note: idle looks like it can happily exist as a bool instead of
as an int, no?

-- 
Jarod Wilson
jarod@redhat.com

