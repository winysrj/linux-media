Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0977C43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 03:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3CED2183F
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 03:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Ep2PK85I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbfB1DYS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 22:24:18 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37020 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730131AbfB1DYS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 22:24:18 -0500
Received: by mail-pf1-f195.google.com with SMTP id s22so9012832pfh.4
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2019 19:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NEayOZWTOlW8hnuhgwXKXENHgurVhDXIl8x38Vkhwnc=;
        b=Ep2PK85IMTsK1Pr4E4asW5xap4WxYHVNWGtZTMzKGhq6TnBqc7vEymfZGpVuUrcI5c
         0hLFf5YyFQ/SbG6nvE0BZbUNjgW1mDO8g5610xwwTC5+HjxVAr8EGc2I0xqJp6x8SVoE
         tQp+th28YI0dvyrPqdFrwT60gvS/7NkX6jKRE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NEayOZWTOlW8hnuhgwXKXENHgurVhDXIl8x38Vkhwnc=;
        b=SuMlimcVOcG/KhaIOF6ZQrzpCJVOIuUO4phm6f7mDs4gnEI7l2PbfFXUFfcJRQ2J72
         tb6AQ0C2euf/bNcUEc+JsxulYl8j6uCGX6K9W0+fOp8uEVxIL/ajPC6d0LZkaeHTmt9J
         etjZT+9Ud38Fx0VCqTLIeUJ5QrsZAIOoyjyL+FvAW7HtLqW414YBPw3jYL04YmnkrAqi
         ZeDWmJdzibZezoV6et4dFvO2Am/AWYmRQlamDUVLA3T/FnWlDPV4kLIWTgslGF7D3wru
         dovFA5lkDloAdIGaaE9c+htSD27mpIqLi2RTHH/80ypeg+7ryqkb9/o7jU06gm/2dir0
         g29g==
X-Gm-Message-State: AHQUAuZN99e/YVm6/F2mM8CjDuuraMQivGq+mCfJEP7+SLh5kk9nQ7WH
        2scJN1l9Y7pLGo9yHe693EKuFA==
X-Google-Smtp-Source: AHgI3IYjLUNFlqmDMdcGIOnvLgdzzpztO80aLWIYU7/ytOsFHy562kxjVQc46urxkGsi5+BhBjus1w==
X-Received: by 2002:a62:b242:: with SMTP id x63mr5172210pfe.4.1551324257142;
        Wed, 27 Feb 2019 19:24:17 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id s2sm21808114pgc.67.2019.02.27.19.24.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Feb 2019 19:24:16 -0800 (PST)
Date:   Wed, 27 Feb 2019 19:24:13 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Frederic Chen <frederic.chen@mediatek.com>
Cc:     "tfiga@chromium.org" <tfiga@chromium.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sean Cheng =?utf-8?B?KOmEreaYh+W8mCk=?= 
        <Sean.Cheng@mediatek.com>,
        Sj Huang =?utf-8?B?KOm7g+S/oeeSiyk=?= <sj.huang@mediatek.com>,
        Christie Yu =?utf-8?B?KOa4uOmbheaDoCk=?= 
        <christie.yu@mediatek.com>,
        Holmes Chiou =?utf-8?B?KOmCseaMuik=?= 
        <holmes.chiou@mediatek.com>,
        Jerry-ch Chen =?utf-8?B?KOmZs+aVrOaGsik=?= 
        <Jerry-ch.Chen@mediatek.com>,
        Jungo Lin =?utf-8?B?KOael+aYjuS/iik=?= <jungo.lin@mediatek.com>,
        Rynn Wu =?utf-8?B?KOWQs+iCsuaBqSk=?= <Rynn.Wu@mediatek.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        "laurent.pinchart+renesas@ideasonboard.com" 
        <laurent.pinchart+renesas@ideasonboard.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek DIP
 driver
Message-ID: <20190228032411.GA84890@google.com>
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
 <1549020091-42064-8-git-send-email-frederic.chen@mediatek.com>
 <20190207190824.GA98164@google.com>
 <1550756198.11724.86.camel@mtksdccf07>
 <1550902734.18654.36.camel@mtksdccf07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550902734.18654.36.camel@mtksdccf07>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Frederic,

