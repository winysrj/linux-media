Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33369 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbbETMHe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 08:07:34 -0400
Date: Wed, 20 May 2015 09:07:27 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jemma Denson <jdenson@gmail.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL v3] for 4.2: add support for cx24120/Technisat SkyStar S2
Message-ID: <20150520090727.1519d0c8@recife.lan>
In-Reply-To: <555C7425.9040101@gmail.com>
References: <20150420092720.3cb092ba@dibcom294.coe.adi.dibcom.com>
	<20150427171628.5ba22752@recife.lan>
	<20150518121115.07d37b78@dibcom294.coe.adi.dibcom.com>
	<20150520100506.10a46054@dibcom294.coe.adi.dibcom.com>
	<555C7425.9040101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick/Jemma,

Em Wed, 20 May 2015 12:46:45 +0100
Jemma Denson <jdenson@gmail.com> escreveu:

> On 20/05/15 09:05, Patrick Boettcher wrote:
> > Hi Mauro,
> >
> > This is an updated version (v3) of the pull-request for integrating the
> > cx24120-driver.
> >
> > Jemma (and partially me) addressed all strict-conding-style-issues and
> > fixed several things regarding signal-stats and demod-issues + some code
> > cleaning in general.
> >
> > Yesterday night Jemma implemented everything related to the UNC and
> > BER-stuff. I also integrated your smatch-patches on my branch.
> >
> > In this mail you'll also find the complete patch, please feel free to
> > review it.

Thank you! It is now in good shape on my eyes. Patches merged. 
The only minor issue is that I had to fold two patches to avoid
compilation breakage in the middle of the patch series, but I
solved this myself.

> >
> >
> 
> Mauro, I have realised I might have made a mistake in how UCB is 
> calculated - I have a patch for this already, should I just send this 
> through to the list on it's own?

Yes, please. I just merged the pull request. So, no need to re-send the
entire patch series again.

Regards,
Mauro
