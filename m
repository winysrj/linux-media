Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab3BOOYE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 09:24:04 -0500
Date: Fri, 15 Feb 2013 12:10:06 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: DVB: EOPNOTSUPP vs. ENOTTY in
 ioctl(FE_READ_UNCORRECTED_BLOCKS)
Message-ID: <20130215121006.504a64b6@redhat.com>
In-Reply-To: <511D5834.2030002@tvdr.de>
References: <511CE2BF.8020905@tvdr.de>
	<511D085A.80009@iki.fi>
	<CAHFNz9JN_z5xa0eyaacdOKSdTJoOqAW87+jeLW+3AnARDVX41g@mail.gmail.com>
	<511D37FF.9070206@iki.fi>
	<CAHFNz9+1w2W0dc9ZrW7mewA7aB4YbuJW7QT5Pr7-m2Js9vpq8A@mail.gmail.com>
	<511D5834.2030002@tvdr.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 Feb 2013 22:33:40 +0100
Klaus Schmidinger <Klaus.Schmidinger@tvdr.de> escreveu:

> On 14.02.2013 20:50, Manu Abraham wrote:
> > On Fri, Feb 15, 2013 at 12:46 AM, Antti Palosaari <crope@iki.fi> wrote:
> >> On 02/14/2013 08:05 PM, Manu Abraham wrote:
> >>>
> >>> On Thu, Feb 14, 2013 at 9:22 PM, Antti Palosaari <crope@iki.fi> wrote:
> >>>>
> >>>> On 02/14/2013 03:12 PM, Klaus Schmidinger wrote:
> >>>>>
> >>>>>
> >>>>> In VDR I use an ioctl() call with FE_READ_UNCORRECTED_BLOCKS on a device
> >>>>> (using stb0899).
> >>>>> After this call I check 'errno' for EOPNOTSUPP to determine whether this
> >>>>> device supports this call. This used to work just fine, until a few
> >>>>> months
> >>>>> ago I noticed that my devices using stb0899 didn't display their signal
> >>>>> quality in VDR's OSD any more. After further investigation I found that
> >>>>> ioctl(FE_READ_UNCORRECTED_BLOCKS) no longer returns EOPNOTSUPP, but
> >>>>> rather
> >>>>> ENOTTY. And since I stop getting the signal quality in case any unknown
> >>>>> errno value appears, this broke my signal quality query function.
> >>>>>
> >>>>> Is there a reason why this has been changed?
> >>>>
> >>>>
> >>>>
> >>>> I changed it in order to harmonize error codes. ENOTTY is correct error
> >>>> code
> >>>> for the case IOCTL is not implemented. What I think it is Kernel wide
> >>>> practice.
> >>>>
> >>>
> >>> By doing so, You BROKE User Space ABI. Whatever it is, we are not allowed
> >>> to
> >>> break User ABI. https://lkml.org/lkml/2012/12/23/75
> >>
> >>
> >> Yes, it will change API, that's clear. But the hell, how you will get
> >> anything fixed unless you change it? Introduce totally new API every-time
> >> when bug is found? You should also understand that changing that single
> >> error code on that place will not change all the drivers and there will be
> >> still some other error statuses returned by individual drivers.
> >>
> >> It is about 100% clear that ENOTTY is proper error code for unimplemented
> >> IOCTL. I remember maybe more than one discussion about that unimplemented
> >> IOCTL error code. It seems to be defined by POSIX [1] standard.
> >
> >
> > It could be. But what I stated is thus:
> >
> > There existed commonality where all unimplemented IOCTL's returned
> > EOPNOTSUPP when the corresponding callback wasn't implemented.
> > So, this was kind of standardized though it was not the ideal thing,
> > though it was not a big issue, it just stated "socket" additionally.
> >
> > You changed it to ENOTTY to make it fit for the idealistic world.
> > All applications that depended for ages, on those error are now broken.
> 
> I'm sorry I stirred up this topic again. I wasn't aware that *this* was
> the reason for https://lkml.org/lkml/2012/12/23/75.

You should also take a look on this one:
	[1] http://permalink.gmane.org/gmane.linux.kernel/1235728
and:
	[2] http://permalink.gmane.org/gmane.linux.kernel/1349845

So, yes, ENOTTY should be the proper error code for it.

> 
> As an application developer myself I don't mind if bugs in drivers are
> fixed, I just wanted to understand the rationale. So now I've learned
> that bugs in drivers can't be fixed, because some software might rely
> on the bug. Oh well...

Unfortunately, yes: fixing driver bugs that break application that
rely on it is a problem. As Linus said on [1]:

	"We may have to revert it if things get too nasty, 
	 but we should have done this years and years ago, so let's hope not."

I think we should revert Antti patch, until we're sure that all applications
are capable of working fine with ENOTTY. Only after that, we can remove the
bad usage of EOPNOTSUPP.

> In this particular function of VDR I have now changed things to no longer
> check for any particular "not supported" errno value, just EINTR. I hope
> that one is standardized enough...

Regards,
Mauro
