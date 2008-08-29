Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KYtu2-00038A-7L
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 04:40:00 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: "'Devin Heitmueller'" <devin.heitmueller@gmail.com>
References: <004f01c90921$248fe2b0$6dafa810$@com.au>	
	<412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>	
	<007f01c90965$344da360$9ce8ea20$@com.au>	
	<412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>	
	<008001c9096a$f315df10$d9419d30$@com.au>	
	<412bdbff0808281731t7641e4d1kf86058e071c7d5fb@mail.gmail.com>	
	<008101c90971$ca7e5080$5f7af180$@com.au>
	<412bdbff0808281905w1a76f8eald99de203fd0c18be@mail.gmail.com>
In-Reply-To: <412bdbff0808281905w1a76f8eald99de203fd0c18be@mail.gmail.com>
Date: Fri, 29 Aug 2008 10:40:28 +0800
Message-ID: <008201c90980$9b7ffd10$d27ff730$@com.au>
MIME-Version: 1.0
Content-Language: en-au
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge WinTV-NOVA-T-500 New Firmware
	(dvb-usb-dib0700-1.20.fw) causes problems
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

> Let's try this to rule out whether it's the new i2c interface or some
> other aspect of the 1.20 firmware:
> 
> Add the following line to the dib0700_devices.c at line 78:
> 
> st->fw_use_legacy_i2c_api = 1;
> 
> It should end up looking like:
> 
> =======
> static int bristol_frontend_attach(struct dvb_usb_adapter *adap)
> {
>         struct dib0700_state *st = adap->dev->priv;
> 
> 	st->fw_use_legacy_i2c_api = 1;
> 
>         if (adap->id == 0) {
> ....
> =======
> 
> That will tell it to fall back to the legacy i2c interface (which was
> working fine for you in the 1.10 firmware).
> 
> Make that change, reboot your system, and send me the dmesg output so
> we can see if you still get i2c errors.
> 
> Thanks,
> 
> Devin
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
Devin,

See output below.  Tuners are now working correctly with MythTV.

[   32.498881] dib0700: loaded with support for 7 different device-types
[   32.498961] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold
state, will try to load a firmware
--
[   32.537956] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
--
[   32.778909] dib0700: firmware started successfully.
[   33.281095] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm
state.
[   33.281127] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   33.281295] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   33.390157] DVB: registering frontend 0 (DiBcom 3000MC/P)...
[   33.448122] MT2060: successfully identified (IF1 = 1258)
[   33.923079] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   33.923271] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   33.928451] DVB: registering frontend 1 (DiBcom 3000MC/P)...
[   33.932949] MT2060: successfully identified (IF1 = 1255)
[   34.416827] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1e.0/0000:05:00.2/usb11/11-1/input/input6
[   34.444154] dvb-usb: schedule remote query interval to 150 msecs.
[   34.444157] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully
initialized and connected.
[   34.444269] usbcore: registered new interface driver dvb_usb_dib0700
--
FYI copy of code that I edited (dib0700_devices.c)

static int bristol_frontend_attach(struct dvb_usb_adapter *adap)
{
        struct dib0700_state *st = adap->dev->priv;
        st->fw_use_legacy_i2c_api = 1;
        if (adap->id == 0) {
                dib0700_set_gpio(adap->dev, GPIO6,  GPIO_OUT, 0);
msleep(10);
                dib0700_set_gpio(adap->dev, GPIO6,  GPIO_OUT, 1);
msleep(10);
                dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
msleep(10);
                dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
msleep(10);

                if (force_lna_activation)
                        dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
                else
                        dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 0);

                if (dib3000mc_i2c_enumeration(&adap->dev->i2c_adap, 2,
DEFAULT_DIB3000P_I2C_ADDRESS, bristol_dib3000mc_config) != 0) {
                        dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
msleep(10);
                        return -ENODEV;
                }
        }
        st->mt2060_if1[adap->id] = 1220;
        return (adap->fe = dvb_attach(dib3000mc_attach,
&adap->dev->i2c_adap,
                (10 + adap->id) << 1, &bristol_dib3000mc_config[adap->id]))
== NULL ? -ENODEV : 0;
}



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
