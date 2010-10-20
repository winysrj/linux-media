Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:20688 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0JTO3f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 10:29:35 -0400
Date: Wed, 20 Oct 2010 16:29:27 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 3/4] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <000301cb6c21$539ed5b0$fadc8110$%oh@samsung.com>
To: jaeryul.oh@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, kgene.kim@samsung.com
Message-id: <000101cb7063$366960a0$a33c21e0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-us
Content-transfer-encoding: 7BIT
References: <1286968160-10629-1-git-send-email-k.debski@samsung.com>
 <1286968160-10629-4-git-send-email-k.debski@samsung.com>
 <004b01cb6b68$9d45a8b0$d7d0fa10$%oh@samsung.com>
 <005b01cb6b9f$304dd390$90e97ab0$%debski@samsung.com>
 <000301cb6c21$539ed5b0$fadc8110$%oh@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>Thank you for your reply about my comments. 
>Refer to as below.

Hi,


>> 
>> I don't know if this is necessary. MFC_NUM_CONTEXTS can be fixed at 
>> the maximum number allowed by MFC hw: 16. I highly doubt someone will 
>> open that many contexts. Increasing this number will not significantly 
>> increase storage space used by MFC if no contexts are used. It will 
>> only change size of one pointer array ( struct s5p_mfc_ctx 
>> *ctx[MFC_NUM_CONTEXTS]; ).
>> 
>In many project, user can open many contexts according to the scenario
>of not only phone but also netbook, tablet. 'cause MFC supports multiple
>instance. That's why I suggested this param. be configurable.

I see no problem with setting it to the maximum number allowed by MFC - 16.
There would be no use of setting a smaller value. Except a _minimal_ saving
of memory.

>> >
>> > > +
>> > > +/* Check whether a context should be run on hardware */ int 
>> > > +s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx) {
>> > > +	mfc_debug("s5p_mfc_ctx_ready: src=%d, dst=%d, state=%d\n",
>> > > +		  ctx->src_queue_cnt, ctx->dst_queue_cnt,
ctx->state);
>> > > +	/* Context is to parse header */
>> > > +	if (ctx->src_queue_cnt >= 1 && ctx->state ==
>> > MFCINST_DEC_GOT_INST)
>> > > +		return 1;
>> > > +	/* Context is to decode a frame */
>> > > +	if (ctx->src_queue_cnt >= 1 && ctx->state ==
MFCINST_DEC_RUNNING
>> > &&
>> > > +					ctx->dst_queue_cnt >= ctx-


--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

