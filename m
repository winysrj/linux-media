Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4L1V0kA011539
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 21:31:00 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4L1UjDc015402
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 21:30:46 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1053720nfc.21
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 18:30:45 -0700 (PDT)
Date: Wed, 21 May 2008 11:31:44 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080521113144.3a5ca518@glory.loctelecom.ru>
In-Reply-To: <1211331167.4235.26.camel@pc10.localdom.local>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

Hi


> no time at all on it yet, but I confirm that you are in the center of
> the trouble and that empress device and pci device are in sync after
> your patch. Mauro might review it, if some time for it, since he did
> the ioctl2 conversion, but he would need a Signed-off-by line from
> you, if we come through with the rest too that way.

Ok. I patch was send.

> Trying ioctls using qv4l2, which works on older versions for me,
> except for setting TV standard and channel from the empress device,
> we see the next oops coming from saa7134-tvaudio now on my saa7134
> device. (there is some little empress code, saa7134 and
> saa7135/saa7131e are different for audio)

This structure used in many functions added by Mauro.

struct saa7134_fh *fh = priv;
struct saa7134_dev *dev = fh->dev;

empress_g_fmt_cap
empress_s_fmt_cap
empress_reqbufs
empress_querybuf
and other

It is correct for this functions?? 

> Frederic on the known previously working empress saa7134 device on the
> dvb LM seems to be quite happy with the snapshot i pointed too. So if
> your card has no further setup problems, mine has, you might try that
> snapshot too to escape the swamps.

I read from /dev/video1 only 0x00 bytes.
For send data from saa7134 to MPEG chip need configure saa7134 output port for video and audio.
I try it now.

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
