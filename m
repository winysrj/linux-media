Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40966 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbbCJNql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 09:46:41 -0400
Message-ID: <54FEF5B4.1060209@xs4all.nl>
Date: Tue, 10 Mar 2015 14:46:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com
Subject: Re: em38xx locking question
References: <54FEEF38.6060506@vanguardiasur.com.ar> <54FEF0E9.9070804@xs4all.nl> <54FEF1D1.3000909@vanguardiasur.com.ar>
In-Reply-To: <54FEF1D1.3000909@vanguardiasur.com.ar>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2015 02:29 PM, Ezequiel Garcia wrote:
> 
> 
> On 03/10/2015 10:26 AM, Hans Verkuil wrote:
>> On 03/10/2015 02:18 PM, Ezequiel Garcia wrote:
>>> Mauro,
>>>
>>> Function drivers/media/usb/em28xx/em28xx-video.c:get_next_buf
>>> (copy pasted below for reference) does not take the list spinlock,
>>> yet it modifies the list. Is that correct?
>>
>> That looks wrong to me. You really need spinlocks here.
>>
> 
> OK, second question then. Is there any way to guarantee the URBs irq handler
> is *not* running, when vb2_ops are called (e.g. stop_streaming)?

That depends on the op. But stop_streaming is the op that is supposed to
turn off the streaming (and thus the irq), so it depends on the order
of how things are done in that function.

> Otherwise, given stop_streaming will return the current buffer to vb2
> (dev->usb_ctl.vid_buf), I believe that will race against the irq handler,
> which is processing it.
> 
> It seems that's currently racy as well.

Hmm, the stop_streaming code looks fine at first sight, but I think there
is a race if you start streaming both video and vbi, and then stop streaming
one of the two. I think the code might keep calling get_next_buf() in that
case, even if for that stream the streaming was stopped.

This is a problem anyway: get_next_buf() should do this check at the beginning:

	if (!vb2_start_streaming_called(vb2_queue))
		return NULL;

to prevent it from using buffer before start_streaming was actually called.

Regards,

	Hans
