Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2HDFhbn003078
	for <video4linux-list@redhat.com>; Mon, 17 Mar 2008 09:15:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2HDFBnP022879
	for <video4linux-list@redhat.com>; Mon, 17 Mar 2008 09:15:11 -0400
Date: Mon, 17 Mar 2008 10:14:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20080317101433.42e56c4c@gaivota>
In-Reply-To: <200803171133.58855.hverkuil@xs4all.nl>
References: <patchbomb.1205671781@liva.fdsoft.se>
	<Pine.LNX.4.58.0803161258550.20723@shell4.speakeasy.net>
	<k1w6a2xdk.fsf@liva.fdsoft.se>
	<200803171133.58855.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Frej Drejhammar <frej.drejhammar@gmail.com>, video4linux-list@redhat.com,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 0 of 2] cx88: Enable additional cx2388x features.
 Version 2
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

On Mon, 17 Mar 2008 11:33:58 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> That's not quite what I meant. I'm responsible of all the MPEG controls, 
> so I'm definitely all for exposing hardware features to the user :-)
> 
> What I want to prevent is adding controls as a workaround for what might 
> be a driver bug. So in this case I wonder whether chroma AGC shouldn't 
> be enabled in the cx88 driver as it is for cx2584x.
> 
> Looking at the cx25840 datasheet it basically says that it should always 
> be enabled except for component input (YPrPb) or SECAM. So I would 
> suggest doing the same in cx88 rather than adding a control. Only if 
> there are cases where Chroma AGC harms the picture quality rather than 
> improves it, then the addition of a control might become important.

IMO, the better would be to add both Chroma AGC and Color Killer controls as a generic control.

The default value for Chroma AGC should be changed to match the datasheet recommended
way (0 for SECAM, 1 for PAL/NTSC).

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
