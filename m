Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33012 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2FZUnr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 16:43:47 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so566936pbb.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 13:43:47 -0700 (PDT)
Date: Tue, 26 Jun 2012 13:43:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 2/4] em28xx: defer probe() if userspace mode is
 disabled
Message-ID: <20120626204344.GD3885@kroah.com>
References: <4FE9169D.5020300@redhat.com>
 <1340739262-13747-1-git-send-email-mchehab@redhat.com>
 <1340739262-13747-3-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340739262-13747-3-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2012 at 04:34:20PM -0300, Mauro Carvalho Chehab wrote:
> +	/*
> +	 * If the device requires firmware, probe() may need to be
> +	 * postponed, as udev may not be ready yet to honour firmware
> +	 * load requests.
> +	 */
> +	if (em28xx_boards[id->driver_info].needs_firmware &&
> +	    is_usermodehelp_disabled()) {
> +		printk_once(KERN_DEBUG DRIVER_NAME
> +		            ": probe deferred for board %d.\n",
> +		            (unsigned)id->driver_info);
> +		return -EPROBE_DEFER;

You should printk once per device, right?  Not just for one time per
module load.

Also, what about using dev_dbg()?  Is there a _once version that works
for that?

thanks,

greg k-h
