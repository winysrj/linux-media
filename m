Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61682 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754057AbeAGRC1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 Jan 2018 12:02:27 -0500
MIME-Version: 1.0
Message-ID: <trinity-c1bacffc-c76f-448f-8e58-de25fdc7a331-1515344505269@3c-app-gmx-bs71>
From: "Josef Griebichler" <griebichler.josef@gmx.at>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Mauro Carvalho Chehab" <mchehab@s-opensource.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, "Eric Dumazet" <edumazet@google.com>,
        "Rik van Riel" <riel@redhat.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Hannes Frederic Sowa" <hannes@redhat.com>,
        "Jesper Dangaard Brouer" <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "David Miller" <davem@davemloft.net>, torvalds@linux-foundation.org
Subject: Aw: Re: dvb usb issues since kernel 4.9
Content-Type: multipart/mixed;
 boundary=kenitram-01954fda-fba2-4663-8b6c-b5b624ce1c5a
Date: Sun, 7 Jan 2018 18:01:45 +0100
In-Reply-To: <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
References: <20180107090336.03826df2@vento.lan>
 <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--kenitram-01954fda-fba2-4663-8b6c-b5b624ce1c5a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

here I provide lsusb from my affected hardware (technotrend s2-4600)=2E
http://ix=2Eio/DLY

With this hardware I had errors when recording with tvheadend=2E Livetv wa=
s ok, only channel switching made some problems sometimes=2E Please see att=
ached tvheadend service logs=2E

I also provide dmesg (libreelec on rpi3 with kernel 4=2E14=2E10 with rever=
t of the mentioned commit)=2E
http://ix=2Eio/DM2


Regards
Josef
=C2=A0
=C2=A0

Gesendet:=C2=A0Sonntag, 07=2E Januar 2018 um 16:41 Uhr
Von:=C2=A0"Alan Stern" <stern@rowland=2Eharvard=2Eedu>
An:=C2=A0"Mauro Carvalho Chehab" <mchehab@s-opensource=2Ecom>
Cc:=C2=A0"Josef Griebichler" <griebichler=2Ejosef@gmx=2Eat>, "Greg Kroah-H=
artman" <gregkh@linuxfoundation=2Eorg>, linux-usb@vger=2Ekernel=2Eorg, "Eri=
c Dumazet" <edumazet@google=2Ecom>, "Rik van Riel" <riel@redhat=2Ecom>, "Pa=
olo Abeni" <pabeni@redhat=2Ecom>, "Hannes Frederic Sowa" <hannes@redhat=2Ec=
om>, "Jesper Dangaard Brouer" <jbrouer@redhat=2Ecom>, linux-kernel <linux-k=
ernel@vger=2Ekernel=2Eorg>, netdev <netdev@vger=2Ekernel=2Eorg>, "Jonathan =
Corbet" <corbet@lwn=2Enet>, LMML <linux-media@vger=2Ekernel=2Eorg>, "Peter =
Zijlstra" <peterz@infradead=2Eorg>, "David Miller" <davem@davemloft=2Enet>,=
 torvalds@linux-foundation=2Eorg
Betreff:=C2=A0Re: dvb usb issues since kernel 4=2E9
On Sun, 7 Jan 2018, Mauro Carvalho Chehab wrote: > > > It seems that the o=
riginal patch were designed to solve some IRQ issues > > > with network car=
ds with causes data losses on high traffic=2E However, > > > it is also cau=
sing bad effects on sustained high bandwidth demands > > > required by DVB =
cards, at least on some USB host drivers=2E > > > > > > Alan/Greg/Eric/Davi=
d: > > > > > > Any ideas about how to fix it without causing regressions to=
 > > > network? > > > > It would be good to know what hardware was involved=
 on the x86 system > > and to have some timing data=2E Can we see the outpu=
t from lsusb and > > usbmon, running on a vanilla kernel that gets plenty o=
f video glitches? > > From Josef's report, and from the BZ, the affected ha=
rdware seems > to be based on Montage Technology M88DS3103/M88TS2022 chipse=
t=2E What type of USB host controller does the x86_64 system use? EHCI or x=
HCI? > The driver it uses is at drivers/media/usb/dvb-usb-v2/dvbsky=2Ec, > =
with shares a USB implementation that is used by a lot more drivers=2E > Th=
e URB handling code is at: > > drivers/media/usb/dvb-usb-v2/usb_urb=2Ec > >=
 This particular driver allocates 8 buffers with 4096 bytes each > for bulk=
 transfers, using transfer_flags =3D URB_NO_TRANSFER_DMA_MAP=2E > > This be=
come a popular USB hardware nowadays=2E I have one S960c > myself, so I can=
 send you the lsusb from it=2E You should notice, however, > that a DVB-C/D=
VB-S2 channel can easily provide very high sustained bit > rates=2E Here, o=
n my DVB-S2 provider, a typical transponder produces 58 Mpps > of payload a=
fter removing URB headers=2E You mentioned earlier that the driver uses bul=
k transfers=2E In USB-2=2E0, the maximum possible payload data transfer rat=
e using bulk transfers is 53248 bytes/ms, which is 53=2E248 MB/s (i=2Ee=2E,=
 lower than 58 MB/s)=2E And even this is possible only if almost nothing el=
se is using the bus at the same time=2E > A 10 minutes record with the > en=
tire data (with typically contains 5-10 channels) can easily go > above 4 G=
B, just to reproduce 1-2 glitches=2E So, I'm not sure if > a usbmon dump wo=
uld be useful=2E It might not be helpful at all=2E However, I'm not interes=
ted in the payload data (which would be unintelligible to me anyway) but ra=
ther the timing of URB submissions and completions=2E A usbmon trace which =
didn't keep much of the payload data would only require on the order of 50 =
MB per minute -- and Josef said that glitches usually would show up within =
a minute or so=2E > I'm enclosing the lsusb from a S960C device, with is ba=
sed on those > Montage chipsets: What I wanted to see was the output from "=
lsusb" on the affected system, not the output from "lsusb -v -s B:D" on you=
r system=2E > > Overall, this may be a very difficult problem to solve=2E T=
he > > 4cd13c21b207 commit was intended to improve throughput at the cost o=
f > > increased latency=2E But then what do you do when the latency becomes=
 > > too high for the video subsystem to handle? > > Latency can't be too h=
igh, otherwise frames will be dropped=2E Yes, that's the whole point=2E > E=
ven if the Kernel itself doesn't drop, if the delay goes higher > than a ce=
rtain threshold, userspace will need to drop, as it > should be presenting =
audio and video on real time=2E Yet, typically, > userspace will delay it b=
y one or two seconds, with would mean > 1500-3500 buffers, with I suspect i=
t is a lot more than the hardware > limits=2E So I suspect that the hardwar=
e starves free buffers a way > before userspace, as media hardware don't ha=
ve unlimited buffers > inside them, as they assume that the Kernel/userspac=
e will be fast > enough to sustain bit rates up to 66 Mbps of payload=2E Th=
e timing information would tell us how large the latency is=2E In any case,=
 you might be able to attack the problem simply by using more than 8 buffer=
s=2E With just eight 4096-byte buffers, the total pipeline capacity is only=
 about 0=2E62 ms (at the maximum possible transfer rate)=2E Increasing the =
number of buffers to 65 would give a capacity of 5 ms, which is probably a =
lot better suited for situations where completions are handled by the ksoft=
irqd thread=2E > Perhaps media drivers could pass some quirk similar to URB=
_ISO_ASAP, > in order to revert the kernel logic to prioritize latency inst=
ead of > throughput=2E It can't be done without pervasive changes to the US=
B subsystem, which I would greatly prefer to avoid=2E Besides, this wouldn'=
t really solve the problem=2E Decreasing the latency for one device will ca=
use it to be increased for others=2E Alan Stern
--kenitram-01954fda-fba2-4663-8b6c-b5b624ce1c5a
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=service.log

