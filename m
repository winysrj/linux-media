Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:39078 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaGZPYg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 11:24:36 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9B00GTMS4ZDG40@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 26 Jul 2014 11:24:35 -0400 (EDT)
Date: Sat, 26 Jul 2014 12:24:31 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Marcel J.E. Mol" <marcel@mesa.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [v4l-utils] keytable: add support for XMP IR protocol
Message-id: <20140726122431.2401d546.m.chehab@samsung.com>
In-reply-to: <20140616211711.GA2343@joshua.mesa.nl>
References: <20140616211711.GA2343@joshua.mesa.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Jun 2014 23:17:11 +0200
"Marcel J.E. Mol" <marcel@mesa.nl> escreveu:

You also missed your Signed-off-by: here. There will be a small conflict
with this patch, as I added yesterday the missing support for sharp and
mce-kbd on ir-keytable.

It would be nice if you could rebase it, but if you can't, I'll do it
anyway after merging your Kernel patch.

Regards,
Mauro


> 
> ---
>  utils/keytable/keytable.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
> index 065ac3b..ba98cd3 100644
> --- a/utils/keytable/keytable.c
> +++ b/utils/keytable/keytable.c
> @@ -86,6 +86,7 @@ enum ir_protocols {
>  	LIRC		= 1 << 5,
>  	SANYO		= 1 << 6,
>  	RC_5_SZ		= 1 << 7,
> +	XMP		= 1 << 8,
>  	OTHER		= 1 << 31,
>  };
>  
> @@ -110,7 +111,7 @@ static const char doc[] = "\nAllows get/set IR keycode/scancode tables\n"
>  	"  SYSDEV   - the ir class as found at /sys/class/rc\n"
>  	"  TABLE    - a file with a set of scancode=keycode value pairs\n"
>  	"  SCANKEY  - a set of scancode1=keycode1,scancode2=keycode2.. value pairs\n"
> -	"  PROTOCOL - protocol name (nec, rc-5, rc-6, jvc, sony, sanyo, rc-5-sz, lirc, other) to be enabled\n"
> +	"  PROTOCOL - protocol name (nec, rc-5, rc-6, jvc, sony, sanyo, rc-5-sz, lirc, xmp, other) to be enabled\n"
>  	"  DELAY    - Delay before repeating a keystroke\n"
>  	"  PERIOD   - Period to repeat a keystroke\n"
>  	"  CFGFILE  - configuration file that associates a driver/table name with a keymap file\n"
> @@ -234,6 +235,8 @@ static error_t parse_keyfile(char *fname, char **table)
>  							ch_proto |= SANYO;
>  						else if (!strcasecmp(p,"rc-5-sz"))
>  							ch_proto |= RC_5_SZ;
> +						else if (!strcasecmp(p,"xmp"))
> +							ch_proto |= XMP;
>  						else if (!strcasecmp(p,"other") || !strcasecmp(p,"unknown"))
>  							ch_proto |= OTHER;
>  						else {
> @@ -471,6 +474,8 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
>  				ch_proto |= LIRC;
>  			else if (!strcasecmp(p,"rc-5-sz"))
>  				ch_proto |= RC_5_SZ;
> +			else if (!strcasecmp(p,"xmp"))
> +				ch_proto |= XMP;
>  			else
>  				goto err_inval;
>  			p = strtok(NULL, ",;");
> @@ -744,6 +749,8 @@ static enum ir_protocols v1_get_hw_protocols(char *name)
>  			proto |= SANYO;
>  		else if (!strcmp(p, "rc-5-sz"))
>  			proto |= RC_5_SZ;
> +		else if (!strcmp(p, "xmp"))
> +			proto |= XMP;
>  		else
>  			proto |= OTHER;
>  
> @@ -790,6 +797,9 @@ static int v1_set_hw_protocols(struct rc_device *rc_dev)
>  	if (rc_dev->current & RC_5_SZ)
>  		fprintf(fp, "rc-5-sz ");
>  
> +	if (rc_dev->current & XMP)
> +		fprintf(fp, "xmp ");
> +
>  	if (rc_dev->current & OTHER)
>  		fprintf(fp, "unknown ");
>  
> @@ -921,6 +931,8 @@ static enum ir_protocols v2_get_protocols(struct rc_device *rc_dev, char *name)
>  			proto = LIRC;
>  		else if (!strcmp(p, "rc-5-sz"))
>  			proto = RC_5_SZ;
> +		else if (!strcmp(p, "xmp"))
> +			proto = XMP;
>  		else
>  			proto = OTHER;
>  
> @@ -977,6 +989,9 @@ static int v2_set_protocols(struct rc_device *rc_dev)
>  	if (rc_dev->current & RC_5_SZ)
>  		fprintf(fp, "+rc-5-sz\n");
>  
> +	if (rc_dev->current & XMP)
> +		fprintf(fp, "+xmp\n");
> +
>  	if (rc_dev->current & OTHER)
>  		fprintf(fp, "+unknown\n");
>  
> @@ -1006,6 +1021,8 @@ static void show_proto(	enum ir_protocols proto)
>  		fprintf (stderr, "LIRC ");
>  	if (proto & RC_5_SZ)
>  		fprintf (stderr, "RC-5-SZ ");
> +	if (proto & XMP)
> +		fprintf (stderr, "XMP ");
>  	if (proto & OTHER)
>  		fprintf (stderr, "other ");
>  }
> @@ -1128,6 +1145,10 @@ static int get_attribs(struct rc_device *rc_dev, char *sysfs_name)
>  			rc_dev->supported |= SONY;
>  			if (v1_get_sw_enabled_protocol(cur->name))
>  				rc_dev->current |= SONY;
> +		} else if (strstr(cur->name, "/xmp_decoder")) {
> +			rc_dev->supported |= XMP;
> +			if (v1_get_sw_enabled_protocol(cur->name))
> +				rc_dev->current |= XMP;
>  		}
>  	}
>  
> @@ -1159,6 +1180,9 @@ static int set_proto(struct rc_device *rc_dev)
>  		if (rc_dev->supported & SONY)
>  			rc += v1_set_sw_enabled_protocol(rc_dev, "/sony_decoder",
>  						      rc_dev->current & SONY);
> +		if (rc_dev->supported & XMP)
> +			rc += v1_set_sw_enabled_protocol(rc_dev, "/xmp_decoder",
> +						      rc_dev->current & XMP);
>  	} else {
>  		rc = v1_set_hw_protocols(rc_dev);
>  	}
