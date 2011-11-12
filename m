Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62205 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1KLOQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 09:16:52 -0500
Received: by vcbf1 with SMTP id f1so4094646vcb.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 06:16:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiwnOTv=yhFeAsjQ+=5vrsUfy5b8HqtXGiFuimXe2M-+Bw@mail.gmail.com>
References: <CAA7M+FBvP0A7L6o-Fw4CQ2xR2CYqu233L+83BGGOcLooK0bk7w@mail.gmail.com>
	<CAGoCfiw+yy3Hz=7yvGTYrYQn5VfNh3CrabS_Kxx7G88jcwt9aQ@mail.gmail.com>
	<20111112141403.53708f28@hana.gusto>
	<CAGoCfiwnOTv=yhFeAsjQ+=5vrsUfy5b8HqtXGiFuimXe2M-+Bw@mail.gmail.com>
Date: Sat, 12 Nov 2011 14:16:51 +0000
Message-ID: <CAA7M+FAi517fUjLUxLsVSMr99N+2gpuhJMoiTbsuxyKGuf7-Kw@mail.gmail.com>
Subject: Re: HVR-4000 may be broken in kernel mods (again) ?
From: "jonathanjstevens@gmail.com" <jonathanjstevens@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, sure... bit more history...

I've struggled along with the card for many year. Was previously in a
F12 x64, with the http://hg.kewl.org/pub/v4l-dvb-20100517/ DVB modules
compiled in and everything worked except MythTV. Then with a few
kludges to MythTV everything ended up working.

The system is a "under the stairs server" so does a fair few things
for me, quite a few VMs (hence Xen), mythtvbackend with a few tuners,
file server, etc...

Last year to get the Xen support I moved to OpenSuse 11.4, and again
had to patch v4l modules and MythTV.

So, I didn't really get on with OpenSuse at all, and was keen to get
back to Fedora. F16 provides the upstream support for dom0 under Xen
(I'm not one for compiling my own kernel - that's a bit out of my
comfort zone).

So been testing the F16 and all seemed fine, so went for the move. I
also spotted http://www.kernellabs.com/blog/?p=1568 from which I
figured that I'd probably be fairly safe wrt the HVR-4000 - should
have tested it I suppose, but there we go...

So, the system itself is all known to work with patched opensuse 11.4
and patched MythTV (which shouldn't be necessary now as per the above
links) and Xen did not get in the way.

Now, more details:

First off, I have no satellite, so this is all about DVB-T
(terrestrial UK/Freeview)

MythTV could not scan the HVR-4000, but was fine with my Nova USB, fed
from same wire.

So, I tried scandvb (not sure why it's called scandvb instead of
dvbscan in Fedora). Did not manage to find any services.
So, I tried w_scan, and again was unable to discover any services.
It looks a bit like it finds the transponders (sometimes) but mutters
about timeout loading filters.

I then used the Nova to scan for channels with w_scan, which worked,
and I used the resulting output to successfully get FE_LOCK with tzap
on the HVR-4000.
However, using the transponder information from w_scan with scandvb
did not find any services.

I thought therefore it might just be a tuning issue, so used the
tuning info from the Nova in MythTV for the HVR-4000. MythTV reports
"Partial Lock".

dmesg does not report any errors that I can see.

I'm happy to post up a pile of diags, but don't want to bombard the
list with stuff you're not interested in - so if you tell me what
you'd like me to run/test I'll happily do that. I will verify Xen is
not causing this in the meantime.

Here is a very verbose scandvb...

