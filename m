Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.237])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marco.difresco@gmail.com>) id 1JwhLM-0001Zf-62
	for linux-dvb@linuxtv.org; Thu, 15 May 2008 19:34:18 +0200
Received: by wx-out-0506.google.com with SMTP id h27so369540wxd.17
	for <linux-dvb@linuxtv.org>; Thu, 15 May 2008 10:34:11 -0700 (PDT)
From: Marco Di Fresco <marco.difresco@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
Date: Thu, 15 May 2008 19:33:47 +0200
Message-Id: <1210872827.11661.0.camel@PC-MARCO>
Mime-Version: 1.0
Subject: [linux-dvb] Problems to get channels with Hauppauge Nova-TD Stick
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1307032082=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1307032082==
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WA1cfMTj/HaaPOYAn/Vu"


--=-WA1cfMTj/HaaPOYAn/Vu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all,
I have bought a Hauppauge Nova-TD Stick few days ago, but I am having
problems to get the channels.

According to 'dmesg', the card is recognized (even with the kernel
bundled modules, but to be sure I downloaded the latest modules with
'hg'):

[  137.485145] dvb-usb: found a 'Hauppauge Nova-TD Stick/Elgato Eye-TV
Diversity' in cold state, will try to load a firmware
[  137.551403] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.10.fw'
[  137.948233] dvb-usb: found a 'Hauppauge Nova-TD Stick/Elgato Eye-TV
Diversity' in warm state.
[  137.948285] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[  138.186907] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[  138.409176] dvb-usb: schedule remote query interval to 150 msecs.
[  138.409359] dvb-usb: Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity
successfully initialized and connected.



I first tried to scan for the channels with a scan file found in
'=EF=BB=BF/usr/share/doc/dvb-utils/examples/scan/dvb-t/', but without succe=
ss.

$ scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/it-Venezia
> ./.tzap/channels.conf
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/it-Venezia
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 706000000 0 2 1 3 1 0 0
initial transponder 602000000 0 2 1 3 1 0 0
initial transponder 490000000 0 2 1 3 1 0 0
initial transponder 818000000 0 2 1 3 1 0 0
initial transponder 826000000 0 2 1 3 1 0 0
initial transponder 770000000 0 2 1 3 1 0 0
initial transponder 594000000 0 2 1 3 1 0 0
>>> tune to:
706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
826000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
826000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
770000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
770000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
594000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
594000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSIO=
N_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
dumping lists (0 services)
Done.



So far I give it the benefit of doubts since I do not really live
in =EF=BB=BFVenice, but in another city in the same region (Vicenza in
specific). So I tried to do the scan with 'w_scan':

$ w_scan -f t -i 0 -F -t 3 -o 4 -R 1 -T 1 -O 1 -E 1 -X -v>
~/.tzap/channels.conf
w_scan version 20080105
Info: using DVB adapter auto detection.
   Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
-_-_-_-_ Getting frontend capabilities-_-_-_-_
frontend DiBcom 7000PC supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
177500:
184500:
191500:
198500:
205500:
212500:
219500:
226500:
474000:
482000: signal ok (I999B8C999D999M999T999G999Y999)
490000:
498000:
506000:
514000: signal ok (I999B8C999D999M999T999G999Y999)
522000:
530000:
538000:
546000:
554000:
562000:
570000:
578000:
586000: signal ok (I999B8C999D999M999T999G999Y999)
594000:
602000:
610000:
618000:
626000:
634000:
642000:
650000:
658000:
666000: signal ok (I999B8C999D999M999T999G999Y999)
674000:
682000:
690000:
698000:
706000:
714000:
722000:
730000:
738000:
746000:
754000:
762000:
770000:
778000:
786000:
794000:
802000:
810000:
818000:
826000:
834000:
842000:
850000:
858000:
tune to:
>>> tuning status =3D=3D 0x0f
>>> tuning status =3D=3D 0x1f
PAT
PMT 0x0bba for service 0x0bb9
PMT 0x03ea for service 0x03e9
PMT 0x07d2 for service 0x07d1
SDT (actual TS)
     LA10(TELEBASSANO)
     TVSET-TELENORD(TELEBASSANO)
     RETE VENETA(TELEBASSANO)
NIT (actual TS)
Network Name 'Network Name'
tune to:
>>> tuning status =3D=3D 0x0a
>>> tuning status =3D=3D 0x1a
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
tune to:
>>> tuning status =3D=3D 0x0a
>>> tuning status =3D=3D 0x1a
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
tune to:
>>> tuning status =3D=3D 0x0b
>>> tuning status =3D=3D 0x1b
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
dumping lists (3 services)
Done.

