Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35549 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbbCJNVQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 09:21:16 -0400
Received: by qgfh3 with SMTP id h3so1616068qgf.2
        for <linux-media@vger.kernel.org>; Tue, 10 Mar 2015 06:21:15 -0700 (PDT)
Message-ID: <54FEEF38.6060506@vanguardiasur.com.ar>
Date: Tue, 10 Mar 2015 10:18:48 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com
Subject: em38xx locking question
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Function drivers/media/usb/em28xx/em28xx-video.c:get_next_buf
(copy pasted below for reference) does not take the list spinlock,
yet it modifies the list. Is that correct?

static inline struct em28xx_buffer *get_next_buf(struct em28xx *dev,
                                                 struct em28xx_dmaqueue *dma_q)
{
        struct em28xx_buffer *buf;

        if (list_empty(&dma_q->active)) {
                em28xx_isocdbg("No active queue to serve\n");
                return NULL;
        }
 
        /* Get the next buffer */
        buf = list_entry(dma_q->active.next, struct em28xx_buffer, list);
        /* Cleans up buffer - Useful for testing for frame/URB loss */
        list_del(&buf->list);
        buf->pos = 0; 
        buf->vb_buf = buf->mem;
 
        return buf;
}

Thanks!
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
