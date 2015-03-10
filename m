Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:32848 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbbCJN0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 09:26:09 -0400
Message-ID: <54FEF0E9.9070804@xs4all.nl>
Date: Tue, 10 Mar 2015 14:26:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com
Subject: Re: em38xx locking question
References: <54FEEF38.6060506@vanguardiasur.com.ar>
In-Reply-To: <54FEEF38.6060506@vanguardiasur.com.ar>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2015 02:18 PM, Ezequiel Garcia wrote:
> Mauro,
> 
> Function drivers/media/usb/em28xx/em28xx-video.c:get_next_buf
> (copy pasted below for reference) does not take the list spinlock,
> yet it modifies the list. Is that correct?

That looks wrong to me. You really need spinlocks here.

Regards,

	Hans

> 
> static inline struct em28xx_buffer *get_next_buf(struct em28xx *dev,
>                                                  struct em28xx_dmaqueue *dma_q)
> {
>         struct em28xx_buffer *buf;
> 
>         if (list_empty(&dma_q->active)) {
>                 em28xx_isocdbg("No active queue to serve\n");
>                 return NULL;
>         }
>  
>         /* Get the next buffer */
>         buf = list_entry(dma_q->active.next, struct em28xx_buffer, list);
>         /* Cleans up buffer - Useful for testing for frame/URB loss */
>         list_del(&buf->list);
>         buf->pos = 0; 
>         buf->vb_buf = buf->mem;
>  
>         return buf;
> }
> 
> Thanks!
> 

