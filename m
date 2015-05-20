Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:43826 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbbETMeP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 08:34:15 -0400
Date: Wed, 20 May 2015 14:34:12 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Jemma Denson <jdenson@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL v3] for 4.2: add support for cx24120/Technisat SkyStar S2
Message-ID: <20150520143412.4d9fe9c0@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <20150520090727.1519d0c8@recife.lan>
References: <20150420092720.3cb092ba@dibcom294.coe.adi.dibcom.com>
	<20150427171628.5ba22752@recife.lan>
	<20150518121115.07d37b78@dibcom294.coe.adi.dibcom.com>
	<20150520100506.10a46054@dibcom294.coe.adi.dibcom.com>
	<555C7425.9040101@gmail.com>
	<20150520090727.1519d0c8@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 May 2015 09:07:27 -0300 Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:

> Hi Patrick/Jemma,
> 
> Em Wed, 20 May 2015 12:46:45 +0100
> Jemma Denson <jdenson@gmail.com> escreveu:
> 
> > On 20/05/15 09:05, Patrick Boettcher wrote:
> > > Hi Mauro,
> > >
> > > This is an updated version (v3) of the pull-request for integrating the
> > > cx24120-driver.
> > >
> > > Jemma (and partially me) addressed all strict-conding-style-issues and
> > > fixed several things regarding signal-stats and demod-issues + some code
> > > cleaning in general.
> > >
> > > Yesterday night Jemma implemented everything related to the UNC and
> > > BER-stuff. I also integrated your smatch-patches on my branch.
> > >
> > > In this mail you'll also find the complete patch, please feel free to
> > > review it.
> 
> Thank you! It is now in good shape on my eyes. Patches merged. 
> The only minor issue is that I had to fold two patches to avoid
> compilation breakage in the middle of the patch series, but I
> solved this myself.

Thank you for your help (and especially to Jemma).

(one big thing crossed off my eternal TODO-list.)

best regards,
--
Patrick.
