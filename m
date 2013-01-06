Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55198 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3AFUfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2013 15:35:38 -0500
Received: by mail-ee0-f50.google.com with SMTP id b45so9186416eek.37
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 12:35:37 -0800 (PST)
Message-ID: <1357504527.7859.12.camel@canaries64>
Subject: Re: [PATCH] ts2020: call get_rf_strength from frontend
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Date: Sun, 06 Jan 2013 20:35:27 +0000
In-Reply-To: <50E9C647.4090301@iki.fi>
References: <1357476042.16016.8.camel@canaries64> <50E97E05.1090607@iki.fi>
	 <1357496042.4129.26.camel@canaries64> <50E9C647.4090301@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2013-01-06 at 20:45 +0200, Antti Palosaari wrote:
> On 01/06/2013 08:14 PM, Malcolm Priestley wrote:
> > On Sun, 2013-01-06 at 15:37 +0200, Antti Palosaari wrote:
> >> On 01/06/2013 02:40 PM, Malcolm Priestley wrote:
> >>> Restore ds3000.c read_signal_strength.
> >>>
> >>> Call tuner get_rf_strength from frontend read_signal_strength.
> >>>
> >>> We are able to do a NULL check and doesn't limit the tuner
> >>> attach to the frontend attach area.
> >>>
> >>> At the moment the lmedm04 tuner attach is stuck in frontend
> >>> attach area.
> >>
> >> I would like to nack that, as I see some problems:
> >> 1) it changes deviation against normal procedures
> >> 2) interface driver (usb/pci) should have full control to make decision
> >> 3) you shoot to our own leg easily in power management
> >>
> > This patch does not do any operational changes, and is a proper way to
> > call to another module with a run time NULL check. The same way as
> > another tuner function from demodulator is called.
> 
> uh, certainly I understand it does not change functionality in that 
> case! I tried to point out it is logically insane and error proof. Ee 
> should make this kind of direct calls between drivers as less as 
> possible - just to make life easier in future. It could work for you, 
> but for some other it could cause problems as hardware is designed 
> differently.
> 
> >> * actually bug 3) already happened some drivers, like rtl28xxu. Tuner is
> >> behind demod and demod is put sleep => no access to tuner. FE callback
> >> is overridden (just like you are trying to do as default) which means
> >> user-space could still make queries => I/O errors.
> >
> > In such cases, the tuner init/sleep should also be called.
> 
> ???????
> I think you don't understand functionality at all!
> 
Please, I have been working with the I2C bus in the electronics field
for the last 20 years.

If you are really worried about the the tuner being a sleep. You add
fe variable check this in it's own init/sleep and define the function
something like this.

static int fe_foo_read_signal_strength(struct dvb_frontend *fe,
	u16 *strength)
{
	struct fe_foo_state *state = fe->demodulator_priv;

	if (state->fe_inactive) {
... any extra commands to restore tuner power
		if (fe->ops.tuner_ops.init)
			fe->ops.tuner_ops.init(fe);
			
	}		

	if (fe->ops.tuner_ops.get_rf_strength)
		fe->ops.tuner_ops.get_rf_strength(fe, strength);

	if (state->fe_inactive) {
		if (fe->ops.tuner_ops.sleep)
			fe->ops.tuner_ops.sleep(fe);
... any extra commands to remove tuner power
	}

	return 0;
}

However, I think this is unnecessary in the rs2000 and ds3000.

Regards


Malcolm








