Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:32834 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3CFWR4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 17:17:56 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so7998648lab.37
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 14:17:54 -0800 (PST)
Date: Thu, 7 Mar 2013 02:10:14 +0400
From: Volokh Konstantin <volokh84@gmail.com>
To: Darrick Burch <darrick@tuffmail.com>
Cc: volokh84@gmail.com, linux-media@vger.kernel.org
Subject: Re: Regarding linux go7007 driver
Message-ID: <20130306221013.GA10958@Volokh.Home>
References: <26718.207.87.255.226.1362592320.squirrel@webmail.tuffmail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26718.207.87.255.226.1362592320.squirrel@webmail.tuffmail.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 06, 2013 at 12:52:00PM -0500, Darrick Burch wrote:
> Kolokh:
> 
> I've been doing some work on the go7007 driver in order to make it work
> properly with my device, an ADS DVD XPress DX2.  This device is USB and
> uses the EZ-USB controller using a tw9906 as a video decoder.  There is
> actually a patch floating around which is supposed to make this work and
> I've been able to merge the needed changes in order for the go7007-usb
> driver to detect the device.
> 
Hi, Darrick,
Hans Verkuil start to a massive overhaul of the go7007 driver , so he collect these patches on
http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/go7007

for git use latest:
git remote add hverkuil git://git.linuxtv.org/hverkuil/media_tree.git 
git remote update
git checkout -b go7007 hverkuil/go7007

So, there are last patches applied (including mine).
I hope, what that work will be merged in linux.git branch (when repair will done)

> However, I see that there is a problem with the way the i2c subdevice
> modules are written.  When the go7007 module attempts to register any of
> these subdevices with video4linux, there is a kernel oops since their
> private state structs do not contain v4l2_subdev as a first member.
> 
> I see that you had attempted to correct this problem for the tw2804 in
> this patch...
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/staging/media/go7007?id=0982db20aba5fd124bb5942d679d8732478e992a
> 
> ..but it was rejected and reverted.  Was there a reason why it was never
> resubmitted?  I see an opportunity to get acquainted with kernel module
> development by fixing the subdevice drivers, but I didn't know if there
> were any existing plans for this module and whether or not my effort would
> be worth it.
> 
> Thanks,
> -Darrick
Regards,
Volokh
> 