On Sat, Feb 23, 2019 at 02:18:54PM +0800, Frederic Chen wrote:
> Dear Brian,
> 
> I appreciate your comments. I'm really sorry for the delay in responding
> to the comments due to some mail subscribing failed issue inside my company.

No problem.

> On Thu, 2019-02-21 at 21:36 +0800, Jungo Lin wrote:
> > On Thu, 2019-02-07 at 11:08 -0800, Brian Norris wrote:
> > > On Fri, Feb 01, 2019 at 07:21:31PM +0800, Frederic Chen wrote:

> > > > +static void dip_submit_worker(struct work_struct *work)
> > > > +{
> > > > +	struct mtk_dip_submit_work *dip_submit_work =
> > > > +		container_of(work, struct mtk_dip_submit_work, frame_work);
> > > > +
> > > > +	struct mtk_dip_hw_ctx  *dip_ctx = dip_submit_work->dip_ctx;
> > > > +	struct mtk_dip_work *dip_work;
> > > > +	struct dip_device *dip_dev;
> > > > +	struct dip_subframe *buf;
> > > > +	u32 len, num;
> > > > +	int ret;
> > > > +
> > > > +	dip_dev = container_of(dip_ctx, struct dip_device, dip_ctx);
> > > > +	num  = atomic_read(&dip_ctx->num_composing);
> > > > +
> > > > +	mutex_lock(&dip_ctx->dip_worklist.queuelock);
> > > > +	dip_work = list_first_entry(&dip_ctx->dip_worklist.queue,
> > > > +				    struct mtk_dip_work, list_entry);
> > > > +	mutex_unlock(&dip_ctx->dip_worklist.queuelock);
> > > 
> > > I see you grab the head of the list here, but then you release the lock.
> > > Then you later assume that reference is still valid, throughout this
> > > function.
> > > 
> > > That's usually true, because you only remove/delete entries from this
> > > list within this same workqueue (at the end of this function). But it's
> > > not true in dip_release_context() (which doesn't even grab the lock,
> > > BTW).
> > > 
> > > I think there could be several ways to solve this, but judging by how
> > > this list entry is used...couldn't you just remove it from the list
> > > here, while holding the lock? Then you only have to kfree() it when
> > > you're done under the free_work_list label.
> > > 
> 
> I see. I would like to modify the codes as following:
> 
> mutex_lock(&dip_ctx->dip_useridlist.queuelock);

You missed the part where you get the head of the list:

	dip_work = list_first_entry(...);

But otherwise mostly looks OK.

> dip_work->user_id->num--;

Why do you need to do that with the queuelock held? Once you remove this
work item from the list (safely under the lock), shouldn't you be the
only one accessing it?

(Note, I don't actually know what that 'num' really means. I'm just
looking at basic driver mechanics.)

> list_del(&dip_work->list_entry);
> dip_ctx->dip_worklist.queue_cnt--;
> len = dip_ctx->dip_worklist.queue_cnt;
> mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
> 
> goto free_work_list;
> 
> /* ...... */
> 
> free_work_list:
> 	kfree(dip_work);
> 
> > > > +
> > > > +	mutex_lock(&dip_ctx->dip_useridlist.queuelock);
> > > > +	if (dip_work->user_id->state == DIP_STATE_STREAMOFF) {
> > > > +		mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
> > > > +
> > > > +		dip_work->frameparams.state = FRAME_STATE_STREAMOFF;
> > > > +		call_mtk_dip_ctx_finish(dip_dev, &dip_work->frameparams);
> > > > +
> > > > +		mutex_lock(&dip_ctx->dip_useridlist.queuelock);
> > > > +		dip_work->user_id->num--;
> > > > +		dev_dbg(&dip_dev->pdev->dev,
> > > > +			"user_id(%x) is streamoff and num: %d, frame_no(%d) index: %x\n",
> > > > +			dip_work->user_id->id, dip_work->user_id->num,
> > > > +			dip_work->frameparams.frame_no,
> > > > +			dip_work->frameparams.index);
> > > > +		mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
> > > > +
> > > > +		goto free_work_list;
> > > > +	}
> > > > +	mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
> > > > +
> > > > +	while (num >= DIP_COMPOSING_MAX_NUM) {
> > > > +		ret = wait_event_interruptible_timeout
> > > > +			(dip_ctx->composing_wq,
> > > > +			 (num < DIP_COMPOSING_MAX_NUM),
> > > > +			 msecs_to_jiffies(DIP_COMPOSING_WQ_TIMEOUT));
> > > > +
> > > > +		if (ret == -ERESTARTSYS)
> > > > +			dev_err(&dip_dev->pdev->dev,
> > > > +				"interrupted by a signal!\n");
> > > > +		else if (ret == 0)
> > > > +			dev_dbg(&dip_dev->pdev->dev,
> > > > +				"timeout frame_no(%d), num: %d\n",
> > > > +				dip_work->frameparams.frame_no, num);
> > > > +		else
> > > > +			dev_dbg(&dip_dev->pdev->dev,
> > > > +				"wakeup frame_no(%d), num: %d\n",
> > > > +				dip_work->frameparams.frame_no, num);
> > > > +
> > > > +		num = atomic_read(&dip_ctx->num_composing);
> > > > +	};
> > > > +
> > > > +	mutex_lock(&dip_ctx->dip_freebufferlist.queuelock);
> > > > +	if (list_empty(&dip_ctx->dip_freebufferlist.queue)) {
> > > > +		mutex_unlock(&dip_ctx->dip_freebufferlist.queuelock);
> > > > +
> > > > +		dev_err(&dip_dev->pdev->dev,
> > > > +			"frame_no(%d) index: %x no free buffer: %d\n",
> > > > +			dip_work->frameparams.frame_no,
> > > > +			dip_work->frameparams.index,
> > > > +			dip_ctx->dip_freebufferlist.queue_cnt);
> > > > +
> > > > +		/* Call callback to notify V4L2 common framework
> > > > +		 * for failure of enqueue
> > > > +		 */
> > > > +		dip_work->frameparams.state = FRAME_STATE_ERROR;
> > > > +		call_mtk_dip_ctx_finish(dip_dev, &dip_work->frameparams);
> > > > +
> > > > +		mutex_lock(&dip_ctx->dip_useridlist.queuelock);
> > > > +		dip_work->user_id->num--;
> > > > +		mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
> > > > +
> > > > +		goto free_work_list;
> > > > +	}
> > > > +
> > > > +	buf = list_first_entry(&dip_ctx->dip_freebufferlist.queue,
> > > > +			       struct dip_subframe,
> > > > +			       list_entry);
> > > > +	list_del(&buf->list_entry);
> > > > +	dip_ctx->dip_freebufferlist.queue_cnt--;
> > > > +	mutex_unlock(&dip_ctx->dip_freebufferlist.queuelock);
> > > > +
> > > > +	mutex_lock(&dip_ctx->dip_usedbufferlist.queuelock);
> > > > +	list_add_tail(&buf->list_entry, &dip_ctx->dip_usedbufferlist.queue);
> > > > +	dip_ctx->dip_usedbufferlist.queue_cnt++;
> > > > +	mutex_unlock(&dip_ctx->dip_usedbufferlist.queuelock);
> > > > +
> > > > +	memcpy(&dip_work->frameparams.subfrm_data,
> > > > +	       &buf->buffer, sizeof(buf->buffer));
> > > > +
> > > > +	memset((char *)buf->buffer.va, 0, DIP_SUB_FRM_SZ);
> > > > +
> > > > +	memcpy(&dip_work->frameparams.config_data,
> > > > +	       &buf->config_data, sizeof(buf->config_data));
> > > > +
> > > > +	memset((char *)buf->config_data.va, 0, DIP_COMP_SZ);
> > > > +
> > > > +	if (dip_work->frameparams.tuning_data.pa == 0) {
> > > > +		dev_dbg(&dip_dev->pdev->dev,
> > > > +			"frame_no(%d) has no tuning_data\n",
> > > > +			dip_work->frameparams.frame_no);
> > > > +
> > > > +		memcpy(&dip_work->frameparams.tuning_data,
> > > > +		       &buf->tuning_buf, sizeof(buf->tuning_buf));
> > > > +
> > > > +		memset((char *)buf->tuning_buf.va, 0, DIP_TUNING_SZ);
> > > > +		/* When user enqueued without tuning buffer,
> > > > +		 * it would use driver internal buffer.
> > > > +		 * So, tuning_data.va should be 0
> > > > +		 */
> > > > +		dip_work->frameparams.tuning_data.va = 0;
> > > > +	}
> > > > +
> > > > +	dip_work->frameparams.drv_data = (u64)dip_ctx;
> > > > +	dip_work->frameparams.state = FRAME_STATE_COMPOSING;
> > > > +
> > > > +	memcpy((void *)buf->frameparam.va, &dip_work->frameparams,
> > > > +	       sizeof(dip_work->frameparams));
> > > > +
> > > > +	dip_send(dip_ctx->vpu_pdev, IPI_DIP_FRAME,
> > > > +		 (void *)&dip_work->frameparams,
> > > > +		 sizeof(dip_work->frameparams), 0);
> > > > +	num = atomic_inc_return(&dip_ctx->num_composing);
> > > > +
> > > > +free_work_list:
> > > > +
> > > > +	mutex_lock(&dip_ctx->dip_worklist.queuelock);
> > > > +	list_del(&dip_work->list_entry);
> > > > +	dip_ctx->dip_worklist.queue_cnt--;
> > > > +	len = dip_ctx->dip_worklist.queue_cnt;
> > > > +	mutex_unlock(&dip_ctx->dip_worklist.queuelock);
> > > > +
> > > > +	dev_dbg(&dip_dev->pdev->dev,
> > > > +		"frame_no(%d) index: %x, worklist count: %d, composing num: %d\n",
> > > > +		dip_work->frameparams.frame_no, dip_work->frameparams.index,
> > > > +		len, num);
> > > > +
> > > > +	kfree(dip_work);
> > > > +}


