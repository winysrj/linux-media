Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758943AbZEKVlx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 17:41:53 -0400
Date: Mon, 11 May 2009 14:07:18 -0700
From: Greg KH <greg@kroah.com>
To: Mike Isely <isely@isely.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: remove driver_data direct access of struct
	device
Message-ID: <20090511210718.GF31999@kroah.com>
References: <20090430221808.GA18526@kroah.com> <Pine.LNX.4.64.0905012217170.15541@cnc.isely.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905012217170.15541@cnc.isely.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 01, 2009 at 10:18:38PM -0500, Mike Isely wrote:
> 
> Acked-By: Mike Isely <isely@pobox.com>
> 
> Note #1: I am just acking the pvrusb2 part of this.
> 
> Note #2: I am immediately pulling the pvrusb2 part of these changes into 
> that driver.

Thanks for doing this, I appreciate it.

greg k-h
