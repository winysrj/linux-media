Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1JnIzx-0008Kw-Bv
	for linux-dvb@linuxtv.org; Sat, 19 Apr 2008 21:45:22 +0200
Received: by fg-out-1718.google.com with SMTP id 22so916168fge.25
	for <linux-dvb@linuxtv.org>; Sat, 19 Apr 2008 12:45:17 -0700 (PDT)
Message-ID: <854d46170804191245m6015dbdpe8b244aa1c884153@mail.gmail.com>
Date: Sat, 19 Apr 2008 21:45:17 +0200
From: "Faruk A" <fa@elwak.com>
To: "Dominik Kuhlen" <dkuhlen@gmx.net>
In-Reply-To: <200804191154.20445.dkuhlen@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <200804190101.14457.dkuhlen@gmx.net>
	<200804191154.20445.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
	TT-Connect-S2-3600 final version
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

2008/4/19 Dominik Kuhlen <dkuhlen@gmx.net>:
> Hi,
>  Good news for all stb0899 owners :)
>
>
>  On Saturday 19 April 2008, Dominik Kuhlen wrote:
>  > Hi,
>  >
>  > Here is my current version after quite a while of testing and tuning:
>  > I stripped the stb0899 tuning/searching algo to speed up tuning a bit
>  > now I have very fast and reliable locks (no failures, no errors)
>  >
>  The frequency reported by DVBFE_GET_PARAMS when in DVB-S2 mode is not correct.
>  The attached patch fixes this:
>  Now i can request any frequency near the center (even more than 10MHz lower or higher)
>  and the reported frequency is within a few kHz of the actual center frequency.
>
>
>   Dominik
>
>
> _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

First of all thanks for the latest drivers.
I'm using  Technotrend TT Connect S2-3650 CI this new drivers works
well with vdr, no problem locking and tunning to any dvbs channels. As
for dvbs2 doesn't seem to work with vdr but i have no problem locking
it with szap.

The second patch you posted "patch_multiproto_dvbs2_frequency.diff"
doesn't seem to work for me, it does compile fine but the problem is
loading the the driver.

insmod stb0899.ko verbose=5

insmod: error inserting 'stb0899.ko': -1 Unknown symbol in module

Apr 19 21:22:40 archer usbcore: deregistering interface driver pctv452e
Apr 19 21:22:40 archer dvb-usb: Technotrend TT Connect S2-3600
successfully deinitialized and disconnected.
Apr 19 21:22:40 archer usbcore: deregistering interface driver
dvb-usb-tt-connect-s2-3600-01.fw
Apr 19 21:22:45 archer stb0899: Unknown symbol __divdi3
Apr 19 21:22:45 archer dvb-usb: found a 'Technotrend TT Connect
S2-3600' in warm state.
Apr 19 21:22:45 archer pctv452e_power_ctrl: 1
Apr 19 21:22:47 archer dvb-usb: recv bulk message failed: -110
Apr 19 21:22:47 archer dvb-usb: will pass the complete MPEG2 transport
stream to the software demuxer.
Apr 19 21:22:47 archer DVB: registering new adapter (Technotrend TT
Connect S2-3600)
Apr 19 21:22:47 archer pctv452e_frontend_attach Enter
Apr 19 21:22:47 archer DVB: Unable to find symbol stb0899_attach()
Apr 19 21:22:47 archer dvb-usb: no frontend was attached by
'Technotrend TT Connect S2-3600'
Apr 19 21:22:47 archer input: IR-receiver inside an USB DVB receiver
as /devices/pci0000:00/0000:00:1d.7/usb5/5-4/input/input13
Apr 19 21:22:47 archer dvb-usb: schedule remote query interval to 100 msecs.
Apr 19 21:22:47 archer pctv452e_power_ctrl: 0
Apr 19 21:22:47 archer dvb-usb: Technotrend TT Connect S2-3600
successfully initialized and connected.
Apr 19 21:22:47 archer usbcore: registered new interface driver pctv452e
Apr 19 21:22:47 archer usbcore: registered new interface driver
dvb-usb-tt-connect-s2-3600-01.fw
..............................................................................................
One last thing how come you didn't include this part in your latest patch ?

+/* Remote Control Stuff fo S2-3600 (copied from TT-S1500): */
+static struct dvb_usb_rc_key tt_connect_s2_3600_rc_key[] = {
+        {0x15, 0x01, KEY_POWER},
+        {0x15, 0x02, KEY_SHUFFLE}, /* ? double-arrow key */
+        {0x15, 0x03, KEY_1},
+        {0x15, 0x04, KEY_2},
+        {0x15, 0x05, KEY_3},
+        {0x15, 0x06, KEY_4},
+        {0x15, 0x07, KEY_5},
+        {0x15, 0x08, KEY_6},
+        {0x15, 0x09, KEY_7},
+        {0x15, 0x0a, KEY_8},
+        {0x15, 0x0b, KEY_9},
+        {0x15, 0x0c, KEY_0},
+        {0x15, 0x0d, KEY_UP},
+        {0x15, 0x0e, KEY_LEFT},
+        {0x15, 0x0f, KEY_OK},
+        {0x15, 0x10, KEY_RIGHT},
+        {0x15, 0x11, KEY_DOWN},
+        {0x15, 0x12, KEY_INFO},
+        {0x15, 0x13, KEY_EXIT},
+        {0x15, 0x14, KEY_RED},
+        {0x15, 0x15, KEY_GREEN},
+        {0x15, 0x16, KEY_YELLOW},
+        {0x15, 0x17, KEY_BLUE},
+        {0x15, 0x18, KEY_MUTE},
+        {0x15, 0x19, KEY_TEXT},
+        {0x15, 0x1a, KEY_MODE},  /* ? TV/Radio */
+        {0x15, 0x21, KEY_OPTION},
+        {0x15, 0x22, KEY_EPG},
+        {0x15, 0x23, KEY_CHANNELUP},
+        {0x15, 0x24, KEY_CHANNELDOWN},
+        {0x15, 0x25, KEY_VOLUMEUP},
+        {0x15, 0x26, KEY_VOLUMEDOWN},
+        {0x15, 0x27, KEY_SETUP},
+        {0x15, 0x3a, KEY_RECORD},/* these keys are only in the black remote */
+        {0x15, 0x3b, KEY_PLAY},
+        {0x15, 0x3c, KEY_STOP},
+        {0x15, 0x3d, KEY_REWIND},
+        {0x15, 0x3e, KEY_PAUSE},
+        {0x15, 0x3f, KEY_FORWARD}
+};

Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
