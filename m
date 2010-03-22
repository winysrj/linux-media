Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37836 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0CVGkf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 02:40:35 -0400
Date: Sun, 21 Mar 2010 23:40:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Greg KH <gregkh@suse.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Mike Isely <isely@pobox.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sujith Thomas <sujith.thomas@intel.com>,
	Matthew Garrett <mjg@redhat.com>, linuxppc-dev@ozlabs.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] device_attributes: add sysfs_attr_init() for dynamic
 attributes
Message-ID: <20100322064027.GG31621@core.coreip.homeip.net>
References: <1269238878-991-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269238878-991-1-git-send-email-w.sang@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfram,

On Mon, Mar 22, 2010 at 07:21:17AM +0100, Wolfram Sang wrote:
> Made necessary by 6992f5334995af474c2b58d010d08bc597f0f2fe.
> 
> Found by this semantic patch:
> 
> @ init @
> type T;
> identifier A;
> @@
> 
>         T {
>                 ...
>                 struct device_attribute A;
>                 ...
>         };
> 
> @ main extends init @
> expression E;
> statement S;
> identifier err;
> T *name;
> @@
> 
>         ... when != sysfs_attr_init(&name->A.attr);
> (
> +       sysfs_attr_init(&name->A.attr);
>         if (device_create_file(E, &name->A))
>                 S
> |
> +       sysfs_attr_init(&name->A.attr);
>         err = device_create_file(E, &name->A);
> )
> 
> While reviewing, I put the initialization to apropriate places.
> 

My standard question - are all of these need to be dynamically
allocated?

Thanks.

-- 
Dmitry
