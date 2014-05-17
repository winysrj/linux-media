Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:44877 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932428AbaEQMVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 May 2014 08:21:49 -0400
Date: Sat, 17 May 2014 09:21:12 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] media: stk1160: Avoid stack-allocated buffer for
 control URBs
Message-ID: <20140517122112.GA704@arch.cereza>
References: <1397737700-1081-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <536CAF29.4030200@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <536CAF29.4030200@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 09 May 12:34 PM, Hans Verkuil wrote:
> On 04/17/2014 02:28 PM, Ezequiel Garcia wrote:
> > Currently stk1160_read_reg() uses a stack-allocated char to get the
> > read control value. This is wrong because usb_control_msg() requires
> > a kmalloc-ed buffer.
> > 
> > This commit fixes such issue by kmalloc'ating a 1-byte buffer to receive
> > the read value.
> > 
> > While here, let's remove the urb_buf array which was meant for a similar
> > purpose, but never really used.
> 
> Rather than allocating and freeing a buffer for every read_reg I would allocate
> this buffer in the probe function.
> 
> That way this allocation is done only once.
> 

Hm... sorry for being so stubborn, but I've just noticed that having a
shared buffer would require adding a spinlock to protect it, where the current
proposal doesn't need it.

Do you still think that's the right thing to do?

Thanks!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
