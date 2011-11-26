Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:34144 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754618Ab1KZWSA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 17:18:00 -0500
Date: Sat, 26 Nov 2011 17:17:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Johann Klammer <klammerr@aon.at>
cc: linux-usb@vger.kernel.org, <linux-media@vger.kernel.org>
Subject: Re: PROBLEM: EHCI disconnects DVB & HDD
In-Reply-To: <4ED152C4.404@aon.at>
Message-ID: <Pine.LNX.4.44L0.1111261713500.28370-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 26 Nov 2011, Johann Klammer wrote:

> Alan Stern wrote:
> > This is probably a low-level hardware error.  Interference between the
> > two ports of some kind.
> 
> This is quite possible. Have been able to produce a more verbose logfile 
> snippet.

The log shows that your EHCI controller reports disconnects on both
ports, after which it is unable to re-enumerate the disk drive.  
Following that, a bug in the DVB driver prevents it from unbinding
properly, causing a hang.

This could be the result of an electrical glitch or power fluctuation.  
Are these devices bus-powered?

Or it could simply be something wrong with your EHCI controller.

Alan Stern

