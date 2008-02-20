Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1KMfVi4005310
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 17:41:31 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1KMf0nY022465
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 17:41:00 -0500
Received: by wf-out-1314.google.com with SMTP id 28so856624wfc.6
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 14:41:00 -0800 (PST)
Message-ID: <175f5a0f0802201441n5ea7bb58rdfa70663799edcad@mail.gmail.com>
Date: Wed, 20 Feb 2008 23:41:00 +0100
From: "H. Willstrand" <h.willstrand@gmail.com>
To: "Thomas Kaiser" <linux-dvb@kaiser-linux.li>
In-Reply-To: <47BCA5BA.20009@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <47BC7E91.6070303@kaiser-linux.li>
	<175f5a0f0802201208u4bca35afqc0291136fe2482b@mail.gmail.com>
	<47BC8BFC.2000602@kaiser-linux.li>
	<175f5a0f0802201232y6a1bfc53u4fe92fede3abcb34@mail.gmail.com>
	<47BC90CA.1000707@kaiser-linux.li>
	<175f5a0f0802201254q7dc96190k35caafe9ba7d3274@mail.gmail.com>
	<47BC9788.7070604@kaiser-linux.li> <20080220215850.GA2391@daniel.bse>
	<47BCA5BA.20009@kaiser-linux.li>
Content-Transfer-Encoding: 8bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: V4L2_PIX_FMT_RAW
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

On Wed, Feb 20, 2008 at 11:12 PM, Thomas Kaiser
<linux-dvb@kaiser-linux.li> wrote:
> Daniel Glöckner wrote:
>  > On Wed, Feb 20, 2008 at 10:11:36PM +0100, Thomas Kaiser wrote:
>  >> H. Willstrand wrote:
>  >>> Well, it can go ugly if one piece of hardware supports several "raw"
>  >>> formats, they need to be distinct. And in the end of the day the V4L2
>  >>> drivers might consist of several identical "raw" formats which then
>  >>> aren't consolidated.
>  >> I don't really understand what you try to say here.
>  >
>  > Think about an analog TV card.
>  > In the future there might be one where RAW could mean either sampled
>  > CVBS or sampled Y/C. The card may be able to provide the Y/C in planar
>  > and packed format. It may be capable of 16 bit at 13.5Mhz and 8 bit at
>  > 27Mhz, ...
>  >
>  > If we start defining raw formats, there needs to be a way to choose
>  > between all those variants without defining lots of additional pixel
>  > formats.
>  >
>  > Maybe an ioctl VIDIOC_S_RAW where one passes a number to select the
>  > variant. An application would then have to check the driver and version
>  > field returned by VIDIOC_QUERYCAP to determine the number to pass. This
>  > way drivers may freely assign numbers to their raw formats.
>
>  Yeh, That's something I mean.
>

Okay, suppose we have pixel formats and raw formats. Comparing with
digital cameras raw usually means non processed image in a proprietary
format. What do we mean here?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