[root@mythtvtuner jon]# scandvb -a 0 -f 1 -d 1 -v -v -v -v -5 -n -x 0
dvbscan.channels.conf
scanning dvbscan.channels.conf
using '/dev/dvb/adapter0/frontend1' and '/dev/dvb/adapter0/demux1'
initial transponder 650000000 0 9 9 6 2 4 4
initial transponder 754000000 0 3 9 3 1 0 0
initial transponder 794000000 0 2 9 3 1 0 0
initial transponder 738000000 0 2 9 3 1 0 0
initial transponder 690000000 0 2 9 3 1 0 0
initial transponder 722000000 0 2 9 3 1 0 0
initial transponder 706000000 0 9 9 6 2 4 4
initial transponder 842000000 0 9 9 6 2 4 4
>>> tune to: 650000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO
>>> tuning status == 0x01
>>> tuning status == 0x1f
add_filter:1377: add filter pid 0x0000
start_filter:1317: start filter pid 0x0000 table_id 0x00
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0011
start_filter:1317: start filter pid 0x0011 table_id 0x42
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x40
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x41
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1385: remove filter pid 0x0011
stop_filter:1363: stop filter pid 0x0011
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1385: remove filter pid 0x0000
stop_filter:1363: stop filter pid 0x0000
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
>>> tune to: 754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 794000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> tuning status == 0x01
>>> tuning status == 0x1f
add_filter:1377: add filter pid 0x0000
start_filter:1317: start filter pid 0x0000 table_id 0x00
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0011
start_filter:1317: start filter pid 0x0011 table_id 0x42
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x40
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x41
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1385: remove filter pid 0x0011
stop_filter:1363: stop filter pid 0x0011
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1385: remove filter pid 0x0000
stop_filter:1363: stop filter pid 0x0000
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
>>> tune to: 738000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> tuning status == 0x01
>>> tuning status == 0x1f
add_filter:1377: add filter pid 0x0000
start_filter:1317: start filter pid 0x0000 table_id 0x00
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0011
start_filter:1317: start filter pid 0x0011 table_id 0x42
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x40
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x41
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1385: remove filter pid 0x0011
stop_filter:1363: stop filter pid 0x0011
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1385: remove filter pid 0x0000
stop_filter:1363: stop filter pid 0x0000
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
>>> tune to: 690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> tuning status == 0x01
>>> tuning status == 0x1f
add_filter:1377: add filter pid 0x0000
start_filter:1317: start filter pid 0x0000 table_id 0x00
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0011
start_filter:1317: start filter pid 0x0011 table_id 0x42
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x40
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x41
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1385: remove filter pid 0x0011
stop_filter:1363: stop filter pid 0x0011
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1385: remove filter pid 0x0000
stop_filter:1363: stop filter pid 0x0000
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
>>> tune to: 722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> tuning status == 0x01
>>> tuning status == 0x1f
add_filter:1377: add filter pid 0x0000
start_filter:1317: start filter pid 0x0000 table_id 0x00
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0011
start_filter:1317: start filter pid 0x0011 table_id 0x42
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x40
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x41
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1385: remove filter pid 0x0011
stop_filter:1363: stop filter pid 0x0011
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1385: remove filter pid 0x0000
stop_filter:1363: stop filter pid 0x0000
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
>>> tune to: 706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x03
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
WARNING: >>> tuning failed!!!
>>> tune to: 706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO (tuning failed)
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
WARNING: >>> tuning failed!!!
>>> tune to: 842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x03
>>> tuning status == 0x01
>>> tuning status == 0x03
>>> tuning status == 0x01
WARNING: >>> tuning failed!!!
>>> tune to: 842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO (tuning failed)
>>> tuning status == 0x01
>>> tuning status == 0x1f
add_filter:1377: add filter pid 0x0000
start_filter:1317: start filter pid 0x0000 table_id 0x00
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0011
start_filter:1317: start filter pid 0x0011 table_id 0x42
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x40
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
add_filter:1377: add filter pid 0x0010
start_filter:1317: start filter pid 0x0010 table_id 0x41
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 5
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0011
remove_filter:1385: remove filter pid 0x0011
stop_filter:1363: stop filter pid 0x0011
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
update_poll_fds:1297: poll fd 4
WARNING: filter timeout pid 0x0000
remove_filter:1385: remove filter pid 0x0000
stop_filter:1363: stop filter pid 0x0000
update_poll_fds:1297: poll fd 7
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
update_poll_fds:1297: poll fd 6
WARNING: filter timeout pid 0x0010
remove_filter:1385: remove filter pid 0x0010
stop_filter:1363: stop filter pid 0x0010
dumping lists (0 services)
Done.





