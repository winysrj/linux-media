Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:45247 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbbCJNcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 09:32:25 -0400
Received: by qgaj5 with SMTP id j5so1645823qga.12
        for <linux-media@vger.kernel.org>; Tue, 10 Mar 2015 06:32:25 -0700 (PDT)
Message-ID: <54FEF1D1.3000909@vanguardiasur.com.ar>
Date: Tue, 10 Mar 2015 10:29:53 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, hans.verkuil@cisco.com
Subject: Re: em38xx locking question
References: <54FEEF38.6060506@vanguardiasur.com.ar> <54FEF0E9.9070804@xs4all.nl>
In-Reply-To: <54FEF0E9.9070804@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/10/2015 10:26 AM, Hans Verkuil wrote:
> On 03/10/2015 02:18 PM, Ezequiel Garcia wrote:
>> Mauro,
>>
>> Function drivers/media/usb/em28xx/em28xx-video.c:get_next_buf
>> (copy pasted below for reference) does not take the list spinlock,
>> yet it modifies the list. Is that correct?
> 
> That looks wrong to me. You really need spinlocks here.
> 

OK, second question then. Is there any way to guarantee the URBs irq handler
is *not* running, when vb2_ops are called (e.g. stop_streaming)?

Otherwise, given stop_streaming will return the current buffer to vb2
(dev->usb_ctl.vid_buf), I believe that will race against the irq handler,
which is processing it.

It seems that's currently racy as well.

-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
