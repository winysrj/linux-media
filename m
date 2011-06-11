Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54026 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627Ab1FKPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 11:32:12 -0400
Received: by eyx24 with SMTP id 24so1198701eyx.19
        for <linux-media@vger.kernel.org>; Sat, 11 Jun 2011 08:32:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
Date: Sat, 11 Jun 2011 11:32:10 -0400
Message-ID: <BANLkTikWiEb+aGGbSNSZ+YtdeVRB6QaJtg@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Jun 11, 2011 at 11:05 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Second version of this patch series.
>
> It's the same as RFCv1, except that I dropped the g_frequency and
> g_tuner/s_tuner patches (patch 3, 6 and 7 in the original patch series)
> because I need to think more on those, and I added a new fix for tuner_resume
> which was broken as well.

Hi Hans,

I appreciate your taking the time to refactor this code (no doubt it
really needed it).  All that I ask is that you please actually *try*
the resulting patches with VLC and a tuner that supports standby in
order to ensure that it didn't cause any regressions.  This stuff was
brittle to begin with, and there are lots of opportunities for
obscure/unexpected effects resulting from what appear to be sane
changes.

The last series of patches that went in were in response to this stuff
being very broken, and I would hate to see a regression in existing
applications after we finally got it working.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
