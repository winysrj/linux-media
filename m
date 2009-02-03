Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40936 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751088AbZBCTxc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 14:53:32 -0500
Date: Tue, 3 Feb 2009 14:53:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Jean-Francois Moine <moinejf@free.fr>
cc: kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <20090203191311.2c1695b7@free.fr>
Message-ID: <Pine.LNX.4.44L0.0902031448340.2272-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Feb 2009, Jean-Francois Moine wrote:

> > Perhaps we also need to do what Adam suggested yesterday, and add a
> > call to destroy_urbs() in gspca_disconnect()?
> 
> Surely not! The destroy_urbs() must be called at the right time, i.e.
> on close().

Theodore was pointing out that destroy_urbs() must also be called 
during disconnect.  If a camera is unplugged while it is in use then 
waiting until close() is no good -- it will cause destroy_urbs() to 
pass a stale pointer to usb_buffer_free().  That's the reason for the 
oops.

Alan Stern

