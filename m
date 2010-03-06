Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab0CFQMa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Mar 2010 11:12:30 -0500
Date: Sat, 6 Mar 2010 08:12:51 -0800
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org, linuxtv-commits-bounces@linuxtv.org,
	linuxtv-commits@linuxtv.org,
	"Eric W.Biederman" <ebiederm@xmission.com>
Subject: Re: [git:v4l-dvb/master] sysfs: sysfs_sd_setattr set iattrs
	unconditionally
Message-ID: <20100306161251.GA23287@suse.de>
References: <E1Nnuwt-0000VK-9b@www.linuxtv.org> <20100306170655.03d97556@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306170655.03d97556@hyperion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 06, 2010 at 05:06:55PM +0100, Jean Delvare wrote:
> Err, what's happening here? I can't see any chmod call in any V4L or DVB
> driver, so why would this patch matter there? And we will get this fix
> through Linus' tree anyway, so why bother at all? I'm puzzled.

I'm confused too, I got a bunch of these, for patches that seem to be in
Linus's tree already.  Did a script go haywire?

greg k-h
