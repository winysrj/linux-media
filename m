Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2D32n65029168
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 23:02:49 -0400
Received: from hs-out-0708.google.com (hs-out-0708.google.com [64.233.178.246])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2D32F7W029509
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 23:02:15 -0400
Received: by hs-out-0708.google.com with SMTP id x43so2929157hsb.3
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 20:02:15 -0700 (PDT)
Date: Thu, 13 Mar 2008 11:02:09 +0800
From: Limin Wang <lance.lmwang@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20080313030209.GA8994@lmwangpc.yuvad.cn>
References: <20080312082530.GA3570@lmwangpc.yuvad.cn>
	<47D7A00C.1020307@cineca.it>
	<20080312101633.GA4654@lmwangpc.yuvad.cn>
	<20080312113807.GB20885@stinkie>
	<20080312134247.GA5902@lmwangpc.yuvad.cn>
	<20080312212158.GA1411@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312212158.GA1411@daniel.bse>
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

Hi,

* Daniel Gl?ckner <daniel-gl@gmx.net> [2008-03-12 22:21:58 +0100]:

> On Wed, Mar 12, 2008 at 09:42:47PM +0800, Limin Wang wrote:
> > thanks to all for your information. I haven't look at SDI format in detail. To
> > my knowledge, it can embedded audio with uncompress or compress format, so any
> > idea about it? Any question for audio/video sync? If I had to write SDI
> > de-muxer, what's the specs to process all SDI format so that I can demux it by
> > the definition of standard.
> 
> http://en.wikipedia.org/wiki/Serial_Digital_Interface
> looks like a good starting point

I have no clue about the SDI file format by the wiki, even I have reviewed
SMPTE 259M document, it's described from hardware level. So any expert know
which document describe the detailed format?

By the way, I google this thread for about osprey560 which support v4l:
http://lists-archives.org/video4linux/12385-.html

What's the conclusion about the card? can the latest kernel support the SDI input?


Thanks,
Limin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
