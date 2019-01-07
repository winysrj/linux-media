Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD9EC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 16:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94B352147C
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 16:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfAGQz1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 11:55:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37880 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbfAGQz1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 11:55:27 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.91 #2 (Red Hat Linux))
        id 1ggYBJ-0004Uf-Pc; Mon, 07 Jan 2019 16:55:17 +0000
Date:   Mon, 7 Jan 2019 16:55:17 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Malathi Gottam <mgottam@codeaurora.org>
Cc:     stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        acourbot@chromium.org, vgarodia@codeaurora.org
Subject: Re: [PATCH v2] media: venus: add debugfs support
Message-ID: <20190107165517.GS2217@ZenIV.linux.org.uk>
References: <1546871340-13009-1-git-send-email-mgottam@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546871340-13009-1-git-send-email-mgottam@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 07, 2019 at 07:59:00PM +0530, Malathi Gottam wrote:

> +static struct dentry *venus_debugfs_init_drv(void)
> +{
> +	bool ok = false;
> +	struct dentry *dir = NULL;
> +
> +	dir = debugfs_create_dir("venus", NULL);
> +	if (IS_ERR_OR_NULL(dir)) {
> +		dir = NULL;
> +		pr_err("failed to create debug dir");
> +		goto failed_create_dir;
> +	}

Huh?  When does debugfs_create_dir() return ERR_PTR()?

Any interface that mixes returning NULL for error-reporting with returning
ERR_PTR(...) for the same needs to be put out of its misery.  As it happens,
debugfs_create_dir() returns NULL on all errors.  And if you've meant the
above as "future-proofing"... don't do that, please.  That only breeds
confusion down the road, as the code gets cut'n'pasted around.

> -	if (ret)
> +	if (ret) {
> +		dprintk(ERR,
> +			"Failed to set actual buffer count %d for buffer type %d\n",
> +			buf_count.count_actual, buf_count.type);
>  		return ret;
>  
>  	buf_count.type = HFI_BUFFER_OUTPUT;
>  	buf_count.count_actual = output_bufs;
>  

*blink*
Does that even compile?
