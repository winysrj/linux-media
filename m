Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55895 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1JPMYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Oct 2011 08:24:06 -0400
Received: by bkbzt19 with SMTP id zt19so2333830bkb.19
        for <linux-media@vger.kernel.org>; Sun, 16 Oct 2011 05:24:04 -0700 (PDT)
Date: Sun, 16 Oct 2011 14:23:59 +0200
From: Julian Andres Klode <jak@jak-linux.org>
To: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	devel@driverdev.osuosl.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/7] staging/as102: cleanup - formatting code
Message-ID: <20111016122359.GA19023@jak-linux.org>
References: <4E7F1FB5.5030803@gmail.com>
 <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
 <4E7FF0A0.7060004@gmail.com>
 <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
 <20110927094409.7a5fcd5a@stein>
 <20110927174307.GD24197@suse.de>
 <20110927213300.6893677a@stein>
 <4E9992F9.7000101@poczta.onet.pl>
 <4E99F313.4050103@poczta.onet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E99F313.4050103@poczta.onet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 15, 2011 at 10:54:43PM +0200, Piotr Chmura wrote:
> staging as102: cleanup - formatting code
> 
> Cleanup code: change double spaces into single, put tabs instead of spaces where they should be.
> 
> Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
> Cc: Devin Heitmueller<dheitmueller@kernellabs.com>
> Cc: Greg HK<gregkh@suse.de>

Just a few hints from my side. Most of my comments apply to multiple other parts
of the code, but I did not want to quote everything and you should be able to
find the other parts I did not mention explicitely as well.

I don't have much knowledge of kernel code style, but wanted to point out a few
things that seem to be obviously wrong or uncommon, and stuff I wouldn't do. There
may be a few false positives and some things missing.

[And yes, I actually only wanted to comment on the two-space thing, but I somehow
ended up reading the complete patch or the first half of it].

> 
> diff -Nur linux.as102.03-typedefs/drivers/staging/as102/as102_drv.c linux.as102.04-tabs/drivers/staging/as102/as102_drv.c
> --- linux.as102.03-typedefs/drivers/staging/as102/as102_drv.c	2011-10-14 17:55:02.000000000 +0200
> +++ linux.as102.04-tabs/drivers/staging/as102/as102_drv.c	2011-10-14 23:20:05.000000000 +0200
> @@ -10,7 +10,7 @@
>   *
>   * This program is distributed in the hope that it will be useful,
>   * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>   * GNU General Public License for more details.
>   *
>   * You should have received a copy of the GNU General Public License

For reference, the standard variant uses two spaces after the period (aka
English Spacing).

> -failed:
> +	failed:
>  	LEAVE();
>  	/* FIXME: free dvb_XXX */
>  	return ret;

It's more common to have no indentation before labels (about
7 times more common).

> @@ -332,7 +332,7 @@
> 
>  /**
>   * \brief as102 driver exit point. This function is called when device has
> - *       to be removed.
> + *		to be removed.
>   */

Does it make sense to reindent that? If you intent to keep API documentation
comments, you want to convert them to kernel-doc style anyway.

>  	dprintk(debug, "min_delay_ms = %d ->  %d\n", settings->min_delay_ms,
> -		1000);
> +			1000);
>  #endif

Seems to be more indentation than really required.

> @@ -201,7 +201,7 @@
>  		break;
>  	case TUNE_STATUS_STREAM_TUNED:
>  		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC |
> -			FE_HAS_LOCK;
> +		FE_HAS_LOCK;
>  		break;

I think it looks better with indentation here. Otherwise you might not
read the | at the end of the previous line and think FE_HAS_LOCK is
a strange macro evaluating to a function call. Moving the operator
into the second line would also make this even more clear.

>  #else
> -	.release		= as102_fe_release,
> -	.init			= as102_fe_init,
> +		.release		= as102_fe_release,
> +		.init			= as102_fe_init,
>  #endif
>  };

Is there a reason why struct members are indented using
two tabs (here and elsewhere)?

> 
> @@ -393,7 +393,7 @@
>  }
> 
>  int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
> -			  struct dvb_frontend *dvb_fe)
> +		struct dvb_frontend *dvb_fe)
>  {

If there's still space to align further to the right, why not
use it? It makes the code look better if parameters are aligned
below each other (or at least nearly).

>  	int errno;
>  	struct dvb_adapter *dvb_adap;
> @@ -407,7 +407,7 @@
>  	/* init frontend callback ops */
>  	memcpy(&dvb_fe->ops,&as102_fe_ops, sizeof(struct dvb_frontend_ops));
>  	strncpy(dvb_fe->ops.info.name, as102_dev->name,
> -		sizeof(dvb_fe->ops.info.name));
> +			sizeof(dvb_fe->ops.info.name));
> 

It does not seem helpful to align like this, it certainly looks
much uglier than the old one which had sizeof aligned with dvb.

>  	/* set frequency */
> @@ -642,32 +642,32 @@
>  	 * if HP/LP are both set to FEC_NONE, HP will be selected.
>  	 */
>  	if ((tune_args->hierarchy != HIER_NONE)&&

Misses a space before the &&

>  		dprintk(debug, "\thierarchy: 0x%02x  "
>  				"selected: %s  code_rate_%s: 0x%02x\n",
> -			tune_args->hierarchy,
> -			tune_args->hier_select == HIER_HIGH_PRIORITY ?
> -			"HP" : "LP",
> -			tune_args->hier_select == HIER_HIGH_PRIORITY ?
> -			"HP" : "LP",
> -			tune_args->code_rate);
> +				tune_args->hierarchy,
> +				tune_args->hier_select == HIER_HIGH_PRIORITY ?
> +						"HP" : "LP",
> +						tune_args->hier_select == HIER_HIGH_PRIORITY ?
> +								"HP" : "LP",
> +								tune_args->code_rate);

You indented the second argument one level further than the
first one. And the third argument even more.

>  			errno = bus_adap->ops->upload_fw_pkt(bus_adap,
> -							     (uint8_t *)
> -							&fw_pkt, 2, 0);
> +					(uint8_t *)
> +					&fw_pkt, 2, 0);

Splitting after the "&fw_pkt," seems more sensible, as you have the
cast and its operand on the same line then.

> 
>  static int as102_usb_start_stream(struct as102_dev_t *dev);
>  static void as102_usb_stop_stream(struct as102_dev_t *dev);
> @@ -38,59 +38,59 @@
>  static int as102_release(struct inode *inode, struct file *file);
> 
>  static struct usb_device_id as102_usb_id_table[] = {
> -	{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
> -	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
> -	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
> -	{ USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID) },
> -	{ } /* Terminating entry */
> +		{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
> +		{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
> +		{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
> +		{ USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID) },
> +		{ } /* Terminating entry */
>  };

Again, two levels of indentation do not add anything valuable.

> 
>  /* Note that this table must always have the same number of entries as the
> -   as102_usb_id_table struct */
> +	as102_usb_id_table struct */
>  static const char *as102_device_names[] = {
> -	AS102_REFERENCE_DESIGN,
> -	AS102_PCTV_74E,
> -	AS102_ELGATO_EYETV_DTT_NAME,
> -	AS102_NBOX_DVBT_DONGLE_NAME,
> -	NULL /* Terminating entry */
> +		AS102_REFERENCE_DESIGN,
> +		AS102_PCTV_74E,
> +		AS102_ELGATO_EYETV_DTT_NAME,
> +		AS102_NBOX_DVBT_DONGLE_NAME,
> +		NULL /* Terminating entry */
>  };

Same here and at a lot of other locations.

[I stopped here]


-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.
