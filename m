Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36417 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965047AbbBQL5L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 06:57:11 -0500
Date: Tue, 17 Feb 2015 09:57:05 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David Howells <dhowells@redhat.com>
Cc: mkrufky@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] cxusb: Use enum to represent table offsets rather than
 hard-coding numbers
Message-ID: <20150217095705.6b317321@recife.lan>
In-Reply-To: <20150216153307.19963.61947.stgit@warthog.procyon.org.uk>
References: <20150216153307.19963.61947.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Feb 2015 15:33:07 +0000
David Howells <dhowells@redhat.com> escreveu:

> Use enum to represent table offsets rather than hard-coding numbers to avoid
> problems with the numbers becoming out of sync with the table.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  drivers/media/usb/dvb-usb/cxusb.c |  115 +++++++++++++++++++++++--------------
>  1 file changed, 71 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index f327c49..5bb1c5c 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -1516,28 +1516,55 @@ static void cxusb_disconnect(struct usb_interface *intf)
>  	dvb_usb_device_exit(intf);
>  }
>  
> -static struct usb_device_id cxusb_table [] = {
> -	{ USB_DEVICE(USB_VID_MEDION, USB_PID_MEDION_MD95700) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LG064F_COLD) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LG064F_WARM) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_1_COLD) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_1_WARM) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LGZ201_COLD) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LGZ201_WARM) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_TH7579_COLD) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_TH7579_WARM) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_COLD) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_WARM) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_2_COLD) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_2_WARM) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_4) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM) },
> -	{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_A868R) },
> -	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2) },
> -	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_CONEXANT_D680_DMB) },
> -	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_D689) },
> -	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230) },
> +enum cxusb_table_index {
> +	ix_USB_PID_MEDION_MD95700,
> +	ix_USB_PID_DVICO_BLUEBIRD_LG064F_COLD,
> +	ix_USB_PID_DVICO_BLUEBIRD_LG064F_WARM,
> +	ix_USB_PID_DVICO_BLUEBIRD_DUAL_1_COLD,
> +	ix_USB_PID_DVICO_BLUEBIRD_DUAL_1_WARM,
> +	ix_USB_PID_DVICO_BLUEBIRD_LGZ201_COLD,
> +	ix_USB_PID_DVICO_BLUEBIRD_LGZ201_WARM,
> +	ix_USB_PID_DVICO_BLUEBIRD_TH7579_COLD,
> +	ix_USB_PID_DVICO_BLUEBIRD_TH7579_WARM,
> +	ix_USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_COLD,
> +	ix_USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_WARM,
> +	ix_USB_PID_DVICO_BLUEBIRD_DUAL_2_COLD,
> +	ix_USB_PID_DVICO_BLUEBIRD_DUAL_2_WARM,
> +	ix_USB_PID_DVICO_BLUEBIRD_DUAL_4,
> +	ix_USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2,
> +	ix_USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM,
> +	ix_USB_PID_AVERMEDIA_VOLAR_A868R,
> +	ix_USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2,
> +	ix_USB_PID_CONEXANT_D680_DMB,
> +	ix_USB_PID_MYGICA_D689,
> +	ix_USB_PID_MYGICA_T230,

I would do a s/ix_USB_PID_// in the above, in order to simplify the
namespace and to avoid giving the false impression that those are vendor
IDs. If you look below on your patch, even you forgot to add a "ix_"
prefix into one of the entires ;)

Just calling MEDION_MD95700..MYGICA_T230 would be enough and shorter.

