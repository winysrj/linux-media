Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7SJi4cm009617
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 15:44:04 -0400
Received: from mail3.sea5.speakeasy.net (mail3.sea5.speakeasy.net
	[69.17.117.5])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7SJhscK000635
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 15:43:54 -0400
Date: Thu, 28 Aug 2008 12:43:46 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Robert William Fuller <hydrologiccycle@gmail.com>
In-Reply-To: <48B4C328.2040502@gmail.com>
Message-ID: <Pine.LNX.4.58.0808281236330.2423@shell2.speakeasy.net>
References: <200808251445.22005.jdelvare@suse.de>
	<1219711251.2796.47.camel@morgan.walls.org>
	<20080826232913.GA2145@daniel.bse>
	<Pine.LNX.4.58.0808261911000.2423@shell2.speakeasy.net>
	<48B4C328.2040502@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Jean Delvare <jdelvare@suse.de>
Subject: Re: [v4l-dvb-maintainer] bttv driver questions
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

On Tue, 26 Aug 2008, Robert William Fuller wrote:
> Trent Piepho wrote:
> >> The driver fills buffers with instructions for the DMA engine, one buffer
> >> for the top field and one for the bottom field. These instructions tell
> >> the engine where to write a specific pixel. For interlaced video the
> >> instructions for the top field write to line 0, 2, 4, ... in memory and for
> >> the bottom field to line 1, 3, 5, ... .
> >
> > Keep in mind that _either_ field can be transmitted first.  I.e., in some
> > cases one first writes lines 1,3,5 then lines 0,2,4.  I'm not sure if bttv
> > supports both field dominances or not, but I think it does.
>
> My particular board always returns top field first on capture.  I don't
> know if that helps.

V4L2 allows the application to select the field dominance,
V4L2_FIELD_INTERLACED_TB vs V4L2_FIELD_INTERLACED_BT.  The bt878 chip can
support both, but I don't know if the bttv driver has support for it.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
