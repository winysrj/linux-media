Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3F9t0dA013599
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 05:55:00 -0400
Received: from web26102.mail.ukl.yahoo.com (web26102.mail.ukl.yahoo.com
	[217.146.182.143])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3F9sgsl030066
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 05:54:43 -0400
Date: Tue, 15 Apr 2008 11:54:36 +0200 (CEST)
From: linuxcbon <linuxcbon@yahoo.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080414172208.3b20e53d@areia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <969007.77776.qm@web26102.mail.ukl.yahoo.com>
Cc: Video <video4linux-list@redhat.com>, linux-kernel@vger.kernel.org
Subject: RE : Re: RE : Re: Question about Creative Webcam Pro PD1030 ? Bug ?
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


--- Mauro Carvalho Chehab <mchehab@infradead.org> a écrit :

> > I forgot to cc the linux mailing list, so here it is again.
> 
> The better is to copy V4L mailing list.
> 
> > hi Mauro,
> > 
> > thanks for your answer !
> > 
> > I already contacted the authors (Mark,Wallac,Olawlor), but no feedback
> > yet.
> > 
> > I got no oops message from kernel.
> 
> So, this doesn't seem to be a driver issue. I suspect that your
> userspace app
> is trying to configure an unsupported configuration. This driver still
> implements the legacy V4L1 API. Maybe converting it to V4L2 would solve
> your
> issues. Another option is to check if gspca driver works with this
> device.
> 
> Cheers,
> Mauro

Hi,

lsmod gives :
ov511                  77072  0 
compat_ioctl32          1408  1 ov511
videodev               27904  1 ov511
v4l2_common            16896  1 videodev
v4l1_compat            14596  1 videodev

This device works with OV511+ 
(see http://alpha.dyndns.org/ov511/cameras.html).
Difference between OV511 and OV511+ ?

cheers, linuxcbon




      _____________________________________________________________________________ 
Envoyez avec Yahoo! Mail. Une boite mail plus intelligente http://mail.yahoo.fr

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
