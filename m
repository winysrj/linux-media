Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:34587 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377Ab2KMRf5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 12:35:57 -0500
Date: Tue, 13 Nov 2012 18:35:38 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [PATCH 1/5] [media] dvb-usb: add a pre_init hook to struct
 dvb_usb_device_properties
Message-Id: <20121113183538.0ad7f5d574e449b90583c3fe@studenti.unina.it>
In-Reply-To: <509854B7.40606@iki.fi>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
	<1352158096-17737-2-git-send-email-ospite@studenti.unina.it>
	<509854B7.40606@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 06 Nov 2012 02:07:19 +0200
Antti Palosaari <crope@iki.fi> wrote:

> On 11/06/2012 01:28 AM, Antonio Ospite wrote:
> > Some devices need to issue a pre-initialization command sequence via
> > i2c in order to "enable" the communication with some adapter components.
> >
> > This happens for instance in the vp7049 USB DVB-T stick on which the
> > frontend cannot be detected without first sending a certain sequence of
> > commands via i2c.
> 
> I looked patch 3 and it is not I2C communication but direct M9206 memory 
> access you did. I could guess it is GPIO sequence to reset & power demod 
> and tuner. Due to that, correct place for this kind of initialization is 
> inside demod and tuner attach.
>

You are right it's not I2C, it's just usb communication with the bridge,
sorry.

An approach like the following would work for me, but it is rather dirty.

 /* Callbacks for DVB USB */
 static int m920x_mt352_frontend_attach(struct dvb_usb_adapter *adap)
 {
        deb("%s\n",__func__);

+       if (strncmp(adap->dev->desc->name, "DTV-DVB UDTT7049",
+                   strlen(adap->dev->desc->name)) == 0) {
+               int ret = vp7049_pre_init(adap->dev);
+               if (ret < 0)
+                       return ret;
+       }
+
        adap->fe_adap[0].fe = dvb_attach(mt352_attach,
                                         &m920x_mt352_config,
                                         &adap->dev->i2c_adap);


>From a semantic point of view doing it in fe attach looks strange tho,
because the communication itself is strictly with the bridge (m920x) and
not with the frontend (mt352), even if the frontend is affected in this
case.

To me it still looks like something to do in dvb_usb_init() _before_
dvb_usb_adapter_init(), can you please help me understand better your
point of view?

> With a USB power meter, some trial & error testing, and maybe fw disasm 
> you could even detect those GPIOS :)
>

I don't have the equipment, and maybe I don't have the disassembling
skills either, I might try to isolate the minimum required sequence by
commenting in and out register changes but I feel more confident with
sending the sequence just like it was captured from the windows driver.

> > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> > ---
> >
> > If this approach is OK I can send a similar patch for dvb-usb-v2.
> 
> There is already such callbacks - but no callback between I2C init and 
> FE attach. There is read_config() which is called first, good place to 
> make probing device and detect hw config. Another new callback is 
> .init() which is called after demod and tuner attach. Stuff like USB 
> interface config should remain here. On USB power management case 
> reset_resume() that function is called too in order re-configure reseted 
> USB IF.
> 
> I don't see need yet another new callback.
>

OK, after I solve the issue on dvb-usb in a way you like it, I'll have a
clearer picture of how this will have to be solved in dvb-usb-v2 too.

> > Are all the dvb-usb drivers going to be ported to dvb-usb-v2 eventually?
> 
> There is still quite many drivers to convert, so maybe it is not happen 
> anytime soon or even later. Feel free to convert that driver. For bonus 
> you will get for example power-management support for free.
> 

Good to know about the power management, but it's unlikely I can work on
porting the driver to dvb-usb-v2.

Regards,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
