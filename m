Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:30175 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759170Ab3JORMJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 13:12:09 -0400
Date: Tue, 15 Oct 2013 19:11:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: cannot ret error from probe - switch tuner to I2C driver model
Message-ID: <20131015191158.287fa715@endymion.delvare>
In-Reply-To: <525D5BA3.5080406@iki.fi>
References: <1381709450-14345-1-git-send-email-crope@iki.fi>
	<525B577D.2050105@iki.fi>
	<525D5BA3.5080406@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

The driver's .probe() after i2c_new_device() is simply not supposed to
fail. You should only use i2c_new_device() if you are 100% sure that
there is a device of the given type at the given address. Checking
i2c_get_clientdata() is an ugly trick that you should no longer need to
use.

i2c_driver.detect() is used for fully auto-detectable, standalone
devices. Mostly hardware monitoring chips fall into this category. You
should never use that mechanism for video chips, and as a matter of
fact, I2C_CLASS_* flags for analog and digital TV were killed years
ago. To make it clearer: for everything TV/video related, only .probe()
and .remove() are relevant, .detect() is not.

I think you simply want to use i2c_new_probed_device() instead of
i2c_new_device(), so that the i2c client is only instantiated if the
right device is present at the address. In the case where different
chips could be present and you have to differentiate between then, you
can provide a custom detection callback to i2c_new_probed_device(), and
have it return -ENODEV if the right device isn't found. If you don't
provide a custom detection callback, the default one is used
(i2c_probe_func_quick_read in i2c-core.c), that only checks for any
device's presence at a specified address.

Hope that clarifies,
Jean

On Tue, 15 Oct 2013 18:13:39 +0300, Antti Palosaari wrote:
> Jean
> could you look that and comment how I should implement it properly.
> I saw you also added i2c_new_probed_device() [1] that these TV drivers 
> could be ported properly I2C model.
> 
> [1] http://lists.lm-sensors.org/pipermail/i2c/2007-March/000990.html
> 
> I am pretty sure I have looked and tested all the I2C pieces quite 
> carefully. There is .detect() callback which looks just what I need, but 
> unfortunately it is nor called in case of i2c_new_probed_device() and 
> i2c_new_device().
> 
> 
> 
> On 14.10.2013 05:31, Antti Palosaari wrote:
> > On 14.10.2013 03:10, Antti Palosaari wrote:
> >> kernel: usb 1-2: rtl2832u_tuner_attach:
> >> kernel: e4000 5-0064: e4000_probe:
> >> kernel: usb 1-2: rtl2832u_tuner_attach: client ptr ffff88030a849000
> >>
> >> See attached patch.
> >>
> >> Is there any way to return error to caller?
> >>
> >> Abuse platform data ptr from struct i2c_board_info and call
> >> i2c_unregister_device() ?
> >
> > Answer to myself: best option seems to be check i2c_get_clientdata()
> > pointer after i2c_new_device().
> >
> > client = i2c_new_device(&d->i2c_adap, &info);
> > if (client)
> >      if (i2c_get_clientdata(client) == NULL)
> >          // OOPS, I2C probe fails
> >
> > That is because it is set NULL in error case by really_probe() in
> > drivers/base/dd.c. Error status is also cleared there with comment:
> > /*
> >   * Ignore errors returned by ->probe so that the next driver can try
> >   * its luck.
> >   */
> >
> > That is told in I2C documentation too:
> > Note that starting with kernel 2.6.34, you don't have to set the `data'
> > field
> > to NULL in remove() or if probe() failed anymore. The i2c-core does this
> > automatically on these occasions. Those are also the only times the core
> > will
> > touch this field.
> >
> >
> >
> > But maybe the comment for actual function, i2c_new_device, is still a
> > bit misleading as it says NULL is returned for the error. All the other
> > errors yes, but not for the I2C .probe() as it is reseted by device core.
> >
> > * This returns the new i2c client, which may be saved for later use with
> >   * i2c_unregister_device(); or NULL to indicate an error.
> >   */
> > struct i2c_client *
> > i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
> >
> >
> > regards
> > Antti
> >
> >
> >>
> >> regards
> >> Antti
> >>
> >> ---
> >>   drivers/media/tuners/e4000.c            | 31
> >> +++++++++++++++++++++++++++++++
> >>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 18 ++++++++++++++++--
> >>   2 files changed, 47 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
> >> index 54e2d8a..f4e0567 100644
> >> --- a/drivers/media/tuners/e4000.c
> >> +++ b/drivers/media/tuners/e4000.c
> >> @@ -442,6 +442,37 @@ err:
> >>   }
> >>   EXPORT_SYMBOL(e4000_attach);
> >>
> >> +static int e4000_probe(struct i2c_client *client, const struct
> >> i2c_device_id *did)
> >> +{
> >> +    dev_info(&client->dev, "%s:\n", __func__);
> >> +    return -ENODEV;
> >> +}
> >> +
> >> +static int e4000_remove(struct i2c_client *client)
> >> +{
> >> +    dev_info(&client->dev, "%s:\n", __func__);
> >> +    return 0;
> >> +}
> >> +
> >> +static const struct i2c_device_id e4000_id[] = {
> >> +    {"e4000", 0},
> >> +    {}
> >> +};
> >> +
> >> +MODULE_DEVICE_TABLE(i2c, e4000_id);
> >> +
> >> +static struct i2c_driver e4000_driver = {
> >> +    .driver = {
> >> +        .owner    = THIS_MODULE,
> >> +        .name    = "e4000",
> >> +    },
> >> +    .probe        = e4000_probe,
> >> +    .remove        = e4000_remove,
> >> +    .id_table    = e4000_id,
> >> +};
> >> +
> >> +module_i2c_driver(e4000_driver);
> >> +
> >>   MODULE_DESCRIPTION("Elonics E4000 silicon tuner driver");
> >>   MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
> >>   MODULE_LICENSE("GPL");
> >> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> >> b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> >> index defc491..fbbe867 100644
> >> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> >> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> >> @@ -898,8 +898,22 @@ static int rtl2832u_tuner_attach(struct
> >> dvb_usb_adapter *adap)
> >>                   adap->fe[0]->ops.tuner_ops.get_rf_strength;
> >>           return 0;
> >>       case TUNER_RTL2832_E4000:
> >> -        fe = dvb_attach(e4000_attach, adap->fe[0], &d->i2c_adap,
> >> -                &rtl2832u_e4000_config);
> >> +//        fe = dvb_attach(e4000_attach, adap->fe[0], &d->i2c_adap,
> >> +//                &rtl2832u_e4000_config);
> >> +        {
> >> +            static const struct i2c_board_info info = {
> >> +                .type = "e4000",
> >> +                .addr = 0x64,
> >> +            };
> >> +            struct i2c_client *client;
> >> +
> >> +            fe = NULL;
> >> +            client = i2c_new_device(&d->i2c_adap, &info);
> >> +            if (IS_ERR_OR_NULL(client))
> >> +                dev_err(&d->udev->dev, "e4000 probe failed\n");
> >> +
> >> +            dev_dbg(&d->udev->dev, "%s: client ptr %p\n", __func__,
> >> client);
> >> +        }
> >>           break;
> >>       case TUNER_RTL2832_FC2580:
> >>           fe = dvb_attach(fc2580_attach, adap->fe[0], &d->i2c_adap,
> >>
