Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <scachi@gmx.de>) id 1KJtKH-0003SF-SZ
	for linux-dvb@linuxtv.org; Fri, 18 Jul 2008 19:01:02 +0200
Date: Fri, 18 Jul 2008 19:00:26 +0200
From: Ingo Arndt <scachi@gmx.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080718190026.7280f266@chicken.squirrel.local>
In-Reply-To: <Pine.LNX.4.61.0807140928510.18200@susik.kapsa.cz>
References: <mailman.1.1216017558.829.linux-dvb@linuxtv.org>
	<Pine.LNX.4.61.0807140928510.18200@susik.kapsa.cz>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Pinnacle PCTV Dual DVB-T Diversity Stick built in
 IR-Receiver supported ?
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

On Mon, 14 Jul 2008 10:19:00 +0200 (CEST)
Tomas Blaha <tomasb@kapsa.cz> wrote:

> Hello,
> 
> I would like working remote too, but what I see from source code the 
> remote is not supported. There is
> 
>    struct dvb_usb_device_properties dib0700_devices[]
> 
> in dib0700_devices.c which lists abilities of devices and for this adapter 
> and "DiBcom STK7070PD reference design" there is no RC support. I even try 
> to enable the support as it is enabled on other devices from the same ,
> family, but without luck. Drivers queryed the adapter for a RC keypress 
> afaik correctly, but only zeros were returned from the device.

Same here... any hints where to look at ( functions, files) for 
getting the ir receiver/remote control to work ?


As noted above by Tomas Blaha, I have enabled the support as on other
devices from the same family: "
.rc_interval      = DEFAULT_RC_INTERVAL,
		.rc_key_map       = dib0700_rc_keys,
		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
		.rc_query         = dib0700_rc_query
"
and on dvb-t stick init dmesg tells now: "input: IR-receiver inside an USB
DVB receiver as /class/input/input21"
But I don't even know if this is a step forward or doesn't mean anything at all
as the receiver may still be uninitialized ?

It is getting queryed but the function dib0700_rc_query seems to return on:
/* losing half of KEY_0 events from Philipps rc5 remotes.. */
	if (key[0]==0 && key[1]==0 && key[2]==0 && key[3]==0) return 0;

The remote seems to be the "tiny Pinnacle remote" in the code, it has 
all its keys and is tiny.

Heres some more dmesg output:

dvb-usb: found a 'Pinnacle PCTV Dual DVB-T Diversity Stick' in cold state, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Pinnacle PCTV Dual DVB-T Diversity Stick' in warm state.
power control: 1
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)
DiB7000P: checking demod on I2C address: 130 (82)
ep 0 read error (status = -32)
I2C read failed on address 41
DiB7000P: i2c read error on 768
DiB7000P: wrong Vendor ID (read=0x0)
DiB7000P: checking demod on I2C address: 18 (12)
DiB7000P: setting output mode for demod ffff8100dfb714c8 to 4
DiB7000P: IC 1 initialized (to i2c_address 0x82)
DiB7000P: checking demod on I2C address: 128 (80)
ep 0 read error (status = -32)
I2C read failed on address 40
DiB7000P: i2c read error on 768
DiB7000P: wrong Vendor ID (read=0x100)
DiB7000P: checking demod on I2C address: 18 (12)
DiB7000P: setting output mode for demod ffff8100dfb714c8 to 4
DiB7000P: IC 0 initialized (to i2c_address 0x80)
DiB7000P: setting output mode for demod ffff8100dfb714c8 to 0
DiB7000P: setting output mode for demod ffff8100dfb714c8 to 0
DiB7000P: checking demod on I2C address: 128 (80)
DiB7000P: gpio dir: ffff: val: 0, pwm_pos: ffff
DiB7000P: setting output mode for demod ffff810112326800 to 0
DiB7000P: using default timf
DVB: registering frontend 0 (DiBcom 7000PC)...
DiB0070: Revision: 3
DiB0070: CTRL_LO5: 0x16a4
DiB0070: WBDStart = 314 (Vargen) - FF = 391
DiB0070: successfully identified
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)
DiB7000P: checking demod on I2C address: 130 (82)
DiB7000P: gpio dir: ffff: val: 0, pwm_pos: ffff
DiB7000P: setting output mode for demod ffff81011907d000 to 0
DiB7000P: using default timf
DVB: registering frontend 1 (DiBcom 7000PC)...
DiB0070: Revision: 3
DiB0070: CTRL_LO5: 0x16a4
DiB0070: WBDStart = 425 (Vargen) - FF = 528
DiB0070: successfully identified
input: IR-receiver inside an USB DVB receiver as /class/input/input21
dvb-usb: schedule remote query interval to 150 msecs.
power control: 0
dvb-usb: Pinnacle PCTV Dual DVB-T Diversity Stick successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700

-- 
Best regards,
Ingo Arndt

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
