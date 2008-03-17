Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2HGHlLW028908
	for <video4linux-list@redhat.com>; Mon, 17 Mar 2008 12:17:47 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2HGHBXk024413
	for <video4linux-list@redhat.com>; Mon, 17 Mar 2008 12:17:12 -0400
Received: by nf-out-0910.google.com with SMTP id g13so2068553nfb.21
	for <video4linux-list@redhat.com>; Mon, 17 Mar 2008 09:17:11 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@infradead.org>
From: Frej Drejhammar <frej.drejhammar@gmail.com>
In-Reply-To: <20080317101433.42e56c4c@gaivota> (Mauro Carvalho Chehab's
	message of "Mon, 17 Mar 2008 10:14:33 -0300")
References: <patchbomb.1205671781@liva.fdsoft.se>
	<Pine.LNX.4.58.0803161258550.20723@shell4.speakeasy.net>
	<k1w6a2xdk.fsf@liva.fdsoft.se> <200803171133.58855.hverkuil@xs4all.nl>
	<20080317101433.42e56c4c@gaivota>
Date: Mon, 17 Mar 2008 17:17:04 +0100
Message-ID: <kprtt1g1r.fsf@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com, Trent Piepho <xyzzy@speakeasy.org>
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

> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> What I want to prevent is adding controls as a workaround for what
>> might be a driver bug. So in this case I wonder whether chroma AGC
>> shouldn't be enabled in the cx88 driver as it is for cx2584x.
>> 
>> Looking at the cx25840 datasheet it basically says that it should
>> always be enabled except for component input (YPrPb) or SECAM. So I
>> would suggest doing the same in cx88 rather than adding a
>> control. Only if there are cases where Chroma AGC harms the picture
>> quality rather than improves it, then the addition of a control
>> might become important.

The data sheet for cx2388x is not so clear. For ACGC it describes what
it does and then notes that it can be turned off. The default is off.

For the color-killer there is a similar description, and it then notes
that the color-killer can be disabled. The default is disabled.

Mauro Carvalho Chehab <mchehab@infradead.org> writes:
> IMO, the better would be to add both Chroma AGC and Color Killer
> controls as a generic control.

Is there a procedure for adding controls to the V4L2-spec? Is the
docbook source available in a public repository (not just the tarball
at v4l2spec.bytesex.org)?

> The default value for Chroma AGC should be changed to match the
> datasheet recommended way (0 for SECAM, 1 for PAL/NTSC).

I'll revise the patch to do this.

Regards,

--Frej

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
