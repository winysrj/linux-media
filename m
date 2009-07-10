Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:51654 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbZGJWrL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 18:47:11 -0400
Date: Fri, 10 Jul 2009 15:26:30 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: kjsisson@bellsouth.net, mchehab@infradead.org,
	linux-media@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [patch]stv680: kfree called before usb_kill_urb
Message-ID: <20090710222630.GD3253@kroah.com>
References: <200907031848.49825.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907031848.49825.oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 03, 2009 at 06:48:49PM +0200, Oliver Neukum wrote:
> The irq handler will touch memory. Even in the error case some URBs may
> complete. Thus no memory must be kfreed before all URBs are killed.
> 
> Signed-off-by: Oliver Neukum <oliver@neukum.org>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
