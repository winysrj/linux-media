Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:14214 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZDGMjB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 08:39:01 -0400
Subject: Re: Topro 6800 webcam driver
From: Alexey Klimov <klimov.linux@gmail.com>
To: Andrey Panin <pazke@donpac.ru>
Cc: Anders Blomdell <anders.blomdell@control.lth.se>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org
In-Reply-To: <20090407111331.GA6618@ports.donpac.ru>
References: <49DB1FCC.4010902@control.lth.se>
	 <20090407111331.GA6618@ports.donpac.ru>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 16:39:01 +0400
Message-Id: <1239107942.23489.23.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-04-07 at 15:13 +0400, Andrey Panin wrote:
> On 097, 04 07, 2009 at 11:41:32AM +0200, Anders Blomdell wrote:

<snip>


> > +static const struct sd_desc sd_desc = {
> > +	.name = MODULE_NAME,
> > +	.ctrls = sd_ctrls,
> > +	.nctrls = ARRAY_SIZE(sd_ctrls),
> > +	.config = sd_config,
> > +	.init = sd_init,
> > +	.start = sd_start,
> > +	.stopN = sd_stopN,
> > +	.pkt_scan = sd_pkt_scan,
> > +	.querymenu = sd_querymenu,
> > +
> > +};
> > +
> > +static const __devinitdata struct usb_device_id device_table[] = {
> > +	{USB_DEVICE(0x06a2, 0x0003)},
> > +	{}			/* Terminating entry */
> > +};
> > +
> > +MODULE_DEVICE_TABLE(usb, device_table);
> > +
> > +static int sd_probe(struct usb_interface *interface,
> > +		    const struct usb_device_id *id)
> > +{
> > +	return gspca_dev_probe(interface, id, &sd_desc, sizeof(struct sd),
> > +			       THIS_MODULE);
> > +}
> > +
> > +static struct usb_driver tp6800_driver = {
> > +	.name = MODULE_NAME,
> > +	.id_table = device_table,
> > +	.probe = sd_probe,
> > +	.disconnect = gspca_disconnect,
> > +#ifdef CONFIG_PM
> > +	.suspend = gspca_suspend,
> > +	.resume = gspca_resume,
> > +#endif
> > +};
> > +
> > +/* Module loading and unloading */
> > +
> > +static int __init tp6800_init(void)
> > +{
> > +	int result;
> > +
> > +	result = usb_register(&tp6800_driver);
> > +	if (result) {
> > +		printk(KERN_INFO "%s usb_register_failed %d\n",
> > +		       MODULE_NAME, result);
> > +	} else {
> > +		printk(KERN_INFO "%s registered\n", MODULE_NAME);
> > +	}
> > +
> > +	return result;
> > +}
> > +
> > +static void __exit tp6800_exit(void)
> > +{
> > +	usb_deregister(&tp6800_driver);
> > +	printk(KERN_INFO "%s deregistered\n", MODULE_NAME);
> > +}
> 
> Are these registered/deregistered messages really useful ?

Looks like that gspca-framework use PDEBUG() messages for that.
For example, t613.c contains this:

static void __exit sd_mod_exit(void)
{
        usb_deregister(&sd_driver);
        PDEBUG(D_PROBE, "deregistered");
}


-- 
Best regards, Klimov Alexey