And here is tzap working (which surely is a good sign that things are
not too bad)

[jon@mythtvtuner ~]$ sudo tzap -a 0 -f 1 -d 0 -c ~/tzap.channels.conf
"BBC ONE(BBC)"
[sudo] password for jon:
using '/dev/dvb/adapter0/frontend1' and '/dev/dvb/adapter0/demux0'
tuning to 650000000 Hz
video pid 0x0065, audio pid 0x0066
status 01 | signal 5151 | snr 8000 | ber 00003fff | unc 00000000 |
status 1f | signal 5050 | snr ffff | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 5050 | snr ffff | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 5050 | snr ffff | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 5050 | snr ffff | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 5050 | snr ffff | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 5050 | snr ffff | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 5050 | snr ffff | ber 00000000 | unc 00000000 | FE_HAS_LOCK


Here is dmesg (some of it)

[   11.870584] Linux media interface: v0.10
[   11.871743] Linux video capture interface: v2.00
[   11.871747] WARNING: You are using an experimental version of the
media stack.
[   11.871748] 	As the driver is backported to an older kernel, it doesn't offer
[   11.871749] 	enough quality for its usage in production.
[   11.871750] 	Use it with care.
[   11.871751] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[   11.871752] 	e9eb0dadba932940f721f9d27544a7818b2fa1c5 [media] V4L
menu: add submenu for platform devices
[   11.871753] 	1df3a2c6d036f4923c229fa98725deda320680e1 [media] cx88:
fix menu level for the VP-3054 module
[   11.871755] 	486eeb5628f812b4836405e2b2e76594287dd873 [media] V4L
menu: move all PCI(e) devices to their own submenu
[   11.872757] WARNING: You are using an experimental version of the
media stack.
[   11.872759] 	As the driver is backported to an older kernel, it doesn't offer
[   11.872760] 	enough quality for its usage in production.
[   11.872761] 	Use it with care.
[   11.872762] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[   11.872763] 	e9eb0dadba932940f721f9d27544a7818b2fa1c5 [media] V4L
menu: add submenu for platform devices
[   11.872764] 	1df3a2c6d036f4923c229fa98725deda320680e1 [media] cx88:
fix menu level for the VP-3054 module
[   11.872766] 	486eeb5628f812b4836405e2b2e76594287dd873 [media] V4L
menu: move all PCI(e) devices to their own submenu
[   11.876985] IR NEC protocol handler initialized
[   11.878126] xen: registering gsi 17 triggering 0 polarity 1
[   11.878133] xen_map_pirq_gsi: returning irq 17 for gsi 17
[   11.878136] xen: --> pirq=17 -> irq=17 (gsi=17)
[   11.878138] Already setup the GSI :17
[   11.878143] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[   11.878147] ALSA sound/pci/hda/hda_intel.c:2415 Using LPIB position fix
[   11.878307] snd_hda_intel 0000:01:00.1: setting latency timer to 64
[   11.878363] cx2388x alsa driver version 0.0.9 loaded
[   11.878385] xen: registering gsi 18 triggering 0 polarity 1
[   11.878388] xen_map_pirq_gsi: returning irq 18 for gsi 18
[   11.878390] xen: --> pirq=18 -> irq=18 (gsi=18)
[   11.878392] Already setup the GSI :18
[   11.878394] cx88_audio 0000:09:00.1: PCI INT A -> GSI 18 (level,
low) -> IRQ 18
[   11.879409] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
[   11.881357] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[   11.881649] IR RC5(x) protocol handler initialized
[   11.882696] ALSA sound/pci/hda/hda_intel.c:1492 Enable sync_write
for stable communication
[   11.884295] cx88[0]: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68,autodetected], frontend(s): 2
[   11.884299] IR RC6 protocol handler initialized
[   11.884302] cx88[0]: TV tuner type 63, Radio tuner type -1
[   11.885880] HDMI status: Codec=0 Pin=3 Presence_Detect=0 ELD_Valid=0
[   11.886302] IR JVC protocol handler initialized
[   11.888016] input: HDA ATI HDMI HDMI/DP as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card0/input6
[   11.889714] IR Sony protocol handler initialized
[   11.892123] IR MCE Keyboard/mouse protocol handler initialized
[   11.894462] lirc_dev: IR Remote Control driver registered, major 249
[   11.894682] IR LIRC bridge handler initialized
[   11.997719] cx88[0]: i2c init: enabling analog demod on
HVR1300/3000/4000 tuner
[   12.000685] i2c-core: driver [tuner] using legacy suspend method
[   12.000688] i2c-core: driver [tuner] using legacy resume method
[   12.016378] tda9887 8-0043: creating new instance
[   12.016382] tda9887 8-0043: tda988[5/6/7] found
[   12.017441] tuner 8-0043: Tuner 74 found with type(s) Radio TV.
[   12.020346] tuner 8-0061: Tuner -1 found with type(s) Radio TV.
[   12.072472] tveeprom 8-0050: Hauppauge model 69009, rev B2D3, serial# 3314002
[   12.072476] tveeprom 8-0050: MAC address is 00:0d:fe:32:91:52
[   12.072478] tveeprom 8-0050: tuner model is Philips FMD1216MEX (idx
133, type 78)
[   12.072480] tveeprom 8-0050: TV standards PAL(B/G) PAL(I)
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[   12.072483] tveeprom 8-0050: audio processor is CX882 (idx 33)
[   12.072484] tveeprom 8-0050: decoder processor is CX882 (idx 25)
[   12.072486] tveeprom 8-0050: has radio, has IR receiver, has no IR
transmitter
[   12.072488] cx88[0]: hauppauge eeprom: model=69009
[   12.075121] tuner-simple 8-0061: creating new instance
[   12.075125] tuner-simple 8-0061: type set to 78 (Philips FMD1216MEX
MK3 Hybrid Tuner)
[   12.105616] Registered IR keymap rc-hauppauge
[   12.105726] input: cx88 IR (Hauppauge WinTV-HVR400 as
/devices/pci0000:00/0000:00:1c.6/0000:08:00.0/0000:09:00.1/rc/rc0/input7
[   12.105798] rc0: cx88 IR (Hauppauge WinTV-HVR400 as
/devices/pci0000:00/0000:00:1c.6/0000:08:00.0/0000:09:00.1/rc/rc0
[   12.105897] input: MCE IR Keyboard/Mouse (cx88xx) as
/devices/virtual/input/input8
[   12.106053] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx)
registered at minor = 0
[   12.106105] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   12.106271] xen: registering gsi 16 triggering 0 polarity 1
[   12.106291] xen_map_pirq_gsi: returning irq 16 for gsi 16
[   12.106293] xen: --> pirq=16 -> irq=16 (gsi=16)
[   12.106295] Already setup the GSI :16
[   12.106299] cx88_audio 0000:09:02.1: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   12.110892] cx88[1]: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68,autodetected], frontend(s): 2
[   12.110895] cx88[1]: TV tuner type 63, Radio tuner type -1
[   12.131644] mtp-probe[800]: checking bus 2, device 4:
"/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6"
[   12.131654] mtp-probe[797]: checking bus 5, device 2:
"/sys/devices/pci0000:00/0000:00:1c.4/0000:06:00.0/usb5/5-2"
[   12.133740] mtp-probe[825]: checking bus 2, device 5:
"/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.1"
[   12.224765] cx88[1]: i2c init: enabling analog demod on
HVR1300/3000/4000 tuner
[   12.229861] mtp-probe[797]: bus: 5, device: 2 was not an MTP device
[   12.230016] mtp-probe[825]: bus: 2, device: 5 was not an MTP device
[   12.230909] mtp-probe[800]: bus: 2, device: 4 was not an MTP device
[   12.251481] tda9887 9-0043: creating new instance
[   12.251484] tda9887 9-0043: tda988[5/6/7] found
[   12.252721] tuner 9-0043: Tuner 74 found with type(s) Radio TV.
[   12.261884] tuner 9-0061: Tuner -1 found with type(s) Radio TV.
[   12.318916] tveeprom 9-0050: Hauppauge model 69009, rev B2D3, serial# 3314061
[   12.318920] tveeprom 9-0050: MAC address is 00:0d:fe:32:91:8d
[   12.318923] tveeprom 9-0050: tuner model is Philips FMD1216MEX (idx
133, type 78)
[   12.318927] tveeprom 9-0050: TV standards PAL(B/G) PAL(I)
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[   12.318930] tveeprom 9-0050: audio processor is CX882 (idx 33)
[   12.318933] tveeprom 9-0050: decoder processor is CX882 (idx 25)
[   12.318935] tveeprom 9-0050: has radio, has IR receiver, has no IR
transmitter
[   12.318938] cx88[1]: hauppauge eeprom: model=69009
[   12.319406] tuner-simple 9-0061: creating new instance
[   12.319410] tuner-simple 9-0061: type set to 78 (Philips FMD1216MEX
MK3 Hybrid Tuner)
[   12.326717] udevd[712]: renamed network interface eth0 to p5p1
[   12.330162] Registered IR keymap rc-hauppauge
[   12.331052] input: cx88 IR (Hauppauge WinTV-HVR400 as
/devices/pci0000:00/0000:00:1c.6/0000:08:00.0/0000:09:02.1/rc/rc1/input9
[   12.331125] rc1: cx88 IR (Hauppauge WinTV-HVR400 as
/devices/pci0000:00/0000:00:1c.6/0000:08:00.0/0000:09:02.1/rc/rc1
[   12.331478] input: MCE IR Keyboard/Mouse (cx88xx) as
/devices/virtual/input/input10
[   12.331757] rc rc1: lirc_dev: driver ir-lirc-codec (cx88xx)
registered at minor = 1
[   12.331809] cx88[1]/1: CX88x/1: ALSA support for cx2388x boards
[   12.332085] xen: registering gsi 18 triggering 0 polarity 1
[   12.332091] xen_map_pirq_gsi: returning irq 18 for gsi 18
[   12.332094] xen: --> pirq=18 -> irq=18 (gsi=18)
[   12.332097] Already setup the GSI :18
[   12.332100] cx8800 0000:09:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   12.332112] cx88[0]/0: found at 0000:09:00.0, rev: 5, irq: 18,
latency: 32, mmio: 0xfa000000
[   12.337223] wm8775 8-001b: chip found @ 0x36 (cx88[0])
[   12.363154] cx88[0]/0: registered device video0 [v4l2]
[   12.363208] cx88[0]/0: registered device vbi0
[   12.363251] cx88[0]/0: registered device radio0
[   12.363328] xen: registering gsi 16 triggering 0 polarity 1
[   12.363334] xen_map_pirq_gsi: returning irq 16 for gsi 16
[   12.363336] xen: --> pirq=16 -> irq=16 (gsi=16)
[   12.363339] Already setup the GSI :16
[   12.363343] cx8800 0000:09:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.363356] cx88[1]/0: found at 0000:09:02.0, rev: 5, irq: 16,
latency: 32, mmio: 0xf6000000
[   12.366580] wm8775 9-001b: chip found @ 0x36 (cx88[1])
[   12.386376] cx88[1]/0: registered device video1 [v4l2]
[   12.386427] cx88[1]/0: registered device vbi1
[   12.386474] cx88[1]/0: registered device radio1
[   12.387179] cx88[0]/2: cx2388x 8802 Driver Manager
[   12.387201] xen: registering gsi 18 triggering 0 polarity 1
[   12.387209] xen_map_pirq_gsi: returning irq 18 for gsi 18
[   12.387212] xen: --> pirq=18 -> irq=18 (gsi=18)
[   12.387216] Already setup the GSI :18
[   12.387220] cx88-mpeg driver manager 0000:09:00.2: PCI INT A -> GSI
18 (level, low) -> IRQ 18
[   12.387235] cx88[0]/2: found at 0000:09:00.2, rev: 5, irq: 18,
latency: 32, mmio: 0xf8000000
[   12.387296] cx88[1]/2: cx2388x 8802 Driver Manager
[   12.387312] xen: registering gsi 16 triggering 0 polarity 1
[   12.387315] xen_map_pirq_gsi: returning irq 16 for gsi 16
[   12.387318] xen: --> pirq=16 -> irq=16 (gsi=16)
[   12.387321] Already setup the GSI :16
[   12.387326] cx88-mpeg driver manager 0000:09:02.2: PCI INT A -> GSI
16 (level, low) -> IRQ 16
[   12.387343] cx88[1]/2: found at 0000:09:02.2, rev: 5, irq: 16,
latency: 32, mmio: 0xf4000000
[   12.393263] WARNING: You are using an experimental version of the
media stack.
[   12.393265] 	As the driver is backported to an older kernel, it doesn't offer
[   12.393266] 	enough quality for its usage in production.
[   12.393267] 	Use it with care.
[   12.393267] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[   12.393269] 	e9eb0dadba932940f721f9d27544a7818b2fa1c5 [media] V4L
menu: add submenu for platform devices
[   12.393270] 	1df3a2c6d036f4923c229fa98725deda320680e1 [media] cx88:
fix menu level for the VP-3054 module
[   12.393271] 	486eeb5628f812b4836405e2b2e76594287dd873 [media] V4L
menu: move all PCI(e) devices to their own submenu
[   12.394524] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[   12.394527] cx88/2: registering cx8802 driver, type: dvb access: shared
[   12.394532] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68]
[   12.394536] cx88[0]/2: cx2388x based DVB/ATSC card
[   12.394538] cx8802_alloc_frontends() allocating 2 frontend(s)
[   12.413195] tuner-simple 8-0061: attaching existing instance
[   12.413200] tuner-simple 8-0061: couldn't set type to 63. Using 78
(Philips FMD1216MEX MK3 Hybrid Tuner) instead
[   12.418555] DVB: registering new adapter (cx88[0])
[   12.418561] DVB: registering adapter 0 frontend 0 (Conexant
CX24116/CX24118)...
[   12.419467] DVB: registering adapter 0 frontend 1 (Conexant CX22702 DVB-T)...
[   12.420230] cx88[1]/2: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68]
[   12.420234] cx88[1]/2: cx2388x based DVB/ATSC card
[   12.420237] cx8802_alloc_frontends() allocating 2 frontend(s)
[   12.427468] tuner-simple 9-0061: attaching existing instance
[   12.427471] tuner-simple 9-0061: couldn't set type to 63. Using 78
(Philips FMD1216MEX MK3 Hybrid Tuner) instead
[   12.433273] DVB: registering new adapter (cx88[1])
[   12.433277] DVB: registering adapter 1 frontend 0 (Conexant
CX24116/CX24118)...
[   12.433962] DVB: registering adapter 1 frontend 1 (Conexant CX22702 DVB-T)..

PS have tried a few different versions of firmware - didn't make a
difference, they all report as loading successfully.

Kaffeine was also unable to scan channels.


Thanks for your time :)



On 12 November 2011 13:20, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Sat, Nov 12, 2011 at 8:14 AM, Lars Schotte <gusto@guttok.net> wrote:
>> i am alos curious what he means by "try to use it". i mean did he try
>> to use it with tzap, or szap, or w_scan, or what? because i dont even
>> know about mythtv, i only use dvbutils, mplayer, xine and vdr.
>
> I agree with Lars on this.  It would be useful if the user could
> describe in more detail his testing methodology.  Also, is there some
> previous kernel in which he knew it was working properly?  Has he
> *ever* seen it work in his environment?  Do we know definitively that
> this really a regression or has the user never seen the board work?
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
