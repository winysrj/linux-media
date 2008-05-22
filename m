Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4MLDUo7015848
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 17:13:30 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4MLCWu5014546
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 17:12:49 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <20080522092452.35878221@glory.loctelecom.ru>
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<20080414172821.3966dfbf@areia>
	<20080415125059.3e065997@glory.loctelecom.ru>
	<20080415000611.610af5c6@gaivota>
	<20080415135455.76d18419@glory.loctelecom.ru>
	<20080415122524.3455e060@gaivota>
	<20080422175422.3d7e4448@glory.loctelecom.ru>
	<20080422130644.7bfe3b2d@gaivota>
	<20080423124157.1a8eda0a@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804222254350.20809@bombadil.infradead.org>
	<20080423160505.36064bf7@glory.loctelecom.ru>
	<20080423113739.7f314663@gaivota>
	<20080424093259.7880795b@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804232237450.31358@bombadil.infradead.org>
	<20080512201114.3bd41ee5@glory.loctelecom.ru>
	<1210719122.26311.37.camel@pc10.localdom.local>
	<20080520152426.5540ee7f@glory.loctelecom.ru>
	<1211331167.4235.26.camel@pc10.localdom.local>
	<20080521131652.5a4850a5@glory.loctelecom.ru>
	<48344B16.2010005@hccnet.nl>
	<20080522092452.35878221@glory.loctelecom.ru>
Content-Type: text/plain
Date: Thu, 22 May 2008 23:11:33 +0200
Message-Id: <1211490693.2511.17.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Gert Vervoort <gert.vervoort@hccnet.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] I2S on for MPEG of saa7134_empress
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


Am Donnerstag, den 22.05.2008, 09:24 +1000 schrieb Dmitri Belimov:
> Hi Gert
> 
> > Dmitri Belimov wrote:
> > > Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov
> > > <d.belimov@gmail.com>
> > >
> > > P.S. After this patch I have some data from /dev/video1. Mplayer
> > > mpeg_test02.dat I can see gray screen with blinked color squares.
> > > May be audio data?
> > >
> > >   
> > If the board has the SAA6752 directly connected to the SAA7134 TS
> > port, then on /dev/video1 there should be MPEG-2 transport stream
> > packets (check for 188 byte packets starting with 0x47).
> 
> I check data. First 4 bytes in data packet is 0x80 0x80 0x80 0x80.
> 
> I add initialization video_out for my card and right data for 
> SAA7134_VIDEO_PORT_CTRL*
> 
> in new data file i have more data but first 4 bytes is 0x89 0x89 0x89 0x89.
> 
> I can send you tared data files if you want.
> Last changes not sended to mailling list.
> 
> > If I remember correctly for the original TS capture code of the
> > SAA7134 driver, if the SAA6752 was not properly enabled or there was
> > no video signal, no data was available on the /dev/video1.
> > At that time I used an user space I2C program to configure the
> > encoder, currently there is a module called  saa6752hs which I
> > suppose does these settings.
> 
> Can you send me this programm??
> 
> With my best regards, Dmitry.

Is there anything known about switching the host mode if DVB and a
encoder is on the same board with a single saa7134 PCI bridge?

We have great progress on some other first class solutions with some
hints we got.

Maybe some reference design?
It is hard to believe, that it comes from elsewhere out of nothing.

There is not any high preference on it, but given that such solutions
have been available long before other competitors came up with something
similarly functional, to have it in GNU/Linux would be a pleasure and
also is some sort of credit/thanks to those who cared about it.

Thanks,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
