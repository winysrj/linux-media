Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KYsFO-0005T8-5k
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 02:53:57 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: "'Devin Heitmueller'" <devin.heitmueller@gmail.com>,
	"'Patrick Boettcher'" <patrick.boettcher@desy.de>
References: <004f01c90921$248fe2b0$6dafa810$@com.au>	
	<412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>	
	<007f01c90965$344da360$9ce8ea20$@com.au>	
	<412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>	
	<008001c9096a$f315df10$d9419d30$@com.au>
	<412bdbff0808281731t7641e4d1kf86058e071c7d5fb@mail.gmail.com>
In-Reply-To: <412bdbff0808281731t7641e4d1kf86058e071c7d5fb@mail.gmail.com>
Date: Fri, 29 Aug 2008 08:54:23 +0800
Message-ID: <008101c90971$ca7e5080$5f7af180$@com.au>
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
> Wow, that's so early in the loading process for the device, it's hard
> to see how that can have anything to do with my i2c changes.
> 
> Patrick, do you have any changelogs that describe the differences
> between 1.10 and 1.20 other than the addition of the new i2c API?
> 
> Devin
> 
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

Devin,

I have applied the latest patch, swapped back to the .20firmware and now get
the following output from dmesg:

[   32.161603] Linux video capture interface: v2.00
--
[   32.407733] dib0700: loaded with support for 7 different device-types
[   32.408042] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold
state, will try to load a firmware
[   32.451939] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
[   32.654066] dib0700: firmware started successfully.
[   33.157310] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm
state.
[   33.157342] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   33.157430] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   33.221594] dib0700: i2c write error (status = -32)
[   33.221595]
[   33.225841] dib0700: i2c write error (status = -32)
[   33.225841]
[   33.237332] DVB: registering frontend 0 (DiBcom 3000MC/P)...
[   33.237582] dib0700: i2c write error (status = -32)
[   33.237582]
[   33.282556] dib0700: i2c write error (status = -32)
[   33.282557]
[   33.282559] mt2060 I2C read failed
[   33.282587] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   33.282867] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   33.284802] DVB: registering frontend 1 (DiBcom 3000MC/P)...
[   33.285055] dib0700: i2c write error (status = -32)
[   33.285056]
[   33.286178] dib0700: i2c write error (status = -32)
[   33.286179]
[   33.286180] mt2060 I2C read failed
[   33.286242] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1e.0/0000:05:00.2/usb6/6-1/input/input6
[   33.333182] dvb-usb: schedule remote query interval to 150 msecs.
[   33.333186] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully
initialized and connected.
[   33.333286] usbcore: registered new interface driver dvb_usb_dib0700

Please note that the tuners are available within MythTV but are unable to
tune to any channel.

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