> +	NR__cxusb_table_index
> +};
> +
> +static struct usb_device_id cxusb_table [NR__cxusb_table_index + 1] = {
> +#define _(vend, prod) [ix_##prod] = { vend, prod }

Of course, if you change s/ix_USB_PID_//, here, you'll need to change the
macro to:

#define _(vend, prod) [prod] = { vend, USB_PID_##prod }

And maybe add some comment. Yet, I think that the best would be to just
remove the macro, an just use:

static struct usb_device_id cxusb_table [] = {
	[VID_MEDION] = {USB_VID_MEDION,	USB_PID_MEDION_MD95700},
...
}

> +	_(USB_VID_MEDION,	USB_PID_MEDION_MD95700), // 0

Please don't use c99 comments. Also, I don't think that the comments would
help, as the entries on this table doesn't need to follow the same order
as defined at the enum.

> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_LG064F_COLD),
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_LG064F_WARM), // 2
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_DUAL_1_COLD),
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_DUAL_1_WARM), // 4
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_LGZ201_COLD),
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_LGZ201_WARM), // 6
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_TH7579_COLD),
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_TH7579_WARM), // 8
> +	_(USB_VID_DVICO,	USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_COLD),
> +	_(USB_VID_DVICO,	USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_WARM), // 10
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_DUAL_2_COLD),
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_DUAL_2_WARM), // 12
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_DUAL_4),
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2), // 14
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM),
> +	_(USB_VID_AVERMEDIA,	USB_PID_AVERMEDIA_VOLAR_A868R), // 16
> +	_(USB_VID_DVICO,	USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2),
> +	_(USB_VID_CONEXANT,	USB_PID_CONEXANT_D680_DMB), // 18
> +	_(USB_VID_CONEXANT,	USB_PID_MYGICA_D689),
> +	_(USB_VID_CONEXANT,	USB_PID_MYGICA_T230), // 20
> +#undef _
>  	{}		/* Terminating entry */
>  };
>  MODULE_DEVICE_TABLE (usb, cxusb_table);
> @@ -1581,7 +1608,7 @@ static struct dvb_usb_device_properties cxusb_medion_properties = {
>  	.devices = {
>  		{   "Medion MD95700 (MDUSBTV-HYBRID)",
>  			{ NULL },
> -			{ &cxusb_table[0], NULL },
> +			{ &cxusb_table[ix_USB_PID_MEDION_MD95700], NULL },
>  		},
>  	}
>  };
> @@ -1637,8 +1664,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgh064f_properties = {
>  	.num_device_descs = 1,
>  	.devices = {
>  		{   "DViCO FusionHDTV5 USB Gold",
> -			{ &cxusb_table[1], NULL },
> -			{ &cxusb_table[2], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_LG064F_COLD], NULL },
> +			{ &cxusb_table[USB_PID_DVICO_BLUEBIRD_LG064F_WARM], NULL },

Here, you forgot the "ix_" prefix.

>  		},
>  	}
>  };
> @@ -1693,16 +1720,16 @@ static struct dvb_usb_device_properties cxusb_bluebird_dee1601_properties = {
>  	.num_device_descs = 3,
>  	.devices = {
>  		{   "DViCO FusionHDTV DVB-T Dual USB",
> -			{ &cxusb_table[3], NULL },
> -			{ &cxusb_table[4], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_DUAL_1_COLD], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_DUAL_1_WARM], NULL },
>  		},
>  		{   "DigitalNow DVB-T Dual USB",
> -			{ &cxusb_table[9],  NULL },
> -			{ &cxusb_table[10], NULL },
> +			{ &cxusb_table[ix_USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_COLD],  NULL },
> +			{ &cxusb_table[ix_USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_WARM], NULL },
>  		},
>  		{   "DViCO FusionHDTV DVB-T Dual Digital 2",
> -			{ &cxusb_table[11], NULL },
> -			{ &cxusb_table[12], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_DUAL_2_COLD], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_DUAL_2_WARM], NULL },
>  		},
>  	}
>  };
> @@ -1756,8 +1783,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties = {
>  	.num_device_descs = 1,
>  	.devices = {
>  		{   "DViCO FusionHDTV DVB-T USB (LGZ201)",
> -			{ &cxusb_table[5], NULL },
> -			{ &cxusb_table[6], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_LGZ201_COLD], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_LGZ201_WARM], NULL },
>  		},
>  	}
>  };
> @@ -1812,8 +1839,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_dtt7579_properties = {
>  	.num_device_descs = 1,
>  	.devices = {
>  		{   "DViCO FusionHDTV DVB-T USB (TH7579)",
> -			{ &cxusb_table[7], NULL },
> -			{ &cxusb_table[8], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_TH7579_COLD], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_TH7579_WARM], NULL },
>  		},
>  	}
>  };
> @@ -1865,7 +1892,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_properties = {
>  	.devices = {
>  		{   "DViCO FusionHDTV DVB-T Dual Digital 4",
>  			{ NULL },
> -			{ &cxusb_table[13], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_DUAL_4], NULL },
>  		},
>  	}
>  };
> @@ -1918,7 +1945,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties = {
>  	.devices = {
>  		{   "DViCO FusionHDTV DVB-T NANO2",
>  			{ NULL },
> -			{ &cxusb_table[14], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2], NULL },
>  		},
>  	}
>  };
> @@ -1972,8 +1999,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_prope
>  	.num_device_descs = 1,
>  	.devices = {
>  		{   "DViCO FusionHDTV DVB-T NANO2 w/o firmware",
> -			{ &cxusb_table[14], NULL },
> -			{ &cxusb_table[15], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM], NULL },
>  		},
>  	}
>  };
> @@ -2017,7 +2044,7 @@ static struct dvb_usb_device_properties cxusb_aver_a868r_properties = {
>  	.devices = {
>  		{   "AVerMedia AVerTVHD Volar (A868R)",
>  			{ NULL },
> -			{ &cxusb_table[16], NULL },
> +			{ &cxusb_table[ix_USB_PID_AVERMEDIA_VOLAR_A868R], NULL },
>  		},
>  	}
>  };
> @@ -2071,7 +2098,7 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
>  	.devices = {
>  		{   "DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2)",
>  			{ NULL },
> -			{ &cxusb_table[17], NULL },
> +			{ &cxusb_table[ix_USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2], NULL },
>  		},
>  	}
>  };
> @@ -2125,7 +2152,7 @@ static struct dvb_usb_device_properties cxusb_d680_dmb_properties = {
>  		{
>  			"Conexant DMB-TH Stick",
>  			{ NULL },
> -			{ &cxusb_table[18], NULL },
> +			{ &cxusb_table[ix_USB_PID_CONEXANT_D680_DMB], NULL },
>  		},
>  	}
>  };
> @@ -2179,7 +2206,7 @@ static struct dvb_usb_device_properties cxusb_mygica_d689_properties = {
>  		{
>  			"Mygica D689 DMB-TH",
>  			{ NULL },
> -			{ &cxusb_table[19], NULL },
> +			{ &cxusb_table[ix_USB_PID_MYGICA_D689], NULL },
>  		},
>  	}
>  };
> @@ -2232,7 +2259,7 @@ static struct dvb_usb_device_properties cxusb_mygica_t230_properties = {
>  		{
>  			"Mygica T230 DVB-T/T2/C",
>  			{ NULL },
> -			{ &cxusb_table[20], NULL },
> +			{ &cxusb_table[ix_USB_PID_MYGICA_T230], NULL },
>  		},
>  	}
>  };
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
