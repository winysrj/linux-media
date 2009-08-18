Return-path: <linux-media-owner@vger.kernel.org>
Received: from b186.blue.fastwebserver.de ([62.141.42.186]:59930 "EHLO
	mail.gw90.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501AbZHRKJS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 06:09:18 -0400
Subject: Re: dib0700 diversity support
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de>
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>
	 <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de>
	 <1250244562.5438.3.camel@mattotaupa.wohnung.familie-menzel.net>
	 <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-U+IxvDLSl3+sj4aVTip5"
Date: Tue, 18 Aug 2009 12:09:09 +0200
Message-Id: <1250590149.5938.33.camel@mattotaupa.wohnung.familie-menzel.net>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-U+IxvDLSl3+sj4aVTip5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Patrick,


Am Dienstag, den 18.08.2009, 10:54 +0200 schrieb Patrick Boettcher:
> On Fri, 14 Aug 2009, Paul Menzel wrote:
> >> I'll post a request for testing soon.
> >
> > I am looking forward to it.
>=20
> Can you please try the drivers from here:=20
> http://linuxtv.org/hg/~pb/v4l-dvb/

I installed it as described in [1].

        # clone
        make
        sudo make install
        sudo make unload
        # insert stick again

[1] http://sidux.com/module-Wikula-history-tag-TerraTec.html

Thanks for your work. Do I also need to update the firmware file?

> In the best case they improve the situation for you. In the worst case=20
> (not wanted :) ) it will degrade.

Ok, I do not know how to test this objectively. Not knowing what how to
do this, I just insert the console output of Kaffeine while scanning for
channels. See the end of this message.

In summary I would they I did not see any difference in quality between
the two versions at a bad reception spot. I thought the signal bar
showed values increased by 2=E2=80=934 %, so a little bit better.

I will test later at a better reception point.


Thanks for your work,

Paul


### Old Version 2.6.30.4, amd64 ###
=E2=80=A2 tested channel between 40 and 44 % signal shown by Kaffeine


/dev/dvb/adapter0/frontend0 : opened ( DiBcom 7000PC )
/dev/dvb/adapter1/frontend0 : opened ( DiBcom 7000PC )
0 EPG plugins loaded for device 0:0.
0 EPG plugins loaded for device 1:0.
Loaded epg data : 0 events (0 msecs)
Tuning to: TSID:769-SID:16408 / autocount: 0
DvbCam::probe(): /dev/dvb/adapter0/ca0: : Datei oder Verzeichnis nicht
gefunden
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 658000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
. LOCKED.
NOUT: 1
dvbEvents 0:0 started
Tuning delay: 850 ms
pipe opened
demux_wavpack: (open_wv_file:127) open_wv_file: non-seekable inputs
aren't supported yet.
xine pipe opened /home/paul/.kaxtv.ts
DvbCam::probe(): /dev/dvb/adapter1/ca0: : Datei oder Verzeichnis nicht
gefunden

Invalid section length or timeout: pid=3D17


Invalid section length or timeout: pid=3D0

dvbsi: The end :)
Channels found: 0
Asked to stop
pipe closed
Live stopped
dvbstream::run() end
dvbEvents 0:0 ended
fdDvr closed
Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 177500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
....... LOCKED.
Transponders: 1/57
scanMode=3D0
it's dvb 2!

Invalid section length or timeout: pid=3D17


Invalid section length or timeout: pid=3D0

Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 184500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 191500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 198500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 205500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 212500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 219500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 226500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 474000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 482000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 490000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 498000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 506000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
.. LOCKED.
Transponders: 13/57
scanMode=3D0
it's dvb 2!

Invalid section length or timeout: pid=3D17


Invalid section length or timeout: pid=3D0

Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 514000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 522000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
. LOCKED.
Transponders: 15/57
scanMode=3D0
it's dvb 2!

Invalid section length or timeout: pid=3D17


Invalid section length or timeout: pid=3D0

Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 530000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 538000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 546000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 554000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 562000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 570000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
. LOCKED.
Transponders: 21/57
scanMode=3D0
it's dvb 2!

Invalid section length or timeout: pid=3D17


