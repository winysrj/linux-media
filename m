Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2CDhQws010289
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 09:43:26 -0400
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2CDgsdF013545
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 09:42:55 -0400
Received: by mu-out-0910.google.com with SMTP id i10so8292261mue.5
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 06:42:54 -0700 (PDT)
Date: Wed, 12 Mar 2008 21:42:47 +0800
From: Limin Wang <lance.lmwang@gmail.com>
To: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
Message-ID: <20080312134247.GA5902@lmwangpc.yuvad.cn>
References: <20080312082530.GA3570@lmwangpc.yuvad.cn>
	<47D7A00C.1020307@cineca.it>
	<20080312101633.GA4654@lmwangpc.yuvad.cn>
	<20080312113807.GB20885@stinkie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080312113807.GB20885@stinkie>
Content-Transfer-Encoding: 8bit
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

Hi,

* Daniel Glöckner <daniel-gl@gmx.net> [2008-03-12 12:38:07 +0100]:

> On 12 Mar 08 18:16, Limin Wang wrote:
> > Thanks for your comments, I have look at their SDK. It seems that they save
> > the orignal SDI data into file and haven't any interface to demux the video 
> > and audio of the raw SDI stream. I need to transcode the SDI to other compress
> > format h264/aac etc to save disk space.
> 
> You shouldn't make your decision to buy a card depend on the SDK.
> When I look at the "SDK", I see a complete open source public domain driver
> that gives access to all aspects of the SDI stream.
> 
> As SDI is uncompressed, it should be a matter of hours to write a
> demultiplexer and feed the streams to x264 and faac or any other compresser.
> 
> I found the Ingex software suite that deals with SDI data on Sourceforge.
> Maybe it includes a demultiplexer you can use.
> 
> Btw., the PCIe version is 5% cheaper.

thanks to all for your information. I haven't look at SDI format in detail. To
my knowledge, it can embedded audio with uncompress or compress format, so any
idea about it? Any question for audio/video sync? If I had to write SDI
de-muxer, what's the specs to process all SDI format so that I can demux it by
the definition of standard.


Thanks,
Limin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
