Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37280 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751761Ab2IARO0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Sep 2012 13:14:26 -0400
Date: Sat, 1 Sep 2012 20:14:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 2/9] ir-rx51: Handle signals properly
Message-ID: <20120901171420.GC6638@valkosipuli.retiisi.org.uk>
References: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1346349271-28073-3-git-send-email-timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346349271-28073-3-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi,

On Thu, Aug 30, 2012 at 08:54:24PM +0300, Timo Kokkonen wrote:
> @@ -273,9 +281,18 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
>  
>  	/*
>  	 * Don't return back to the userspace until the transfer has
> -	 * finished
> +	 * finished. However, we wish to not spend any more than 500ms
> +	 * in kernel. No IR code TX should ever take that long.
> +	 */
> +	i = wait_event_timeout(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0,
> +			HZ / 2);

Why such an arbitrary timeout? In reality it might not bite the user space
in practice ever, but is it (and if so, why) really required in the first
place?

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
