Return-Path: <SRS0=3Wpa=PB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D98C43387
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 10:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD4D420675
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 10:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="Q5umoCXG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbeLXKTi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 24 Dec 2018 05:19:38 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38675 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbeLXKTh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Dec 2018 05:19:37 -0500
Received: by mail-ed1-f65.google.com with SMTP id h50so9762920ede.5
        for <linux-media@vger.kernel.org>; Mon, 24 Dec 2018 02:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=kDUK7mJ5jxdg2NZAI6vwwNSRWG7mQudGouDHyxCsLXU=;
        b=Q5umoCXGy6Ht0sndchX4B3oGN0HYxhl0hacaQvnetqtH8Wuu1RuDIP3LZav+L094Aq
         0HN3FA59h+mhDIz7ll0QU/T7sfcfpS/rokmn2A8BAG8Kyt7WDE12ySfEh0DylxaWWmkb
         QCy6PYwGEo9Gen8snJybP4Y3pJ2Vj0xNiv4zE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=kDUK7mJ5jxdg2NZAI6vwwNSRWG7mQudGouDHyxCsLXU=;
        b=qKGSRtwzSuR1mUMOzR6KIMzhBXjbTnUf0UmmgIAXOvzxwQSL2DypC8JKM6tIe//mAO
         XhJYQSzM3q0lupssvyTBxCwv5VNF40OdqDRQo/4n5YzeMbb/lpCgH1LFEBDWneQMe0y2
         VzggmgRjkOgua8J3ZTXxYG8Sp9MsSRQCS0juoGqVbdOCDxcrZPtthUhGffj10/a1GDyD
         69oj1b48K+w34++PPAMD+db68OK74nXTaP3Rfw6DbtXtwRg7bD6EyIxW9atYW682eYhJ
         lw44V2QcK8myhGAQm+sZHuEjYE4GrFtDisUN+RlBKRMFmqhh1cufv5YvJ9QJFWrxmjIh
         N8tQ==
X-Gm-Message-State: AA+aEWbiwUTKNm68UfxDVkZapin+j2Z1JeZCDtyauLwmxlj0F6BQ111e
        4vljPzyny/dmZ6KTnNXLLXJUtw==
X-Google-Smtp-Source: AFSGD/WNHrhPfrChUKkFKrTD4aWr8+lwW1k2YUx2dfH8J6TGH9bssxivFwGjNqP9TcSXPF7YNc1PLw==
X-Received: by 2002:a50:a4b6:: with SMTP id w51mr9854287edb.48.1545646775893;
        Mon, 24 Dec 2018 02:19:35 -0800 (PST)
Received: from dvetter-linux.ger.corp.intel.com ([194.230.159.220])
        by smtp.gmail.com with ESMTPSA id gy12-v6sm4649429ejb.44.2018.12.24.02.19.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Dec 2018 02:19:35 -0800 (PST)
Date:   Mon, 24 Dec 2018 11:19:30 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Yangtao Li <tiny.windzz@gmail.com>
Cc:     sumit.semwal@linaro.org, gustavo@padovan.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: Change to use DEFINE_SHOW_ATTRIBUTE macro
Message-ID: <20181224101826.GA30772@dvetter-linux.ger.corp.intel.com>
Mail-Followup-To: Yangtao Li <tiny.windzz@gmail.com>,
        sumit.semwal@linaro.org, gustavo@padovan.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20181130161101.3413-1-tiny.windzz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130161101.3413-1-tiny.windzz@gmail.com>
X-Operating-System: Linux dvetter-linux.ger.corp.intel.com
 4.18.17-200.fc28.x86_64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Nov 30, 2018 at 11:11:01AM -0500, Yangtao Li wrote:
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>

Sorry, fell through the cracks, applied for 4.22, thanks for your patch.
For next time around pls ping again after 1-2 weeks already, instead of
1-2 months.

Thanks, Daniel

> ---
>  drivers/dma-buf/dma-buf.c    | 12 +-----------
>  drivers/dma-buf/sync_debug.c | 16 +++-------------
>  2 files changed, 4 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 02f7f9a89979..7c858020d14b 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -1093,17 +1093,7 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
>  	return 0;
>  }
>  
> -static int dma_buf_debug_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, dma_buf_debug_show, NULL);
> -}
> -
> -static const struct file_operations dma_buf_debug_fops = {
> -	.open           = dma_buf_debug_open,
> -	.read           = seq_read,
> -	.llseek         = seq_lseek,
> -	.release        = single_release,
> -};
> +DEFINE_SHOW_ATTRIBUTE(dma_buf_debug);
>  
>  static struct dentry *dma_buf_debugfs_dir;
>  
> diff --git a/drivers/dma-buf/sync_debug.c b/drivers/dma-buf/sync_debug.c
> index c4c8ecb24aa9..c0abf37df88b 100644
> --- a/drivers/dma-buf/sync_debug.c
> +++ b/drivers/dma-buf/sync_debug.c
> @@ -147,7 +147,7 @@ static void sync_print_sync_file(struct seq_file *s,
>  	}
>  }
>  
> -static int sync_debugfs_show(struct seq_file *s, void *unused)
> +static int sync_info_debugfs_show(struct seq_file *s, void *unused)
>  {
>  	struct list_head *pos;
>  
> @@ -178,17 +178,7 @@ static int sync_debugfs_show(struct seq_file *s, void *unused)
>  	return 0;
>  }
>  
> -static int sync_info_debugfs_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, sync_debugfs_show, inode->i_private);
> -}
> -
> -static const struct file_operations sync_info_debugfs_fops = {
> -	.open           = sync_info_debugfs_open,
> -	.read           = seq_read,
> -	.llseek         = seq_lseek,
> -	.release        = single_release,
> -};
> +DEFINE_SHOW_ATTRIBUTE(sync_info_debugfs);
>  
>  static __init int sync_debugfs_init(void)
>  {
> @@ -218,7 +208,7 @@ void sync_dump(void)
>  	};
>  	int i;
>  
> -	sync_debugfs_show(&s, NULL);
> +	sync_info_debugfs_show(&s, NULL);
>  
>  	for (i = 0; i < s.count; i += DUMP_CHUNK) {
>  		if ((s.count - i) > DUMP_CHUNK) {
> -- 
> 2.17.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
