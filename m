Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbbC1Opv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2015 10:45:51 -0400
Date: Sat, 28 Mar 2015 07:45:49 -0700
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] Adding HVR2205/HVR2255 support / misc cleanup
Message-ID: <20150328074549.749d6fff@concha.lan>
In-Reply-To: <CALzAhNUZzMAqW4xmuoK3sZMM-8tdKaiz973kMhkV_9qTAMEgPw@mail.gmail.com>
References: <CALzAhNXBw-cCvdfb=DjvKaMfk3JEyoAEGA_nPec4+=Hetj_yRA@mail.gmail.com>
	<CALzAhNUZzMAqW4xmuoK3sZMM-8tdKaiz973kMhkV_9qTAMEgPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven,

Em Sat, 28 Mar 2015 08:19:45 -0400
Steven Toth <stoth@kernellabs.com> escreveu:

> > Long awaited patches for the Hauppauge HVR2205 and HVR2255 in this patchset.
> > Along with a fix for the querycap warning being thrown on newer kernels.
> 
> Mauro, I had a user point out that I'd missed a critical ATSC patch.
> You'll see an additional patch in this
> tree not mentioned in the original pull request "[media] saa7164: fix
> HVR2255 ATSC inversion issue"
> 
> Please ensure this is also pulled.

Please send another pull request. My scripts get both the initial and
the final changesets from the e-mail, in order to ensure that it is
pulling only what's being requested, avoiding unpleasant surprises of
merging patches that aren't ok yet to pull.

Thanks!
Mauro
> 
> Thank you sir!
> 
> - Steve+1.646.355.8490
> 




Cheers,
Mauro
