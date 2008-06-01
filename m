Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m512B6Ii015639
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 22:11:06 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m512AaNG012674
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 22:10:54 -0400
Received: by yw-out-2324.google.com with SMTP id 5so195889ywb.81
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 19:10:54 -0700 (PDT)
Date: Sat, 31 May 2008 23:10:49 -0300
From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
To: daniel@gimpelevich.san-francisco.ca.us
Message-ID: <20080531231049.725bf4d2@tux>
In-Reply-To: <c5bea28d26aa1caa1e85da.20080531171359.qnavryt4@webmail.dslextreme.com>
References: <c5bea28d26aa1caa1e85da.20080531171359.qnavryt4@webmail.dslextreme.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: komendantsky@gmail.com, video4linux-list@redhat.com
Subject: Re: [PATCH] PowerColor RA330 (Real Angel 330) fixes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, 31 May 2008 17:13:59 -0700 (PDT)
"Daniel Gimpelevich" <daniel@gimpelevich.san-francisco.ca.us> wrote:

> I finally got around to the RA330 patches. Here is hopefully the final
> fix. Also attached is the revised lircd.conf for its IR receiver. The IR
> codes are somehow different from what was needed with Markus Rechberger's
> flavor of the driver.

	Hi Daniel. Regarding your patch (patch1.diff), I have the
following problems if I apply it:

1) the sound from TV/radio doesn't work

2) the s-video input image worked with tvtime but didn't work with
mencoder (it recorded everything as a black screen). Without your patch
(and using v25 firmware, mencoder works fine). I record using:

mencoder -tv device=/dev/video1:input=2:norm=pal-m:amode=1 -ovc lavc
-lavcopts vcodec=mpeg4:mbd=1 -oac mp3lame
-o /home/fraga/src/tvrecord-${TODAY}-${NOW}.avi tv://

	I'm using the following firmware:

e7ffa23f8898839ebeb6e2e8b65f829e  xc3028-v27.fw

	since you changed to v27, but are you completely sure that this
board works with v27 firmware? Or am I using a different v27 firmware? If so, 
can you send me the correct one?

	Do you have any suggestions?

	For example, with your patch, if I try to use gqradio, I get:

