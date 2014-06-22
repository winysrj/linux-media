Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:38008 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaFVVbc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jun 2014 17:31:32 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N7L00DAWAGIQS30@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 22 Jun 2014 17:31:30 -0400 (EDT)
Date: Sun, 22 Jun 2014 18:31:25 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Best way to add subdev that doesn't use I2C or SPI?
Message-id: <20140622183125.73518922.m.chehab@samsung.com>
In-reply-to: <53A4F2EA.6070600@iki.fi>
References: <CAGoCfiyeHbYYTSYY_VPEXJ4z8668w6LdjprW1+FbMJCOoCekwA@mail.gmail.com>
 <53A4F2EA.6070600@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 21 Jun 2014 05:50:18 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Moikka Devin
> 
> On 06/21/2014 04:58 AM, Devin Heitmueller wrote:
> > Hello,
> >
> > I'm in the process of adding support for a new video decoder.  However
> > in this case it's an IP block on a USB bridge as opposed to the
> > typical case which is an I2C device.  Changing registers for the
> > subdev is the same mechanism as changing registers in the rest of the
> > bridge (a specific region of registers is allocated for the video
> > decoder).
> >
> > Doing a subdev driver seems like the logical approach to keep the
> > video decoder related routines separate from the rest of the bridge.
> > It also allows the reuse of the code if we find other cases where the
> > IP block is present in other devices.  However I'm not really sure
> > what the mechanics are for creating a subdev that isn't really an I2C
> > device.
> >
> > I think we've had similar cases with the Conexant parts where the Mako
> > was actually a block on the main bridge (i.e. cx23885/7/8, cx231xx).
> > But in that case the cx25840 subdev just issues I2C commands and
> > leverages the fact that you can talk to the parts over I2C even though
> > they're really on-chip.

Well, some IP designs use internally something similar to I2C. That's
the case of cx231xx, as far as I know.

> >
> > Are there any other cases today where we have a subdev that uses
> > traditional register access routines provided by the bridge driver to
> > read/write the video decoder registers?  In this case I would want to
> > reuse the register read/write routines provided by the bridge, which
> > ultimately are send as USB control messages.
> >
> > Any suggestions welcome (and in particular if you can point me to an
> > example case where this is already being done).
> >
> > Thanks in advance,
> >
> > Devin
> 
> Abuse I2C bus. If your integrated IP block is later sold as a separate 
> chip, there is likely I2C bus used then. If you now abuse I2C it could 
> be even possible that no changes at all is then needed or only small fixes.
> 
> I have done that few times, not for V4L2 sub-device, but on DVB side. 
> For example AF9015/AF9013 and AF9035/AF9033/IT913x.

If it is not I2C, we should not be faking it.

On V4L2 side, the subdev interface is enough to provide you abstraction
for that. The only thing that will be different is that the probing method
will be different. After probing a device, you'll keep using the V4L2
subdev methods to call the demod, like:

                v4l2_device_call_all(&v4l2->v4l2_dev,
                                     0, tuner, s_frequency, &f);

And so on.

On DVB side, the changes are bigger. Currently, most drivers only
need an init function, as they assume that everything will happen via
I2C. If they support hardware filtering, though, they actually violate
this model, with causes troubles with random Kconfig configurations
and may prevent to do a rmmod at the frontend.

Due to that, I'm starting to do some changes like the subdev API
at the DVB side too. Take a look at my recent patches for dib8000
and dib7000p:
	http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=8abe4a0a3f6d4217b16a1a3f68cd5c72ab5a058e
	http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=d44913c1e547df19b2dc0b527f92a4b4354be23a

There are actually two small patches preceding them, that just renames
the frontend_attach functions:
	http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=7f67d96ab181aff4af2074ba0a56b3f81333e896
	http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=b9bc7d59b72511f8a51e847aedc39f74bfc102a3

The main difference between V4L2 subdev and this model is that,
at DVB side, we don't have yet a well defined set of calls for
the demod hardware: I just added there whatever was already defined
at the Dibcom Drivers.

So, the new attach function are currently creating a per-demod
structure:

+void *dib8000_attach(struct dib8000_ops *ops)
+{
+ if (!ops)
+ return NULL;
+
+ ops->pwm_agc_reset = dib8000_pwm_agc_reset;
+ ops->get_dc_power = dib8090p_get_dc_power;
+ ops->set_gpio = dib8000_set_gpio;
+ ops->get_slave_frontend = dib8000_get_slave_frontend;
+ ops->set_tune_state = dib8000_set_tune_state;
+ ops->pid_filter_ctrl = dib8000_pid_filter_ctrl;
+ ops->remove_slave_frontend = dib8000_remove_slave_frontend;
+ ops->get_adc_power = dib8000_get_adc_power;
+ ops->update_pll = dib8000_update_pll;
+ ops->tuner_sleep = dib8096p_tuner_sleep;
+ ops->get_tune_state = dib8000_get_tune_state;
+ ops->get_i2c_tuner = dib8096p_get_i2c_tuner;
+ ops->set_slave_frontend = dib8000_set_slave_frontend;
+ ops->pid_filter = dib8000_pid_filter;
+ ops->ctrl_timf = dib8000_ctrl_timf;
+ ops->init = dib8000_init;
+ ops->get_i2c_master = dib8000_get_i2c_master;
+ ops->i2c_enumeration = dib8000_i2c_enumeration;
+ ops->set_wbd_ref = dib8000_set_wbd_ref;
+
+ return ops;
+}
+EXPORT_SYMBOL(dib8000_attach);


Some of the above functions are clearly DibCom-specific ones, but
some of them should likely belong on a DVB kind of subdev, like

	ops->init		- initializes the frontend (similar to what
				  attach makes on most frontends);
	ops->pid_filter		- sets the hardware PID filters;
	ops->set_gpio		- sets demod GPIOs;
	ops->tuner_sleep	- To be generic enough, this should
				  be converted into something better
				  in order to control the power state
				  of the device.

When I have some spare time, my plan is to convert the entire
dib0700 to use this model, and start working on a generic subdev
interface for DVB.

Regards,
Mauro
