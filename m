Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2.dnainternet.fi ([87.94.96.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K1qOU-0002MU-4t
	for linux-dvb@linuxtv.org; Fri, 30 May 2008 00:14:47 +0200
Message-ID: <483F2AB3.7080304@iki.fi>
Date: Fri, 30 May 2008 01:14:11 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Germano Paciocco <germano.paciocco@gmail.com>
References: <8ffdeb6d0805291448oe0cb37coa5ae2a6fcc2308ea@mail.gmail.com>
In-Reply-To: <8ffdeb6d0805291448oe0cb37coa5ae2a6fcc2308ea@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problem with AF9015
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

hi,

Germano Paciocco wrote:
> Hi.
> I installed this device on a gentoo. I think I have made all correct
> things. In fact I have no errors on dmesg (i post it below).
> modules loaded are these:
> 
> af9013                 12868  1
> dvb_usb_af9015         13252  0
> dvb_usb                20684  1 dvb_usb_af9015
> i2c_core               22336  5 mt2060,af9013,v4l2_common,dvb_usb,i2c_i801
> 
> I have downlaoded source with command "hg clone
> http://linuxtv.org/hg/~anttip/af9015/" and compiled succesfully, but
> kaffeine says that dvb device is af9013, and nothing is shown!
> I downloades this firmware
> 
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
> 
> and placed into /lib/firmware. It seems it is loaded correctly, how
> you can see in the dmesg pasted below
> 
> Thank you in advance for the help.

All seems to be ok and device is just "standard" one that is worked 
ages... But there is still I2C error seen that breaks functionality. 
Does it always same when re-plugging the stick?

You can also try newer tree to see if it helps.
http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
