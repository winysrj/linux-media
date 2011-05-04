Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab1EDO4W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 10:56:22 -0400
Message-ID: <4DC16911.6080309@redhat.com>
Date: Wed, 04 May 2011 11:56:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org, jarod@wilsonet.com
Subject: Re: [PATCH 05/10] rc-core: add separate defines for protocol bitmaps
 and	numbers
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu> <20110428151337.8272.78812.stgit@felix.hardeman.nu>
In-Reply-To: <20110428151337.8272.78812.stgit@felix.hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-04-2011 12:13, David Härdeman escreveu:
> The RC_TYPE_* defines are currently used both where a single protocol is
> expected and where a bitmap of protocols is expected. This patch tries
> to separate the two in preparation for the following patches.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>

Most of the patch is just renaming stuff. So, I'm commenting just the
rc-main.c/rc-map.h changes.

> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 5b4422e..5a182b2 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -102,7 +102,7 @@ static struct rc_map_list empty_map = {
>  	.map = {
>  		.scan    = empty,
>  		.size    = ARRAY_SIZE(empty),
> -		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
>  		.name    = RC_MAP_EMPTY,
>  	}
>  };
> @@ -725,14 +725,17 @@ static struct {
>  	u64	type;
>  	char	*name;
>  } proto_names[] = {
> -	{ RC_TYPE_UNKNOWN,	"unknown"	},
> -	{ RC_TYPE_RC5,		"rc-5"		},
> -	{ RC_TYPE_NEC,		"nec"		},
> -	{ RC_TYPE_RC6,		"rc-6"		},
> -	{ RC_TYPE_JVC,		"jvc"		},
> -	{ RC_TYPE_SONY,		"sony"		},
> -	{ RC_TYPE_RC5_SZ,	"rc-5-sz"	},
> -	{ RC_TYPE_LIRC,		"lirc"		},
> +	{ RC_BIT_OTHER,		"other"		},
> +	{ RC_BIT_RC5,		"rc-5"		},
> +	{ RC_BIT_RC5X,		"rc-5-x"	},
> +	{ RC_BIT_RC5_SZ,	"rc-5-sz"	},
> +	{ RC_BIT_RC6,		"rc-6"		},
> +	{ RC_BIT_JVC,		"jvc"		},
> +	{ RC_BIT_SONY12,	"sony12"	},
> +	{ RC_BIT_SONY15,	"sony15"	},
> +	{ RC_BIT_SONY20,	"sony20"	},
> +	{ RC_BIT_NEC,		"nec"		},
> +	{ RC_BIT_LIRC,		"lirc"		},
>  };

There are some API breakages on the above. We shouln't do it, except
if strictly required, and, if we'll do it, we need to do it via
	Documentation/feature-removal-schedule.txt.

There are two types of breakages on the above: 
	1) the removal of "unknown" and "sony" types;
	2) the behaviour change of "rc-5" (that, currently, means
both rc-5 and rc-5x.

Also, while you've mapped rc5/sony variants, nec variants weren't mapped.

IMO, what we should do on the above is:
	1) preserve the "unknown";

	2) use "rc-5", "sony", "nec" with the meaning that they will
enable all variants of those protocols;

	3) add a new set of protocols to indicate subsets, like "sony:20",
"rc-5:normal", "rc5:x", etc.

	4) if you're changing the interface, please submit a patch also
to v4l-utils, adding a logic there to handle the changes.
>  
>  #define PROTO_NONE	"none"
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index 9184751..2c68ca6 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -11,19 +11,36 @@
>  
>  #include <linux/input.h>
>  
> -#define RC_TYPE_UNKNOWN	0
> -#define RC_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
> -#define RC_TYPE_NEC	(1  << 1)
> -#define RC_TYPE_RC6	(1  << 2)	/* Philips RC6 protocol */
> -#define RC_TYPE_JVC	(1  << 3)	/* JVC protocol */
> -#define RC_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
> -#define RC_TYPE_RC5_SZ	(1  << 5)	/* RC5 variant used by Streamzap */
> -#define RC_TYPE_LIRC	(1  << 30)	/* Pass raw IR to lirc userspace */
> -#define RC_TYPE_OTHER	(1u << 31)

