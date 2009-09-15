Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59103 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbZIOKy4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 06:54:56 -0400
Subject: Re: tuner, code for discuss
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <200909150826.17805.hverkuil@xs4all.nl>
References: <20090819160700.049985b5@glory.loctelecom.ru>
	 <20090915140715.2b9ea890@glory.loctelecom.ru>
	 <303a8ee30909142118h6808a249o2cb22570fca8dfd4@mail.gmail.com>
	 <200909150826.17805.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 06:56:22 -0400
Message-Id: <1253012182.3166.31.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-09-15 at 08:26 +0200, Hans Verkuil wrote:
> On Tuesday 15 September 2009 06:18:55 Michael Krufky wrote:
> > On Tue, Sep 15, 2009 at 12:07 AM, Dmitri Belimov <d.belimov@gmail.com> wrote:

> > Personally, I don't quite understand why we would need to add such
> > controls NOW, while we've supported this video standard for years
> > already.  I am not arguing against this in any way, but I dont feel
> > like I'm qualified to accept this addition without hearing the
> > opinions of others first.
> > 
> > Can somebody help to shed some light?
> 
> It's the first time I've heard about SECAM and AGC-TOP problems. I do know
> that the TOP value is standard-dependent, although the datasheets recommend
> different SECAM-L values only. So I can imagine that in some cases you would
> like to adjust the TOP value a bit.
> 
> The problem is that end-users will have no idea what to do with a control like
> that. It falls into the category of 'advanced controls' that might be nice to
> add but is only for very advanced users or applications.

The AGC Take Over Point (TOP) is the signal level at which the 2nd stage
of the amplifier chain (after the IF filter) takes over gain control
from the 1st stage in the amplifier chain.  The idea is to maximize
overall noise figure by boosting small signals as needed, but avoiding
hittng amplifer non-linearities that generate intermodulation products
(i.e. spectral "splatter").

The TOP setting depends on the TV standard *and* the attenuation through
the IF filter.  I'm fairly sure, it is something that one probably
should not change to a value different from the manufacturer's
recommendation for a particular TV standard, unless you are dealing with
input signals in a very controlled, known range aor you have taken
measurments inside the tuner and precisely know the loss through the IF
filter.  If the user doesn't understand how the AGC-TOP setting will
affect his overall system noise figure, for all inoming signal
strengths, then the user shouldn't change it. (IMO)



> The proposed media controller actually gives you a way of implementing that
> as tuner-specific controls that do not show up in the regular /dev/videoX
> control list. I have no problems adding an AGC-TOP control as a tuner-specific
> control, but adding it as a generic control is a bad idea IMHO.

If needed, it should be an advanced control or, dare I say, a tunable
via sysfs.  Setting the TOP wrong will simply degrade reception for the
the general case of an unknown incoming signal level.

The tuner-sumple code has initialization values for TOP.  Also there are
some module options for the user to fix TOP to a value, IIRC.  Both are
rather inflexible for someone who does want to manipulate the TOP in an
environment where the incoming RF signal levels are controlled.

Regards,
Andy

> Regards,
> 
> 	Hans


