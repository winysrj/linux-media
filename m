Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <sutton.nm@gmail.com>) id 1RWHaI-00075o-Vi
	for linux-dvb@linuxtv.org; Fri, 02 Dec 2011 02:06:39 +0100
Received: from mail-pz0-f54.google.com ([209.85.210.54])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1RWHaI-000011-Hp; Fri, 02 Dec 2011 02:06:38 +0100
Received: by dafa1 with SMTP id a1so1176283daf.41
	for <linux-dvb@linuxtv.org>; Thu, 01 Dec 2011 17:06:35 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 2 Dec 2011 01:06:35 +0000
Message-ID: <CAP_ERaFTaU=8cOwi+sj3QCy1F9QgTmYJihGaXrJA1XyveY8dxw@mail.gmail.com>
From: Neil Sutton <sutton.nm@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] PCTV452e / S2-3600 displays I2C error
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1874991610=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1874991610==
Content-Type: multipart/alternative; boundary=f46d041b47f699723c04b3119403

--f46d041b47f699723c04b3119403
Content-Type: text/plain; charset=ISO-8859-1

Hi all,

I'm not entirely sure if this is the correct list, but I compiled the
latest 3.2 RC3 kernel to get native support of my S2-3600 tuner
(s2-liplianin seems to cause trouble with my other tuner).

I enabled the PCTV452e module in the kernel and the device detects ok;

[   12.075239] dvb-usb: found a 'Technotrend TT Connect S2-3600' in warm
state.
[   12.076620] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   12.080767] dvb-usb: MAC address: 00:d0:5c:64:54:95
[   12.759115] dvb-usb: found a 'Hauppauge Nova-T Stick' in cold state,
will try to load a firmware
[   13.298383] dvb-usb: Technotrend TT Connect S2-3600 successfully
initialized and connected.
[   13.464394] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
[   14.180319] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
[   14.180429] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   15.356117] dvb-usb: Hauppauge Nova-T Stick successfully initialized and
connected.
[   15.356832] usbcore: registered new interface driver dvb_usb_dib0700

But when I try to make any tuning with the device I get no picture and the
following get put to syslog;

Dec  2 01:01:26 MicroServer kernel: [ 1535.331468] dvb-usb: could not
submit URB no. 0 - get them all back
Dec  2 01:01:26 MicroServer kernel: [ 1535.372388] pctv452e: I2C error
-121; AA 97  CC 00 01 -> 55 97  CC 00 00.
Dec  2 01:01:26 MicroServer kernel: [ 1535.385003] pctv452e: I2C error
-121; AA AE  CC 00 01 -> 55 AE  CC 00 00.
Dec  2 01:01:26 MicroServer kernel: [ 1535.444992] pctv452e: I2C error
-121; AA C9  CC 00 01 -> 55 C9  CC 00 00.
Dec  2 01:01:46 MicroServer kernel: [ 1555.665248] dvb-usb: could not
submit URB no. 0 - get them all back
Dec  2 01:01:46 MicroServer kernel: [ 1555.708805] pctv452e: I2C error
-121; AA 2E  CC 00 01 -> 55 2E  CC 00 00.
Dec  2 01:01:46 MicroServer kernel: [ 1555.722046] pctv452e: I2C error
-121; AA 45  CC 00 01 -> 55 45  CC 00 00.
Dec  2 01:01:46 MicroServer kernel: [ 1555.784543] pctv452e: I2C error
-121; AA 60  CC 00 01 -> 55 60  CC 00 00.

The 'URB' errors appear each time the card moves to a new transponder, the
I2C errors appear to be when the card is attempting to lock a channel
within the current transponder.

Does anyone have any thoughts on what might be causing this ? - I've had a
search around but can't really find the problem mentioned anywhere... the
device works fine under the latest liplianin drivers.

Many Thanks
Neil

--f46d041b47f699723c04b3119403
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,<br><br>I&#39;m not entirely sure if this is the correct list, but I=
 compiled the latest 3.2 RC3 kernel to get native support of my S2-3600 tun=
er (s2-liplianin seems to cause trouble with my other tuner).<br><br>I enab=
led the PCTV452e module in the kernel and the device detects ok;<br>
<br>[=A0=A0 12.075239] dvb-usb: found a &#39;Technotrend TT Connect S2-3600=
&#39; in warm state.<br>[=A0=A0 12.076620] dvb-usb: will pass the complete =
MPEG2 transport stream to the software demuxer.<br>[=A0=A0 12.080767] dvb-u=
sb: MAC address: 00:d0:5c:64:54:95<br>
[=A0=A0 12.759115] dvb-usb: found a &#39;Hauppauge Nova-T Stick&#39; in col=
d state, will try to load a firmware<br>[=A0=A0 13.298383] dvb-usb: Technot=
rend TT Connect S2-3600 successfully initialized and connected.<br>[=A0=A0 =
13.464394] dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700-1.2=
0.fw&#39;<br>
[=A0=A0 14.180319] dvb-usb: found a &#39;Hauppauge Nova-T Stick&#39; in war=
m state.<br>[=A0=A0 14.180429] dvb-usb: will pass the complete MPEG2 transp=
ort stream to the software demuxer.<br>[=A0=A0 15.356117] dvb-usb: Hauppaug=
e Nova-T Stick successfully initialized and connected.<br>
[=A0=A0 15.356832] usbcore: registered new interface driver dvb_usb_dib0700=
<br><br>But when I try to make any tuning with the device I get no picture =
and the following get put to syslog;<br><br>Dec=A0 2 01:01:26 MicroServer k=
ernel: [ 1535.331468] dvb-usb: could not submit URB no. 0 - get them all ba=
ck<br>
Dec=A0 2 01:01:26 MicroServer kernel: [ 1535.372388] pctv452e: I2C error -1=
21; AA 97=A0 CC 00 01 -&gt; 55 97=A0 CC 00 00.<br>Dec=A0 2 01:01:26 MicroSe=
rver kernel: [ 1535.385003] pctv452e: I2C error -121; AA AE=A0 CC 00 01 -&g=
t; 55 AE=A0 CC 00 00.<br>
Dec=A0 2 01:01:26 MicroServer kernel: [ 1535.444992] pctv452e: I2C error -1=
21; AA C9=A0 CC 00 01 -&gt; 55 C9=A0 CC 00 00.<br>Dec=A0 2 01:01:46 MicroSe=
rver kernel: [ 1555.665248] dvb-usb: could not submit URB no. 0 - get them =
all back<br>
Dec=A0 2 01:01:46 MicroServer kernel: [ 1555.708805] pctv452e: I2C error -1=
21; AA 2E=A0 CC 00 01 -&gt; 55 2E=A0 CC 00 00.<br>Dec=A0 2 01:01:46 MicroSe=
rver kernel: [ 1555.722046] pctv452e: I2C error -121; AA 45=A0 CC 00 01 -&g=
t; 55 45=A0 CC 00 00.<br>
Dec=A0 2 01:01:46 MicroServer kernel: [ 1555.784543] pctv452e: I2C error -1=
21; AA 60=A0 CC 00 01 -&gt; 55 60=A0 CC 00 00.<br><br>The &#39;URB&#39; err=
ors appear each time the card moves to a new transponder, the I2C errors ap=
pear to be when the card is attempting to lock a channel within the current=
 transponder.<br>
<br>Does anyone have any thoughts on what might be causing this ? - I&#39;v=
e had a search around but can&#39;t really find the problem mentioned anywh=
ere... the device works fine under the latest liplianin drivers.<br><br>
Many Thanks<br>Neil<br>

--f46d041b47f699723c04b3119403--


--===============1874991610==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1874991610==--
