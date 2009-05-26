Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:34884 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbZEZSpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 14:45:10 -0400
Message-ID: <4A1C37F8.2090703@unsolicited.net>
Date: Tue, 26 May 2009 19:42:00 +0100
From: David <david@unsolicited.net>
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
	USB list <linux-usb@vger.kernel.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dbrownell@users.sourceforge.net, leonidv11@gmail.com,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
 down
References: <4A1967A2.4050906@unsolicited.net>	<Pine.LNX.4.44L0.0905242208260.15195-100000@netrider.rowland.org>	<20090524203902.594a0eec.zaitcev@redhat.com>	<4A1A5E24.20201@unsolicited.net>	<4A1A8E53.9060108@unsolicited.net> <20090525184843.33c93006.zaitcev@redhat.com>
In-Reply-To: <20090525184843.33c93006.zaitcev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pete Zaitcev wrote:
> On Mon, 25 May 2009 13:25:55 +0100, David <david@unsolicited.net> wrote:
>
>   
> I suppose so. I misunderstood how this worked. I guessed that the
> DMA API debugging was the culprit because its introduction coincided
> with the recent onset of this oops.
>
> Although usbmon does essentially illegal tricks to look at data
> already mapped for DMA, the code used to work for a few releases.
> Bisecting may help. I cannot be sure of it though, and it's
> going to take a lot of reboots.
>
> Unfortunately, although I have an Opteron, the issue does not
> occur here, so I'm at a loss for the moment. But I'll have to
> tackle it somehow. Not sure how though. Any suggestions are welcome.
>
> -- Pete
>   

I've been doing a bit of random rebooting (I don't really have time to
do a full bisect), and can reproduce the usbmon panic on this machine
back to 2.6.24.. so it certainly hasn't appeared that recently.

Cheers
David
