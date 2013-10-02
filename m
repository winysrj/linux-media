Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53881 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754415Ab3JBThP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 15:37:15 -0400
Date: Wed, 2 Oct 2013 15:37:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Xenia Ragiadakou <burzalodowa@gmail.com>,
	<linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-media@vger.kernel.org>
Subject: Re: New USB core API to change interval and max packet size
In-Reply-To: <Pine.LNX.4.44L0.1310021449240.1293-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1310021536110.1293-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2 Oct 2013, Alan Stern wrote:

> > Ok, so it sounds like we want to keep the changes the endpoints across
> > alt setting changes.
> 
> No, just the opposite.  That was the point I was trying to make.  Any
> changes to ep5 in altsetting 0 (for example) will have no effect on ep1
----------------------------------------------------------------------^^^

Typo: this should have been ep5 as well.

> in altsetting 1, because the two altsettings reference the endpoint by
> two separate usb_host_endpoint structures.

Alan Stern

