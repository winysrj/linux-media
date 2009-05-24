Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:36336 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752946AbZEXOdz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 10:33:55 -0400
Date: Sun, 24 May 2009 10:33:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: David <david@unsolicited.net>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
	<linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	<dbrownell@users.sourceforge.net>, <leonidv11@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
  down
In-Reply-To: <4A189187.4020407@unsolicited.net>
Message-ID: <Pine.LNX.4.44L0.0905241031050.7718-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 24 May 2009, David wrote:

> Traces attached. Took a while as my quad core hangs solid when 0u is
> piped to a file (I had to compile on a laptop and take the logs there).

Is the output file being written to a USB device?  Obviously that's not
a good thing to do; it's like running tcpdump over an ssh connection --
you end up dumping the packets containing the dump output!

But if not then this is a genuine bug and it should be reported
separately on the linux-usb mailing list.

Alan Stern