2017-01-16 16:30:22.749 [   INFO] main: Log started
2017-01-16 16:30:22.756 [   INFO] http: Starting HTTP server 0.0.0.0:9981
2017-01-16 16:30:22.756 [   INFO] htsp: Starting HTSP server 0.0.0.0:9982
2017-01-16 16:30:22.757 [  ERROR] satips: use --satip_bindaddr parameter to select the local IP for SAT>IP
2017-01-16 16:30:22.757 [  ERROR] satips: using Google lookup (might block the task until timeout)
2017-01-16 16:30:22.797 [   INFO] config: loaded
2017-01-16 16:30:22.801 [   INFO] config: scanfile (re)initialization with path <none>
2017-01-16 16:30:24.211 [   INFO] scanfile: DVB-S - loaded 1 regions with 112 networks
2017-01-16 16:30:24.211 [   INFO] scanfile: DVB-T - loaded 43 regions with 1106 networks
2017-01-16 16:30:24.211 [   INFO] scanfile: DVB-C - loaded 17 regions with 56 networks
2017-01-16 16:30:24.211 [   INFO] scanfile: ATSC-T - loaded 2 regions with 9 networks
2017-01-16 16:30:24.211 [   INFO] scanfile: ATSC-C - loaded 1 regions with 5 networks
2017-01-16 16:30:24.211 [   INFO] scanfile: ISDB-T - loaded 2 regions with 1297 networks
2017-01-16 16:30:24.817 [   INFO] linuxdvb: adapter added /dev/dvb/adapter0
2017-01-16 16:30:24.925 [   INFO] dvr: Creating new configuration ''
2017-01-16 16:30:24.925 [   INFO] dvr: Creating new configuration ''
2017-01-16 16:30:24.925 [  ERROR] dvr: Unable to create second default config, removing
2017-01-16 16:30:24.932 [   INFO] capmt: Oscam active
2017-01-16 16:30:24.932 [   INFO] descrambler: adding CAID 2600 as constant crypto-word (BISS)
2017-01-16 16:30:24.932 [   INFO] epggrab: module eit created
2017-01-16 16:30:24.932 [   INFO] epggrab: module uk_freesat created
2017-01-16 16:30:24.932 [  ERROR] capmt: Oscam: Cannot connect to 127.0.0.1:9000 (Connection refused); Do you have OSCam running?
2017-01-16 16:30:24.932 [   INFO] capmt: Oscam: Automatic reconnection attempt in in 60 seconds
2017-01-16 16:30:24.932 [   INFO] epggrab: module uk_freeview created
2017-01-16 16:30:24.933 [   INFO] epggrab: module viasat_baltic created
2017-01-16 16:30:24.933 [   INFO] epggrab: module Bulsatcom_39E created
2017-01-16 16:30:24.933 [   INFO] epggrab: module psip created
2017-01-16 16:30:24.948 [   INFO] epggrab: module opentv-ausat created
2017-01-16 16:30:24.948 [   INFO] epggrab: module opentv-skyuk created
2017-01-16 16:30:24.949 [   INFO] epggrab: module opentv-skyit created
2017-01-16 16:30:24.951 [   INFO] epggrab: module opentv-skynz created
2017-01-16 16:30:24.952 [   INFO] epggrab: module pyepg created
2017-01-16 16:30:24.952 [   INFO] epggrab: module xmltv created
2017-01-16 16:30:24.957 [   INFO] spawn: Executing "/storage/.kodi/addons/service.tvheadend42/bin/tv_grab_file"
2017-01-16 16:30:24.963 [   INFO] epggrab: module /storage/.kodi/addons/service.tvheadend42/bin/tv_grab_file created
2017-01-16 16:30:25.074 [   INFO] epgdb: gzip format detected, inflating (ratio 17.3% deflated size 2995068)
2017-01-16 16:30:25.308 [   INFO] epgdb: parsing 17344211 bytes
2017-01-16 16:30:26.471 [   INFO] epgdb: loaded v2
2017-01-16 16:30:26.471 [   INFO] epgdb:   config     1
2017-01-16 16:30:26.471 [   INFO] epgdb:   brands     0
2017-01-16 16:30:26.471 [   INFO] epgdb:   seasons    0
2017-01-16 16:30:26.471 [   INFO] epgdb:   episodes   24310
2017-01-16 16:30:26.471 [   INFO] epgdb:   broadcasts 22479
2017-01-16 16:30:26.526 [ NOTICE] START: HTS Tvheadend version 4.1.2401 ~ LibreELEC Tvh-addon v8.1.108-#0110-milhouse-v4.1-2413-g489ba95 started, running as PID:419 UID:0 GID:39, CWD:/ CNF:/storage/.kodi/userdata/addon_data/service.tvheadend42
2017-01-16 16:30:26.530 [   INFO] mpegts: 10773.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:30:26.567 [   INFO] subscription: 0001: "epggrab" subscribing to mux "10773.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 16:30:28.262 [   INFO] htsp: Got connection from 127.0.0.1
2017-01-16 16:30:28.265 [   INFO] htsp: 127.0.0.1: Welcomed client software: Kodi Media Center (HTSPv25)
2017-01-16 16:30:28.273 [   INFO] htsp: 127.0.0.1 [ Kodi Media Center ]: Identified as user ''
2017-01-16 16:30:37.216 [   INFO] subscription: 0001: "epggrab" unsubscribing
2017-01-16 16:30:38.120 [   INFO] mpegts: 10891.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:30:38.139 [   INFO] subscription: 0003: "epggrab" subscribing to mux "10891.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 16:31:06.560 [   INFO] subscription: 0003: "epggrab" unsubscribing
2017-01-16 16:31:07.546 [   INFO] mpegts: 10920.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:31:07.565 [   INFO] subscription: 0005: "epggrab" subscribing to mux "10920.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 16:31:17.990 [   INFO] subscription: 0005: "epggrab" unsubscribing
2017-01-16 16:31:18.956 [   INFO] mpegts: 11052.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:31:18.975 [   INFO] subscription: 0007: "epggrab" subscribing to mux "11052.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 16:31:24.903 [   INFO] capmt: Oscam: mode 5 connected to 127.0.0.1:9000 (single)
2017-01-16 16:31:24.904 [   INFO] capmt: Oscam: Connected to server 'OSCam v1.20-unstable_svn, build r (armv7ve-libreelec-linux-gnueabi)' (protocol version 2)
2017-01-16 16:31:45.461 [   INFO] subscription: 0007: "epggrab" unsubscribing
2017-01-16 16:31:46.405 [   INFO] mpegts: 11243.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:31:46.423 [   INFO] subscription: 0009: "epggrab" subscribing to mux "11243.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 16:32:14.211 [   INFO] subscription: 0009: "epggrab" unsubscribing
2017-01-16 16:32:14.745 [   INFO] mpegts: 11302.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:32:14.765 [   INFO] capmt: Oscam: Starting CAPMT server for service "ORF1 HD" on adapter 0
2017-01-16 16:32:14.766 [   INFO] subscription: 000B: "127.0.0.1 [  | Kodi Media Center ]" subscribing on channel "ORF1 HD", weight: 150, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "11302.75H", provider: "ORF", service: "ORF1 HD", profile="htsp", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-16 16:32:15.486 [WARNING] tbl-eit: eit: 11302.75H in Astra 19,2: invalid checksum (len 1846, errors 1)
2017-01-16 16:32:15.561 [WARNING] tbl-base: pmt: 11302.75H in Astra 19,2: invalid checksum (len 164, errors 1)
2017-01-16 16:32:16.894 [WARNING] TS: Astra 19,2/11302.75H/ORF1 HD Transport error indicator (total 1)
2017-01-16 16:32:17.329 [  ERROR] descrambler: cannot decode packets for service "ORF1 HD"
2017-01-16 16:32:20.488 [WARNING] tbl-base: nit: 11302.75H in Astra 19,2: invalid checksum (len 1023, errors 1)
2017-01-16 16:32:21.038 [WARNING] tbl-base: pat: 11302.75H in Astra 19,2: invalid checksum (len 36, errors 1)
2017-01-16 16:32:22.888 [   INFO] subscription: 000B: "127.0.0.1 [  | Kodi Media Center ]" unsubscribing from "ORF1 HD", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-16 16:32:23.848 [   INFO] mpegts: 11302.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:32:23.866 [   INFO] subscription: 000D: "epggrab" subscribing to mux "11302.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 16:32:24.628 [   INFO] mpegts: 11273.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:32:24.632 [   INFO] subscription: 000D: "epggrab" unsubscribing
2017-01-16 16:32:24.651 [   INFO] capmt: Oscam: Starting CAPMT server for service "ORF SPORT+ HD" on adapter 0
2017-01-16 16:32:24.651 [   INFO] subscription: 000F: "127.0.0.1 [  | Kodi Media Center ]" subscribing on channel "ORF SPORT+ HD", weight: 150, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "11273.25H", provider: "ORF", service: "ORF SPORT+ HD", profile="htsp", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-16 16:39:44.768 [   INFO] subscription: 000F: "127.0.0.1 [  | Kodi Media Center ]" unsubscribing from "ORF SPORT+ HD", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-16 16:39:50.867 [   INFO] mpegts: 12051V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:39:50.927 [   INFO] capmt: Oscam: Starting CAPMT server for service "PULS 4 Austria" on adapter 0
2017-01-16 16:39:50.927 [   INFO] subscription: 0018: "127.0.0.1 [  | Kodi Media Center ]" subscribing on channel "PULS 4 Austria", weight: 150, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "12051V", provider: "ProSiebenSat.1", service: "PULS 4 Austria", profile="htsp", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-16 16:39:51.905 [WARNING] TS: Astra 19,2/12051V/PULS 4 Austria: TELETEXT @ #39 Continuity counter error (total 1)
2017-01-16 16:53:35.037 [   INFO] subscription: 0018: "127.0.0.1 [  | Kodi Media Center ]" unsubscribing from "PULS 4 Austria", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-16 16:53:35.041 [   INFO] mpegts: 11273.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:53:35.064 [   INFO] capmt: Oscam: Starting CAPMT server for service "ORF SPORT+ HD" on adapter 0
2017-01-16 16:53:35.064 [   INFO] subscription: 0026: "127.0.0.1 [  | Kodi Media Center ]" subscribing on channel "ORF SPORT+ HD", weight: 150, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "11273.25H", provider: "ORF", service: "ORF SPORT+ HD", profile="htsp", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-16 16:53:52.671 [   INFO] subscription: 0026: "127.0.0.1 [  | Kodi Media Center ]" unsubscribing from "ORF SPORT+ HD", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-16 16:53:53.637 [   INFO] mpegts: 11302.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:53:53.656 [   INFO] subscription: 0027: "epggrab" subscribing to mux "11302.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 16:54:09.382 [   INFO] dvr: entry adcf886064fc4846648169c93f3223d6 "Film um 4: Verlobung auf Umwegen" on "PULS 4 Austria" starting at 2017-01-16 15:54:20, scheduled for recording by "127.0.0.1"
2017-01-16 16:54:09.382 [   INFO] dvr: "Film um 4: Verlobung auf Umwegen" on "PULS 4 Austria" recorder starting
2017-01-16 16:54:09.383 [   INFO] mpegts: 12051V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 16:54:09.385 [   INFO] subscription: 0027: "epggrab" unsubscribing
2017-01-16 16:54:09.426 [   INFO] capmt: Oscam: Starting CAPMT server for service "PULS 4 Austria" on adapter 0
2017-01-16 16:54:09.427 [   INFO] subscription: 0029: "DVR: Film um 4: Verlobung auf Umwegen" subscribing on channel "PULS 4 Austria", weight: 300, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "12051V", provider: "ProSiebenSat.1", service: "PULS 4 Austria", profile="pass"
2017-01-16 16:54:10.278 [   INFO] dvr: /storage/recordings/Film um 4_ Verlobung auf Umwegen.ts from adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "12051V", provider: "ProSiebenSat.1", service: "PULS 4 Austria"
2017-01-16 16:54:10.278 [   INFO] dvr:  #  type              lang  resolution  aspect ratio  sample rate  channels
2017-01-16 16:54:10.278 [   INFO] dvr:  1  TELETEXT                                                                 
2017-01-16 16:54:10.278 [   INFO] dvr:  2  MPEG2VIDEO              720x576     ?                                    
2017-01-16 16:54:10.278 [   INFO] dvr:  3  MPEG2AUDIO        ger                             ?            ?         
2017-01-16 16:54:10.278 [   INFO] dvr:  4  CA                                                                       
2017-01-16 16:54:10.278 [   INFO] dvr:  5  CA                                                                       
2017-01-16 16:54:10.278 [   INFO] dvr:  6  CA                                                                       
2017-01-16 16:54:10.278 [   INFO] dvr:  7  CA                                                                       
2017-01-16 16:54:10.278 [   INFO] dvr:  8  CA                                                                       
2017-01-16 16:54:10.278 [   INFO] dvr:  9  CA                                                                       
2017-01-16 16:54:10.278 [   INFO] dvr: 10  CA                                                                       
2017-01-16 16:54:46.512 [   INFO] htsp: Got connection from 127.0.0.1
2017-01-16 16:54:46.512 [   INFO] htsp: 127.0.0.1: Welcomed client software: Kodi Media Center (HTSPv25)
2017-01-16 16:54:46.514 [   INFO] htsp: 127.0.0.1 [ Kodi Media Center ]: Identified as user ''
2017-01-16 16:54:47.611 [   INFO] htsp: 127.0.0.1 [  | Kodi Media Center ]: Disconnected
2017-01-16 16:54:50.514 [   INFO] htsp: 127.0.0.1 [  | Kodi Media Center ]: Disconnected
2017-01-16 16:55:04.516 [   INFO] htsp: Got connection from 127.0.0.1
2017-01-16 16:55:04.516 [   INFO] htsp: 127.0.0.1: Welcomed client software: Kodi Media Center (HTSPv25)
2017-01-16 16:55:04.518 [   INFO] htsp: 127.0.0.1 [ Kodi Media Center ]: Identified as user ''
2017-01-16 17:30:22.000 [   INFO] epgdb: snapshot start
2017-01-16 17:30:22.727 [   INFO] epgdb: queued to save (size 16168596)
2017-01-16 17:30:22.727 [   INFO] epgdb:   brands     0
2017-01-16 17:30:22.727 [   INFO] epgdb:   seasons    0
2017-01-16 17:30:22.727 [   INFO] epgdb: save start
2017-01-16 17:30:22.727 [   INFO] epgdb:   episodes   22996
2017-01-16 17:30:22.727 [   INFO] epgdb:   broadcasts 22996
2017-01-16 17:30:23.848 [   INFO] epgdb: stored (size 2737648)
2017-01-16 17:37:39.388 [WARNING] TS: Astra 19,2/12051V/PULS 4 Austria: MPEG2VIDEO @ #1791 Continuity counter error (total 1)
2017-01-16 17:37:39.388 [WARNING] TS: Astra 19,2/12051V/PULS 4 Austria: TELETEXT @ #39 Continuity counter error (total 1)
2017-01-16 17:37:39.388 [WARNING] TS: Astra 19,2/12051V/PULS 4 Austria: MPEG2AUDIO @ #1792 Continuity counter error (total 1)
2017-01-16 17:50:53.141 [   INFO] subscription: 0029: "DVR: Film um 4: Verlobung auf Umwegen" unsubscribing from "PULS 4 Austria"
2017-01-16 17:50:53.144 [   INFO] dvr: "Film um 4: Verlobung auf Umwegen" on "PULS 4 Austria": End of program: Completed OK
2017-01-16 17:51:56.769 [   INFO] mpegts: 11302.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:51:56.808 [   INFO] subscription: 0061: "epggrab" subscribing to mux "11302.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:52:24.271 [   INFO] subscription: 0061: "epggrab" unsubscribing
2017-01-16 17:52:25.263 [   INFO] mpegts: 11361.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:52:25.282 [   INFO] subscription: 0063: "epggrab" subscribing to mux "11361.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:52:34.727 [   INFO] subscription: 0063: "epggrab" unsubscribing
2017-01-16 17:52:35.694 [   INFO] mpegts: 11420.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:52:35.713 [   INFO] subscription: 0065: "epggrab" subscribing to mux "11420.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:52:46.306 [   INFO] subscription: 0065: "epggrab" unsubscribing
2017-01-16 17:52:47.304 [   INFO] mpegts: 11493.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:52:47.324 [   INFO] subscription: 0067: "epggrab" subscribing to mux "11493.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:53:14.281 [   INFO] subscription: 0067: "epggrab" unsubscribing
2017-01-16 17:53:15.228 [   INFO] mpegts: 11582.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:53:15.246 [   INFO] subscription: 0069: "epggrab" subscribing to mux "11582.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:53:43.071 [   INFO] subscription: 0069: "epggrab" unsubscribing
2017-01-16 17:53:44.052 [   INFO] mpegts: 11670.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:53:44.071 [   INFO] subscription: 006B: "epggrab" subscribing to mux "11670.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:53:54.805 [   INFO] subscription: 006B: "epggrab" unsubscribing
2017-01-16 17:53:55.762 [   INFO] mpegts: 12148.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:53:55.803 [   INFO] subscription: 006D: "epggrab" subscribing to mux "12148.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:54:06.298 [   INFO] subscription: 006D: "epggrab" unsubscribing
2017-01-16 17:54:07.272 [   INFO] mpegts: 12187.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:54:07.313 [   INFO] subscription: 006F: "epggrab" subscribing to mux "12187.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:54:23.361 [   INFO] subscription: 006F: "epggrab" unsubscribing
2017-01-16 17:54:24.315 [   INFO] mpegts: 12226.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:54:24.355 [   INFO] subscription: 0071: "epggrab" subscribing to mux "12226.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:54:38.315 [   INFO] subscription: 0071: "epggrab" unsubscribing
2017-01-16 17:54:39.301 [   INFO] mpegts: 12265.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:54:39.342 [   INFO] subscription: 0073: "epggrab" subscribing to mux "12265.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:55:07.105 [   INFO] subscription: 0073: "epggrab" unsubscribing
2017-01-16 17:55:08.103 [   INFO] mpegts: 12304.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:55:08.144 [   INFO] subscription: 0075: "epggrab" subscribing to mux "12304.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:55:18.490 [   INFO] subscription: 0075: "epggrab" unsubscribing
2017-01-16 17:55:19.436 [   INFO] mpegts: 12421.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:55:19.477 [   INFO] subscription: 0077: "epggrab" subscribing to mux "12421.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:55:47.325 [   INFO] subscription: 0077: "epggrab" unsubscribing
2017-01-16 17:55:48.262 [   INFO] mpegts: 12460.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:55:48.303 [   INFO] subscription: 0079: "epggrab" subscribing to mux "12460.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:55:58.805 [   INFO] subscription: 0079: "epggrab" unsubscribing
2017-01-16 17:55:59.772 [   INFO] mpegts: 12662.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 17:55:59.812 [   INFO] subscription: 007B: "epggrab" subscribing to mux "12662.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 17:56:00.851 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 1183, errors 1)
2017-01-16 17:56:10.776 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 152, errors 59)
2017-01-16 17:56:15.992 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 3, errors 1)
2017-01-16 17:56:21.293 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 55, errors 114)
2017-01-16 17:56:24.970 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1012, errors 1)
2017-01-16 17:56:26.503 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 2)
2017-01-16 17:56:31.701 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 160, errors 155)
2017-01-16 17:56:34.359 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 1)
2017-01-16 17:56:41.731 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 289, errors 201)
2017-01-16 17:56:41.732 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 3, errors 4)
2017-01-16 17:56:52.226 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 58, errors 242)
2017-01-16 17:56:52.721 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 6)
2017-01-16 17:57:02.694 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 3702, errors 300)
2017-01-16 17:57:04.843 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 111, errors 2)
2017-01-16 17:57:05.924 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 2)
2017-01-16 17:57:12.636 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 111, errors 341)
2017-01-16 17:57:16.780 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 9)
2017-01-16 17:57:23.122 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 2973, errors 389)
2017-01-16 17:57:27.347 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 11)
2017-01-16 17:57:33.127 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 731, errors 449)
2017-01-16 17:57:43.647 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 245, errors 499)
2017-01-16 17:57:46.727 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 3)
2017-01-16 17:57:49.367 [WARNING] tbl-base: bat: 12662.75H in Astra 19,2: invalid checksum (len 60, errors 1)
2017-01-16 17:57:49.368 [WARNING] tbl-base: sdt: 12662.75H in Astra 19,2: invalid checksum (len 60, errors 1)
2017-01-16 17:57:54.030 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 1083, errors 545)
2017-01-16 17:57:54.030 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 13)
2017-01-16 17:58:03.979 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 1049, errors 596)
2017-01-16 17:58:05.083 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 16)
2017-01-16 17:58:12.388 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 4)
2017-01-16 17:58:14.068 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 3008, errors 641)
2017-01-16 17:58:16.217 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 3, errors 20)
2017-01-16 17:58:24.515 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 3299, errors 686)
2017-01-16 17:58:29.670 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 5)
2017-01-16 17:58:34.962 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 308, errors 738)
2017-01-16 17:58:40.153 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 3)
2017-01-16 17:58:40.711 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 22)
2017-01-16 17:58:44.917 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 4030, errors 789)
2017-01-16 17:58:47.017 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 6)
2017-01-16 17:58:51.150 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 27, errors 4)
2017-01-16 17:58:55.422 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 2341, errors 838)
2017-01-16 17:58:57.528 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 3, errors 23)
2017-01-16 17:59:02.212 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 3, errors 5)
2017-01-16 17:59:05.822 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 815, errors 885)
2017-01-16 17:59:13.197 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 8)
2017-01-16 17:59:15.938 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 3342, errors 929)
2017-01-16 17:59:16.340 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 27)
2017-01-16 17:59:26.348 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 1907, errors 980)
2017-01-16 17:59:26.850 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1012, errors 9)
2017-01-16 17:59:29.538 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 29)
2017-01-16 17:59:34.149 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 17, errors 6)
2017-01-16 17:59:36.888 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 1928, errors 1036)
2017-01-16 17:59:42.160 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 32)
2017-01-16 17:59:47.368 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 58, errors 1086)
2017-01-16 17:59:49.456 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 111, errors 11)
2017-01-16 17:59:54.079 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 34)
2017-01-16 17:59:58.285 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 252, errors 1145)
2017-01-16 18:00:04.590 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 37)
2017-01-16 18:00:08.785 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 1733, errors 1190)
2017-01-16 18:00:15.103 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 8)
2017-01-16 18:00:18.784 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 994, errors 1226)
2017-01-16 18:00:22.410 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 38)
2017-01-16 18:00:27.713 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1012, errors 12)
2017-01-16 18:00:28.711 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 2309, errors 1281)
2017-01-16 18:00:39.156 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 620, errors 1332)
2017-01-16 18:00:45.026 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1012, errors 13)
2017-01-16 18:00:49.243 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 1083, errors 1378)
2017-01-16 18:00:52.798 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 39)
2017-01-16 18:00:59.671 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 2977, errors 1433)
2017-01-16 18:01:02.239 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 9)
2017-01-16 18:01:09.648 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 2031, errors 1485)
2017-01-16 18:01:10.210 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 43)
2017-01-16 18:01:13.309 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 11)
2017-01-16 18:01:14.801 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 14)
2017-01-16 18:01:19.675 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 505, errors 1534)
2017-01-16 18:01:21.140 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 46)
2017-01-16 18:01:29.066 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 12)
2017-01-16 18:01:30.159 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 2263, errors 1590)
2017-01-16 18:01:32.286 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 16)
2017-01-16 18:01:40.544 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 940, errors 1649)
2017-01-16 18:01:50.479 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 3186, errors 1692)
2017-01-16 18:01:52.155 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 48)
2017-01-16 18:02:00.990 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 268, errors 1741)
2017-01-16 18:02:02.574 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 3, errors 51)
2017-01-16 18:02:11.498 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 553, errors 1789)
2017-01-16 18:02:12.500 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 53)
2017-01-16 18:02:15.702 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 14)
2017-01-16 18:02:21.913 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 399, errors 1844)
2017-01-16 18:02:26.671 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 56)
2017-01-16 18:02:32.023 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 1735, errors 1878)
2017-01-16 18:02:32.975 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 18)
2017-01-16 18:02:40.390 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 74, errors 57)
2017-01-16 18:02:42.390 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 136, errors 1937)
2017-01-16 18:02:46.630 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 15)
2017-01-16 18:02:52.339 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 656, errors 1989)
2017-01-16 18:02:55.002 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1012, errors 19)
2017-01-16 18:03:02.427 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 218, errors 2042)
2017-01-16 18:03:02.818 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 60)
2017-01-16 18:03:12.871 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1012, errors 20)
2017-01-16 18:03:12.871 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 262, errors 2094)
2017-01-16 18:03:20.224 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 170, errors 61)
2017-01-16 18:03:23.356 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 280, errors 2133)
2017-01-16 18:03:24.864 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 21)
2017-01-16 18:03:30.676 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 63)
2017-01-16 18:03:33.761 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 238, errors 2190)
2017-01-16 18:03:43.780 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 1761, errors 2252)
2017-01-16 18:03:47.467 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1012, errors 22)
2017-01-16 18:03:50.685 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 17)
2017-01-16 18:03:54.188 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 262, errors 2310)
2017-01-16 18:04:01.596 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 18)
2017-01-16 18:04:04.288 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 58, errors 2357)
2017-01-16 18:04:13.679 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 55, errors 67)
2017-01-16 18:04:14.704 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 354, errors 2410)
2017-01-16 18:04:16.743 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 20)
2017-01-16 18:04:24.619 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 2244, errors 2460)
2017-01-16 18:04:25.719 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 24)
2017-01-16 18:04:27.331 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 69)
2017-01-16 18:04:34.678 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 2877, errors 2519)
2017-01-16 18:04:38.768 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 71)
2017-01-16 18:04:40.897 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 21)
2017-01-16 18:04:45.118 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 2966, errors 2579)
2017-01-16 18:04:54.593 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 20, errors 74)
2017-01-16 18:04:55.045 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 113, errors 2623)
2017-01-16 18:05:01.351 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 48, errors 22)
2017-01-16 18:05:06.127 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 521, errors 2681)
2017-01-16 18:05:08.202 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 74, errors 77)
2017-01-16 18:05:14.524 [WARNING] tbl-base: cat: 12662.75H in Astra 19,2: invalid checksum (len 3, errors 23)
2017-01-16 18:05:16.062 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 1185, errors 2723)
2017-01-16 18:05:26.467 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 3361, errors 2761)
2017-01-16 18:05:33.359 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 157, errors 78)
2017-01-16 18:05:34.874 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 25)
2017-01-16 18:05:36.572 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 57, errors 2808)
2017-01-16 18:05:46.989 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 1600, errors 2862)
2017-01-16 18:05:49.591 [WARNING] tbl-base: pat: 12662.75H in Astra 19,2: invalid checksum (len 124, errors 81)
2017-01-16 18:05:52.255 [WARNING] tbl-base: nit: 12662.75H in Astra 19,2: invalid checksum (len 1023, errors 27)
2017-01-16 18:05:57.455 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 656, errors 2920)
2017-01-16 18:06:07.405 [WARNING] tbl-eit: eit: 12662.75H in Astra 19,2: invalid checksum (len 292, errors 2980)
2017-01-16 18:06:09.772 [WARNING] epggrab: EIT: DVB Grabber - data completion timeout for 12662.75H in Astra 19,2
2017-01-16 18:06:09.772 [   INFO] subscription: 007B: "epggrab" unsubscribing
2017-01-16 18:06:10.773 [   INFO] mpegts: 10773.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:06:10.791 [   INFO] subscription: 0080: "epggrab" subscribing to mux "10773.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:06:23.523 [WARNING] linuxdvb: TechnoTrend S2-4600 - retune
2017-01-16 18:06:34.432 [   INFO] subscription: 0080: "epggrab" unsubscribing
2017-01-16 18:06:35.424 [   INFO] mpegts: 10891.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:06:35.444 [   INFO] subscription: 0082: "epggrab" subscribing to mux "10891.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:07:03.680 [   INFO] subscription: 0082: "epggrab" unsubscribing
2017-01-16 18:07:04.651 [   INFO] mpegts: 10920.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:07:04.671 [   INFO] subscription: 0084: "epggrab" subscribing to mux "10920.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:07:05.262 [WARNING] tbl-eit: eit: 10920.75H in Astra 19,2: invalid checksum (len 673, errors 1)
2017-01-16 18:07:15.409 [   INFO] subscription: 0084: "epggrab" unsubscribing
2017-01-16 18:07:16.362 [   INFO] mpegts: 11052.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:07:16.381 [   INFO] subscription: 0086: "epggrab" subscribing to mux "11052.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:07:43.602 [   INFO] subscription: 0086: "epggrab" unsubscribing
2017-01-16 18:07:44.591 [   INFO] mpegts: 11243.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:07:44.611 [   INFO] subscription: 0088: "epggrab" subscribing to mux "11243.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:08:11.120 [   INFO] subscription: 0088: "epggrab" unsubscribing
2017-01-16 18:08:12.117 [   INFO] mpegts: 11273.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:08:12.136 [   INFO] subscription: 008A: "epggrab" subscribing to mux "11273.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:08:47.327 [   INFO] subscription: 008A: "epggrab" unsubscribing
2017-01-16 18:08:48.248 [   INFO] mpegts: 11302.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:08:48.267 [   INFO] subscription: 008C: "epggrab" subscribing to mux "11302.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:09:39.604 [   INFO] subscription: 008C: "epggrab" unsubscribing
2017-01-16 18:09:40.595 [   INFO] mpegts: 11361.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:09:40.614 [   INFO] subscription: 008E: "epggrab" subscribing to mux "11361.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:09:54.536 [   INFO] subscription: 008E: "epggrab" unsubscribing
2017-01-16 18:09:55.528 [   INFO] mpegts: 11420.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:09:55.547 [   INFO] subscription: 0090: "epggrab" subscribing to mux "11420.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:10:05.974 [   INFO] subscription: 0090: "epggrab" unsubscribing
2017-01-16 18:10:06.960 [   INFO] mpegts: 11493.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:10:06.979 [   INFO] subscription: 0092: "epggrab" subscribing to mux "11493.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:10:33.687 [   INFO] subscription: 0092: "epggrab" unsubscribing
2017-01-16 18:10:34.641 [   INFO] mpegts: 11582.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:10:34.660 [   INFO] subscription: 0094: "epggrab" subscribing to mux "11582.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:11:02.300 [   INFO] subscription: 0094: "epggrab" unsubscribing
2017-01-16 18:11:03.267 [   INFO] mpegts: 11670.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:11:03.287 [   INFO] subscription: 0096: "epggrab" subscribing to mux "11670.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:11:13.923 [   INFO] subscription: 0096: "epggrab" unsubscribing
2017-01-16 18:11:14.876 [   INFO] mpegts: 12148.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:11:14.917 [   INFO] subscription: 0098: "epggrab" subscribing to mux "12148.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:11:25.315 [   INFO] subscription: 0098: "epggrab" unsubscribing
2017-01-16 18:11:26.285 [   INFO] mpegts: 12187.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:11:26.326 [   INFO] subscription: 009A: "epggrab" subscribing to mux "12187.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:11:42.468 [   INFO] subscription: 009A: "epggrab" unsubscribing
2017-01-16 18:11:43.399 [   INFO] mpegts: 12226.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:11:43.440 [   INFO] subscription: 009C: "epggrab" subscribing to mux "12226.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:11:57.227 [   INFO] subscription: 009C: "epggrab" unsubscribing
2017-01-16 18:11:58.211 [   INFO] mpegts: 12265.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:11:58.252 [   INFO] subscription: 009E: "epggrab" subscribing to mux "12265.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:12:25.877 [   INFO] subscription: 009E: "epggrab" unsubscribing
2017-01-16 18:12:26.837 [   INFO] mpegts: 12304.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:12:26.879 [   INFO] subscription: 00A0: "epggrab" subscribing to mux "12304.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:12:37.421 [   INFO] subscription: 00A0: "epggrab" unsubscribing
2017-01-16 18:12:38.348 [   INFO] mpegts: 12421.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:12:38.390 [   INFO] subscription: 00A2: "epggrab" subscribing to mux "12421.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:12:38.885 [WARNING] tbl-eit: eit: 12421.5H in Astra 19,2: invalid checksum (len 371, errors 1)
2017-01-16 18:13:08.101 [   INFO] subscription: 00A2: "epggrab" unsubscribing
2017-01-16 18:13:09.075 [   INFO] mpegts: 12460.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:13:09.116 [   INFO] subscription: 00A4: "epggrab" subscribing to mux "12460.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:13:19.488 [   INFO] subscription: 00A4: "epggrab" unsubscribing
2017-01-16 18:13:20.486 [   INFO] mpegts: 12692.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:13:20.526 [   INFO] subscription: 00A6: "epggrab" subscribing to mux "12692.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:13:52.921 [   INFO] subscription: 00A6: "epggrab" unsubscribing
2017-01-16 18:13:53.918 [   INFO] mpegts: 11347V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:13:53.937 [   INFO] subscription: 00A8: "epggrab" subscribing to mux "11347V", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:14:03.088 [   INFO] subscription: 00A8: "epggrab" unsubscribing
2017-01-16 18:14:04.026 [   INFO] mpegts: 12051V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:14:04.068 [   INFO] subscription: 00AA: "epggrab" subscribing to mux "12051V", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:14:14.613 [   INFO] subscription: 00AA: "epggrab" unsubscribing
2017-01-16 18:14:15.536 [   INFO] mpegts: 12480V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-16 18:14:15.576 [   INFO] subscription: 00AC: "epggrab" subscribing to mux "12480V", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-16 18:14:26.080 [   INFO] subscription: 00AC: "epggrab" unsubscribing

