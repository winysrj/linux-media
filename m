Return-path: <mchehab@pedra>
Received: from connie.slackware.com ([64.57.102.36]:53592 "EHLO
	connie.slackware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab1DLCWL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 22:22:11 -0400
Date: Mon, 11 Apr 2011 19:14:27 -0700 (PDT)
From: Robby Workman <rworkman@slackware.com>
To: linux-media@vger.kernel.org
cc: Patrick Volkerding <volkerdi@slackware.com>
Subject: Re: [PATCHES] Misc. trivial fixes
In-Reply-To: <alpine.LNX.2.00.1104111908050.32072@connie.slackware.com>
Message-ID: <alpine.LNX.2.00.1104111913310.32188@connie.slackware.com>
References: <alpine.LNX.2.00.1104111908050.32072@connie.slackware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 11 Apr 2011, Robby Workman wrote:

> Patch #1 installs udev rules files to /lib/udev/rules.d/ instead
> of /etc/udev/rules.d/ - see commit message for more info.
>
> Patch #2 allows override of manpage installation directory by
> packagers - see commit message for more info


EEEK!  It just occurred to me that this mailing list might 
possibly be used by more than one project (horrors!), so 
I should probably specify that the patches in the previous
mail are aimed at v4l-utils.   Sorry for the noise.

-RW
