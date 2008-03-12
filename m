Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2CAHJ1p015460
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 06:17:19 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.243])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2CAGdBs024257
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 06:16:39 -0400
Received: by an-out-0708.google.com with SMTP id c31so763136ana.124
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 03:16:39 -0700 (PDT)
Date: Wed, 12 Mar 2008 18:16:33 +0800
From: Limin Wang <lance.lmwang@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20080312101633.GA4654@lmwangpc.yuvad.cn>
References: <20080312082530.GA3570@lmwangpc.yuvad.cn>
	<47D7A00C.1020307@cineca.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D7A00C.1020307@cineca.it>
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


* Andrea Venturi <a.venturi@cineca.it> [2008-03-12 10:19:08 +0100]:

> Limin Wang wrote:
> > Hi,
> > 
> > I am a newbie to the list and can't find how to search on the archive, so
> > had to ask the question here.
> > If you have any recommendations for SDI cards under linux, would you mind
> > telling me? 
> 
> hi,
> 
> we are using Dektec card as ASI ports (for DVB transport stream), under
> linux, and they do have quite a good linux driver, fully open source and
> more than GPL (public domain?) albeit not linux-dvb compliant, but it's
> just a character device.
> 
> the SDI link is the same physical stuff of ASI so for example this card
> shoud work for your task too:
> 
>   http://www.dektec.com/Products/DTA-145/index.asp
> 
> YMMV, i don't have a direct experience about SDI usage, but i had a good
> experience with Dektec stuff so i suggest them quite wholeheartedly
> (btw, don't have any economic interest.. :-)

Thanks for your comments, I have look at their SDK. It seems that they save
the orignal SDI data into file and haven't any interface to demux the video and
audio of the raw SDI stream. I need to transcode the SDI to other compress
format h264/aac etc to save disk space.


Thanks,
Limin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