--kenitram-01954fda-fba2-4663-8b6c-b5b624ce1c5a
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=service0.log

2017-01-15 08:23:58.096 [   INFO] main: Log started
2017-01-15 08:23:58.103 [   INFO] http: Starting HTTP server 0.0.0.0:9981
2017-01-15 08:23:58.104 [   INFO] htsp: Starting HTSP server 0.0.0.0:9982
2017-01-15 08:23:58.104 [  ERROR] satips: use --satip_bindaddr parameter to select the local IP for SAT>IP
2017-01-15 08:23:58.104 [  ERROR] satips: using Google lookup (might block the task until timeout)
2017-01-15 08:23:58.143 [   INFO] config: loaded
2017-01-15 08:23:58.147 [   INFO] config: scanfile (re)initialization with path <none>
2017-01-15 08:23:59.570 [   INFO] scanfile: DVB-S - loaded 1 regions with 112 networks
2017-01-15 08:23:59.570 [   INFO] scanfile: DVB-T - loaded 43 regions with 1106 networks
2017-01-15 08:23:59.570 [   INFO] scanfile: DVB-C - loaded 17 regions with 56 networks
2017-01-15 08:23:59.571 [   INFO] scanfile: ATSC-T - loaded 2 regions with 9 networks
2017-01-15 08:23:59.571 [   INFO] scanfile: ATSC-C - loaded 1 regions with 5 networks
2017-01-15 08:23:59.571 [   INFO] scanfile: ISDB-T - loaded 2 regions with 1297 networks
2017-01-15 08:24:00.160 [   INFO] linuxdvb: adapter added /dev/dvb/adapter0
2017-01-15 08:24:00.242 [   INFO] dvr: Creating new configuration ''
2017-01-15 08:24:00.242 [   INFO] dvr: Creating new configuration ''
2017-01-15 08:24:00.242 [  ERROR] dvr: Unable to create second default config, removing
2017-01-15 08:24:00.248 [   INFO] capmt: Oscam active
2017-01-15 08:24:00.248 [   INFO] descrambler: adding CAID 2600 as constant crypto-word (BISS)
2017-01-15 08:24:00.248 [   INFO] epggrab: module eit created
2017-01-15 08:24:00.248 [   INFO] epggrab: module uk_freesat created
2017-01-15 08:24:00.248 [   INFO] epggrab: module uk_freeview created
2017-01-15 08:24:00.248 [   INFO] epggrab: module viasat_baltic created
2017-01-15 08:24:00.249 [   INFO] epggrab: module Bulsatcom_39E created
2017-01-15 08:24:00.249 [   INFO] epggrab: module psip created
2017-01-15 08:24:00.249 [  ERROR] capmt: Oscam: Cannot connect to 127.0.0.1:9000 (Connection refused); Do you have OSCam running?
2017-01-15 08:24:00.249 [   INFO] capmt: Oscam: Automatic reconnection attempt in in 60 seconds
2017-01-15 08:24:00.262 [   INFO] epggrab: module opentv-ausat created
2017-01-15 08:24:00.262 [   INFO] epggrab: module opentv-skyuk created
2017-01-15 08:24:00.262 [   INFO] epggrab: module opentv-skyit created
2017-01-15 08:24:00.264 [   INFO] epggrab: module opentv-skynz created
2017-01-15 08:24:00.265 [   INFO] epggrab: module pyepg created
2017-01-15 08:24:00.265 [   INFO] epggrab: module xmltv created
2017-01-15 08:24:00.270 [   INFO] spawn: Executing "/storage/.kodi/addons/service.tvheadend42/bin/tv_grab_file"
2017-01-15 08:24:00.275 [   INFO] epggrab: module /storage/.kodi/addons/service.tvheadend42/bin/tv_grab_file created
2017-01-15 08:24:00.412 [   INFO] epgdb: gzip format detected, inflating (ratio 17.4% deflated size 3031228)
2017-01-15 08:24:00.635 [   INFO] epgdb: parsing 17432913 bytes
2017-01-15 08:24:01.774 [   INFO] epgdb: loaded v2
2017-01-15 08:24:01.774 [   INFO] epgdb:   config     1
2017-01-15 08:24:01.774 [   INFO] epgdb:   brands     0
2017-01-15 08:24:01.774 [   INFO] epgdb:   seasons    0
2017-01-15 08:24:01.774 [   INFO] epgdb:   episodes   24363
2017-01-15 08:24:01.774 [   INFO] epgdb:   broadcasts 23301
2017-01-15 08:24:01.809 [ NOTICE] START: HTS Tvheadend version 4.1.2401 ~ LibreELEC Tvh-addon v8.1.108-#0110-milhouse-v4.1-2413-g489ba95 started, running as PID:418 UID:0 GID:39, CWD:/ CNF:/storage/.kodi/userdata/addon_data/service.tvheadend42
2017-01-15 08:24:01.814 [   INFO] mpegts: 10773.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:24:01.852 [   INFO] subscription: 0001: "epggrab" subscribing to mux "10773.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:24:03.723 [   INFO] htsp: Got connection from 127.0.0.1
2017-01-15 08:24:03.725 [   INFO] htsp: 127.0.0.1: Welcomed client software: Kodi Media Center (HTSPv25)
2017-01-15 08:24:03.728 [   INFO] htsp: 127.0.0.1 [ Kodi Media Center ]: Identified as user ''
2017-01-15 08:24:12.542 [   INFO] subscription: 0001: "epggrab" unsubscribing
2017-01-15 08:24:13.460 [   INFO] mpegts: 10891.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:24:13.479 [   INFO] subscription: 0003: "epggrab" subscribing to mux "10891.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:24:14.157 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 3328, errors 1)
2017-01-15 08:24:14.271 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 1)
2017-01-15 08:24:22.565 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 1)
2017-01-15 08:24:24.112 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 2723, errors 207)
2017-01-15 08:24:25.276 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 407, errors 1)
2017-01-15 08:24:25.276 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 407, errors 1)
2017-01-15 08:24:25.982 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 3)
2017-01-15 08:24:34.091 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 2234, errors 405)
2017-01-15 08:24:39.377 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 6)
2017-01-15 08:24:39.930 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 3)
2017-01-15 08:24:40.507 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 9)
2017-01-15 08:24:40.507 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 9)
2017-01-15 08:24:41.270 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 1)
2017-01-15 08:24:44.139 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 3766, errors 624)
2017-01-15 08:24:51.495 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1023, errors 4)
2017-01-15 08:24:51.949 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 8)
2017-01-15 08:24:54.197 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 3474, errors 832)
2017-01-15 08:24:58.974 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 173, errors 11)
2017-01-15 08:24:58.974 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 173, errors 11)
2017-01-15 08:25:00.250 [   INFO] capmt: Oscam: mode 5 connected to 127.0.0.1:9000 (single)
2017-01-15 08:25:00.251 [   INFO] capmt: Oscam: Connected to server 'OSCam v1.20-unstable_svn, build r (armv7ve-libreelec-linux-gnueabi)' (protocol version 2)
2017-01-15 08:25:02.079 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 12)
2017-01-15 08:25:03.307 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 2)
2017-01-15 08:25:04.295 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 757, errors 1047)
2017-01-15 08:25:13.391 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 16)
2017-01-15 08:25:14.235 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 548, errors 1254)
2017-01-15 08:25:14.586 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 6)
2017-01-15 08:25:15.907 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 108, errors 13)
2017-01-15 08:25:15.907 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 108, errors 13)
2017-01-15 08:25:22.438 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 3)
2017-01-15 08:25:24.316 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 3979, errors 1469)
2017-01-15 08:25:24.316 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 17)
2017-01-15 08:25:27.421 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 111, errors 8)
2017-01-15 08:25:28.659 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 17)
2017-01-15 08:25:28.659 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 17)
2017-01-15 08:25:34.280 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1386, errors 1679)
2017-01-15 08:25:36.937 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 26)
2017-01-15 08:25:38.192 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 4)
2017-01-15 08:25:44.132 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 18)
2017-01-15 08:25:44.132 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 18)
2017-01-15 08:25:44.252 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 76, errors 1867)
2017-01-15 08:25:51.515 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 27)
2017-01-15 08:25:52.168 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1023, errors 9)
2017-01-15 08:25:54.302 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1839, errors 2068)
2017-01-15 08:25:58.487 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 20)
2017-01-15 08:25:58.487 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 20)
2017-01-15 08:26:02.709 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 30)
2017-01-15 08:26:04.281 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1227, errors 2273)
2017-01-15 08:26:05.380 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 5)
2017-01-15 08:26:13.055 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 265, errors 23)
2017-01-15 08:26:13.055 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 265, errors 23)
2017-01-15 08:26:13.858 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 34)
2017-01-15 08:26:14.330 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 639, errors 2465)
2017-01-15 08:26:24.334 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 3848, errors 2661)
2017-01-15 08:26:26.090 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 217, errors 26)
2017-01-15 08:26:26.090 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 217, errors 26)
2017-01-15 08:26:29.285 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 37)
2017-01-15 08:26:34.365 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 842, errors 2859)
2017-01-15 08:26:41.325 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 10)
2017-01-15 08:26:44.304 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1644, errors 3039)
2017-01-15 08:26:46.408 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 41)
2017-01-15 08:26:46.633 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 31)
2017-01-15 08:26:46.633 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 31)
2017-01-15 08:26:54.517 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 477, errors 3240)
2017-01-15 08:26:56.618 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 44)
2017-01-15 08:26:58.036 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 1006, errors 34)
2017-01-15 08:26:58.036 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 1006, errors 34)
2017-01-15 08:27:04.335 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 6)
2017-01-15 08:27:04.562 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 740, errors 3432)
2017-01-15 08:27:09.000 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 173, errors 38)
2017-01-15 08:27:09.000 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 173, errors 38)
2017-01-15 08:27:11.155 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 48)
2017-01-15 08:27:14.563 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 843, errors 3627)
2017-01-15 08:27:24.609 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 702, errors 3820)
2017-01-15 08:27:24.941 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 43)
2017-01-15 08:27:24.941 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 43)
2017-01-15 08:27:26.359 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 51)
2017-01-15 08:27:26.467 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 7)
2017-01-15 08:27:27.148 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1023, errors 12)
2017-01-15 08:27:34.575 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 795, errors 4025)
2017-01-15 08:27:35.574 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 47)
2017-01-15 08:27:35.574 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 47)
2017-01-15 08:27:37.686 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 52)
2017-01-15 08:27:42.077 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 13)
2017-01-15 08:27:44.621 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1342, errors 4231)
2017-01-15 08:27:47.278 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 50)
2017-01-15 08:27:47.278 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 50)
2017-01-15 08:27:49.952 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 55)
2017-01-15 08:27:54.570 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 643, errors 4432)
2017-01-15 08:27:59.891 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 53)
2017-01-15 08:27:59.891 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 53)
2017-01-15 08:28:02.557 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 58)
2017-01-15 08:28:04.659 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 2620, errors 4637)
2017-01-15 08:28:07.641 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 8)
2017-01-15 08:28:10.621 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 407, errors 57)
2017-01-15 08:28:10.621 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 407, errors 57)
2017-01-15 08:28:13.500 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 64)
2017-01-15 08:28:14.592 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 460, errors 4818)
2017-01-15 08:28:22.133 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 112, errors 61)
2017-01-15 08:28:22.133 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 112, errors 61)
2017-01-15 08:28:23.409 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 10)
2017-01-15 08:28:24.702 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1021, errors 5016)
2017-01-15 08:28:25.457 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 15)
2017-01-15 08:28:34.869 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 643, errors 5234)
2017-01-15 08:28:35.215 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 66)
2017-01-15 08:28:37.506 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 65)
2017-01-15 08:28:37.506 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 65)
2017-01-15 08:28:42.514 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 11)
2017-01-15 08:28:44.949 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 278, errors 5436)
2017-01-15 08:28:48.589 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 70)
2017-01-15 08:28:51.448 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 18)
2017-01-15 08:28:51.902 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 68)
2017-01-15 08:28:51.902 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 68)
2017-01-15 08:28:54.983 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1114, errors 5666)
2017-01-15 08:28:59.520 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 74)
2017-01-15 08:29:02.215 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 72)
2017-01-15 08:29:02.215 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 72)
2017-01-15 08:29:04.938 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 959, errors 5858)
2017-01-15 08:29:09.607 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 76)
2017-01-15 08:29:10.814 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 12)
2017-01-15 08:29:13.919 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 75)
2017-01-15 08:29:13.919 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 75)
2017-01-15 08:29:15.044 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 3042, errors 6067)
2017-01-15 08:29:17.456 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 20)
2017-01-15 08:29:20.715 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 77)
2017-01-15 08:29:25.097 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1592, errors 6283)
2017-01-15 08:29:29.404 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 102, errors 77)
2017-01-15 08:29:29.405 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 102, errors 77)
2017-01-15 08:29:33.071 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 80)
2017-01-15 08:29:34.845 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 21)
2017-01-15 08:29:35.067 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 3474, errors 6503)
2017-01-15 08:29:41.688 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 988, errors 80)
2017-01-15 08:29:41.690 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 988, errors 80)
2017-01-15 08:29:44.777 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 84)
2017-01-15 08:29:45.120 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 924, errors 6727)
2017-01-15 08:29:52.552 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 85)
2017-01-15 08:29:52.552 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 85)
2017-01-15 08:29:55.094 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 643, errors 6965)
2017-01-15 08:29:55.881 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 86)
2017-01-15 08:30:03.717 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1023, errors 23)
2017-01-15 08:30:05.167 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 868, errors 7195)
2017-01-15 08:30:09.792 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 88)
2017-01-15 08:30:09.792 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 88)
2017-01-15 08:30:10.475 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 93)
2017-01-15 08:30:15.179 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 475, errors 7428)
2017-01-15 08:30:18.201 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 24)
2017-01-15 08:30:20.233 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 90)
2017-01-15 08:30:20.235 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 90)
2017-01-15 08:30:24.215 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 95)
2017-01-15 08:30:25.177 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 834, errors 7645)
2017-01-15 08:30:30.737 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 13)
2017-01-15 08:30:31.925 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 94)
2017-01-15 08:30:31.926 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 94)
2017-01-15 08:30:34.371 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 17, errors 98)
2017-01-15 08:30:35.139 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1227, errors 7858)
2017-01-15 08:30:41.339 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 496, errors 25)
2017-01-15 08:30:43.328 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 1006, errors 97)
2017-01-15 08:30:43.330 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 1006, errors 97)
2017-01-15 08:30:45.229 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 2773, errors 8040)
2017-01-15 08:30:50.956 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 15)
2017-01-15 08:30:53.175 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 101)
2017-01-15 08:30:55.277 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 667, errors 8277)
2017-01-15 08:30:56.519 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 73, errors 102)
2017-01-15 08:30:56.520 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 73, errors 102)
2017-01-15 08:30:58.725 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 496, errors 28)
2017-01-15 08:31:05.260 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 82, errors 8521)
2017-01-15 08:31:06.568 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 104)
2017-01-15 08:31:09.415 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 1006, errors 105)
2017-01-15 08:31:09.417 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 1006, errors 105)
2017-01-15 08:31:13.108 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1023, errors 29)
2017-01-15 08:31:15.300 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 657, errors 8751)
2017-01-15 08:31:22.617 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 106)
2017-01-15 08:31:24.174 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 112, errors 109)
2017-01-15 08:31:24.174 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 112, errors 109)
2017-01-15 08:31:24.499 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 16)
2017-01-15 08:31:24.724 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 496, errors 30)
2017-01-15 08:31:25.266 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 2298, errors 8948)
2017-01-15 08:31:35.337 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 747, errors 9188)
2017-01-15 08:31:35.447 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 110)
2017-01-15 08:31:41.415 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 112, errors 112)
2017-01-15 08:31:41.415 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 112, errors 112)
2017-01-15 08:31:44.983 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 33)
2017-01-15 08:31:45.282 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 896, errors 9422)
2017-01-15 08:31:46.636 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 115)
2017-01-15 08:31:51.711 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 988, errors 115)
2017-01-15 08:31:51.713 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 988, errors 115)
2017-01-15 08:31:53.039 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 17)
2017-01-15 08:31:55.383 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 834, errors 9644)
2017-01-15 08:31:56.484 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1023, errors 34)
2017-01-15 08:31:58.851 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 119)
2017-01-15 08:32:02.557 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 120)
2017-01-15 08:32:02.557 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 120)
2017-01-15 08:32:05.308 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 787, errors 9899)
2017-01-15 08:32:05.647 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 18)
2017-01-15 08:32:09.208 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 74, errors 122)
2017-01-15 08:32:13.303 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 407, errors 125)
2017-01-15 08:32:13.303 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 407, errors 125)
2017-01-15 08:32:15.419 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 643, errors 10121)
2017-01-15 08:32:16.709 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 496, errors 36)
2017-01-15 08:32:23.471 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 104, errors 127)
2017-01-15 08:32:23.473 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 104, errors 127)
2017-01-15 08:32:25.416 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 955, errors 10344)
2017-01-15 08:32:26.458 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 125)
2017-01-15 08:32:35.073 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 131)
2017-01-15 08:32:35.073 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 131)
2017-01-15 08:32:35.524 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 829, errors 10555)
2017-01-15 08:32:37.309 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 129)
2017-01-15 08:32:39.189 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 20)
2017-01-15 08:32:45.609 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1542, errors 10776)
2017-01-15 08:32:45.722 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 39)
2017-01-15 08:32:45.835 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 133)
2017-01-15 08:32:45.837 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 984, errors 133)
2017-01-15 08:32:48.479 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 134)
2017-01-15 08:32:55.556 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 892, errors 11012)
2017-01-15 08:32:58.758 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 139)
2017-01-15 08:32:59.104 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 90, errors 134)
2017-01-15 08:32:59.104 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 90, errors 134)
2017-01-15 08:33:05.641 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 834, errors 11215)
2017-01-15 08:33:05.873 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1023, errors 41)
2017-01-15 08:33:09.648 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 988, errors 138)
2017-01-15 08:33:09.649 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 988, errors 138)
2017-01-15 08:33:09.878 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 141)
2017-01-15 08:33:14.037 [WARNING] tbl-base: cat: 10891.25H in Astra 19,2: invalid checksum (len 12, errors 22)
2017-01-15 08:33:15.582 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 834, errors 11392)
2017-01-15 08:33:17.492 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 496, errors 44)
2017-01-15 08:33:21.241 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 108, errors 142)
2017-01-15 08:33:21.243 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 108, errors 142)
2017-01-15 08:33:22.576 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 144)
2017-01-15 08:33:25.649 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 474, errors 11631)
2017-01-15 08:33:33.388 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 145)
2017-01-15 08:33:33.964 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 145)
2017-01-15 08:33:33.965 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 185, errors 145)
2017-01-15 08:33:35.600 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 937, errors 11841)
2017-01-15 08:33:37.702 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 45)
2017-01-15 08:33:43.472 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 146)
2017-01-15 08:33:45.596 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 41, errors 12044)
2017-01-15 08:33:47.313 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 108, errors 146)
2017-01-15 08:33:47.313 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 108, errors 146)
2017-01-15 08:33:54.653 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1012, errors 46)
2017-01-15 08:33:55.630 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 842, errors 12257)
2017-01-15 08:33:58.504 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 73, errors 148)
2017-01-15 08:33:58.506 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 73, errors 148)
2017-01-15 08:34:00.292 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 149)
2017-01-15 08:34:05.633 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1101, errors 12478)
2017-01-15 08:34:06.611 [WARNING] tbl-base: nit: 10891.25H in Astra 19,2: invalid checksum (len 1023, errors 48)
2017-01-15 08:34:12.802 [WARNING] tbl-base: pat: 10891.25H in Astra 19,2: invalid checksum (len 40, errors 154)
2017-01-15 08:34:13.648 [WARNING] tbl-base: bat: 10891.25H in Astra 19,2: invalid checksum (len 173, errors 151)
2017-01-15 08:34:13.648 [WARNING] tbl-base: sdt: 10891.25H in Astra 19,2: invalid checksum (len 173, errors 151)
2017-01-15 08:34:15.648 [WARNING] tbl-eit: eit: 10891.25H in Astra 19,2: invalid checksum (len 1481, errors 12713)
2017-01-15 08:34:23.461 [WARNING] epggrab: EIT: DVB Grabber - data completion timeout for 10891.25H in Astra 19,2
2017-01-15 08:34:23.461 [   INFO] subscription: 0003: "epggrab" unsubscribing
2017-01-15 08:34:24.462 [   INFO] mpegts: 10920.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:34:24.480 [   INFO] subscription: 0005: "epggrab" subscribing to mux "10920.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:34:34.857 [   INFO] subscription: 0005: "epggrab" unsubscribing
2017-01-15 08:34:35.824 [   INFO] mpegts: 11052.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:34:35.843 [   INFO] subscription: 0007: "epggrab" subscribing to mux "11052.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:35:03.451 [   INFO] subscription: 0007: "epggrab" unsubscribing
2017-01-15 08:35:04.449 [   INFO] mpegts: 11243.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:35:04.468 [   INFO] subscription: 0009: "epggrab" subscribing to mux "11243.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:35:38.778 [   INFO] subscription: 0009: "epggrab" unsubscribing
2017-01-15 08:35:39.680 [   INFO] mpegts: 11273.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:35:39.700 [   INFO] subscription: 000B: "epggrab" subscribing to mux "11273.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:36:31.524 [   INFO] subscription: 000B: "epggrab" unsubscribing
2017-01-15 08:36:32.522 [   INFO] mpegts: 11302.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:36:32.541 [   INFO] subscription: 000D: "epggrab" subscribing to mux "11302.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:37:05.050 [   INFO] subscription: 000D: "epggrab" unsubscribing
2017-01-15 08:37:06.049 [   INFO] mpegts: 11361.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:37:06.068 [   INFO] subscription: 000F: "epggrab" subscribing to mux "11361.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:37:15.764 [   INFO] subscription: 000F: "epggrab" unsubscribing
2017-01-15 08:37:16.759 [   INFO] mpegts: 11420.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:37:16.777 [   INFO] subscription: 0011: "epggrab" subscribing to mux "11420.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:37:27.584 [   INFO] subscription: 0011: "epggrab" unsubscribing
2017-01-15 08:37:28.571 [   INFO] mpegts: 11493.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:37:28.589 [   INFO] subscription: 0013: "epggrab" subscribing to mux "11493.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:37:55.328 [   INFO] subscription: 0013: "epggrab" unsubscribing
2017-01-15 08:37:56.294 [   INFO] mpegts: 11582.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:37:56.312 [   INFO] subscription: 0015: "epggrab" subscribing to mux "11582.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:38:23.718 [   INFO] subscription: 0015: "epggrab" unsubscribing
2017-01-15 08:38:24.718 [   INFO] mpegts: 11670.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:38:24.736 [   INFO] subscription: 0017: "epggrab" subscribing to mux "11670.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:38:35.478 [   INFO] subscription: 0017: "epggrab" unsubscribing
2017-01-15 08:38:36.426 [   INFO] mpegts: 12148.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:38:36.467 [   INFO] subscription: 0019: "epggrab" subscribing to mux "12148.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:38:46.841 [   INFO] subscription: 0019: "epggrab" unsubscribing
2017-01-15 08:38:47.837 [   INFO] mpegts: 12187.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:38:47.878 [   INFO] subscription: 001B: "epggrab" subscribing to mux "12187.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:39:04.116 [   INFO] subscription: 001B: "epggrab" unsubscribing
2017-01-15 08:39:05.052 [   INFO] mpegts: 12226.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:39:05.092 [   INFO] subscription: 001D: "epggrab" subscribing to mux "12226.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:39:27.988 [   INFO] subscription: 001D: "epggrab" unsubscribing
2017-01-15 08:39:28.972 [   INFO] mpegts: 12265.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:39:29.013 [   INFO] subscription: 001F: "epggrab" subscribing to mux "12265.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:39:58.309 [   INFO] subscription: 001F: "epggrab" unsubscribing
2017-01-15 08:39:59.296 [   INFO] mpegts: 12304.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:39:59.337 [   INFO] subscription: 0021: "epggrab" subscribing to mux "12304.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:40:09.786 [   INFO] subscription: 0021: "epggrab" unsubscribing
2017-01-15 08:40:10.705 [   INFO] mpegts: 12421.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:40:10.746 [   INFO] subscription: 0023: "epggrab" subscribing to mux "12421.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:40:39.664 [   INFO] subscription: 0023: "epggrab" unsubscribing
2017-01-15 08:40:40.628 [   INFO] mpegts: 12460.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:40:40.670 [   INFO] subscription: 0025: "epggrab" subscribing to mux "12460.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:40:51.091 [   INFO] subscription: 0025: "epggrab" unsubscribing
2017-01-15 08:40:52.037 [   INFO] mpegts: 12662.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:40:52.078 [   INFO] subscription: 0027: "epggrab" subscribing to mux "12662.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:41:31.374 [   INFO] subscription: 0027: "epggrab" unsubscribing
2017-01-15 08:41:32.372 [   INFO] mpegts: 12692.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:41:32.413 [   INFO] subscription: 0029: "epggrab" subscribing to mux "12692.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:42:08.401 [   INFO] subscription: 0029: "epggrab" unsubscribing
2017-01-15 08:42:09.402 [   INFO] mpegts: 11347V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:42:09.421 [   INFO] subscription: 002B: "epggrab" subscribing to mux "11347V", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:42:18.439 [   INFO] subscription: 002B: "epggrab" unsubscribing
2017-01-15 08:42:19.409 [   INFO] mpegts: 12051V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:42:19.449 [   INFO] subscription: 002D: "epggrab" subscribing to mux "12051V", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:42:29.959 [   INFO] subscription: 002D: "epggrab" unsubscribing
2017-01-15 08:42:30.919 [   INFO] mpegts: 12480V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 08:42:30.960 [   INFO] subscription: 002F: "epggrab" subscribing to mux "12480V", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 08:42:41.761 [   INFO] subscription: 002F: "epggrab" unsubscribing
2017-01-15 09:07:20.855 [   INFO] mpegts: 11302.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 09:07:20.896 [   INFO] capmt: Oscam: Starting CAPMT server for service "ORF1 HD" on adapter 0
2017-01-15 09:07:20.896 [   INFO] subscription: 0030: "127.0.0.1 [  | Kodi Media Center ]" subscribing on channel "ORF1 HD", weight: 150, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "11302.75H", provider: "ORF", service: "ORF1 HD", profile="htsp", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 09:07:22.158 [WARNING] TS: Astra 19,2/11302.75H/ORF1 HD: H264 @ #1920 Continuity counter error (total 1)
2017-01-15 09:07:22.158 [WARNING] TS: Astra 19,2/11302.75H/ORF1 HD: AC3 @ #1922 Continuity counter error (total 1)
2017-01-15 09:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 09:23:58.756 [   INFO] epgdb: queued to save (size 17851777)
2017-01-15 09:23:58.756 [   INFO] epgdb:   brands     0
2017-01-15 09:23:58.756 [   INFO] epgdb:   seasons    0
2017-01-15 09:23:58.756 [   INFO] epgdb:   episodes   24907
2017-01-15 09:23:58.756 [   INFO] epgdb:   broadcasts 24907
2017-01-15 09:23:58.756 [   INFO] epgdb: save start
2017-01-15 09:24:00.048 [   INFO] epgdb: stored (size 3105382)
2017-01-15 09:24:46.915 [   INFO] subscription: 0030: "127.0.0.1 [  | Kodi Media Center ]" unsubscribing from "ORF1 HD", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 09:24:46.921 [   INFO] mpegts: 12051V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 09:24:46.962 [   INFO] subscription: 0031: "127.0.0.1 [  | Kodi Media Center ]" subscribing on channel "ProSieben Austria", weight: 150, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "12051V", provider: "ProSiebenSat.1", service: "ProSieben Austria", profile="htsp", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 09:33:43.985 [   INFO] subscription: 0031: "127.0.0.1 [  | Kodi Media Center ]" unsubscribing from "ProSieben Austria", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 09:33:43.989 [   INFO] mpegts: 11302.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 09:33:44.008 [   INFO] capmt: Oscam: Starting CAPMT server for service "ORF1 HD" on adapter 0
2017-01-15 09:33:44.009 [   INFO] subscription: 0032: "127.0.0.1 [  | Kodi Media Center ]" subscribing on channel "ORF1 HD", weight: 150, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "11302.75H", provider: "ORF", service: "ORF1 HD", profile="htsp", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 10:11:12.297 [   INFO] subscription: 0032: "127.0.0.1 [  | Kodi Media Center ]" unsubscribing from "ORF1 HD", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 10:11:12.301 [   INFO] mpegts: 12051V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 10:11:12.344 [   INFO] subscription: 0033: "127.0.0.1 [  | Kodi Media Center ]" subscribing on channel "ProSieben Austria", weight: 150, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "12051V", provider: "ProSiebenSat.1", service: "ProSieben Austria", profile="htsp", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 10:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 10:23:58.768 [   INFO] epgdb: queued to save (size 17837665)
2017-01-15 10:23:58.768 [   INFO] epgdb:   brands     0
2017-01-15 10:23:58.768 [   INFO] epgdb:   seasons    0
2017-01-15 10:23:58.768 [   INFO] epgdb:   episodes   24896
2017-01-15 10:23:58.768 [   INFO] epgdb:   broadcasts 24896
2017-01-15 10:23:58.768 [   INFO] epgdb: save start
2017-01-15 10:24:00.097 [   INFO] epgdb: stored (size 3101591)
2017-01-15 10:25:27.612 [   INFO] subscription: 0033: "127.0.0.1 [  | Kodi Media Center ]" unsubscribing from "ProSieben Austria", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 10:25:27.616 [   INFO] mpegts: 11302.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 10:25:27.635 [   INFO] capmt: Oscam: Starting CAPMT server for service "ORF1 HD" on adapter 0
2017-01-15 10:25:27.635 [   INFO] subscription: 0034: "127.0.0.1 [  | Kodi Media Center ]" subscribing on channel "ORF1 HD", weight: 150, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "11302.75H", provider: "ORF", service: "ORF1 HD", profile="htsp", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 10:57:29.712 [   INFO] subscription: 0034: "127.0.0.1 [  | Kodi Media Center ]" unsubscribing from "ORF1 HD", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 11:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 11:23:58.746 [   INFO] epgdb: queued to save (size 17836400)
2017-01-15 11:23:58.746 [   INFO] epgdb:   brands     0
2017-01-15 11:23:58.746 [   INFO] epgdb:   seasons    0
2017-01-15 11:23:58.746 [   INFO] epgdb:   episodes   24894
2017-01-15 11:23:58.746 [   INFO] epgdb: save start
2017-01-15 11:23:58.746 [   INFO] epgdb:   broadcasts 24894
2017-01-15 11:23:59.918 [   INFO] epgdb: stored (size 3101247)
2017-01-15 12:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 12:23:58.710 [   INFO] epgdb: queued to save (size 17836400)
2017-01-15 12:23:58.710 [   INFO] epgdb:   brands     0
2017-01-15 12:23:58.710 [   INFO] epgdb:   seasons    0
2017-01-15 12:23:58.710 [   INFO] epgdb:   episodes   24894
2017-01-15 12:23:58.710 [   INFO] epgdb:   broadcasts 24894
2017-01-15 12:23:58.710 [   INFO] epgdb: save start
2017-01-15 12:23:59.880 [   INFO] epgdb: stored (size 3101247)
2017-01-15 13:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 13:23:58.737 [   INFO] epgdb: queued to save (size 17836400)
2017-01-15 13:23:58.737 [   INFO] epgdb:   brands     0
2017-01-15 13:23:58.737 [   INFO] epgdb:   seasons    0
2017-01-15 13:23:58.737 [   INFO] epgdb:   episodes   24894
2017-01-15 13:23:58.737 [   INFO] epgdb:   broadcasts 24894
2017-01-15 13:23:58.737 [   INFO] epgdb: save start
2017-01-15 13:23:59.903 [   INFO] epgdb: stored (size 3101247)
2017-01-15 14:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 14:23:58.750 [   INFO] epgdb: queued to save (size 17836400)
2017-01-15 14:23:58.750 [   INFO] epgdb:   brands     0
2017-01-15 14:23:58.750 [   INFO] epgdb:   seasons    0
2017-01-15 14:23:58.750 [   INFO] epgdb:   episodes   24894
2017-01-15 14:23:58.750 [   INFO] epgdb:   broadcasts 24894
2017-01-15 14:23:58.750 [   INFO] epgdb: save start
2017-01-15 14:23:59.912 [   INFO] epgdb: stored (size 3101247)
2017-01-15 15:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 15:23:58.728 [   INFO] epgdb: queued to save (size 17836400)
2017-01-15 15:23:58.728 [   INFO] epgdb:   brands     0
2017-01-15 15:23:58.728 [   INFO] epgdb:   seasons    0
2017-01-15 15:23:58.728 [   INFO] epgdb:   episodes   24894
2017-01-15 15:23:58.728 [   INFO] epgdb: save start
2017-01-15 15:23:58.728 [   INFO] epgdb:   broadcasts 24894
2017-01-15 15:23:59.902 [   INFO] epgdb: stored (size 3101247)
2017-01-15 16:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 16:23:58.709 [   INFO] epgdb: queued to save (size 17836400)
2017-01-15 16:23:58.709 [   INFO] epgdb:   brands     0
2017-01-15 16:23:58.709 [   INFO] epgdb:   seasons    0
2017-01-15 16:23:58.709 [   INFO] epgdb:   episodes   24894
2017-01-15 16:23:58.709 [   INFO] epgdb:   broadcasts 24894
2017-01-15 16:23:58.709 [   INFO] epgdb: save start
2017-01-15 16:23:59.917 [   INFO] epgdb: stored (size 3101247)
2017-01-15 17:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 17:23:58.719 [   INFO] epgdb: queued to save (size 17836400)
2017-01-15 17:23:58.719 [   INFO] epgdb:   brands     0
2017-01-15 17:23:58.719 [   INFO] epgdb:   seasons    0
2017-01-15 17:23:58.719 [   INFO] epgdb:   episodes   24894
2017-01-15 17:23:58.719 [   INFO] epgdb:   broadcasts 24894
2017-01-15 17:23:58.719 [   INFO] epgdb: save start
2017-01-15 17:23:59.888 [   INFO] epgdb: stored (size 3101247)
2017-01-15 18:04:00.955 [   INFO] mpegts: 10773.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:04:00.993 [   INFO] subscription: 0035: "epggrab" subscribing to mux "10773.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:04:01.248 [WARNING] linuxdvb: Unable to provide UNC value.
2017-01-15 18:04:11.868 [   INFO] subscription: 0035: "epggrab" unsubscribing
2017-01-15 18:04:12.864 [   INFO] mpegts: 10891.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:04:12.883 [   INFO] subscription: 0037: "epggrab" subscribing to mux "10891.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:04:40.989 [   INFO] subscription: 0037: "epggrab" unsubscribing
2017-01-15 18:04:41.987 [   INFO] mpegts: 10920.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:04:42.006 [   INFO] subscription: 0039: "epggrab" subscribing to mux "10920.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:04:52.475 [   INFO] subscription: 0039: "epggrab" unsubscribing
2017-01-15 18:04:53.396 [   INFO] mpegts: 11052.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:04:53.415 [   INFO] subscription: 003B: "epggrab" subscribing to mux "11052.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:05:20.716 [   INFO] subscription: 003B: "epggrab" unsubscribing
2017-01-15 18:05:21.717 [   INFO] mpegts: 11243.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:05:21.736 [   INFO] subscription: 003D: "epggrab" subscribing to mux "11243.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:05:48.848 [   INFO] subscription: 003D: "epggrab" unsubscribing
2017-01-15 18:05:49.842 [   INFO] mpegts: 11273.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:05:49.861 [   INFO] subscription: 003F: "epggrab" subscribing to mux "11273.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:06:31.358 [   INFO] subscription: 003F: "epggrab" unsubscribing
2017-01-15 18:06:32.302 [   INFO] mpegts: 11302.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:06:32.321 [   INFO] subscription: 0041: "epggrab" subscribing to mux "11302.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:07:00.586 [   INFO] subscription: 0041: "epggrab" unsubscribing
2017-01-15 18:07:01.501 [   INFO] mpegts: 11361.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:07:01.519 [   INFO] subscription: 0043: "epggrab" subscribing to mux "11361.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:07:10.610 [   INFO] subscription: 0043: "epggrab" unsubscribing
2017-01-15 18:07:11.608 [   INFO] mpegts: 11420.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:07:11.627 [   INFO] subscription: 0045: "epggrab" subscribing to mux "11420.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:07:22.206 [   INFO] subscription: 0045: "epggrab" unsubscribing
2017-01-15 18:07:23.119 [   INFO] mpegts: 11493.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:07:23.137 [   INFO] subscription: 0047: "epggrab" subscribing to mux "11493.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:07:50.014 [   INFO] subscription: 0047: "epggrab" unsubscribing
2017-01-15 18:07:50.941 [   INFO] mpegts: 11582.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:07:50.959 [   INFO] subscription: 0049: "epggrab" subscribing to mux "11582.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:08:18.672 [   INFO] subscription: 0049: "epggrab" unsubscribing
2017-01-15 18:08:19.666 [   INFO] mpegts: 11670.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:08:19.684 [   INFO] subscription: 004B: "epggrab" subscribing to mux "11670.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:08:30.292 [   INFO] subscription: 004B: "epggrab" unsubscribing
2017-01-15 18:08:31.276 [   INFO] mpegts: 12148.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:08:31.317 [   INFO] subscription: 004D: "epggrab" subscribing to mux "12148.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:08:41.782 [   INFO] subscription: 004D: "epggrab" unsubscribing
2017-01-15 18:08:42.686 [   INFO] mpegts: 12187.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:08:42.726 [   INFO] subscription: 004F: "epggrab" subscribing to mux "12187.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:08:58.967 [   INFO] subscription: 004F: "epggrab" unsubscribing
2017-01-15 18:08:59.901 [   INFO] mpegts: 12226.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:08:59.942 [   INFO] subscription: 0051: "epggrab" subscribing to mux "12226.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:09:13.925 [   INFO] subscription: 0051: "epggrab" unsubscribing
2017-01-15 18:09:14.914 [   INFO] mpegts: 12265.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:09:14.955 [   INFO] subscription: 0053: "epggrab" subscribing to mux "12265.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:09:43.096 [   INFO] subscription: 0053: "epggrab" unsubscribing
2017-01-15 18:09:44.038 [   INFO] mpegts: 12304.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:09:44.079 [   INFO] subscription: 0055: "epggrab" subscribing to mux "12304.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:09:54.561 [   INFO] subscription: 0055: "epggrab" unsubscribing
2017-01-15 18:09:55.546 [   INFO] mpegts: 12421.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:09:55.587 [   INFO] subscription: 0057: "epggrab" subscribing to mux "12421.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:10:23.918 [   INFO] subscription: 0057: "epggrab" unsubscribing
2017-01-15 18:10:24.870 [   INFO] mpegts: 12460.5H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:10:24.910 [   INFO] subscription: 0059: "epggrab" subscribing to mux "12460.5H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:10:35.308 [   INFO] subscription: 0059: "epggrab" unsubscribing
2017-01-15 18:10:36.279 [   INFO] mpegts: 12662.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:10:36.320 [   INFO] subscription: 005B: "epggrab" subscribing to mux "12662.75H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:11:11.252 [   INFO] subscription: 005B: "epggrab" unsubscribing
2017-01-15 18:11:12.207 [   INFO] mpegts: 12692.25H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:11:12.248 [   INFO] subscription: 005D: "epggrab" subscribing to mux "12692.25H", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:11:44.334 [   INFO] subscription: 005D: "epggrab" unsubscribing
2017-01-15 18:11:45.334 [   INFO] mpegts: 11347V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:11:45.352 [   INFO] subscription: 005F: "epggrab" subscribing to mux "11347V", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:11:54.324 [   INFO] subscription: 005F: "epggrab" unsubscribing
2017-01-15 18:11:55.241 [   INFO] mpegts: 12051V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:11:55.281 [   INFO] subscription: 0061: "epggrab" subscribing to mux "12051V", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:12:05.788 [   INFO] subscription: 0061: "epggrab" unsubscribing
2017-01-15 18:12:06.750 [   INFO] mpegts: 12480V in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 18:12:06.790 [   INFO] subscription: 0063: "epggrab" subscribing to mux "12480V", weight: 4, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", service: "Raw PID Subscription"
2017-01-15 18:12:17.219 [   INFO] subscription: 0063: "epggrab" unsubscribing
2017-01-15 18:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 18:23:58.741 [   INFO] epgdb: queued to save (size 17409698)
2017-01-15 18:23:58.741 [   INFO] epgdb:   brands     0
2017-01-15 18:23:58.741 [   INFO] epgdb:   seasons    0
2017-01-15 18:23:58.741 [   INFO] epgdb:   episodes   24383
2017-01-15 18:23:58.741 [   INFO] epgdb:   broadcasts 24383
2017-01-15 18:23:58.741 [   INFO] epgdb: save start
2017-01-15 18:23:59.869 [   INFO] epgdb: stored (size 3008292)
2017-01-15 19:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 19:23:58.717 [   INFO] epgdb: queued to save (size 17406449)
2017-01-15 19:23:58.717 [   INFO] epgdb:   brands     0
2017-01-15 19:23:58.717 [   INFO] epgdb:   seasons    0
2017-01-15 19:23:58.717 [   INFO] epgdb:   episodes   24380
2017-01-15 19:23:58.717 [   INFO] epgdb:   broadcasts 24380
2017-01-15 19:23:58.717 [   INFO] epgdb: save start
2017-01-15 19:23:59.841 [   INFO] epgdb: stored (size 3007451)
2017-01-15 20:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 20:23:58.765 [   INFO] epgdb: queued to save (size 17403477)
2017-01-15 20:23:58.765 [   INFO] epgdb:   brands     0
2017-01-15 20:23:58.765 [   INFO] epgdb: save start
2017-01-15 20:23:58.765 [   INFO] epgdb:   seasons    0
2017-01-15 20:23:58.765 [   INFO] epgdb:   episodes   24377
2017-01-15 20:23:58.765 [   INFO] epgdb:   broadcasts 24377
2017-01-15 20:23:59.914 [   INFO] epgdb: stored (size 3007254)
2017-01-15 21:10:21.857 [   INFO] mpegts: 11243.75H in Astra 19,2 - tuning on TechnoTrend S2-4600
2017-01-15 21:10:21.895 [   INFO] capmt: Oscam: Starting CAPMT server for service "ATV HD" on adapter 0
2017-01-15 21:10:21.896 [   INFO] subscription: 0064: "127.0.0.1 [  | Kodi Media Center ]" subscribing on channel "ATV HD", weight: 150, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "11243.75H", provider: "ATV", service: "ATV HD", profile="htsp", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 21:10:22.154 [WARNING] linuxdvb: Unable to provide UNC value.
2017-01-15 21:10:23.037 [WARNING] tsfix: The timediff for TELETEXT is big (3898119747), using current dts
2017-01-15 21:10:23.037 [  ERROR] tsfix: transport stream TELETEXT, DTS discontinuity. DTS = 0, last = 4691811245
2017-01-15 21:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 21:23:58.763 [   INFO] epgdb: queued to save (size 17388858)
2017-01-15 21:23:58.763 [   INFO] epgdb:   brands     0
2017-01-15 21:23:58.763 [   INFO] epgdb:   seasons    0
2017-01-15 21:23:58.763 [   INFO] epgdb:   episodes   24357
2017-01-15 21:23:58.763 [   INFO] epgdb:   broadcasts 24357
2017-01-15 21:23:58.763 [   INFO] epgdb: save start
2017-01-15 21:24:00.056 [   INFO] epgdb: stored (size 3004635)
2017-01-15 21:56:25.436 [   INFO] htsp: Got connection from 10.0.0.13
2017-01-15 21:56:25.450 [   INFO] htsp: 10.0.0.13: Identified as user '' (unverified)
2017-01-15 21:56:25.450 [   INFO] htsp: 10.0.0.13 [  ]: Welcomed client software: org.tvheadend.tvhclient (HTSPv23)
2017-01-15 21:56:25.467 [   INFO] htsp: 10.0.0.13 [  | org.tvheadend.tvhclient ]: Identified as user ''
2017-01-15 21:56:43.748 [   INFO] dvr: entry 4e667f1a036625199387909817d865c5 "Stephen King's A Good Marriage" on "ATV HD" starting at 2017-01-15 22:21:06, scheduled for recording by "10.0.0.13"
2017-01-15 21:57:31.109 [   INFO] htsp: 10.0.0.13 [  | org.tvheadend.tvhclient ]: Disconnected
2017-01-15 22:21:06.001 [   INFO] dvr: "Stephen King's A Good Marriage" on "ATV HD" recorder starting
2017-01-15 22:21:06.001 [   INFO] subscription: 0065: "DVR: Stephen King's A Good Marriage" subscribing on channel "ATV HD", weight: 300, adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "11243.75H", provider: "ATV", service: "ATV HD", profile="pass"
2017-01-15 22:21:37.893 [   INFO] dvr: /storage/recordings/Stephen King's A Good Marriage.ts from adapter: "TechnoTrend S2-4600", network: "Astra 19,2", mux: "11243.75H", provider: "ATV", service: "ATV HD"
2017-01-15 22:21:37.893 [   INFO] dvr:  #  type              lang  resolution  aspect ratio  sample rate  channels
2017-01-15 22:21:37.893 [   INFO] dvr:  1  H264                    1920x1080   ?                                    
2017-01-15 22:21:37.893 [   INFO] dvr:  2  MPEG2AUDIO        ger                             ?            ?         
2017-01-15 22:21:37.893 [   INFO] dvr:  3  TELETEXT                                                                 
2017-01-15 22:21:37.893 [   INFO] dvr:  4  CA                                                                       
2017-01-15 22:21:37.893 [   INFO] dvr:  5  CA                                                                       
2017-01-15 22:21:37.893 [   INFO] dvr:  6  CA                                                                       
2017-01-15 22:21:37.893 [   INFO] dvr:  7  CA                                                                       
2017-01-15 22:21:37.893 [   INFO] dvr:  8  CA                                                                       
2017-01-15 22:21:37.893 [   INFO] dvr:  9  CA                                                                       
2017-01-15 22:21:37.893 [   INFO] dvr: 10  CA                                                                       
2017-01-15 22:22:08.033 [   INFO] subscription: 0064: "127.0.0.1 [  | Kodi Media Center ]" unsubscribing from "ATV HD", hostname="127.0.0.1", username="127.0.0.1", client="Kodi Media Center"
2017-01-15 22:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 22:23:58.709 [   INFO] epgdb: queued to save (size 17381305)
2017-01-15 22:23:58.709 [   INFO] epgdb:   brands     0
2017-01-15 22:23:58.709 [   INFO] epgdb:   seasons    0
2017-01-15 22:23:58.709 [   INFO] epgdb:   episodes   24349
2017-01-15 22:23:58.709 [   INFO] epgdb:   broadcasts 24349
2017-01-15 22:23:58.709 [   INFO] epgdb: save start
2017-01-15 22:23:59.853 [   INFO] epgdb: stored (size 3003474)
2017-01-15 22:50:20.942 [WARNING] TS: Astra 19,2/11243.75H/ATV HD: H264 @ #2280 Continuity counter error (total 1)
2017-01-15 22:50:20.942 [WARNING] TS: Astra 19,2/11243.75H/ATV HD: TELETEXT @ #2285 Continuity counter error (total 1)
2017-01-15 23:11:40.331 [WARNING] TS: Astra 19,2/11243.75H/ATV HD: H264 @ #2280 Continuity counter error (total 2)
2017-01-15 23:11:40.352 [WARNING] TS: Astra 19,2/11243.75H/ATV HD: TELETEXT @ #2285 Continuity counter error (total 2)
2017-01-15 23:23:58.000 [   INFO] epgdb: snapshot start
2017-01-15 23:23:58.715 [   INFO] epgdb: queued to save (size 17378404)
2017-01-15 23:23:58.715 [   INFO] epgdb:   brands     0
2017-01-15 23:23:58.715 [   INFO] epgdb:   seasons    0
2017-01-15 23:23:58.715 [   INFO] epgdb:   episodes   24346
2017-01-15 23:23:58.715 [   INFO] epgdb:   broadcasts 24346
2017-01-15 23:23:58.715 [   INFO] epgdb: save start
2017-01-15 23:23:59.947 [   INFO] epgdb: stored (size 3002777)
2017-01-15 23:33:35.723 [WARNING] TS: Astra 19,2/11243.75H/ATV HD: H264 @ #2280 Continuity counter error (total 3)
2017-01-16 00:17:39.787 [WARNING] TS: Astra 19,2/11243.75H/ATV HD: H264 @ #2280 Continuity counter error (total 4)
2017-01-16 00:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 00:23:58.720 [   INFO] epgdb: queued to save (size 17373220)
2017-01-16 00:23:58.720 [   INFO] epgdb:   brands     0
2017-01-16 00:23:58.720 [   INFO] epgdb:   seasons    0
2017-01-16 00:23:58.720 [   INFO] epgdb:   episodes   24340
2017-01-16 00:23:58.720 [   INFO] epgdb: save start
2017-01-16 00:23:58.720 [   INFO] epgdb:   broadcasts 24340
2017-01-16 00:23:59.880 [   INFO] epgdb: stored (size 3002107)
2017-01-16 00:26:16.955 [   INFO] subscription: 0065: "DVR: Stephen King's A Good Marriage" unsubscribing from "ATV HD"
2017-01-16 00:26:16.958 [   INFO] dvr: "Stephen King's A Good Marriage" on "ATV HD": End of program: Completed OK
2017-01-16 01:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 01:23:58.713 [   INFO] epgdb: queued to save (size 17368986)
2017-01-16 01:23:58.713 [   INFO] epgdb:   brands     0
2017-01-16 01:23:58.713 [   INFO] epgdb:   seasons    0
2017-01-16 01:23:58.713 [   INFO] epgdb:   episodes   24335
2017-01-16 01:23:58.713 [   INFO] epgdb:   broadcasts 24335
2017-01-16 01:23:58.713 [   INFO] epgdb: save start
2017-01-16 01:23:59.843 [   INFO] epgdb: stored (size 3001477)
2017-01-16 02:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 02:23:58.734 [   INFO] epgdb: queued to save (size 17367726)
2017-01-16 02:23:58.734 [   INFO] epgdb:   brands     0
2017-01-16 02:23:58.734 [   INFO] epgdb:   seasons    0
2017-01-16 02:23:58.734 [   INFO] epgdb: save start
2017-01-16 02:23:58.734 [   INFO] epgdb:   episodes   24334
2017-01-16 02:23:58.734 [   INFO] epgdb:   broadcasts 24334
2017-01-16 02:23:59.882 [   INFO] epgdb: stored (size 3001009)
2017-01-16 03:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 03:23:58.743 [   INFO] epgdb: queued to save (size 17365589)
2017-01-16 03:23:58.743 [   INFO] epgdb:   brands     0
2017-01-16 03:23:58.743 [   INFO] epgdb:   seasons    0
2017-01-16 03:23:58.743 [   INFO] epgdb:   episodes   24332
2017-01-16 03:23:58.743 [   INFO] epgdb:   broadcasts 24332
2017-01-16 03:23:58.743 [   INFO] epgdb: save start
2017-01-16 03:23:59.875 [   INFO] epgdb: stored (size 3000575)
2017-01-16 04:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 04:23:58.743 [   INFO] epgdb: queued to save (size 17362490)
2017-01-16 04:23:58.743 [   INFO] epgdb:   brands     0
2017-01-16 04:23:58.743 [   INFO] epgdb:   seasons    0
2017-01-16 04:23:58.743 [   INFO] epgdb:   episodes   24329
2017-01-16 04:23:58.743 [   INFO] epgdb:   broadcasts 24329
2017-01-16 04:23:58.743 [   INFO] epgdb: save start
2017-01-16 04:23:59.889 [   INFO] epgdb: stored (size 2999748)
2017-01-16 05:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 05:23:58.748 [   INFO] epgdb: queued to save (size 17360759)
2017-01-16 05:23:58.748 [   INFO] epgdb:   brands     0
2017-01-16 05:23:58.748 [   INFO] epgdb:   seasons    0
2017-01-16 05:23:58.748 [   INFO] epgdb:   episodes   24327
2017-01-16 05:23:58.748 [   INFO] epgdb:   broadcasts 24327
2017-01-16 05:23:58.748 [   INFO] epgdb: save start
2017-01-16 05:23:59.874 [   INFO] epgdb: stored (size 2999301)
2017-01-16 06:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 06:23:58.714 [   INFO] epgdb: queued to save (size 17358592)
2017-01-16 06:23:58.714 [   INFO] epgdb:   brands     0
2017-01-16 06:23:58.714 [   INFO] epgdb:   seasons    0
2017-01-16 06:23:58.714 [   INFO] epgdb:   episodes   24325
2017-01-16 06:23:58.714 [   INFO] epgdb:   broadcasts 24325
2017-01-16 06:23:58.714 [   INFO] epgdb: save start
2017-01-16 06:23:59.840 [   INFO] epgdb: stored (size 2998468)
2017-01-16 07:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 07:23:58.705 [   INFO] epgdb: queued to save (size 17357312)
2017-01-16 07:23:58.705 [   INFO] epgdb:   brands     0
2017-01-16 07:23:58.705 [   INFO] epgdb:   seasons    0
2017-01-16 07:23:58.705 [   INFO] epgdb:   episodes   24324
2017-01-16 07:23:58.705 [   INFO] epgdb:   broadcasts 24324
2017-01-16 07:23:58.705 [   INFO] epgdb: save start
2017-01-16 07:23:59.827 [   INFO] epgdb: stored (size 2997948)
2017-01-16 08:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 08:23:58.727 [   INFO] epgdb: queued to save (size 17356250)
2017-01-16 08:23:58.727 [   INFO] epgdb:   brands     0
2017-01-16 08:23:58.727 [   INFO] epgdb:   seasons    0
2017-01-16 08:23:58.727 [   INFO] epgdb:   episodes   24323
2017-01-16 08:23:58.727 [   INFO] epgdb: save start
2017-01-16 08:23:58.727 [   INFO] epgdb:   broadcasts 24323
2017-01-16 08:23:59.848 [   INFO] epgdb: stored (size 2997674)
2017-01-16 09:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 09:23:58.713 [   INFO] epgdb: queued to save (size 17354840)
2017-01-16 09:23:58.713 [   INFO] epgdb:   brands     0
2017-01-16 09:23:58.713 [   INFO] epgdb:   seasons    0
2017-01-16 09:23:58.713 [   INFO] epgdb:   episodes   24321
2017-01-16 09:23:58.713 [   INFO] epgdb:   broadcasts 24321
2017-01-16 09:23:58.713 [   INFO] epgdb: save start
2017-01-16 09:23:59.888 [   INFO] epgdb: stored (size 2997454)
2017-01-16 10:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 10:23:58.729 [   INFO] epgdb: queued to save (size 17352050)
2017-01-16 10:23:58.729 [   INFO] epgdb: save start
2017-01-16 10:23:58.730 [   INFO] epgdb:   brands     0
2017-01-16 10:23:58.730 [   INFO] epgdb:   seasons    0
2017-01-16 10:23:58.730 [   INFO] epgdb:   episodes   24318
2017-01-16 10:23:58.730 [   INFO] epgdb:   broadcasts 24318
2017-01-16 10:23:59.872 [   INFO] epgdb: stored (size 2996515)
2017-01-16 11:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 11:23:58.709 [   INFO] epgdb: queued to save (size 17350198)
2017-01-16 11:23:58.709 [   INFO] epgdb:   brands     0
2017-01-16 11:23:58.709 [   INFO] epgdb:   seasons    0
2017-01-16 11:23:58.709 [   INFO] epgdb:   episodes   24316
2017-01-16 11:23:58.709 [   INFO] epgdb:   broadcasts 24316
2017-01-16 11:23:58.709 [   INFO] epgdb: save start
2017-01-16 11:23:59.847 [   INFO] epgdb: stored (size 2996300)
2017-01-16 12:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 12:23:58.719 [   INFO] epgdb: queued to save (size 17349443)
2017-01-16 12:23:58.719 [   INFO] epgdb:   brands     0
2017-01-16 12:23:58.719 [   INFO] epgdb:   seasons    0
2017-01-16 12:23:58.719 [   INFO] epgdb:   episodes   24315
2017-01-16 12:23:58.719 [   INFO] epgdb:   broadcasts 24315
2017-01-16 12:23:58.719 [   INFO] epgdb: save start
2017-01-16 12:23:59.851 [   INFO] epgdb: stored (size 2996177)
2017-01-16 13:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 13:23:58.714 [   INFO] epgdb: queued to save (size 17348193)
2017-01-16 13:23:58.714 [   INFO] epgdb:   brands     0
2017-01-16 13:23:58.714 [   INFO] epgdb:   seasons    0
2017-01-16 13:23:58.714 [   INFO] epgdb:   episodes   24314
2017-01-16 13:23:58.714 [   INFO] epgdb:   broadcasts 24314
2017-01-16 13:23:58.714 [   INFO] epgdb: save start
2017-01-16 13:23:59.847 [   INFO] epgdb: stored (size 2995738)
2017-01-16 14:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 14:23:58.734 [   INFO] epgdb: queued to save (size 17346918)
2017-01-16 14:23:58.734 [   INFO] epgdb:   brands     0
2017-01-16 14:23:58.734 [   INFO] epgdb:   seasons    0
2017-01-16 14:23:58.734 [   INFO] epgdb:   episodes   24313
2017-01-16 14:23:58.734 [   INFO] epgdb:   broadcasts 24313
2017-01-16 14:23:58.734 [   INFO] epgdb: save start
2017-01-16 14:23:59.866 [   INFO] epgdb: stored (size 2995233)
2017-01-16 15:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 15:23:58.713 [   INFO] epgdb: queued to save (size 17345287)
2017-01-16 15:23:58.713 [   INFO] epgdb:   brands     0
2017-01-16 15:23:58.713 [   INFO] epgdb: save start
2017-01-16 15:23:58.713 [   INFO] epgdb:   seasons    0
2017-01-16 15:23:58.713 [   INFO] epgdb:   episodes   24311
2017-01-16 15:23:58.713 [   INFO] epgdb:   broadcasts 24311
2017-01-16 15:23:59.849 [   INFO] epgdb: stored (size 2995132)
2017-01-16 16:23:58.000 [   INFO] epgdb: snapshot start
2017-01-16 16:23:58.742 [   INFO] epgdb: queued to save (size 17344211)
2017-01-16 16:23:58.742 [   INFO] epgdb:   brands     0
2017-01-16 16:23:58.742 [   INFO] epgdb:   seasons    0
2017-01-16 16:23:58.742 [   INFO] epgdb:   episodes   24310
2017-01-16 16:23:58.742 [   INFO] epgdb: save start
2017-01-16 16:23:58.742 [   INFO] epgdb:   broadcasts 24310
2017-01-16 16:23:59.875 [   INFO] epgdb: stored (size 2995068)

--kenitram-01954fda-fba2-4663-8b6c-b5b624ce1c5a--
