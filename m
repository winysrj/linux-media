Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2508 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690Ab1FKPxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 11:53:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
Date: Sat, 11 Jun 2011 17:53:21 +0200
Cc: linux-media@vger.kernel.org
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl> <BANLkTikWiEb+aGGbSNSZ+YtdeVRB6QaJtg@mail.gmail.com>
In-Reply-To: <BANLkTikWiEb+aGGbSNSZ+YtdeVRB6QaJtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106111753.21581.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, June 11, 2011 17:32:10 Devin Heitmueller wrote:
> On Sat, Jun 11, 2011 at 11:05 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Second version of this patch series.
> >
> > It's the same as RFCv1, except that I dropped the g_frequency and
> > g_tuner/s_tuner patches (patch 3, 6 and 7 in the original patch series)
> > because I need to think more on those, and I added a new fix for tuner_resume
> > which was broken as well.
> 
> Hi Hans,
> 
> I appreciate your taking the time to refactor this code (no doubt it
> really needed it).  All that I ask is that you please actually *try*
> the resulting patches with VLC and a tuner that supports standby in
> order to ensure that it didn't cause any regressions.

That's easier said than done. I don't think I have tuners of that type.

Do you happen to know not-too-expensive cards that you can buy that have
this sort of tuners? It may be useful to be able to test this myself.

> This stuff was
> brittle to begin with, and there are lots of opportunities for
> obscure/unexpected effects resulting from what appear to be sane
> changes.
> 
> The last series of patches that went in were in response to this stuff
> being very broken, and I would hate to see a regression in existing
> applications after we finally got it working.

Yeah, it seems that whenever you touch this tuner code something breaks
for at least one card. There is so much legacy here...

Regards,

	Hans
