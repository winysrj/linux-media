Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51389 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbaHUL5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 07:57:11 -0400
Date: Thu, 21 Aug 2014 06:50:06 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: David =?ISO-8859-1?B?SORyZGVtYW4=?= <david@hardeman.nu>,
	arnd@arndb.de, haifeng.yan@linaro.org, jchxue@gmail.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [media] rc: remove change_protocol in
 rc-ir-raw.c
Message-ID: <20140821065006.6d831ec4@concha.lan>
In-Reply-To: <1408613086-12538-4-git-send-email-zhangfei.gao@linaro.org>
References: <1408613086-12538-1-git-send-email-zhangfei.gao@linaro.org>
	<1408613086-12538-4-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Aug 2014 17:24:45 +0800
Zhangfei Gao <zhangfei.gao@linaro.org> escreveu:

> With commit 4924a311a62f ("[media] rc-core: rename ir-raw.c"),
> empty change_protocol was introduced.

No. This was introduced on this changeset:

commit da6e162d6a4607362f8478c715c797d84d449f8b
Author: David Härdeman <david@hardeman.nu>
Date:   Thu Apr 3 20:32:16 2014 -0300

    [media] rc-core: simplify sysfs code

> As a result, rc_register_device will set dev->enabled_protocols
> addording to rc_map->rc_type, which prevent using all protocols.

I strongly suspect that this patch will break some things, as
the new code seems to expect that this is always be set. 

See the code at store_protocols(): if this callback is not set,
then it won't allow to disable a protocol.

Also, this doesn't prevent using all protocols. You can still use
"ir-keytable -p all" to enable all protocols (the "all" protocol
type were introduced recently at the userspace tool).

>From the way I see, setting the protocol when a table is loaded
is not a bad thing, as:
- if RC tables are loaded, the needed protocol to decode it is
  already known;
- by running just one IR decoder, the IR handling routine will
  be faster and will consume less power;
- on a real case scenario, it is a way more likely that just one
  decoder will ever be needed by the end user.

So, I think that this is just annoying for developers when are checking
if all decoders are working, by sending keycodes from different IR types
at the same time.

> 
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> ---
>  drivers/media/rc/rc-ir-raw.c |    7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index e8fff2a..a118539 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -240,12 +240,6 @@ ir_raw_get_allowed_protocols(void)
>  	return protocols;
>  }
>  
> -static int change_protocol(struct rc_dev *dev, u64 *rc_type)
> -{
> -	/* the caller will update dev->enabled_protocols */
> -	return 0;
> -}
> -
>  /*
>   * Used to (un)register raw event clients
>   */
> @@ -263,7 +257,6 @@ int ir_raw_event_register(struct rc_dev *dev)
>  
>  	dev->raw->dev = dev;
>  	dev->enabled_protocols = ~0;
> -	dev->change_protocol = change_protocol;
>  	rc = kfifo_alloc(&dev->raw->kfifo,
>  			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
>  			 GFP_KERNEL);


-- 

Cheers,
Mauro
