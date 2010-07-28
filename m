Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab0G1SJf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 14:09:35 -0400
Date: Wed, 28 Jul 2010 13:58:52 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 6/9] IR: actually allow not to compile keymaps in..
Message-ID: <20100728175852.GF26480@redhat.com>
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>
 <1280330051-27732-7-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280330051-27732-7-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 06:14:08PM +0300, Maxim Levitsky wrote:
> Currntly, ir device registration fails if keymap requested by driver is not found...
> Fix that by always compiling in the empty keymap, and using it as a failback
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

I like this one, useful improvement, I think. We even get meaningful
output logged as well -- get_rc_map() will let us know the initially
requested keymap failed to load, and then will let us know whether or not
the empty keymap loaded.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