May 31 22:57:31 tux vmunix: xc2028 0-0061: should set frequency 103300 kHz
May 31 22:57:32 tux vmunix: xc2028 0-0061: check_firmware called
May 31 22:57:32 tux vmunix: xc2028 0-0061: checking firmware, user requested type=FM (400), id 0000000000000000, scode_tbl (0), scode_nr 0
May 31 22:57:32 tux vmunix: cx88[0]: Calling XC2028/3028 callback
May 31 22:57:33 tux vmunix: xc2028 0-0061: load_firmware called
May 31 22:57:35 tux vmunix: xc2028 0-0061: seek_firmware called, want type=BASE FM (401), id 0000000000000000.
May 31 22:57:35 tux vmunix: xc2028 0-0061: Found firmware for type=BASE FM (401), id 0000000000000000.
May 31 22:57:35 tux vmunix: xc2028 0-0061: Loading firmware for type=BASE FM (401), id 0000000000000000.
May 31 22:57:35 tux vmunix: cx88[0]: Calling XC2028/3028 callback
May 31 22:57:36 tux vmunix: xc2028 0-0061: Load init1 firmware, if exists
May 31 22:57:37 tux vmunix: xc2028 0-0061: load_firmware called
May 31 22:57:37 tux vmunix: xc2028 0-0061: seek_firmware called, want type=BASE INIT1 FM (4401), id 0000000000000000.
May 31 22:57:37 tux vmunix: xc2028 0-0061: Can't find firmware for type=BASE INIT1 FM (4401), id 0000000000000000.
May 31 22:57:37 tux vmunix: xc2028 0-0061: load_firmwarecale
May 31 22:57:37 tux vmunix: 7x22 -01 ekfrwr ald attp=AEII1F 40) d00000000.<>c08006:Cntfn imaefrtp=AEII1F 40) d00000000.<>c08006:la_imaecle
May 31 22:57:37 tux vmunix: 7x22 -01 ekfrwr ald attp=M(0) d00000000.<>c08006:Fudfrwr o yeF 40,i 00000000
May 31 22:57:37 tux vmunix: 6x22 -01 odn imaefrtp=M(0) d00000000.
May 31 22:57:37 tux vmunix: xc2028 0-0061: xc2028_set_aalog_frqcle
May 31 22:57:37 tux vmunix: 7x22 -01 eei_e_rqcle
May 31 22:57:37 tux vmunix: xc22 -01 c08staao_rqcle
May 31 22:57:37 tux vmunix: 7x22 -01 eei_e_rqcle
May 31 22:57:37 tux vmunix: xc2028 0-0061: divisor= 00 00 19 d3 (freq=103.300)
May 31 22:57:37 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:57:37 tux vmunix: xc2028 0-0061: should set frequency 103300 kHz
May 31 22:57:37 tux vmunix: xc2028 0-0061: check_firmwrecle
May 31 22:57:37 tux vmunix: 7x22 -01 hcigfrwr,ue euse yeF 40,i 00000000 cd_b 0,soen 
May 31 22:57:37 tux vmunix: 7x22 -01 AEfrwr o hne.<
May 31 22:57:38 tux vmunix: c08006:sga teghi 
May 31 22:57:38 tux vmunix: cle
May 31 22:57:39 tux vmunix: e
May 31 22:57:40 tux vmunix: g00 ald
May 31 22:57:40 tux vmunix: le
May 31 22:57:41 tux vmunix:  ald
May 31 22:57:41 tux vmunix: 04 ald
May 31 22:57:42 tux vmunix: e
May 31 22:57:43 tux vmunix: d
May 31 22:57:43 tux vmunix: e
May 31 22:57:44 tux vmunix: 00cle
May 31 22:57:45 tux vmunix: c08006:sga teghi 
May 31 22:57:45 tux vmunix: s0
May 31 22:57:46 tux vmunix: d
May 31 22:57:47 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:57:47 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:57:48 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:57:48 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:57:48 tux vmunix: xc2028 0-0061: xc2028_get_reg 0040 called
May 31 22:57:52 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:57:53 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:57:55 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:57:55 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:57:56 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:57:56 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:57:58 tux vmunix: xc2028 0-0061: xc2028_get_reg 0040 called
May 31 22:58:00 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:58:00 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:58:00 tux vmunix: xc2028 0-0061: xc2028_get_reg 0040 called
May 31 22:58:01 tux vmunix: xc2028 0-0061: signal strength is 0
May 31 22:58:02 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:58:02 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:58:03 tux vmunix: xc2028 0-0061: xc2028_get_reg 0040 called
May 31 22:58:03 tux vmunix: xc2028 0-0061: xc2028_get_reg 0040 called
May 31 22:58:03 tux vmunix: xc2028 0-0061: signal strength is 0
May 31 22:58:03 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:58:03 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:58:04 tux vmunix: xc2028 0-0061: signal strength is 0
May 31 22:58:05 tux vmunix: xc2028 0-0061: xc2028_get_reg 0040 called
May 31 22:58:06 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:58:06 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:58:06 tux vmunix: nlsrnt s0
May 31 22:58:08 tux vmunix: ald
May 31 22:58:08 tux vmunix: ald
May 31 22:58:09 tux vmunix: grg00 ald
May 31 22:58:10 tux vmunix:  ald
May 31 22:58:10 tux vmunix: ald
May 31 22:58:11 tux vmunix: d
May 31 22:58:11 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:58:12 tux vmunix: ald
May 31 22:58:13 tux vmunix: 0cle
May 31 22:58:13 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:58:14 tux vmunix: e
May 31 22:58:15 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:58:15 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:58:15 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:58:15 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:58:16 tux vmunix: e
May 31 22:58:16 tux vmunix: c08006:sga teghi 
May 31 22:58:17 tux vmunix: e
May 31 22:58:18 tux vmunix: c08006:sga teghi 
May 31 22:58:18 tux vmunix: e
May 31 22:58:19 tux vmunix: 22
May 31 22:58:20 tux vmunix: e
May 31 22:58:21 tux vmunix: >006:sga teghi 
May 31 22:58:22 tux vmunix: cld
May 31 22:58:23 tux vmunix: 4 ald
May 31 22:58:23 tux vmunix: 
May 31 22:58:25 tux vmunix: c
May 31 22:58:25 tux vmunix: ld
May 31 22:58:26 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:58:26 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:58:27 tux vmunix: xc2028 0-0061: xc2028_get_reg 0040 called
May 31 22:58:28 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:58:28 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called
May 31 22:58:31 tux vmunix: xc2028 0-0061: xc2028_signal called
May 31 22:58:31 tux vmunix: xc2028 0-0061: xc2028_get_reg 0002 called

	Any hints? Thanks!
	
-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
