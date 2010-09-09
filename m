Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53552 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0IIHcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 03:32:51 -0400
Received: by wwb34 with SMTP id 34so45684wwb.1
        for <linux-media@vger.kernel.org>; Thu, 09 Sep 2010 00:32:49 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] V4L/DVB: dib7770: enable the current mirror
Date: Thu, 9 Sep 2010 09:32:20 +0200
Cc: linux-media@vger.kernel.org
References: <1283874646-20770-1-git-send-email-Patrick.Boettcher@dibcom.fr> <201009071758.24178.pboettcher@kernellabs.com> <4C881939.7030908@redhat.com>
In-Reply-To: <4C881939.7030908@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009090932.20657.pboettcher@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thursday 09 September 2010 01:16:09 Mauro Carvalho Chehab wrote:
> Em 07-09-2010 12:58, Patrick Boettcher escreveu:
> > Hi Mauro,
> > 
> > On Tuesday 07 September 2010 17:50:45 pboettcher@kernellabs.com wrote:
> >> From: Olivier Grenie <olivier.grenie@dibcom.fr>
> >> 
> >> To improve performance on DiB7770-devices enabling the current mirror
> >> is needed.
> >> 
> >> This patch adds an option to the dib7000p-driver to do that and it
> >> creates a separate device-entry in dib0700-device to use those changes
> >> on hardware which is using the DiB7770.
> >> 
> >> Cc: stable@kernel.org
> >> 
> >> Signed-off-by: Olivier Grenie <olivier.grenie@dibcom.fr>
> >> Signed-off-by: Patrick Boettcher <patrick.boettcher@dibcom.fr>
> >> ---
> >> 
> >>  drivers/media/dvb/dvb-usb/dib0700_devices.c |   53
> >> 
> >> ++++++++++++++++++++++++++- drivers/media/dvb/frontends/dib7000p.c     
> >> |
> >> 
> >>   2 +
> >>  
> >>  drivers/media/dvb/frontends/dib7000p.h      |    3 ++
> >>  3 files changed, 57 insertions(+), 1 deletions(-)
> > 
> > This is the patch I was talking to you about in my last Email. This one
> > needs to be quickly applied to 2.6.35. Well ... quickly ... as soon as
> > possible in sense of when you have a free time slot.
> > 
> > This patch help to optimize the performance of the DiB7770-chip which can
> > be found in several devices out there right now.
> > 
> > It was tested and applied on 2.6.36-rc3, It should apply cleanly on
> > 2.6.35.
> 
> Ok. Patch 2/2 is also important for -stable?

No. Only 1/2 is needed.

Thanks for your response.

Patrick.