> > > > +int dip_release_context(struct dip_device *dip_dev)
> > > 
> > > Should be static.
> > > 
> 
> I will change it to static.
> 
> > > > +{
> > > > +	u32 i = 0;
> > > > +	struct dip_subframe *buf, *tmpbuf;
> > > > +	struct mtk_dip_work *dip_work, *tmp_work;
> > > > +	struct dip_user_id  *dip_userid, *tmp_id;
> > > > +	struct mtk_dip_hw_ctx *dip_ctx;
> > > > +
> > > > +	dip_ctx = &dip_dev->dip_ctx;
> > > > +	dev_dbg(&dip_dev->pdev->dev, "composer work queue = %d\n",
> > > > +		dip_ctx->dip_worklist.queue_cnt);
> > > > +
> > > > +	list_for_each_entry_safe(dip_work, tmp_work,
> > > > +				 &dip_ctx->dip_worklist.queue,
> > > > +				 list_entry) {
> > > 
> > > Shouldn't you be holding the mutex for this? Or alternatively, cancel
> > > any outstanding work and move the flush_workqueue()/destroy_workqueue()
> > > up.
> > > 
> > > Similar questions for the other lists we're going through here.
> > > 
> 
> We missed the mutex holding here. I would like to change the codes as following:
> 
> mutex_lock(&dip_ctx->dip_worklist.queuelock);
> list_for_each_entry_safe(dip_work, tmp_work,
> 			 &dip_ctx->dip_worklist.queue,
> 			 list_entry) {
> 	list_del(&dip_work->list_entry);
> 	dip_ctx->dip_worklist.queue_cnt--;
> 	kfree(dip_work);
> }
> mutex_unlock(&dip_ctx->dip_worklist.queuelock);
> 
> I will also modify dip_useridlist and dip_ctx->dip_freebufferlist 
> parts like dip_ctx->dip_worklist.

Seems about right.

Brian

> > > > +		list_del(&dip_work->list_entry);
> > > > +		dev_dbg(&dip_dev->pdev->dev, "dip work frame no: %d\n",
> > > > +			dip_work->frameparams.frame_no);
> > > > +		kfree(dip_work);
> > > > +		dip_ctx->dip_worklist.queue_cnt--;
> > > > +	}
> > > > +
> > > > +	if (dip_ctx->dip_worklist.queue_cnt != 0)
> > > > +		dev_dbg(&dip_dev->pdev->dev,
> > > > +			"dip_worklist is not empty (%d)\n",
> > > > +			dip_ctx->dip_worklist.queue_cnt);
> > > > +
> > > > +	list_for_each_entry_safe(dip_userid, tmp_id,
> > > > +				 &dip_ctx->dip_useridlist.queue,
> > > > +				 list_entry) {
> > > > +		list_del(&dip_userid->list_entry);
> > > > +		dev_dbg(&dip_dev->pdev->dev, "dip user id: %x\n",
> > > > +			dip_userid->id);
> > > > +		kfree(dip_userid);
> > > > +		dip_ctx->dip_useridlist.queue_cnt--;
> > > > +	}
> > > > +
> > > > +	if (dip_ctx->dip_useridlist.queue_cnt != 0)
> > > > +		dev_dbg(&dip_dev->pdev->dev,
> > > > +			"dip_useridlist is not empty (%d)\n",
> > > > +			dip_ctx->dip_useridlist.queue_cnt);
> > > > +
> > > > +	flush_workqueue(dip_ctx->mdpcb_workqueue);
> > > > +	destroy_workqueue(dip_ctx->mdpcb_workqueue);
> > > > +	dip_ctx->mdpcb_workqueue = NULL;
> > > > +
> > > > +	flush_workqueue(dip_ctx->composer_wq);
> > > > +	destroy_workqueue(dip_ctx->composer_wq);
> > > > +	dip_ctx->composer_wq = NULL;
> > > > +
> > > > +	atomic_set(&dip_ctx->num_composing, 0);
> > > > +	atomic_set(&dip_ctx->num_running, 0);
> > > > +
> > > > +	kthread_stop(dip_ctx->dip_runner_thread.thread);
> > > > +	dip_ctx->dip_runner_thread.thread = NULL;
> > > > +
> > > > +	atomic_set(&dip_ctx->dip_user_cnt, 0);
> > > > +	atomic_set(&dip_ctx->dip_stream_cnt, 0);
> > > > +	atomic_set(&dip_ctx->dip_enque_cnt, 0);
> > > > +
> > > > +	/* All the buffer should be in the freebufferlist when release */
> > > > +	list_for_each_entry_safe(buf, tmpbuf,
> > > > +				 &dip_ctx->dip_freebufferlist.queue,
> > > > +				 list_entry) {
> > > > +		struct sg_table *sgt = &buf->table;
> > > > +
> > > > +		dev_dbg(&dip_dev->pdev->dev,
> > > > +			"buf pa (%d): %x\n", i, buf->buffer.pa);
> > > > +		dip_ctx->dip_freebufferlist.queue_cnt--;
> > > > +		dma_unmap_sg_attrs(&dip_dev->pdev->dev, sgt->sgl,
> > > > +				   sgt->orig_nents,
> > > > +				   DMA_BIDIRECTIONAL, DMA_ATTR_SKIP_CPU_SYNC);
> > > > +		sg_free_table(sgt);
> > > > +		list_del(&buf->list_entry);
> > > > +		kfree(buf);
> > > > +		buf = NULL;
> > > > +		i++;
> > > > +	}
> > > > +
> > > > +	if (dip_ctx->dip_freebufferlist.queue_cnt != 0 &&
> > > > +	    i != DIP_SUB_FRM_DATA_NUM)
> > > > +		dev_err(&dip_dev->pdev->dev,
> > > > +			"dip_freebufferlist is not empty (%d/%d)\n",
> > > > +			dip_ctx->dip_freebufferlist.queue_cnt, i);
> > > > +
> > > > +	mutex_destroy(&dip_ctx->dip_useridlist.queuelock);
> > > > +	mutex_destroy(&dip_ctx->dip_worklist.queuelock);
> > > > +	mutex_destroy(&dip_ctx->dip_usedbufferlist.queuelock);
> > > > +	mutex_destroy(&dip_ctx->dip_freebufferlist.queuelock);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
