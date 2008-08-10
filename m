Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7AGKgKf005232
	for <video4linux-list@redhat.com>; Sun, 10 Aug 2008 12:20:42 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7AGKSBp026242
	for <video4linux-list@redhat.com>; Sun, 10 Aug 2008 12:20:28 -0400
Received: by wf-out-1314.google.com with SMTP id 25so1410762wfc.6
	for <video4linux-list@redhat.com>; Sun, 10 Aug 2008 09:20:28 -0700 (PDT)
From: Kyuma Ohta <whatisthis.sowhat@gmail.com>
To: JeanDelvare <khali@linux-fr.org>, HansVerkuil <hverkuil@xs4all.nl>,
	Video4Linux ML <video4linux-list@redhat.com>,
	ivtv-devel ML <ivtv-devel@ivtvdriver.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080807150738.5b1dde60@hyperion.delvare>
References: <1216308014.1146.22.camel@melchior>
	<200807171758.19702.hverkuil@xs4all.nl>
	<1216336451.1146.41.camel@melchior>
	<200808032312.25222.hverkuil@xs4all.nl>
	<20080807150738.5b1dde60@hyperion.delvare>
Content-Type: text/plain; charset=ISO-2022-JP
Date: Sun, 10 Aug 2008 16:40:59 +0900
Message-Id: <1218354059.5457.9.camel@melchior.hokkemirin.ddo.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: [PATCH AVAIL.]ivtv:Crash 2.6.26 with KUROTOSIKOU CX23416-STVLP
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

Dear Hans,and Jean;
 I was applied Hans's patch to 2.6.26.1 vanilla at
morning of 08/06 (JST),and running to now,problem
cause from IIC issue was not happend.
 Thanx for you (^^)

Ohta
---
E-Mail: whatisthis.sowhat@gmail.com (Public)
Home Page: http://d.hatena.ne.jp/artane/ 
&nbsp; (Sorry,not maintaining,and written in Japanese only...)
Twitter: Artanejp (Mainly Japanese)
KEYID: 6B79F95F
FINGERPRINT:
9AB3 8569 6033 FDBE 352B&nbsp; CB6D DBFA B9E2 6B79 F95F
---

2008-08-07 (Thu) の 15:07 +0200, Jean Delvare wrote:
> Hi Hans,
> 
> On Sun, 3 Aug 2008 23:12:25 +0200, Hans Verkuil wrote:
> > Hi Ohta,
> > 
> > Well, I picked up my card this weekend and tested it. It turns out to be 
> > an i2c-core.c bug: chips with i2c addresses in the 0x5x range are 
> > probed differently than other chips and the probe command contains an 
> > error. The upd64083 has an address in that range and so was hit by this 
> > bug. The attached patch for linux/drivers/i2c/i2c-core.c will fix it.
> > 
> > As you can see, this mail also goes to Jean Delvare so that he can move 
> > this upstream (should also go to the 2.6.26-stable series, Jean!).
> > 
> > For the ivtv driver this bug will only hit cards where ivtv has to probe 
> > for an upd64083.
> > 
> > SoB for this patch:
> > 
> > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> > 
> > I've verified that this is only an issue with kernels 2.6.26 and up. 
> > Older kernels are not affected unless the ivtv driver from the v4l-dvb 
> > repository is used. To be more precise: this bug has been in i2c-core.c 
> > since 2.6.22, but the ivtv driver in 2.6.26 was the first driver that 
> > used i2c_new_probed_device() with an i2c address in a range that caused 
> > the broken probe to be used.
> 
> Good catch, thanks for the patch. I'll push it to Linus by the end of
> the week.
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
