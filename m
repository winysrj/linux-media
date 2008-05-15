Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4F3DB9U003158
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 23:13:11 -0400
Received: from mail1.sea5.speakeasy.net (mail1.sea5.speakeasy.net
	[69.17.117.3])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4F3CxM8000342
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 23:12:59 -0400
Date: Wed, 14 May 2008 20:12:53 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Greg KH <greg@kroah.com>
In-Reply-To: <20080515024141.GB21941@kroah.com>
Message-ID: <Pine.LNX.4.58.0805142006130.23876@shell4.speakeasy.net>
References: <20080514205927.GA13134@kroah.com>
	<d9def9db0805141817n4182deedp780791b0a51fb7be@mail.gmail.com>
	<20080515024141.GB21941@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, dean@sensoray.com,
	video4linux-list@redhat.com, mchehab@infradead.org,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] USB: add Sensoray 2255 v4l driver
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

On Wed, 14 May 2008, Greg KH wrote:
> On Thu, May 15, 2008 at 03:17:42AM +0200, Markus Rechberger wrote:
> > Hi Dean, Greg,
>
> Adding dean to the cc: line...  :)
> >
> > On 5/14/08, Greg KH <greg@kroah.com> wrote:
> > > From: Dean Anderson <dean@sensoray.com>
> > >
>
> <big patch snipped>
>
> > Why do you do those conversions in kernelspace?
> > ffmpeg/libswscale has optimized code for colourspace conversions.
> > I know a few drivers do that in kernelspace but it's way more flexible
> > in userspace and depending on the optimization requires less CPU
> > power.
>
> I thought they were there as needed by some V4L1 applications, but that
> code was recently removed by Dean I think.  If they don't need to be
> there, and userspace apps can properly handle the different colorspace,
> then I'll be glad to remove them.

Virtually all apps (V4L1 & 2) can handle YUV and RGB colorspaces.
Certainly all the major ones do and all the major libraries as well.

The problem is when the device only supports some vendor specific or
otherwise very uncommon format.  In that case not doing the conversion in
the kernel means the device won't work with any existing software without
patches.  In this case, while it's not "the right way", drivers often end
up including an in kernel conversion for pragmatic reasons.

This was a problem with the bayer format, but now userspace support for
that format is more common.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
