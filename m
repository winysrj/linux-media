Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56378
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752323AbcKRPxD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 10:53:03 -0500
Date: Fri, 18 Nov 2016 13:52:57 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Vaishali Thakkar <vthakkar1994@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] rc/keymaps: Add helper macro for rc_map_list
 boilerplate
Message-ID: <20161118135257.23edbc4b@vento.lan>
In-Reply-To: <20150711031737.GA12067@vaishali-Ideapad-Z570>
References: <20150711031737.GA12067@vaishali-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 11 Jul 2015 08:47:37 +0530
Vaishali Thakkar <vthakkar1994@gmail.com> escreveu:

> For simple modules that contain a single rc_map_list without any
> additional setup code then ends up being a block of duplicated
> boilerplate. This patch adds a new macro, module_rc_map_list(),
> which replaces the module_init()/module_exit() registrations with
> template functions.
> 
> Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
> ---
>  include/media/rc-map.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index 27763d5..07e765d 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -96,6 +96,16 @@ struct rc_map_list {
>  	struct rc_map map;
>  };
>  
> +/**
> + * module_rc_map_list() - Helper macro for registering a RC drivers
> + * @__rc_map_list: rc_map_list struct
> + * Helper macro for RC drivers which do not do anything special in module
> + * init/exit. This eliminates a lot of boilerplate. Each module may only
> + * use this macro once, and calling it replaces module_init() and module_exit()
> + */
> +#define module_rc_map_list(__rc_map_list) \
> +	module_driver(__rc_map_list, rc_map_register, rc_map_unregister)
> +

What's the sense of adding it, if no driver is using the new macro?

It would make sense if you had sent it as part of a patch series
making it to be used by the existing drivers.

-- 
Thanks,
Mauro
