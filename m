Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0CFRLq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Mar 2010 12:11:46 -0500
Message-ID: <4B928CBF.8070807@redhat.com>
Date: Sat, 06 Mar 2010 14:11:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org,
	linuxtv-commits-bounces@linuxtv.org, linuxtv-commits@linuxtv.org,
	"Eric W.Biederman" <ebiederm@xmission.com>
Subject: Re: [git:v4l-dvb/master] sysfs: sysfs_sd_setattr set iattrs	unconditionally
References: <E1Nnuwt-0000VK-9b@www.linuxtv.org> <20100306170655.03d97556@hyperion.delvare> <20100306161251.GA23287@suse.de>
In-Reply-To: <20100306161251.GA23287@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg KH wrote:
> On Sat, Mar 06, 2010 at 05:06:55PM +0100, Jean Delvare wrote:
>> Err, what's happening here? I can't see any chmod call in any V4L or DVB
>> driver, so why would this patch matter there? And we will get this fix
>> through Linus' tree anyway, so why bother at all? I'm puzzled.
> 
> I'm confused too, I got a bunch of these, for patches that seem to be in
> Linus's tree already.  Did a script go haywire?

Sorry!

There's an post receive hook script that sends an email to the patch author/SOB's 
for the new patches added at v4l-dvb git tree. Unfortunately, the git mailbomb 
script did something wrong: it handled badly all the upstream patches 
that  were merged back on git. I'll need to figure out a way for it to exclude 
patches that got merged from the normal posts.

For now, I've disabled it and removed the patches that were on the queue.

-- 

Cheers,
Mauro
