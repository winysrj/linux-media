Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:34878 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbZITEjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 00:39:09 -0400
Subject: Re: tuner, code for discuss
From: hermann pitton <hermann-pitton@arcor.de>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <200909151117.10060.gene.heskett@verizon.net>
References: <20090819160700.049985b5@glory.loctelecom.ru>
	 <200909150826.17805.hverkuil@xs4all.nl>
	 <1253012182.3166.31.camel@palomino.walls.org>
	 <200909151117.10060.gene.heskett@verizon.net>
Content-Type: text/plain
Date: Sun, 20 Sep 2009 06:26:32 +0200
Message-Id: <1253420792.3255.33.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Dienstag, den 15.09.2009, 11:17 -0400 schrieb Gene Heskett:
> On Tuesday 15 September 2009, Andy Walls wrote:
> >On Tue, 2009-09-15 at 08:26 +0200, Hans Verkuil wrote:
> >> On Tuesday 15 September 2009 06:18:55 Michael Krufky wrote:
> >> > On Tue, Sep 15, 2009 at 12:07 AM, Dmitri Belimov <d.belimov@gmail.com>
> >> > wrote:
> >> >
> >> > Personally, I don't quite understand why we would need to add such
> >> > controls NOW, while we've supported this video standard for years
> >> > already.  I am not arguing against this in any way, but I dont feel
> >> > like I'm qualified to accept this addition without hearing the
> >> > opinions of others first.
> >> >
> >> > Can somebody help to shed some light?
> >>
> >> It's the first time I've heard about SECAM and AGC-TOP problems. I do
> >> know that the TOP value is standard-dependent, although the datasheets
> >> recommend different SECAM-L values only. So I can imagine that in some
> >> cases you would like to adjust the TOP value a bit.
> >>
> >> The problem is that end-users will have no idea what to do with a control
> >> like that. It falls into the category of 'advanced controls' that might
> >> be nice to add but is only for very advanced users or applications.
> >
> >The AGC Take Over Point (TOP) is the signal level at which the 2nd stage
> >of the amplifier chain (after the IF filter) takes over gain control
> >from the 1st stage in the amplifier chain.  The idea is to maximize
> >overall noise figure by boosting small signals as needed, but avoiding
> >hittng amplifer non-linearities that generate intermodulation products
> >(i.e. spectral "splatter").
> >
> >The TOP setting depends on the TV standard *and* the attenuation through
> >the IF filter.  I'm fairly sure, it is something that one probably
> >should not change to a value different from the manufacturer's
> >recommendation for a particular TV standard, unless you are dealing with
> >input signals in a very controlled, known range aor you have taken
> >measurments inside the tuner and precisely know the loss through the IF
> >filter.  If the user doesn't understand how the AGC-TOP setting will
> >affect his overall system noise figure, for all inoming signal
> >strengths, then the user shouldn't change it. (IMO)
> 
> As a retired broadcast engineer, I can say that generally speaking, this is a 
> knob that shouldn't be enabled.  It may in some cases be able to get a db's 
> worth of improvement, but the potential for worsening it by many db, by 
> someone who doesn't understand the interactions, is much too high.  Given a 
> knob, it will be tweaked, usually detrimentally.

you likely get more readers on linux-media@vger.kernel.org these days,
which was considered the right thing to change to next, but, unlike the
dvb ML, video4linux still does not give any advice to the users to
change over to vger.

The Beholder Labs initially planed to introduce it to all tuners around,
including all Multi Europe Philips FM1216ME MK3.

We previously had separate tuners for Russia, maybe only caused by the
different radio bandwidth, but the point when that changed, and it did,
is still not fully investigated.

The case here now is, that we eventually have to deal with at least two
issues.

One is known as "Secam fire" ...
No such complaints on the original Philips tuners during the last four
years so far.

The other one is, that believed _one to one_ Chinese clones of the
original Philips tuners, still using the same Philips chips, have
different SAW filters.

My assumption so far is, that they are not as linear as claimed over the
covered (uncovered ;) frequency ranges, some ups and downs, and that is
what Dmitry tries to compensate in software. And least their labs have
good results for that ... ;)

The Russian border to China is very long, Dmitry told they can tweak
those tuners to receive, maybe somehow limited, even Chinese broadcast.

We have some special case here, so I don't tell just ignore it per se,
but we are also not forced to please some undocumented, maybe wrong
documented, hardware.

Cheers,
Hermann

> >> The proposed media controller actually gives you a way of implementing
> >> that as tuner-specific controls that do not show up in the regular
> >> /dev/videoX control list. I have no problems adding an AGC-TOP control as
> >> a tuner-specific control, but adding it as a generic control is a bad
> >> idea IMHO.
> >
> >If needed, it should be an advanced control or, dare I say, a tunable
> >via sysfs.  Setting the TOP wrong will simply degrade reception for the
> >the general case of an unknown incoming signal level.
> >
> >The tuner-sumple code has initialization values for TOP.  Also there are
> >some module options for the user to fix TOP to a value, IIRC.  Both are
> >rather inflexible for someone who does want to manipulate the TOP in an
> >environment where the incoming RF signal levels are controlled.
> >
> >Regards,
> >Andy
> >
> >> Regards,
> >>
> >> 	Hans
> >


