Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5D6NlBn031486
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 02:23:47 -0400
Received: from smtp40.hccnet.nl (smtp40.hccnet.nl [62.251.0.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5D6NajJ011489
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 02:23:36 -0400
Message-ID: <2a93ca18e1d9bc5726b7f1fd60da1852.squirrel@webmail.hccnet.nl>
In-Reply-To: <20080612194426.0e33d92c@glory.loctelecom.ru>
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
	<20080612194426.0e33d92c@glory.loctelecom.ru>
Date: Fri, 13 Jun 2008 08:23:22 +0200 (CEST)
From: gert.vervoort@hccnet.nl
To: "Dmitri Belimov" <d.belimov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Beholder card M6 with MPEG2 coder
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

Op Do, 12 juni, 2008 11:44 am schreef Dmitri Belimov:
> Hi All
>

Hi Dmitri,

>
> I found strange effect. When I start common TV watching with mplayer. I
> can see TV video. When I start cat /dev/video1 (i try get MPEG stream of
> TV) on the TV screen I see sometimes
> big white square. After stopped cat from /dev/video1 this squares no more.
>
>
> What is it??
>

What video format is being used for the TV video?
I remember that the SAA7134 can not use a planar video format and TS
capture at the same time.
When I added the original TS capture code, I did not deal with this
situation, but I'm not sure if that is still the case.

    Gert


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
