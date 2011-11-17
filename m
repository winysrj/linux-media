Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51083 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab1KQWJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 17:09:24 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RRA94-0006ro-Sa
	for linux-media@vger.kernel.org; Thu, 17 Nov 2011 23:09:22 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 23:09:22 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 23:09:22 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: "scan" returns channels with no VID
Date: Thu, 17 Nov 2011 17:09:08 -0500
Message-ID: <4EC58604.3070509@interlinx.bc.ca>
References: <ja3vrr$27b$1@dough.gmane.org> <CAGoCfiz6K-8q3zCRWPhAWtxzJyJ_DVvEXu8PR2-A2ER=XqYj6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF11D9E5FEF0544330924C2F9"
In-Reply-To: <CAGoCfiz6K-8q3zCRWPhAWtxzJyJ_DVvEXu8PR2-A2ER=XqYj6A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF11D9E5FEF0544330924C2F9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11-11-17 04:58 PM, Devin Heitmueller wrote:
>=20
> I'm not sure about the ones that don't have a VID, but the ones that
> have a VID which aren't viewable are probably because they're
> encrypted.

Fair enough.

> The /usr/bin/scan tool will return channels in the list
> regardless of whether they can actually be viewed without a Cablecard.

Understood.

Ultimately, I'm looking at the PID/AID values because mplayer/mencoder
doesn't seem to be able to find video on one of these known-functional
channels:

$ mencoder -v dvb://122 -o test.mpg -oac copy -ovc copy -dvbin
card=3D2:file=3D~/.mplayer/channels.conf.atsc
=2E..
get_path('channels.conf.atsc') -> '/home/brian/.mplayer/channels.conf.ats=
c'
CONFIG_READ FILE: /home/brian/.mplayer/channels.conf.atsc, type: 4
=2E..
ATSC, NUM: 108, NUM_FIELDS: 4, NAME: 109, FREQ: 555000000
 PIDS:  3695  3696  0
ATSC, NUM: 109, NUM_FIELDS: 4, NAME: 110, FREQ: 555000000
 PIDS:  3693  3694  0
ATSC, NUM: 110, NUM_FIELDS: 4, NAME: 111, FREQ: 561000000
 PIDS:  7313  7315  0
=2E..
ATSC, NUM: 119, NUM_FIELDS: 4, NAME: 120, FREQ: 585000000
 PIDS:  0  5842
ATSC, NUM: 120, NUM_FIELDS: 4, NAME: 121, FREQ: 585000000
 PIDS:  0  5846
ATSC, NUM: 121, NUM_FIELDS: 4, NAME: 122, FREQ: 585000000
 PIDS:  0  5848
ATSC, NUM: 122, NUM_FIELDS: 4, NAME: 123, FREQ: 585000000
 PIDS:  0  5850
ATSC, NUM: 123, NUM_FIELDS: 4, NAME: 124, FREQ: 585000000
 PIDS:  0  5844
=2E..
DVB_CONFIG, can't open device /dev/dvb/adapter2/frontend0, skipping
DVB_CONFIG, can't open device /dev/dvb/adapter3/frontend0, skipping
OPEN_DVB: prog=3D122, card=3D2, type=3D4

dvb_streaming_start(PROG: 122, CARD: 2, FILE: ~/.mplayer/channels.conf.at=
sc)
PROGRAM NUMBER 121: name=3D122, freq=3D585000000
DVB_OPEN_DEVICES(2)
OPEN(0), file /dev/dvb/adapter1/demux0: FD=3D4, CNT=3D0
OPEN(1), file /dev/dvb/adapter1/demux0: FD=3D5, CNT=3D1
DVB_SET_CHANNEL: new channel name=3D122, card: 1, channel 121
dvb_tune Freq: 585000000
TUNE_IT, fd_frontend 3, fd_sec -1
freq 585000000, srate 0, pol Using DVB card "Samsung S5H1409 QAM/8VSB
Frontend"
tuning ATSC to 585000000, modulation=3D5
Getting frontend status
Bit error rate: 0
Signal strength: 316
SNR: 316
UNC: 0
FE_STATUS: FE_HAS_LOCK FE_HAS_SYNC
SET PES FILTER ON PID 0 to fd 4, RESULT: 0, ERRNO: 0
SET PES FILTER ON PID 5848 to fd 5, RESULT: 0, ERRNO: 0
SUCCESSFUL EXIT from dvb_streaming_start
STREAM: [dvbin] dvb://122
STREAM: Description: Dvb Input
STREAM: Author: Nico
STREAM: Comment: based on the code from ??? (probably Arpi)
success: format: 29  data: 0x0 - 0x0
Checking for MPEG-TS...
TRIED UP TO POSITION 0, FOUND 47, packet_size=3D 188, SEEMS A TS? 1
GOOD CC: 30, BAD CC: 0
TS file format detected.
DEMUX OPEN, AUDIO_ID: -1, VIDEO_ID: -1, SUBTITLE_ID: -1,
Checking for MPEG-TS...
TRIED UP TO POSITION 8272, FOUND 47, packet_size=3D 188, SEEMS A TS? 1
GOOD CC: 30, BAD CC: 0
PROBING UP TO 0, PROG: 0
COLLECT_SECTION, start: 64, size: 184, collected: 0
SKIP: 0+1, TID: 0, TLEN: 49, COLLECTED: 184
PARSE_PAT: section_len: 49, section 0/0
PROG: 11 (1-th of 10), PMT: 139
PROG: 77 (2-th of 10), PMT: 140
PROG: 936 (3-th of 10), PMT: 141
PROG: 958 (4-th of 10), PMT: 142
PROG: 19 (5-th of 10), PMT: 143
PROG: 24 (6-th of 10), PMT: 144
PROG: 51 (7-th of 10), PMT: 145
PROG: 85 (8-th of 10), PMT: 146
PROG: 522 (9-th of 10), PMT: 147
PROG: 521 (10-th of 10), PMT: 148
COLLECT_SECTION, start: 64, size: 184, collected: 184
SKIP: 0+1, TID: 0, TLEN: 49, COLLECTED: 184
PARSE_PAT: section_len: 49, section 0/0
PROG: 11 (1-th of 10), PMT: 139
PROG: 77 (2-th of 10), PMT: 140
PROG: 936 (3-th of 10), PMT: 141
PROG: 958 (4-th of 10), PMT: 142
PROG: 19 (5-th of 10), PMT: 143
PROG: 24 (6-th of 10), PMT: 144
PROG: 51 (7-th of 10), PMT: 145
PROG: 85 (8-th of 10), PMT: 146
PROG: 522 (9-th of 10), PMT: 147
PROG: 521 (10-th of 10), PMT: 148
=2E..
NO VIDEO! AUDIO A52(pid=3D5848) NO SUBS (yet)!  PROGRAM N. 0
=3D=3D> Found audio stream: 0

ADDED AUDIO PID 5848, type: 2000 stream n. 0
Opened TS demuxer, audio: 2000(pid 0), video: ffffffff(pid
-1)...POS=3D18800, PROBE=3D0

demux_ts, switched to audio pid 5848, id: 0, sh: 0x9e74088
Video stream is mandatory!

Exiting...

Is this because the VID is 0 or is that unrelated to why this isn't worki=
ng?

Cheers,
b.


--------------enigF11D9E5FEF0544330924C2F9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7FhgQACgkQl3EQlGLyuXA8HQCg5CThCvSXOByaTPPcW1Joc4Wq
18AAoPj+qPbjTL124zvzbvfcBYM717tT
=yEh9
-----END PGP SIGNATURE-----

--------------enigF11D9E5FEF0544330924C2F9--

