Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab2AFNUa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 08:20:30 -0500
Message-ID: <4F06F512.9090704@redhat.com>
Date: Fri, 06 Jan 2012 11:20:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	"Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
	Eduard Bloch <blade@debian.org>
Subject: Re: [RFC/PATCH] [media] dw2102: use symbolic names for dw2102_table
 indices
References: <20111222215356.GA4499@rotes76.wohnheim.uni-kl.de> <20111222234446.GB10497@elie.Belkin> <201112231820.03693.pboettcher@kernellabs.com> <20111223230045.GE21769@elie.Belkin>
In-Reply-To: <20111223230045.GE21769@elie.Belkin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23-12-2011 21:00, Jonathan Nieder wrote:
> dw2102_properties et al refer to entries in the USB-id table using
> hard-coded indices, as in "&dw2102_table[6]", which means adding new
> entries before the end of the list has the potential to introduce bugs
> in code elsewhere in the file.
> 
> Use C99-style initializers with symbolic names for each index to avoid
> this.  This way, other device tables wanting to reuse the USB ids can
> use expressions like "&dw2102_table[TEVII_S630]" that do not change as
> the entries in the table are reordered.
> 
> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
> ---
> Patrick Boettcher wrote:
> 
>> Due to the use of the reference in the USB-id table adding the new set at 
>> the end of the list is actually the best way. Adding them in the middle will 
>> cause a lot of changes and bugs.
> 
> Good catch.  That seems like an accident waiting to happen.  How about
> something like this (untested)?
> 
>  drivers/media/dvb/dvb-usb/dw2102.c |   78 ++++++++++++++++++++++--------------
>  1 files changed, 48 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
> index 64add7cb1fd3..9a1863dc7232 100644
> --- a/drivers/media/dvb/dvb-usb/dw2102.c
> +++ b/drivers/media/dvb/dvb-usb/dw2102.c
> @@ -1435,22 +1435,40 @@ static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  	return 0;
>  }
>  
> +enum dw2102_table_entry {
> +	CYPRESS_DW2102,
> +	CYPRESS_DW2101,
> +	CYPRESS_DW2104,
> +	TEVII_S650,
> +	TERRATEC_CINERGY_S,
> +	CYPRESS_DW3101,
> +	TEVII_S630,
> +	PROF_1100,
> +	TEVII_S660,
> +	PROF_7500,
> +	GENIATECH_SU3000,
> +	TERRATEC_CINERGY_S2,
> +	TEVII_S480_1,
> +	TEVII_S480_2,
> +	X3M_SPC1400HD,
> +};
> +
>  static struct usb_device_id dw2102_table[] = {
> -	{USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2102)},
> -	{USB_DEVICE(USB_VID_CYPRESS, 0x2101)},
> -	{USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2104)},
> -	{USB_DEVICE(0x9022, USB_PID_TEVII_S650)},
> -	{USB_DEVICE(USB_VID_TERRATEC, USB_PID_CINERGY_S)},
> -	{USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW3101)},
> -	{USB_DEVICE(0x9022, USB_PID_TEVII_S630)},
> -	{USB_DEVICE(0x3011, USB_PID_PROF_1100)},
> -	{USB_DEVICE(0x9022, USB_PID_TEVII_S660)},
> -	{USB_DEVICE(0x3034, 0x7500)},
> -	{USB_DEVICE(0x1f4d, 0x3000)},
> -	{USB_DEVICE(USB_VID_TERRATEC, 0x00a8)},
> -	{USB_DEVICE(0x9022, USB_PID_TEVII_S480_1)},
> -	{USB_DEVICE(0x9022, USB_PID_TEVII_S480_2)},
> -	{USB_DEVICE(0x1f4d, 0x3100)},
> +	[CYPRESS_DW2102] = {USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2102)},
> +	[CYPRESS_DW2101] = {USB_DEVICE(USB_VID_CYPRESS, 0x2101)},
> +	[CYPRESS_DW2104] = {USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2104)},
> +	[TEVII_S650] = {USB_DEVICE(0x9022, USB_PID_TEVII_S650)},
> +	[TERRATEC_CINERGY_S] = {USB_DEVICE(USB_VID_TERRATEC, USB_PID_CINERGY_S)},
> +	[CYPRESS_DW3101] = {USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW3101)},
> +	[TEVII_S630] = {USB_DEVICE(0x9022, USB_PID_TEVII_S630)},
> +	[PROF_1100] = {USB_DEVICE(0x3011, USB_PID_PROF_1100)},
> +	[TEVII_S660] = {USB_DEVICE(0x9022, USB_PID_TEVII_S660)},
> +	[PROF_7500] = {USB_DEVICE(0x3034, 0x7500)},
> +	[GENIATECH_SU3000] = {USB_DEVICE(0x1f4d, 0x3000)},
> +	[TERRATEC_CINERGY_S2] = {USB_DEVICE(USB_VID_TERRATEC, 0x00a8)},
> +	[TEVII_S480_1] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_1)},
> +	[TEVII_S480_2] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_2)},
> +	[X3M_SPC1400HD] = {USB_DEVICE(0x1f4d, 0x3100)},
>  	{ }
>  };
>  
> @@ -1610,15 +1628,15 @@ static struct dvb_usb_device_properties dw2102_properties = {
>  	.num_device_descs = 3,
>  	.devices = {
>  		{"DVBWorld DVB-S 2102 USB2.0",
> -			{&dw2102_table[0], NULL},
> +			{&dw2102_table[CYPRESS_DW2102], NULL},
>  			{NULL},
>  		},
>  		{"DVBWorld DVB-S 2101 USB2.0",
> -			{&dw2102_table[1], NULL},
> +			{&dw2102_table[CYPRESS_DW2101], NULL},
>  			{NULL},
>  		},
>  		{"TerraTec Cinergy S USB",
> -			{&dw2102_table[4], NULL},
> +			{&dw2102_table[TERRATEC_CINERGY_S], NULL},
>  			{NULL},
>  		},
>  	}
> @@ -1664,11 +1682,11 @@ static struct dvb_usb_device_properties dw2104_properties = {
>  	.num_device_descs = 2,
>  	.devices = {
>  		{ "DVBWorld DW2104 USB2.0",
> -			{&dw2102_table[2], NULL},
> +			{&dw2102_table[CYPRESS_DW2104], NULL},
>  			{NULL},
>  		},
>  		{ "TeVii S650 USB2.0",
> -			{&dw2102_table[3], NULL},
> +			{&dw2102_table[TEVII_S650], NULL},
>  			{NULL},
>  		},
>  	}
> @@ -1715,7 +1733,7 @@ static struct dvb_usb_device_properties dw3101_properties = {
>  	.num_device_descs = 1,
>  	.devices = {
>  		{ "DVBWorld DVB-C 3101 USB2.0",
> -			{&dw2102_table[5], NULL},
> +			{&dw2102_table[CYPRESS_DW3101], NULL},
>  			{NULL},
>  		},
>  	}
> @@ -1761,7 +1779,7 @@ static struct dvb_usb_device_properties s6x0_properties = {
>  	.num_device_descs = 1,
>  	.devices = {
>  		{"TeVii S630 USB",
> -			{&dw2102_table[6], NULL},
> +			{&dw2102_table[TEVII_S630], NULL},
>  			{NULL},
>  		},
>  	}
> @@ -1770,33 +1788,33 @@ static struct dvb_usb_device_properties s6x0_properties = {
>  struct dvb_usb_device_properties *p1100;
>  static struct dvb_usb_device_description d1100 = {
>  	"Prof 1100 USB ",
> -	{&dw2102_table[7], NULL},
> +	{&dw2102_table[PROF_1100], NULL},
>  	{NULL},
>  };
>  
>  struct dvb_usb_device_properties *s660;
>  static struct dvb_usb_device_description d660 = {
>  	"TeVii S660 USB",
> -	{&dw2102_table[8], NULL},
> +	{&dw2102_table[TEVII_S660], NULL},
>  	{NULL},
>  };
>  
>  static struct dvb_usb_device_description d480_1 = {
>  	"TeVii S480.1 USB",
> -	{&dw2102_table[12], NULL},
> +	{&dw2102_table[TEVII_S480_1], NULL},
>  	{NULL},
>  };
>  
>  static struct dvb_usb_device_description d480_2 = {
>  	"TeVii S480.2 USB",
> -	{&dw2102_table[13], NULL},
> +	{&dw2102_table[TEVII_S480_2], NULL},
>  	{NULL},
>  };
>  
>  struct dvb_usb_device_properties *p7500;
>  static struct dvb_usb_device_description d7500 = {
>  	"Prof 7500 USB DVB-S2",
> -	{&dw2102_table[9], NULL},
> +	{&dw2102_table[PROF_7500], NULL},
>  	{NULL},
>  };
>  
> @@ -1842,15 +1860,15 @@ static struct dvb_usb_device_properties su3000_properties = {
>  	.num_device_descs = 3,
>  	.devices = {
>  		{ "SU3000HD DVB-S USB2.0",
> -			{ &dw2102_table[10], NULL },
> +			{ &dw2102_table[GENIATECH_SU3000], NULL },
>  			{ NULL },
>  		},
>  		{ "Terratec Cinergy S2 USB HD",
> -			{ &dw2102_table[11], NULL },
> +			{ &dw2102_table[TERRATEC_CINERGY_S2], NULL },
>  			{ NULL },
>  		},
>  		{ "X3M TV SPC1400HD PCI",
> -			{ &dw2102_table[14], NULL },
> +			{ &dw2102_table[X3M_SPC1400HD], NULL },
>  			{ NULL },
>  		},
>  	}


This looks like a good idea to me. From time to time, when conflict rises,
sometimes those dvb-usb tables with the magic numbers got unnoticed
conflicts.

So, I'm picking this one.

It should be noticed that this is a common constructor used inside the
dvb-usb drivers. IMHO, an approach like that should be extended to the
other drivers as well.

Regards,
Mauro
