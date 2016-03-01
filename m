Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52647 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbcCALQV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2016 06:16:21 -0500
Date: Tue, 1 Mar 2016 08:16:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 1/4] media: Sanitise the reserved fields of the
 G_TOPOLOGY IOCTL arguments
Message-ID: <20160301081615.68b1ef2c@recife.lan>
In-Reply-To: <1456174024-11389-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1456174024-11389-1-git-send-email-sakari.ailus@linux.intel.com>
	<1456174024-11389-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 22 Feb 2016 22:47:01 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> The argument structs are used in arrays for G_TOPOLOGY IOCTL. The
> arguments themselves do not need to be aligned to a power of two, but
> aligning them up to the largest basic type alignment (u64) on common ABIs
> is a good thing to do.
> 
> The patch changes the size of the reserved fields to 8 or 9 u32's and
> aligns the size of the struct to 8 bytes so we do no longer depend on the
> compiler to perform the alignment.

I ran some tests with both x86_64 and arch64 running both 32 and 64 bits
userspace versions of mc_nextgen_test.

Everything is working fine with the current structures. No need for any
extra alignment or compat32 bits.

So, this patch is not needed. Yet, I agree that it could be useful to
do 64 bits alignment, but I guess we're reserving too much space.

So, except for media_v2_interface, I would be reserving 5 or 6 u32 space,
as it is likely mor than enough for future usage.

See below.

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/uapi/linux/media.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 6aac2f0..1468651 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -302,7 +302,7 @@ struct media_v2_entity {
>  	__u32 id;
>  	char name[64];		/* FIXME: move to a property? (RFC says so) */
>  	__u32 function;		/* Main function of the entity */
> -	__u16 reserved[12];
> +	__u32 reserved[8];

You extended the size here. Any reason? If not
I would use, instead:
	__u32 reserved[6];

>  };
>  
>  /* Should match the specific fields at media_intf_devnode */
> @@ -327,7 +327,7 @@ struct media_v2_pad {
>  	__u32 id;
>  	__u32 entity_id;
>  	__u32 flags;
> -	__u16 reserved[9];
> +	__u32 reserved[9];

Again, you're doubling the reserved space here. Any reason? If not,
I would use, instead:
	__u32 reserved[5];

>  };
>  
>  struct media_v2_link {
> @@ -335,7 +335,7 @@ struct media_v2_link {
>  	__u32 source_id;
>  	__u32 sink_id;
>  	__u32 flags;
> -	__u32 reserved[5];
> +	__u32 reserved[8];

Again, you're doubling the reserved space here. Any reason? If not,
I would use, instead:

	__u32 reserved[6];

>  };
>  
>  struct media_v2_topology {


-- 
Thanks,
Mauro
