Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:34807 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZKWDZQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 22:25:16 -0500
Received: by gxk26 with SMTP id 26so4478280gxk.1
        for <linux-media@vger.kernel.org>; Sun, 22 Nov 2009 19:25:22 -0800 (PST)
Message-ID: <4B0A009C.3080801@hotmail.com>
Date: Mon, 23 Nov 2009 11:25:16 +0800
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
CC: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 06/11] add the generic file
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com> <1258687493-4012-2-git-send-email-shijie8@gmail.com> <1258687493-4012-3-git-send-email-shijie8@gmail.com> <1258687493-4012-4-git-send-email-shijie8@gmail.com> <1258687493-4012-5-git-send-email-shijie8@gmail.com> <1258687493-4012-6-git-send-email-shijie8@gmail.com> <1258687493-4012-7-git-send-email-shijie8@gmail.com>
In-Reply-To: <1258687493-4012-7-git-send-email-shijie8@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> +#ifdef CONFIG_PM
> +/* Is the card working now ? */
> +static inline int is_working(struct poseidon *pd)
> +{
> +	if (pd->state & POSEIDON_STATE_IDLE_HIBERANTION)
> +		return 0;
> +	return pd->interface->pm_usage_cnt > 0;
> +}
> +
> +static int poseidon_suspend(struct usb_interface *intf, pm_message_t msg)
> +{
> +	struct poseidon *pd = usb_get_intfdata(intf);
> +
> +	if (!is_working(pd)) {
> +		if (pd->interface->pm_usage_cnt <= 0
>   
`interface->pm_usage_cnt` has been changed to atomic_t type in the latest code. 

> +			&& !in_hibernation(pd)) {
> +			pd->msg.event = PM_EVENT_AUTO_SUSPEND;
> +			pd->pm_resume = NULL; /*  a good guard */
> +			printk(KERN_DEBUG "\n\t ++ TLG2300 auto suspend ++\n");
> +		}
> +		return 0;
> +	}
> +	pd->msg = msg;
>   

