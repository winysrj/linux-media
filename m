Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KYufx-0005Kf-8D
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 05:29:30 +0200
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
	<008201c90980$9b7ffd10$d27ff730$@com.au>
	<412bdbff0808281950r48f40835w3f81f506c32eaff3@mail.gmail.com>
In-Reply-To: <412bdbff0808281950r48f40835w3f81f506c32eaff3@mail.gmail.com>
Date: Fri, 29 Aug 2008 11:29:59 +0800
Message-ID: <008301c90987$866b3e60$9341bb20$@com.au>
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

> 
> Well that's promising.  Could you please reboot the system a few times
> and test both cold and warm starts so you are comfortable that
> everything is working?
> 
> Once you're confident everything works, could you please try the
> following:
> 
> 1.  Comment out the "st->fw_use_legacy_i2c_api = 1" line you added in
> the previous email
> 2.  Add "| I2C_M_NOSTART" to line 46 of mt2060.c so it looks like the
> following:
> 
> { .addr = priv->cfg->i2c_address, .flags = I2C_M_RD | I2C_M_NOSTART,
> .buf = val,  .len = 1 },
> 
> make, make install, reboot
> 
> Then let me know if the dmesg output contains i2c errors (and send the
> output if it does).
> 
> We're getting close here....
> 
> Devin
> 
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
Devin,

See below for dmesg o/p with i2c errors.


[   31.882627] dib0700: loaded with support for 7 different device-types
[   31.882929] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold
state, will try to load a firmware
--
[   31.929078] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
--
[   32.130509] dib0700: firmware started successfully.
[   32.632225] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm
state.
[   32.632258] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   32.632400] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   32.696537] dib0700: i2c write error (status = -32)
[   32.696539]
[   32.700785] dib0700: i2c write error (status = -32)
[   32.700786]
[   32.712278] DVB: registering frontend 0 (DiBcom 3000MC/P)...
[   32.712527] dib0700: i2c write error (status = -32)
[   32.712527]
[   32.748254] dib0700: i2c write error (status = -32)
[   32.748256]
[   32.748258] mt2060 I2C read failed
[   32.748286] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   32.748570] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   32.750502] DVB: registering frontend 1 (DiBcom 3000MC/P)...
[   32.750775] dib0700: i2c write error (status = -32)
[   32.750776]
[   32.751879] dib0700: i2c write error (status = -32)
[   32.751880]
[   32.751882] mt2060 I2C read failed
[   32.751962] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1e.0/0000:05:00.2/usb9/9-1/input/input6
[   32.793080] dvb-usb: schedule remote query interval to 150 msecs.
[   32.793084] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully
initialized and connected.
--

Copy of file (mt2060.c) modifications:

static int mt2060_readreg(struct mt2060_priv *priv, u8 reg, u8 *val)
{
        struct i2c_msg msg[2] = {
                { .addr = priv->cfg->i2c_address, .flags = 0,        .buf =
&reg, .len = 1 },
                { .addr = priv->cfg->i2c_address, .flags = I2C_M_RD |
I2C_M_NOSTART, .buf = val,  .len = 1 },
        };

        if (i2c_transfer(priv->i2c, msg, 2) != 2) {
                printk(KERN_WARNING "mt2060 I2C read failed\n");
                return -EREMOTEIO;
        }
        return 0;
}

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