> +#define RC_TYPE_UNKNOWN		0	/* Protocol not known */
> +#define RC_TYPE_OTHER		0	/* Protocol known but proprietary */

This change doesn't make sense: we should either remove other or use different
bits for different meanings. This is somewhat a mess currently, as there are, in
fact, 3 types of "protocols":
	1) reverse-engineered drivers, where developer didn't care to check
	   what was the used protocol. It is there due to legacy IR handlers,
	   added before rc-core. The better is to not accept this type anymore
	   for new devices;
	2) Other protocols that don't match at the list of supported protocols.
	   Reserved for the cases were the developer took the care to check if
	   the protocol is not NEC/RC-5/... and didn't find any protocol that
	   matches;
	3) Standard protocols with broken hardware. In general, keycode tables
	   with just 8 bits for RC-5 or NEC, because the hardware uses a cheap
	   uC (generally KS007 or similar) that only decodes the last 8 bits of
	   the protocol. As the developer didn't have a full IR decoder, he was
	   not able to fill the RC/NEC table with the IR address.

The problem with (2) is that it may reflect a temporary state where the protocol
is not yet known. After adding a protocol decoder for it, case (2) turns into
case (1).

So, maybe we can just merge (1) and (2) into the same case: "unknown". Maybe we
should map (3) with a different option, internally (even exporting it as "unknown"
to userspace), as it helps us to identify such cases and fix it later.

> +#define RC_TYPE_RC5		1	/* Philips RC5 protocol */
> +#define RC_TYPE_RC5X		2	/* Philips RC5x protocol */
> +#define RC_TYPE_RC5_SZ		3	/* StreamZap variant of RC5 */
> +#define RC_TYPE_RC6		4	/* Philips RC6 protocol */
> +#define RC_TYPE_JVC		5	/* JVC protocol */
> +#define RC_TYPE_SONY12		6	/* Sony 12 bit protocol */
> +#define RC_TYPE_SONY15		7	/* Sony 15 bit protocol */
> +#define RC_TYPE_SONY20		8	/* Sony 20 bit protocol */
> +#define RC_TYPE_NEC		9	/* NEC protocol */
> +#define RC_TYPE_LIRC		10	/* Pass raw IR to lirc userspace */
>  
> -#define RC_TYPE_ALL (RC_TYPE_RC5 | RC_TYPE_NEC  | RC_TYPE_RC6  | \
> -		     RC_TYPE_JVC | RC_TYPE_SONY | RC_TYPE_LIRC | \
> -		     RC_TYPE_RC5_SZ | RC_TYPE_OTHER)
> +#define RC_BIT_UNKNOWN		(1 << RC_TYPE_UNKNOWN)
> +#define RC_BIT_OTHER		(1 << RC_TYPE_OTHER)
> +#define RC_BIT_RC5		(1 << RC_TYPE_RC5)
> +#define RC_BIT_RC5X		(1 << RC_TYPE_RC5X)
> +#define RC_BIT_RC5_SZ		(1 << RC_TYPE_RC5_SZ)
> +#define RC_BIT_RC6		(1 << RC_TYPE_RC6)
> +#define RC_BIT_JVC		(1 << RC_TYPE_JVC)
> +#define RC_BIT_SONY12		(1 << RC_TYPE_SONY12)
> +#define RC_BIT_SONY15		(1 << RC_TYPE_SONY15)
> +#define RC_BIT_SONY20		(1 << RC_TYPE_SONY20)
> +#define RC_BIT_NEC		(1 << RC_TYPE_NEC)
> +#define RC_BIT_LIRC		(1 << RC_TYPE_LIRC)
> +
> +#define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | RC_BIT_RC5 | \
> +			 RC_BIT_RC5X | RC_BIT_RC6 | RC_BIT_JVC | \
> +			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
> +			 RC_BIT_NEC | RC_BIT_LIRC)
>  
>  struct rc_map_table {
>  	u32	scancode;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
Mauro
