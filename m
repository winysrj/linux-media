Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1JqbPB-0006mS-MA
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2008 00:01:02 +0200
Received: by mu-out-0910.google.com with SMTP id i10so3557257mue.1
	for <linux-dvb@linuxtv.org>; Mon, 28 Apr 2008 15:00:55 -0700 (PDT)
Message-ID: <854d46170804281500g438b5904md5aaffa40ed1a9ce@mail.gmail.com>
Date: Tue, 29 Apr 2008 00:00:55 +0200
From: "Faruk A" <fa@elwak.com>
To: "Dominik Kuhlen" <dkuhlen@gmx.net>
In-Reply-To: <200804202231.32999.dkuhlen@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <200804190101.14457.dkuhlen@gmx.net>
	<200804201054.35570.dkuhlen@gmx.net>
	<854d46170804200605i711bda4ci2c2e1b78a3e1c47b@mail.gmail.com>
	<200804202231.32999.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
	TT-Connect-S2-3600 final version (RC-keymap)
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

>  > If you are going to release another version or future update please
>  > add support for TT connect s2 3650 CI, its same as 3600 but with CI.
>  > +#define USB_PID_TECHNOTREND_CONNECT_S2_3650_CI             0x300a
>  attached as patch
>
>  Dominik

Hi Dominik!

Last week i didn't had a chance to test the "patch_add_tt_s2_3650_ci.diff"
i just tested and it's not working. I'll paste the log here when i use
the device as 3600 and 3650 CI.

First when i use my device as  3600 (changed 0x3007 to 0x300a in dvb-usb-ids.h)

Apr 28 23:27:26 archer dvb-usb: found a 'Technotrend TT Connect
S2-3600' in warm state.
Apr 28 23:27:26 archer pctv452e_power_ctrl: 1
Apr 28 23:27:26 archer dvb-usb: will pass the complete MPEG2 transport
stream to the software demuxer.
Apr 28 23:27:26 archer DVB: registering new adapter (Technotrend TT
Connect S2-3600)
Apr 28 23:27:26 archer pctv452e_frontend_attach Enter
Apr 28 23:27:26 archer stb0899_write_regs [0xf1b6]: 02
Apr 28 23:27:26 archer stb0899_write_regs [0xf1c2]: 00
Apr 28 23:27:26 archer stb0899_write_regs [0xf1c3]: 00
Apr 28 23:27:26 archer stb0899_write_regs [0xf141]: 02
Apr 28 23:27:26 archer _stb0899_read_reg: Reg=[0xf000], data=82
Apr 28 23:27:26 archer stb0899_get_dev_id: ID reg=[0x82]
Apr 28 23:27:26 archer stb0899_get_dev_id: Device ID=[8], Release=[2]
Apr 28 23:27:26 archer _stb0899_read_s2reg Device=[0xf3fc], Base
address=[0x00000400], Offset=[0xf334], Data=[0x444d4431]
Apr 28 23:27:26 archer _stb0899_read_s2reg Device=[0xf3fc], Base
address=[0x00000400], Offset=[0xf33c], Data=[0x00000001]
Apr 28 23:27:26 archer stb0899_get_dev_id: Demodulator Core ID=[DMD1],
Version=[1]
Apr 28 23:27:26 archer _stb0899_read_s2reg Device=[0xfafc], Base
address=[0x00000800], Offset=[0xfa2c], Data=[0x46454331]
Apr 28 23:27:26 archer _stb0899_read_s2reg Device=[0xfafc], Base
address=[0x00000800], Offset=[0xfa34], Data=[0x00000001]
Apr 28 23:27:26 archer stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
Apr 28 23:27:26 archer stb0899_attach: Attaching STB0899
Apr 28 23:27:26 archer lnbp22_set_voltage: 2 (18V=1 13V=0)
Apr 28 23:27:26 archer lnbp22_set_voltage: 0x60)
Apr 28 23:27:26 archer pctv452e_frontend_attach Leave Ok
Apr 28 23:27:26 archer DVB: registering frontend 0 (STB0899 Multistandard)...
Apr 28 23:27:26 archer pctv452e_tuner_attach Enter
Apr 28 23:27:26 archer stb6100_attach: Attaching STB6100
Apr 28 23:27:26 archer pctv452e_tuner_attach Leave
Apr 28 23:27:26 archer input: IR-receiver inside an USB DVB receiver
as /devices/pci0000:00/0000:00:1d.7/usb5/5-4/input/input21
Apr 28 23:27:26 archer dvb-usb: schedule remote query interval to 100 msecs.
Apr 28 23:27:26 archer pctv452e_power_ctrl: 0
Apr 28 23:27:26 archer dvb-usb: Technotrend TT Connect S2-3600
successfully initialized and connected.
Apr 28 23:27:26 archer usbcore: registered new interface driver pctv452e
Apr 28 23:27:26 archer usbcore: registered new interface driver
dvb-usb-tt-connect-s2-3600-01.fw
............................................................................................

Second when i use my device as 3650 CI (changed back dvb-usb-ids.h to
it's original)

Apr 28 23:31:17 archer usbcore: deregistering interface driver pctv452e
Apr 28 23:31:17 archer lnbp22_release
Apr 28 23:31:17 archer lnbp22_set_voltage: 2 (18V=1 13V=0)
Apr 28 23:31:17 archer lnbp22_set_voltage: 0x60)
Apr 28 23:31:17 archer dvb-usb: bulk message failed: -22 (11/572662306)
Apr 28 23:31:17 archer stb0899_release: Release Frontend
Apr 28 23:31:17 archer stb0899_write_regs [0xf141]: 82
Apr 28 23:31:17 archer dvb-usb: bulk message failed: -22 (10/572662306)
Apr 28 23:31:17 archer dvb-usb: Technotrend TT Connect S2-3600
successfully deinitialized and disconnected.
Apr 28 23:31:17 archer usbcore: deregistering interface driver
dvb-usb-tt-connect-s2-3600-01.fw
Apr 28 23:35:27 archer usbcore: registered new interface driver pctv452e
Apr 28 23:35:27 archer usbcore: registered new interface driver
dvb-usb-tt-connect-s2-3600-01.fw
.....................................................................................................
no /dev/dvb

Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
