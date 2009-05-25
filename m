Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZEYCmI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 22:42:08 -0400
Date: Sun, 24 May 2009 20:39:02 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>,
	David <david@unsolicited.net>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	<linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	<dbrownell@users.sourceforge.net>, <leonidv11@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
 down
Message-Id: <20090524203902.594a0eec.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.44L0.0905242208260.15195-100000@netrider.rowland.org>
References: <4A1967A2.4050906@unsolicited.net>
	<Pine.LNX.4.44L0.0905242208260.15195-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 24 May 2009 22:10:50 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> wrote:

> Pete, you should look at this.  It appears to be a problem with the DMA
> mapping in usbmon.  Probably the same sort of thing you were working on
> about a week ago (trying to access device memory).

Indeed it looks the same. Is this an AMD CPU?

I wonder if CONFIG_HAVE_DMA_API_DEBUG does it (enabled with a select
in arch/x86/Kconfig). Strange that it started happening now.

-- Pete
