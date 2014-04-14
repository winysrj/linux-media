Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:34218 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751686AbaDNSYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 14:24:18 -0400
Date: Mon, 14 Apr 2014 15:23:50 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: [PATCH] media: stk1160: Avoid stack-allocated buffer for control
 URBs
Message-ID: <20140414182350.GA23722@arch.cereza>
References: <1397493665-912-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <Pine.LNX.4.44L0.1404141327550.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1404141327550.874-100000@iolanthe.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Apr 14, Alan Stern wrote:
> On Mon, 14 Apr 2014, Ezequiel Garcia wrote:
> 
> > Currently stk1160_read_reg() uses a stack-allocated char to get the
> > read control value. This is wrong because usb_control_msg() requires
> > a kmalloc-ed buffer, and a DMA-API warning is produced:
> > 
> > WARNING: CPU: 0 PID: 1376 at lib/dma-debug.c:1153 check_for_stack+0xa0/0x100()
> > ehci-pci 0000:00:0a.0: DMA-API: device driver maps memory fromstack [addr=ffff88003d0b56bf]
> > 
> > This commit fixes such issue by using a 'usb_ctrl_read' field embedded
> > in the device's struct to pass the value. In addition, we introduce a
> > mutex to protect the value.
> 
> This isn't right either.  The buffer must be allocated in its own cache
> line; it must not be part of a larger structure.
> 

In that case, we can simply allocate 1 byte using kmalloc(). We won't
be needing the mutex and it'll ensure proper cache alignment, right?

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
