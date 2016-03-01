Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52697 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbcCALmv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2016 06:42:51 -0500
Date: Tue, 1 Mar 2016 08:42:45 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 2/4] media: Rearrange the fields in the G_TOPOLOGY
 IOCTL argument
Message-ID: <20160301084245.0b4493b3@recife.lan>
In-Reply-To: <1456174024-11389-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1456174024-11389-1-git-send-email-sakari.ailus@linux.intel.com>
	<1456174024-11389-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 22 Feb 2016 22:47:02 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> This avoids having multiple reserved fields in the struct. Reserved fields
> are added in order to align the struct size to a power of two as well.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/uapi/linux/media.h | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 1468651..65991df 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -341,21 +341,16 @@ struct media_v2_link {
>  struct media_v2_topology {
>  	__u64 topology_version;
>  
> -	__u32 num_entities;
> -	__u32 reserved1;
>  	__u64 ptr_entities;
> -
> -	__u32 num_interfaces;
> -	__u32 reserved2;
>  	__u64 ptr_interfaces;
> -
> -	__u32 num_pads;
> -	__u32 reserved3;
>  	__u64 ptr_pads;
> +	__u64 ptr_links;
>  
> +	__u32 num_entities;
> +	__u32 num_interfaces;
> +	__u32 num_pads;
>  	__u32 num_links;
> -	__u32 reserved4;
> -	__u64 ptr_links;
> +	__u32 reserved[18];
>  };

First of all, there's no need to add reserved fields here. As we've
discussed last year. If we need to grow the number of fields, we
can use the same model as the drivers/input/evdev.c does.
Something like:

#define MASK_SIZE(nr)	((nr) & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT))

	size = _IOC_SIZE(cmd);
	switch (MASK_SIZE(cmd)) {
	case MASK_SIZE(MEDIA_IOC_G_TOPOLOGY):
		media_device_get_topology(dev,
					  (struct media_v2_topology __user *)arg,
					  size);

This warrants binary compatibility if newer versions of the Kernel comes
with a bigger structure.

The problem on using:

struct media_v2_topology {
  	__u64 topology_version;
  	__u64 ptr_entities;
  	__u64 ptr_interfaces;
  	__u64 ptr_pads;
 	__u64 ptr_links;
  
 	__u32 num_entities;
 	__u32 num_interfaces;
 	__u32 num_pads;
  	__u32 num_links;
};

Is that, if we add a new type (for example "foo"), we would have:

struct media_v2_topology {
  	__u64 topology_version;
  	__u64 ptr_entities;
  	__u64 ptr_interfaces;
  	__u64 ptr_pads;
 	__u64 ptr_links;
  
 	__u32 num_entities;
 	__u32 num_interfaces;
 	__u32 num_pads;
  	__u32 num_links;

	__u64 ptr_foo;
	__u32 num_foo;
};

Then, on a next addition for "bar", we would have:

struct media_v2_topology {
  	__u64 topology_version;
  	__u64 ptr_entities;
  	__u64 ptr_interfaces;
  	__u64 ptr_pads;
 	__u64 ptr_links;
  
 	__u32 num_entities;
 	__u32 num_interfaces;
 	__u32 num_pads;
  	__u32 num_links;

	__u64 ptr_foo;
	__u32 num_foo;
	__u32 num_bar;
	__u64 ptr_bar;
};

So, it becomes messy at the addition of new fields.

On the other hand, the way it currently is:

struct media_v2_topology {
	__u64 topology_version;

	__u32 num_entities;
	__u32 reserved1;
	__u64 ptr_entities;

	__u32 num_interfaces;
	__u32 reserved2;
	__u64 ptr_interfaces;

	__u32 num_pads;
	__u32 reserved3;
	__u64 ptr_pads;

	__u32 num_links;
	__u32 reserved4;
	__u64 ptr_links;
};

Adding "foo":

struct media_v2_topology {
	__u64 topology_version;

	__u32 num_entities;
	__u32 reserved1;
	__u64 ptr_entities;

	__u32 num_interfaces;
	__u32 reserved2;
	__u64 ptr_interfaces;

	__u32 num_pads;
	__u32 reserved3;
	__u64 ptr_pads;

	__u32 num_links;
	__u32 reserved4;
	__u64 ptr_links;

	__u32 num_foo;
	__u32 reserved5;
	__u64 ptr_foo;
};

Adding bar:

struct media_v2_topology {
	__u64 topology_version;

	__u32 num_entities;
	__u32 reserved1;
	__u64 ptr_entities;

	__u32 num_interfaces;
	__u32 reserved2;
	__u64 ptr_interfaces;

	__u32 num_pads;
	__u32 reserved3;
	__u64 ptr_pads;

	__u32 num_links;
	__u32 reserved4;
	__u64 ptr_links;

	__u32 num_foo;
	__u32 reserved5;
	__u64 ptr_foo;

	__u32 num_bar;
	__u32 reserved6;
	__u64 ptr_bar;
};

If all your concern is with regards to "reserved[1..n]", then maybe
we could, instead, call them as "align_foo" or "reserved_foo", like:

struct media_v2_topology {
	__u64 topology_version;

	__u32 num_entities;
	__u32 align_entities;	/* not used, should be filled with 0 by userspace */
	__u64 ptr_entities;

	__u32 num_interfaces;
	__u32 align_interfaces;	/* not used, should be filled with 0 by userspace */
	__u64 ptr_interfaces;

	__u32 num_pads;
	__u32 align_pads;	/* not used, should be filled with 0 by userspace */
	__u64 ptr_pads;

	__u32 num_links;
	__u32 align_links;	/* not used, should be filled with 0 by userspace */
	__u64 ptr_links;
};

-- 
Thanks,
Mauro