Invalid section length or timeout: pid=3D0

Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 578000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 586000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 594000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 602000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 610000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 618000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 626000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 634000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 642000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 650000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 658000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
. LOCKED.
Transponders: 32/57
scanMode=3D0
it's dvb 2!
Reading SDT: pid=3D17
SAT.1: sid=3D16408
ProSieben: sid=3D16403
kabel eins: sid=3D16394
N24: sid=3D16398
Reading PAT: pid=3D0
Reading PMT: pid=3D384
Reading PMT: pid=3D304
Reading PMT: pid=3D160
Reading PMT: pid=3D224
Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 666000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 674000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 682000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 690000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 698000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 706000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 714000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 722000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 730000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 738000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 746000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 754000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 762000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 770000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 778000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
. LOCKED.
Transponders: 47/57
scanMode=3D0
it's dvb 2!

Invalid section length or timeout: pid=3D17


Invalid section length or timeout: pid=3D0

Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 786000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 794000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 802000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 810000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 818000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 826000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 834000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 842000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 850000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 858000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Transponders: 57
dvbsi: The end :)
Channels found: 0


### New version 12470:ff3b10cf5a95 ###
=E2=80=A2 tested channel between 42 and 48 %
=E2=80=A2 but no channel found by channel scan in Kaffeine

/dev/dvb/adapter0/frontend0 : opened ( DiBcom 7000PC )
/dev/dvb/adapter1/frontend0 : opened ( DiBcom 7000PC )
0 EPG plugins loaded for device 0:0.
0 EPG plugins loaded for device 1:0.
Loaded epg data : 0 events (0 msecs)
Tuning to: TSID:769-SID:16408 / autocount: 0
DvbCam::probe(): /dev/dvb/adapter0/ca0: : Datei oder Verzeichnis nicht
gefunden
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 658000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
. LOCKED.
NOUT: 1
dvbEvents 0:0 started
Tuning delay: 970 ms
pipe opened
demux_wavpack: (open_wv_file:127) open_wv_file: non-seekable inputs
aren't supported yet.
xine pipe opened /home/paul/.kaxtv.ts
out pipe closed
Asked to stop
Live stopped
dvbstream::run() end
dvbEvents 0:0 ended
fdDvr closed
Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 177500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 184500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 191500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 198500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 205500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 212500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 219500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 226500000 Hz
inv:2 bw:1 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 474000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 482000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 490000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 498000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 506000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
. LOCKED.
Transponders: 13/57
scanMode=3D0
it's dvb 2!

Invalid section length or timeout: pid=3D17


Invalid section length or timeout: pid=3D0

Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 514000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 522000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
. LOCKED.
Transponders: 15/57
scanMode=3D0
it's dvb 2!

Invalid section length or timeout: pid=3D17


Invalid section length or timeout: pid=3D0

Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 530000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 538000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 546000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 554000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 562000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 570000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 578000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 586000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 594000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 602000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 610000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 618000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 626000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 634000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 642000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 650000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 658000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
. LOCKED.
Transponders: 32/57
scanMode=3D0
it's dvb 2!

Invalid section length or timeout: pid=3D17


Invalid section length or timeout: pid=3D0

Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 666000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 674000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 682000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 690000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 698000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 706000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 714000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 722000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 730000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 738000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 746000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 754000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
. LOCKED.
Transponders: 44/57
scanMode=3D0
it's dvb 2!

Invalid section length or timeout: pid=3D17


Invalid section length or timeout: pid=3D0

Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 762000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 770000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 778000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
. LOCKED.
Transponders: 47/57
scanMode=3D0
it's dvb 2!

Invalid section length or timeout: pid=3D17


Invalid section length or timeout: pid=3D0

Frontend closed
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 786000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 794000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 802000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 810000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 818000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 826000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 834000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 842000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 850000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "DiBcom 7000PC"
tuning DVB-T to 858000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...............

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Transponders: 57
dvbsi: The end :)
Channels found: 0

--=-U+IxvDLSl3+sj4aVTip5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqKfcUACgkQPX1aK2wOHVh1xwCeNjSN+3c4tqmrHBUKHKlWPp80
33cAnAh9Jv9tmcrI6u+QnGuqtVJFjCZz
=3I8y
-----END PGP SIGNATURE-----

--=-U+IxvDLSl3+sj4aVTip5--

