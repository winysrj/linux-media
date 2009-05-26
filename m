Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44502 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559AbZEZTHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 15:07:19 -0400
Date: Tue, 26 May 2009 13:01:43 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: David <david@unsolicited.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	USB list <linux-usb@vger.kernel.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dbrownell@users.sourceforge.net, leonidv11@gmail.com,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, zaitcev@redhat.com
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
 down
Message-Id: <20090526130143.85475405.zaitcev@redhat.com>
In-Reply-To: <4A1C37F8.2090703@unsolicited.net>
References: <4A1967A2.4050906@unsolicited.net>
	<Pine.LNX.4.44L0.0905242208260.15195-100000@netrider.rowland.org>
	<20090524203902.594a0eec.zaitcev@redhat.com>
	<4A1A5E24.20201@unsolicited.net>
	<4A1A8E53.9060108@unsolicited.net>
	<20090525184843.33c93006.zaitcev@redhat.com>
	<4A1C37F8.2090703@unsolicited.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 May 2009 19:42:00 +0100, David <david@unsolicited.net> wrote:

> I've been doing a bit of random rebooting (I don't really have time to
> do a full bisect), and can reproduce the usbmon panic on this machine
> back to 2.6.24.. so it certainly hasn't appeared that recently.

Actually that's good to know, thanks a lot.

I can always just stub out any attempt to peek into the IOMMU
on Opterons. This would bring us back into the days of 'D' returned
from everything, although maybe not so bad as we've cut out some
unnecessary usb_buffer use. At least, no more crashing.

-- Pete