As you can see, it found only three channels and for the rest it reports
'=EF=BB=BFInfo: filter timeout pid'. Now, the =EF=BB=BFHauppauge Nova-TD St=
ick should
support digital aerial signal, but not only it does not find
any =EF=BB=BFdigital aerial channel, it does not even find any national ana=
logue
channel (like "Rai Uno, "Rai Due", etc. - the three found are local
channels, and they are not even the all available).

I tried to do a 'dvbsnoop' scan; since the output is too long, I have
uploaded it to a site of mine:
http://marcodifresco.interfree.it/marco/misc/dvbsnoop-result.txt

I tried to search for channels with Kaffeine, but it finds the same
three channels (and actually two times each channel).


I have read on a forum (I cannot find the link now) that if only few
signals are found it is because the signal has too much strength and it
is necessary to use a 6db attenuator; I have found it today, but it did
not solved the problem (actually I am doing further tests since it is a
0-20db attenuator with a wheel to regolate the attenuation).

I have done all the tests with both the small antennas provided with the
stick and with the roof antenna. I know that the =EF=BB=BFroof antenna is
working because I was using it with a regular television and with
an =EF=BB=BFAverMedia AverTV USB 2.0 Plus under Windows (too bad I migrated=
 to
Linux after only a couple of month from the purchase and it was not
supported).

I am using Kubuntu 8.04 64 bits with kernel 2.6.25.3 (I just upgraded it
today, until yesterday I was using 2.6.24.7, with the same results). I
have an Intel Core 2 Duo E6700 on a ECS PN2 SLI2+ Extreme nForce 680i
SLI, EVGA 768-P2-N831-AR GeForce 8800 GTX, 2 GB (4x512MB) DDR2 800 of
RAM.

Now, usually I do not make pressure for help (especially to whom is
doing a good job for free), but I have bought the stick Monday and here
in Italy we have only 7 days to bring the stuff back for a refund (if we
are not satisfied - if it is actually broken we have 1 year warranty by
law), so I have only tomorrow (Friday) evening available for further
testing; if I have to bring it back, I have to do it Saturday morning
since on the afternoon and on Sunday the store is closed --- as I
mentioned I have already wasted money on an AverMedia AverTV USB 2.0
Plus that I used for only a couple of month under Windows (since I have
then I migrated to Linux...) and I have no intentions to add a 79,90
Euro device to the pile of junk in the attic. :-(

Thank in advance. :-)

--=20
Marco Di Fresco
http://marcodifresco.wordpress.com

--=-WA1cfMTj/HaaPOYAn/Vu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQIVAwUASCxz++E1e7n2TLKCAQJDog//Tx08boIZvUqBJ4NLh1d9qocTnh/7io2H
vpGqgc4J/W7CQmPTxiWyLMJ87cOrdsJO/fliY21ase0wLm1UTOXLSO0Hvh8DAfSr
6NjscICNwj9EFi59RhYrRFddEyd+T01OC+VVIvMbuvtAf60lUCEgggF6Hr1JigC+
UEyHCzD1tykVL1sXUCNn94zSl4drsKR4Ke7TsuoDTuappxFuhtMr6QkJ2KGuxPJh
a29/PDY/NXeJ0+wjdkOM7jOU7smpa8ce5z64N1seYdVXixBGIEU5FW3uofpRPnap
Phs7DedcpDSWEUuuQBaFtesf4zQMiax92RJeTDi2HDFTE/D31IgX078lt1GNo5Le
7tj3bC3tYJTGnLt37nwR25gdSDmQy378asiyhH1EBkYbke8hZqJReEg3aBlfk/Pz
S59euES0AyYBNkDPzVl6hcPj2BeJjg7YpDum2IozB2BjMKv2nB1WVQFGRW2B1Zqg
Hw7sCpIgyarezV70maSDPHrF6ijwF+8jaa8uDXdPkmHpm25HvbNSseNOPiCRx742
FLknwpItlkZmEhrE+9c2QpVfESZqOfU+xsbP7ILyDPEyBEWGQjRaQMXffzroCUUD
aGHlSI6Myhi7ZOpg/42nwu/dTSWDmfXYmoJjTJbbm9VpX6loRI3NJFtOzZCBIia7
6rs+z9wKIv8=
=tfDs
-----END PGP SIGNATURE-----

--=-WA1cfMTj/HaaPOYAn/Vu--



--===============1307032082==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1307032082==--
