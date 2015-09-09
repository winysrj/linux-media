Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55794 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752147AbbIIQ3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2015 12:29:38 -0400
Date: Wed, 9 Sep 2015 12:29:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans de Goede <hdegoede@redhat.com>,
	Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
	<linux-media@vger.kernel.org>, <mchehab@osg.samsung.com>,
	<linux-usb@vger.kernel.org>
Subject: Re: [PATCH v1] media: uvcvideo: handle urb completion in a work
 queue
In-Reply-To: <2075897.6pASZPILMt@avalon>
Message-ID: <Pine.LNX.4.44L0.1509091226310.2045-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 9 Sep 2015, Laurent Pinchart wrote:

> > > Instead of fixing the issue in the uvcvideo driver, would it then make
> > > more sense to fix it in the remaining hcd drivers ?
> > 
> > Unfortunately that's not so easy.  It involves some subtle changes
> > related to the way isochronous endpoints are handled.  I wouldn't know
> > what to change in any of the HCDs, except the ones that I maintain.
> 
> I'm not saying it would be easy, but I'm wondering whether it makes change to 
> move individual USB device drivers to work queues when the long term goal is 
> to use tasklets for URB completion anyway.

I'm not sure that this is a long-term goal for every HCD.  For
instance, there probably isn't much incentive to convert a driver if
its host controllers can only run at low speed or full speed.

Alan Stern

