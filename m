Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2RJoKIL010656
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 15:50:20 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2RJo66n014171
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 15:50:07 -0400
Date: Thu, 27 Mar 2008 20:49:46 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Azdine Trachi <azdine_trachi@yahoo.ca>
Message-ID: <20080327194946.GA674@daniel.bse>
References: <697162.37449.qm@web31303.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <697162.37449.qm@web31303.mail.mud.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: NTSC digitized raw data using HD 5500 card
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

On Thu, Mar 27, 2008 at 01:11:16PM -0400, Azdine Trachi wrote:
> I have some  questions regarding the card HD 5500 card. 
> My problem is with the analog capture. The card is installed and works for both digital and analog TV. 
> What am looking for is to capture digitized raw data ( sampled at 4 Fsc=14.3 MHz).
> In other words, I want to make the decoder of this card bypass the the built-in Y/C separation block (Comb filtering, Notch filtering ....etc).
> My question  : is it possible to do this?

The Cx2388{0,1,2,3} chip on that card is capable of capturing raw data at 4xFsc
in 16 bit or 8xFsc in 8 bit. You have the choice between three modes:
1. VBI line mode
   The RISC program gets a fixed number of samples per line and can thus
   interleave the fields in memory.
2. VBI frame mode
   The RISC program gets a fixed number of samples per field including
   all sync impulses between lines.
3. CAP_RAW_ALL
   "continuous raw data mode capture"
   The datasheet doesn't tell us what happens if we enable this.

Unfortunately only "1" has been implemented in the cx88 driver and only for 
the lines prior to the active region.

Martin Dudok van Heel from GNU Radio made some modifications to the cx88
driver several years ago:
http://www.olifantasia.com/projects/gnuradio/mdvh/cx2388x/

You could ask him about his progress.
In the end you want to do the same thing as the GNU Radio project.

The Bt8xx ancestors support "1" and "2" with 8 bit samples at 8xFsc.
The bttv driver allows to capture the active region with both modes.
"1" by setting v4l2_vbi_format's start and count values to high values
"2" by using, uhm, VIDEO_PALETTE_RAW, which has been removed recently

> I am using Xawtv (Streamer) for capturing.

Won't work.
You need to write your own small application.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
