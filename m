Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timcumming123@googlemail.com>) id 1KXwJL-0005Ms-L4
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 13:02:09 +0200
Received: by fk-out-0910.google.com with SMTP id f40so1417128fka.1
	for <linux-dvb@linuxtv.org>; Tue, 26 Aug 2008 04:02:04 -0700 (PDT)
Message-ID: <e42dc1490808260402i153cbbfj9beb18481caeac9d@mail.gmail.com>
Date: Tue, 26 Aug 2008 12:02:04 +0100
From: "Tim Cumming" <timcumming123@googlemail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] WinTV-Nova-T usb2 64bit
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0678014555=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0678014555==
Content-Type: multipart/alternative;
	boundary="----=_Part_2514_32196401.1219748524029"

------=_Part_2514_32196401.1219748524029
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I have recently upgraded my hardware from 32bit to 64bit, and am now
experiencing issues with my Hauppage WinTV Nova-T usb2's.
I have been searching through the mail lists and googling, but with no
luck. I should also mention there is an old WinTV Nova-T pci in the
system working fine.
My problem is that when the usb devices are in use will they work
periodically, but randomly produce a flood of messages ending in
alternate:

dvb-usb: bulk message failed: -110 (2/0)
dvb-usb: bulk message failed: -110 (6/0)

These are old style Nova-T usb2's:

[mythtv@legend ~]$ /sbin/lsusb
Bus 001 Device 014: ID 2040:9301 Hauppauge WinTV NOVA-T USB2 (warm)
Bus 001 Device 012: ID 2040:9301 Hauppauge WinTV NOVA-T USB2 (warm)
Bus 001 Device 010: ID 2040:9301 Hauppauge WinTV NOVA-T USB2 (warm)

The machine is an AMD Phenom 9850 Quad-Core running Fedora 9 and
mythtv. I can provide further details if required, and also details of
the previously working machine. (Although it was a 32bit system).

Regards,

Tim Cumming.


[mythtv@legend ~]$ uname -a
Linux legend.localdomain 2.6.25.14-108.fc9.x86_64 #1 SMP Mon Aug 4
13:46:35 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux

[mythtv@legend ~]$ /sbin/lsmod | grep dvb
dvb_usb_nova_t_usb2    14852  0
dvb_usb_dibusb_common    16516  1 dvb_usb_nova_t_usb2
dib3000mc
20488  4 dvb_usb_dibusb_common
dvb_usb
24844  2 dvb_usb_nova_t_usb2,dvb_usb_dibusb_common
dvb_pll
21140  4
cx88_dvb
22276  0
cx88_vp3054_i2c        11136  1 cx88_dvb
videobuf_dvb
13444  1 cx88_dvb
cx8802
23684  1 cx88_dvb
cx88xx
70184  3 cx88_dvb,cx8802,cx8800
videobuf_dma_sg        20100
5 cx88_dvb,videobuf_dvb,cx8802,cx8800,cx88xx
videobuf_core
24964  5 videobuf_dvb,cx8802,cx8800,cx88xx,videobuf_dma_sg
dvb_core
84004  2 dvb_usb,videobuf_dvb
i2c_core
28448  13
dib3000mc,dibx000_common,dvb_usb,mt2060,dvb_pll,cx22702,cx88_vp3054_i2c,cx88xx,i2c_algo_bit,tveeprom,nvidia,v4l2_common,i2c_piix4



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (Darwin)
Comment: http://getfiregpg.org

iEYEARECAAYFAkiz4qoACgkQ+3B4KcqyceubYgCdHdDGPRuOtEx6daPIjY8DQZAx
n7AAoK91phySrYMbq9+JmeYR2DVeitza
=PR9d
-----END PGP SIGNATURE-----

------=_Part_2514_32196401.1219748524029
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">-----BEGIN PGP SIGNED MESSAGE-----<br>Hash: SHA1<br><br>Hi,<br><br>I have recently upgraded my hardware from 32bit to 64bit, and am now<br>experiencing issues with my Hauppage WinTV Nova-T usb2&#39;s.<br>I have been searching through the mail lists and googling, but with no<br>
luck. I should also mention there is an old WinTV Nova-T pci in the<br>system working fine.<br>My problem is that when the usb devices are in use will they work<br>periodically, but randomly produce a flood of messages ending in<br>
alternate:<br><br>dvb-usb: bulk message failed: -110 (2/0)<br>dvb-usb: bulk message failed: -110 (6/0)<br><br>These are old style Nova-T usb2&#39;s:<br><br>[mythtv@legend ~]$ /sbin/lsusb<br>Bus 001 Device 014: ID 2040:9301 Hauppauge WinTV NOVA-T USB2 (warm)<br>
Bus 001 Device 012: ID 2040:9301 Hauppauge WinTV NOVA-T USB2 (warm)<br>Bus 001 Device 010: ID 2040:9301 Hauppauge WinTV NOVA-T USB2 (warm)<br><br>The machine is an AMD Phenom 9850 Quad-Core running Fedora 9 and<br>mythtv. I can provide further details if required, and also details of<br>
the previously working machine. (Although it was a 32bit system).<br><br>Regards,<br><br>Tim Cumming.<br><br><br>[mythtv@legend ~]$ uname -a<br>Linux legend.localdomain 2.6.25.14-108.fc9.x86_64 #1 SMP Mon Aug 4<br>13:46:35 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux<br>
<br>[mythtv@legend ~]$ /sbin/lsmod | grep dvb<br>dvb_usb_nova_t_usb2&nbsp;&nbsp;&nbsp; 14852&nbsp; 0 <br>dvb_usb_dibusb_common&nbsp;&nbsp;&nbsp; 16516&nbsp; 1 dvb_usb_nova_t_usb2<br>dib3000mc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>20488&nbsp; 4 dvb_usb_dibusb_common<br>dvb_usb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
24844&nbsp; 2 dvb_usb_nova_t_usb2,dvb_usb_dibusb_common<br>dvb_pll&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>21140&nbsp; 4 <br>cx88_dvb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>22276&nbsp; 0 <br>cx88_vp3054_i2c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11136&nbsp; 1 cx88_dvb<br>videobuf_dvb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>13444&nbsp; 1 cx88_dvb<br>
cx8802&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>23684&nbsp; 1 cx88_dvb<br>cx88xx&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>70184&nbsp; 3 cx88_dvb,cx8802,cx8800<br>videobuf_dma_sg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20100&nbsp;<br>5 cx88_dvb,videobuf_dvb,cx8802,cx8800,cx88xx<br>videobuf_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>24964&nbsp; 5 videobuf_dvb,cx8802,cx8800,cx88xx,videobuf_dma_sg<br>
dvb_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>84004&nbsp; 2 dvb_usb,videobuf_dvb<br>i2c_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>28448&nbsp; 13<br>dib3000mc,dibx000_common,dvb_usb,mt2060,dvb_pll,cx22702,cx88_vp3054_i2c,cx88xx,i2c_algo_bit,tveeprom,nvidia,v4l2_common,i2c_piix4<br>
<br><br><br>-----BEGIN PGP SIGNATURE-----<br>Version: GnuPG v1.4.8 (Darwin)<br>Comment: <a href="http://getfiregpg.org">http://getfiregpg.org</a><br><br>iEYEARECAAYFAkiz4qoACgkQ+3B4KcqyceubYgCdHdDGPRuOtEx6daPIjY8DQZAx<br>
n7AAoK91phySrYMbq9+JmeYR2DVeitza<br>=PR9d<br>-----END PGP SIGNATURE-----<br><br><br></div>

------=_Part_2514_32196401.1219748524029--


--===============0678014555==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0678014555==--
