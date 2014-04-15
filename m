Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42513 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754408AbaDOOID (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 10:08:03 -0400
Date: Tue, 15 Apr 2014 10:08:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: [PATCH] media: stk1160: Avoid stack-allocated buffer for control
 URBs
In-Reply-To: <20140414182350.GA23722@arch.cereza>
Message-ID: <Pine.LNX.4.44L0.1404151007220.1310-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Apr 2014, Ezequiel Garcia wrote:

> On Apr 14, Alan Stern wrote:
> > On Mon, 14 Apr 2014, Ezequiel Garcia wrote:
> > 
> > > Currently stk1160_read_reg() uses a stack-allocated char to get the
> > > read control value. This is wrong because usb_control_msg() requires
> > > a kmalloc-ed buffer, and a DMA-API warning is produced:
> > > 
> > > WARNING: CPU: 0 PID: 1376 at lib/dma-debug.c:1153 check_for_stack+0xa0/0x100()
> > > ehci-pci 0000:00:0a.0: DMA-API: device driver maps memory fromstack [addr=ffff88003d0b56bf]
> > > 
> > > This commit fixes such issue by using a 'usb_ctrl_read' field embedded
> > > in the device's struct to pass the value. In addition, we introduce a
> > > mutex to protect the value.
> > 
> > This isn't right either.  The buffer must be allocated in its own cache
> > line; it must not be part of a larger structure.
> > 
> 
> In that case, we can simply allocate 1 byte using kmalloc(). We won't
> be needing the mutex and it'll ensure proper cache alignment, right?

Yes, that will work fine.

Alan Stern

