Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35029 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab2GMKAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 06:00:30 -0400
Date: Fri, 13 Jul 2012 11:00:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Olof Johansson <olof@lixom.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	KS2012 <ksummit-2012-discuss@lists.linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] Device-tree cross-subsystem binding
 workshop [was Media system Summit]
Message-ID: <20120713100020.GA8925@sirena.org.uk>
References: <CAOesGMgs7sBn=Tfk6YP7BE=O0s8qQrz17n-GfEi_Vr2HDy6xZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgs7sBn=Tfk6YP7BE=O0s8qQrz17n-GfEi_Vr2HDy6xZA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 12, 2012 at 06:20:27PM -0700, Olof Johansson wrote:
> On Thu, Jul 12, 2012 at 12:03 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> > I'm not so sure: I think that most decisions that need to be made are
> > quite subsystem specific. Trying to figure out how to implement DT for
> > multiple subsystems in one workshop seems unlikely to succeed, simply
> > because of lack of time. I also don't think there is much overlap between
> > subsystems in this respect, so while the DT implementation for one subsystem
> > is discussed, the representatives of other subsystems are twiddling their
> > thumbs.

I'm seeing an awful lot of common patterns in the way the hardware is
structured here, we shouldn't be redoing the handling of all these
patterns.  Obviously there will be subsystem specific stuff too but
there's a lot of repetitive boiler plate in the high level hookup.
