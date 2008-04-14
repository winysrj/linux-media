Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3EKONH2010579
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 16:24:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3EKOBCo018771
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 16:24:11 -0400
Date: Mon, 14 Apr 2008 17:22:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: linuxcbon <linuxcbon@yahoo.fr>
Message-ID: <20080414172208.3b20e53d@areia>
In-Reply-To: <483029.85409.qm@web26113.mail.ukl.yahoo.com>
References: <20080412135207.79f7fce1@areia>
	<483029.85409.qm@web26113.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Video <video4linux-list@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: RE : Re: Question about Creative Webcam Pro PD1030 ? Bug ?
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

> I forgot to cc the linux mailing list, so here it is again.

The better is to copy V4L mailing list.

> hi Mauro,
> 
> thanks for your answer !
> 
> I already contacted the authors (Mark,Wallac,Olawlor), but no feedback
> yet.
> 
> I got no oops message from kernel.

So, this doesn't seem to be a driver issue. I suspect that your userspace app
is trying to configure an unsupported configuration. This driver still
implements the legacy V4L1 API. Maybe converting it to V4L2 would solve your
issues. Another option is to check if gspca driver works with this device.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
