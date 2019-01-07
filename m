Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10A6C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 13:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C86C62147C
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 13:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfAGNpi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:45:38 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:49767 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727785AbfAGNpi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 08:45:38 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gVDggGzktBDyIgVDkgO6eI; Mon, 07 Jan 2019 14:45:36 +0100
Subject: Re: epoll and vb2_poll: can't wake_up
To:     Yi Qingliang <niqingliang2003@gmail.com>,
        linux-media@vger.kernel.org
References: <CADwFkYdCXY5my5DW=qGJcJBDpjtZpRHXN6h4H2geneekiOzCgg@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3268a1a8-1712-52b2-e0e4-c6a98f003d75@xs4all.nl>
Date:   Mon, 7 Jan 2019 14:45:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CADwFkYdCXY5my5DW=qGJcJBDpjtZpRHXN6h4H2geneekiOzCgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfC7fPB+iqZKTVF7t74WEPTks88TUrDlG3EPwEoSLu3vOVKjxZnZh/QCYVaAHbv4bpQ/f3wlEKWcPyHp3Wh1++5vPPjJfsrIHWpPEW5DugxqTg9Idxqy2
 XhgdviK+BhiJg3Lu/9r2FAC4PA20MHQEkt27PINqrRo2/aTwwZ3yJjrt/R/X0NL7HoTiYfkklnAX/wd0qA0I7EOOOvbB8oN0Q91azOrlBRblmDr/H+qKeGTF
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/29/2018 03:10 AM, Yi Qingliang wrote:
> Hello, I encountered a "can't wake_up" problem when use camera on imx6.
> 
> if delay some time after 'streamon' the /dev/video0, then add fd
> through epoll_ctl, then the process can't be waken_up after some time.
> 
> I checked both the epoll / vb2_poll(videobuf2_core.c) code.
> 
> epoll will pass 'poll_table' structure to vb2_poll, but it only
> contain valid function pointer when inserting fd.
> 
> in vb2_poll, if found new data in done list, it will not call 'poll_wait'.
> after that, every call to vb2_poll will not contain valid poll_table,
> which will result in all calling to poll_wait will not work.
> 
> so if app can process frames quickly, and found frame data when
> inserting fd (i.e. poll_wait will not be called or not contain valid
> function pointer), it will not found valid frame in 'vb2_poll' finally
> at some time, then call 'poll_wait' to expect be waken up at following
> vb2_buffer_done, but no good luck.
> 
> I also checked the 'videobuf-core.c', there is no this problem.
> 
> of course, both epoll and vb2_poll are right by itself side, but the
> result is we can't get new frames.
> 
> I think by epoll's implementation, the user should always call poll_wait.
> 
> and it's better to split the two actions: 'wait' and 'poll' both for
> epoll framework and all epoll users, for example, v4l2.
> 
> am I right?
> 
> Yi Qingliang
> 

Can you test this patch?

Looking at what other drivers/frameworks do it seems that calling
poll_wait() at the start of the poll function is the right approach.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 70e8c3366f9c..b1809628475d 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2273,6 +2273,8 @@ __poll_t vb2_core_poll(struct vb2_queue *q, struct file *file,
 	struct vb2_buffer *vb = NULL;
 	unsigned long flags;

+	poll_wait(file, &q->done_wq, wait);
+
 	if (!q->is_output && !(req_events & (EPOLLIN | EPOLLRDNORM)))
 		return 0;
 	if (q->is_output && !(req_events & (EPOLLOUT | EPOLLWRNORM)))
@@ -2329,8 +2331,6 @@ __poll_t vb2_core_poll(struct vb2_queue *q, struct file *file,
 		 */
 		if (q->last_buffer_dequeued)
 			return EPOLLIN | EPOLLRDNORM;
-
-		poll_wait(file, &q->done_wq, wait);
 	}

 	/*
