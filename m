Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35968 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab2KPCN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 21:13:26 -0500
Date: Thu, 15 Nov 2012 18:13:23 -0800
From: Greg KH <greg@kroah.com>
To: Philippe Valembois - Phil <lephilousophe@users.sourceforge.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV HVR 900 (M/R 65018/B3C0) doesn't work anymore
 since linux 3.6.6
Message-ID: <20121116021323.GB492@kroah.com>
References: <50A3FF56.3070703@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A3FF56.3070703@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2012 at 09:30:14PM +0100, Philippe Valembois - Phil wrote:
> Hello,
> I have posted a bug report here :
> https://bugzilla.kernel.org/show_bug.cgi?id=50361 and I have been told
> to send it to the ML too.
> 
> The commit causing the bug has been pushed to kernel between linux-3.5
> and linux-3.6.
> 
> Here is my bug summary :
> 
> The WinTV HVR900 DVB-T usb stick has stopped working in Linux 3.6.6.
> The tuner fails at tuning and no DVB channel can be watched.
> 
> Reverting the commit 3de9e9624b36263618470c6e134f22eabf8f2551 fixes the
> problem
> and the tuner can tune again. It still seems there is some delay between the
> moment when the USB stick is plugged and when it can tune : running
> dvbscan too
> fast makes the first channels tuning fail but after several seconds it tunes
> perfectly.
> 
> Don't hesitate to ask me for additional debug.

Does this also fail on Linus's tree?  If so, this patch should be
reverted from there too.

thanks,

greg k-h
