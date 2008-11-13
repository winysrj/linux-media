Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1L0e28-0002HC-0E
	for linux-dvb@linuxtv.org; Thu, 13 Nov 2008 16:23:01 +0100
Message-ID: <491C464D.20502@iki.fi>
Date: Thu, 13 Nov 2008 17:22:53 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Anders Eriksson <aeriksson@fastmail.fm>
References: <20081112213814.674D26BC025@tippex.mynet.homeunix.org>
In-Reply-To: <20081112213814.674D26BC025@tippex.mynet.homeunix.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Anysee E30C Plus and no output??
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

Anders Eriksson wrote:
> Hi,
> 
> I'm a newbie in dvb waters, and all the googling doesn't help, so I turn to 
> you. 
> 
> I've installed the device successfully, I gather:
> 
> dvb-usb: found a 'Anysee DVB USB2.0' in warm state.
> i2c-adapter i2c-1: adapter [Anysee DVB USB2.0] registered
> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> DVB: registering new adapter (Anysee DVB USB2.0)
> anysee: firmware version:0.1.0 hardware id:10
> i2c-adapter i2c-1: master_xfer[0] W, addr=0x1e, len=1
> i2c-adapter i2c-1: master_xfer[1] R, addr=0x1e, len=1
> i2c-adapter i2c-1: master_xfer[0] W, addr=0x1e, len=1
> i2c-adapter i2c-1: master_xfer[1] R, addr=0x1e, len=1
> i2c-adapter i2c-1: master_xfer[0] W, addr=0x1e, len=1
> i2c-adapter i2c-1: master_xfer[1] R, addr=0x1e, len=1
> i2c-adapter i2c-1: master_xfer[0] W, addr=0x1a, len=2
> i2c-adapter i2c-1: master_xfer[0] W, addr=0x1a, len=1
> i2c-adapter i2c-1: master_xfer[1] R, addr=0x1a, len=1
> DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
> i2c-adapter i2c-1: master_xfer[0] W, addr=0x1a, len=2
> i2c-adapter i2c-1: master_xfer[0] R, addr=0xc0, len=1
> i2c-adapter i2c-1: master_xfer[0] W, addr=0x1a, len=2
> input: IR-receiver inside an USB DVB receiver as /class/input/input7
> dvb-usb: schedule remote query interval to 200 msecs.
> dvb-usb: Anysee DVB USB2.0 successfully initialized and connected.
> usbcore: registered new interface driver dvb_usb_anysee
> 
> Scanning the device produce a nice channels.conf file, which czap is happy to use:
> SVT HD(Com Hem):306000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:0:4356:1064
> PPV Sport 1(Com Hem):306000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:4097:4353:1065
> PPV Sport 2(Com Hem):306000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:4130:4386:1066
> PPV Sport 3(Com Hem):306000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:4147:4403:1067
> Extreme Sports Channel(Com Hem):314000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:4097:4353:1017
> Channel One Russia(Com Hem):314000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:4147:4403:1018
> ...
> 
> 
> Is czap expected to return? Mine doesn't. I just get a long list of what seems 
> to be SNR readings.
> 
> Anyway, as far as I can tell, I should be all set for pointing mplayer at the 
> dvr0 device:
> mplayer /dev/dvb/adapter0/dvr0
> No output at all! Ctrl-C afer a minute says that it got killed in the 
> demux module. I've looked all over the net and as far as I can tell, it should 
> be as simple as czap to the right channel and then ask mplayer to use the dvr0 
> device. Am I doing something totally stupid here? Is the device broken?

You should:
czap -r "CHANNEL NAME"
mplayer /dev/dvb/adapter0/dvr0

remember use -r switch when czapping, otherwise it does as you described.

There is also error in HW-design in DVB-C Anysee, with too good signals 
it does not work always. Same happens both Windows and Linux. In case of 
too high signal use antenna attenuator.

> 
> Any and all pointers highly appreciated,
> /Anders

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
