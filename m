Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5II7u15022303
	for <video4linux-list@redhat.com>; Wed, 18 Jun 2008 14:07:56 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5II7gN7025191
	for <video4linux-list@redhat.com>; Wed, 18 Jun 2008 14:07:44 -0400
Date: Wed, 18 Jun 2008 20:07:17 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Veda N <veda74@gmail.com>
Message-ID: <20080618180717.GA272@daniel.bse>
References: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
	<20080617092439.GA631@daniel.bse>
	<a5eaedfa0806170239ye9951acv1cc9361b1d43abbe@mail.gmail.com>
	<20080617094510.GA726@daniel.bse>
	<a5eaedfa0806170322v382f5b98o22f2b94830585f7c@mail.gmail.com>
	<20080617104614.GA781@daniel.bse>
	<a5eaedfa0806170815m2911f480lbed9b4fc18622b09@mail.gmail.com>
	<20080617172433.GA227@daniel.bse>
	<a5eaedfa0806180815t6172ad0qf7fa6ccb764c20c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5eaedfa0806180815t6172ad0qf7fa6ccb764c20c0@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: v4l2_pix_format doubts
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

On Wed, Jun 18, 2008 at 08:45:05PM +0530, Veda N wrote:
> Does this value depend on any way of bpp (bits per pixel?)

Pixelformat depends on bpp.
And bytesperline depends on pixelformat, width, and the padding needed by
the hardware.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
