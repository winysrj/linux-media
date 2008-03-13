Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DEK902023787
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 10:20:10 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2DEJHjJ029922
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 10:19:17 -0400
Date: Thu, 13 Mar 2008 15:18:57 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Limin Wang <lance.lmwang@gmail.com>
Message-ID: <20080313141857.GA234@daniel.bse>
References: <20080312082530.GA3570@lmwangpc.yuvad.cn>
	<47D7A00C.1020307@cineca.it>
	<20080312101633.GA4654@lmwangpc.yuvad.cn>
	<20080312113807.GB20885@stinkie>
	<20080312134247.GA5902@lmwangpc.yuvad.cn>
	<20080312212158.GA1411@daniel.bse>
	<20080313030209.GA8994@lmwangpc.yuvad.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313030209.GA8994@lmwangpc.yuvad.cn>
Cc: video4linux-list@redhat.com
Subject: Re: any recommendations for SD/SDI cards under linux?
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

On Thu, Mar 13, 2008 at 11:02:09AM +0800, Limin Wang wrote:
> I have no clue about the SDI file format by the wiki, even I have reviewed
> SMPTE 259M document, it's described from hardware level. So any expert know
> which document describe the detailed format?

I think for SD-SDI it's like this:
143 Mb/s = Composite NTSC sampled at 14,3 MHz, SMPTE 244M
177 Mb/s = Composite PAL sampled at 17,7 MHz, IEC 61179-5
270 Mb/s = 4:2:2 Video sampled at 13,5 MHz, SMPTE 125M
360 Mb/s = 4:2:2 Video sampled at 18 MHz, SMPTE 267M

The first two require signal processing to separate luma and chroma.
The last one exceeds the bitrate of the DekTec card.
I doubt the last two standards will tell you a lot more than
"each line consists of {space for ANC} {SAV} {Cb Y Cr Y}+ {EAV}".

SMPTE 291M = How to add ancillary data
SMPTE 272M = How to pack uncompressed audio into ancillary frames
SMPTE 337M = How to pack compressed instead of uncompressed audio

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
