Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707Ab1KBPKz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Nov 2011 11:10:55 -0400
Date: Wed, 2 Nov 2011 08:10:09 -0700
From: Greg KH <gregkh@suse.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: devel@driverdev.osuosl.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] Move media staging drivers to staging/media
Message-ID: <20111102151009.GA22699@suse.de>
References: <20111102094509.4954fead@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102094509.4954fead@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 02, 2011 at 09:45:09AM -0200, Mauro Carvalho Chehab wrote:
> Greg,
> 
> As agreed, this is the patches that move media drivers to their
> own places. Basically, cx25821 now seems ready to be at the standard
> place, while the other drivers should still be in staging for a while.
> 
> The cxd2099 is a special case. This is an optional driver for handling
> encrypted DVB streams. It abuses of the DVB API and, while we don't
> have a proper way for handling it, we should keep it at staging, as
> its API will change after we add proper support for it. According with
> KS Workshop discussions, the proper way seems to add Media Controller
> capabilities for DVB, and allow changing the DVB pipelines to add
> a decriptor if/when needed.
> 
> PS.: I'll likely merge patch 3 with patch 2 when submitting it
> upstream.

That would be great, please feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to all of these and send them to Linus through your tree.

thanks,

greg k-h
