Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51970 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753244Ab3FQUnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 16:43:37 -0400
Date: Mon, 17 Jun 2013 23:43:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	a.hajda@samsung.com
Subject: Re: [RFC PATCH 2/2] davinci_vpfe: Clean up media entity after
 unregistering subdev
Message-ID: <20130617204332.GC2064@valkosipuli.retiisi.org.uk>
References: <20130611105032.GJ3103@valkosipuli.retiisi.org.uk>
 <1370947849-24314-1-git-send-email-sakari.ailus@iki.fi>
 <1370947849-24314-2-git-send-email-sakari.ailus@iki.fi>
 <CA+V-a8t2MUwEHZMvbb0mN+dy6bH6yt_mwirH6cgoTfZfh83cew@mail.gmail.com>
 <51BE2B3C.30102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BE2B3C.30102@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sun, Jun 16, 2013 at 11:16:44PM +0200, Sylwester Nawrocki wrote:
> Hi,
> 
> On 06/12/2013 06:44 AM, Prabhakar Lad wrote:
> >On Tue, Jun 11, 2013 at 4:20 PM, Sakari Ailus<sakari.ailus@iki.fi>  wrote:
> >>media_entity_cleanup() frees the links array which will be accessed by
> >>media_entity_remove_links() called by v4l2_device_unregister_subdev().
> >>
> >>Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
> >
> >Acked-by: Lad, Prabhakar<prabhakar.csengg@gmail.com>
> 
> I have added these two patches to my tree for 3.11 (in branch for-v3.11-2).
> Please let me know if you would like it to be handled differently.

This was what I was looking forward to. Thanks!

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
