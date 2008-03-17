Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+1cd71b2b73eff9a3aa1a+1667+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JbM72-0002ad-N5
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 21:39:16 +0100
Date: Mon, 17 Mar 2008 17:38:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
Message-ID: <20080317173822.76171cb9@gaivota>
In-Reply-To: <47DEC82C.8000609@h-i-s.nl>
References: <1203538678.8313.12.camel@srv-roden.vogelwikke.nl>
	<47BCAC32.9050601@h-i-s.nl> <47BCB371.2020809@h-i-s.nl>
	<20080227075056.34a80abd@areia> <47D462DD.5080500@h-i-s.nl>
	<20080312180321.6a6800a1@gaivota> <47DAED1E.4030002@h-i-s.nl>
	<20080315112427.6b6c55a4@gaivota> <47DC4C77.2020201@h-i-s.nl>
	<20080317115607.2b9984c9@gaivota> <47DEC82C.8000609@h-i-s.nl>
Mime-Version: 1.0
Cc: achasper@gmail.com, linux-dvb@linuxtv.org,
	stealth banana <stealth.banana@gmail.com>
Subject: Re: [linux-dvb] First patch for Freecom DVB-T (with RTL2831U,
	usb id 14aa:0160)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mon, 17 Mar 2008 20:36:12 +0100
Jan Hoogenraad <jan-conceptronic@h-i-s.nl> wrote:

> Mauro:
> 
> Most of the mail understood.
> 
> Can you put us into contact with the people who did the decoupling to 
> the tuner for for example, with saa711x ?
> We could re-use some of their work, and learn from them.

Several developers ;)

First of all, there are two different behaviors, userspace and kernelspace
API's being one for analog and another for digital. This is due to historic
reasons.

The decoupling is via I2C interface. Basically, each i2c driver is independent.
Kernel Documentation/i2c explains the usage of I2C.

In the case of tuner and saa711x, those are two independent drivers, used
(mostly) by analog mode.

tuner.ko module contains tuner-core.c. There are several other tuner drivers
that can be bound to tuner.ko or to a frontend driver.

On i2c normal way for analog TV, composite/svideo and FM, it probes I2C bus for
the presence of I2C devices by sending a read message with 0 bytes. If some
answer is given, this means that an I2C device is present there. When something
is detected, an attach callback is called. For example, attach_inform(), on
cx88-i2c. The attach_inform() then configures that device, if needed.

A newer method for probing is starting to be implemented, on ivtv driver.

Both tuner and saa711x implements a "command" interface. The command is meant
to receive requests for tuning and other things, like changing video
standard. All I2C devices listen to the I2C command. So, when you change a
video standard, tuner may set the proper IF, while saa711x can send the proper
initialization codes for that video standard.

In order to better support hybrid devices, tuner now is implemented on separate files.
tuner.ko is just the core, meant to be use by analog/svideo/composite or radio mode.

The tuner, itself, can work with both V4L and DVB API's. This is warranted by
the usage of callbacks.

For digital TV, there are several callbacks. In the case of a tuner, for
example xc2028, the driver fills an structure with the callbacks:

static const struct dvb_tuner_ops xc2028_dvb_tuner_ops = {
        .info = {
                 .name = "Xceive XC3028",
                 .frequency_min = 42000000,
                 .frequency_max = 864000000,
                 .frequency_step = 50000,
                 },

        .set_config        = xc2028_set_config,
        .set_analog_params = xc2028_set_analog_freq,
        .release           = xc2028_dvb_release,
        .get_frequency     = xc2028_get_frequency,
        .get_rf_strength   = xc2028_signal,
        .set_params        = xc2028_set_params,
        .sleep             = xc2028_sleep,

#if 0
        int (*get_bandwidth)(struct dvb_frontend *fe, u32 *bandwidth);
        int (*get_status)(struct dvb_frontend *fe, u32 *status);
#endif
};

The above struct contains both callbacks for analog and digital.

dvb core will call the proper callbacks when needed. For example, set_params
select the proper DVB mode, and tune to an specific frequency.

There are similar callbacks also for DVB frontend (a frontend is a tuner plus
a demod - and, for DVB-S, the LNBf control interface).

> A similar thing goes for the IR devices.
> Currently, these sticks are shipped with 3 different IR devices, with 
> different (and sometimes conflicting) IR codes.

IR scan tables can be inside drivers/media/common/ir-keymaps. The hanlding for
gpio RC5 is provided at ir-common.ko.

For I2C, there's a special module for handling this (ir_i2c_kbd). This is also
a generic module. The attach callback is used to setup the specific parameters
for each IR.

> I see that there are two different mechanisms used in the drivers.
> 
> The cxusb.c driver shows how to switch based on the USB ID of the stick.
> 
> The hauppage driver, with ir-kbd-i2c.c and ir-keymaps.c shosw how to 
> switch based on module parameters (mechanism similar to the debug=1).

The usage of module parameters should be used only when other mechanisms aren't
possible. The preferred way is to detect board characteristics via reading the
board eeprom, if available. Hauppauge detection is very good, for most things,
due to tveeprom.ko. There's a parser there to read their info inside the eeprom.

This saves a lot of space inside kernel to handle all differences between the boards.

If this is not possible, the next option is to use USB ID or PCI ID. However,
sometimes, unfortunately, a cheap board doesn't have an unique PCI ID. So, the
only way is to provide module options.

> Can you tell me if there is a roadmap for this (e.g. decoupling the 
> mapping from the stick ID and putting the rc_query subroutines together) ?

What do you mean?

> In the next patch, I'll add a file
> /linux/Documentation/dvb/README.rtl2831
> with some data I got from Realtek.

Good.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
