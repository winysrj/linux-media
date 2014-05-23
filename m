Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2532 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaEWKiw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 May 2014 06:38:52 -0400
Message-ID: <537F2513.8050503@xs4all.nl>
Date: Fri, 23 May 2014 12:38:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: linux-media@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] media: stk1160: Avoid stack-allocated buffer for control
 URBs
References: <1397737700-1081-1-git-send-email-ezequiel.garcia@free-electrons.com> <536CAF29.4030200@xs4all.nl> <20140517122112.GA704@arch.cereza>
In-Reply-To: <20140517122112.GA704@arch.cereza>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/17/2014 02:21 PM, Ezequiel Garcia wrote:
> Hi Hans,
> 
> On 09 May 12:34 PM, Hans Verkuil wrote:
>> On 04/17/2014 02:28 PM, Ezequiel Garcia wrote:
>>> Currently stk1160_read_reg() uses a stack-allocated char to get the
>>> read control value. This is wrong because usb_control_msg() requires
>>> a kmalloc-ed buffer.
>>>
>>> This commit fixes such issue by kmalloc'ating a 1-byte buffer to receive
>>> the read value.
>>>
>>> While here, let's remove the urb_buf array which was meant for a similar
>>> purpose, but never really used.
>>
>> Rather than allocating and freeing a buffer for every read_reg I would allocate
>> this buffer in the probe function.
>>
>> That way this allocation is done only once.
>>
> 
> Hm... sorry for being so stubborn, but I've just noticed that having a
> shared buffer would require adding a spinlock to protect it, where the current
> proposal doesn't need it.
> 
> Do you still think that's the right thing to do?

I'm still not entirely happy, but I've decided to accept it. It's a bug and it
needs to be fixed. Adding a mutex to protect the datastructure adds only more
complexity and it not really worth the effort.

Regards,

	Hans

