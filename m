Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m76DITOf014986
	for <video4linux-list@redhat.com>; Wed, 6 Aug 2008 09:18:29 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m76DIFv9031201
	for <video4linux-list@redhat.com>; Wed, 6 Aug 2008 09:18:15 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1450292ywb.81
	for <video4linux-list@redhat.com>; Wed, 06 Aug 2008 06:18:15 -0700 (PDT)
From: Kyuma Ohta <whatisthis.sowhat@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Video4Linux ML <video4linux-list@redhat.com>,
	ivtv-devel ML <ivtv-devel@ivtvdriver.org>
In-Reply-To: <200808032312.25222.hverkuil@xs4all.nl>
References: <1216308014.1146.22.camel@melchior>
	<200807171758.19702.hverkuil@xs4all.nl>
	<1216336451.1146.41.camel@melchior>
	<200808032312.25222.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 22:18:02 +0900
Message-Id: <1218028683.31961.21.camel@melchior>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: [ivtv-devel] [PATCH AVAIL.]ivtv:Crash 2.6.26 with KUROTOSIKOU
	CX23416-STVLP
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

Dear Hans,
Sorry for later  picked up this article cause of my lazyness(^^;

Thanx for check I2C bus on card you have...I've no physical probes 
(such as oscillo-scope or cheapi2c!!) now...thanx... 

I'll test attached patch until after morning (in JAPAN) firstly,
and testing long-running if happend nothing above short test..
If problem will be occured,'ll report .

Best regards,
Ohta.

2008-08-03 (Sun) ,23:12 +0200  Hans Verkuil Wrote:
> Hi Ohta,
> 
> Well, I picked up my card this weekend and tested it. It turns out to be 
> an i2c-core.c bug: chips with i2c addresses in the 0x5x range are 
> probed differently than other chips and the probe command contains an 
> error. The upd64083 has an address in that range and so was hit by this 
> bug. The attached patch for linux/drivers/i2c/i2c-core.c will fix it.
> 
> As you can see, this mail also goes to Jean Delvare so that he can move 
> this upstream (should also go to the 2.6.26-stable series, Jean!).
> 
> For the ivtv driver this bug will only hit cards where ivtv has to probe 
> for an upd64083.
> 
> SoB for this patch:
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> I've verified that this is only an issue with kernels 2.6.26 and up. 
> Older kernels are not affected unless the ivtv driver from the v4l-dvb 
> repository is used. To be more precise: this bug has been in i2c-core.c 
> since 2.6.22, but the ivtv driver in 2.6.26 was the first driver that 
> used i2c_new_probed_device() with an i2c address in a range that caused 
> the broken probe to be used.
> 
> Thanks for the report Ohta!
> 
> Regards,
> 
> 	Hans
> 
> On Friday 18 July 2008 01:13:45 Kyuma Ohta wrote:
> > Dear Hans,
> > Thanx for reply.
> >
> > Hans Verkuil wrote:
> > > On Thursday 17 July 2008 17:20:14 Kyuma Ohta wrote:
> > > > Hi,
> > > > I'm testing 2.6.26/amd64 with Athlon64 x2 Box with
> > > > KUROTOSIKOU CX23416-STVLP,always crash ivtv driver
> > > > when loading upd64083 driver.
> > > > I checked crash dump,this issue cause of loading
> > > > upd64083.ko with i2c_probed_new_device().
> > > > So,I fixed ivtv-i2c.c of 2.6.26 vanilla,and
> > > > fixed *pretty* differnce memory allocation,structure
> > > > of upd64083.c.
> > > > I'm running patched 2.6.26 vanilla with below attached
> > > > patches over 24hrs,and over 10hrs recording from ivtv,
> > > > not happend anything;-)
> > > > Please apply below to 2.6.26.x..
> > > >
> > > > Best regards,
> > > > Ohta.
> > >
> > > Hi Ohta,
> > >
> > > Thanks for the patches. If I'm not mistaken there are several
> > > variants of this card: without upd* devices, only with upd64083 and
> > > with both upd devices. Which one do you have?
> > >
> > > Can you also show the dmesg output when ivtv loads?
> > >
> > > Looking at the four patches, I would say that the only relevant
> > > patch is the fix-probing patch. If you try it with only that one
> > > applied, does it still work correct for you? Note that this patch
> > > will not work with a KUROTOSIKOU card that has no upd* devices at
> > > all.
> > >
> > > Can you also give me the kernel backtrace when you load ivtv with
> > > the vanilla 2.6.26? I do not quite understand why it should crash.
> > >
> > > Regards,
> > >
> > > 	Hans
> >
> > I have a ivtv card with *both* upd64083 and upd64031a.
> > I don't still try testing apply only one of patch,only
> > apply all of...
> >
> > I attach compressed logs when loading ivtv at boottime,
> > parallel probing saa7134 v4l2 device,
> > both applied (successed) ,not applied (failed).
> >
> > Best regards,
> > Ohta
> >
> >
> >
> > E-Mail: whatisthis.sowhat@gmail.com (Public)
> > Home Page: http://d.hatena.ne.jp/artane/
> >   (Sorry,not maintaining,and written in Japanese only...)
> > Twitter: Artanejp (Mainly Japanese)
> > ICQ: 366538955
> > KEYID: 6B79F95F
> > FINGERPRINT:
> > 9AB3 8569 6033 FDBE 352B  CB6D DBFA B9E2 6B79 F95F
> 
> 
E-Mail: whatisthis.sowhat@gmail.com (Public)
Home Page: http://d.hatena.ne.jp/artane/ 
  (Sorry,not maintaining,and written in Japanese only...)
Twitter: Artanejp (Mainly Japanese)
ICQ: 366538955
KEYID: 6B79F95F
FINGERPRINT:
9AB3 8569 6033 FDBE 352B  CB6D DBFA B9E2 6B79 F95F



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
