Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43247 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757780Ab1FKQEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 12:04:21 -0400
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl> <BANLkTikWiEb+aGGbSNSZ+YtdeVRB6QaJtg@mail.gmail.com>
In-Reply-To: <BANLkTikWiEb+aGGbSNSZ+YtdeVRB6QaJtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 11 Jun 2011 12:04:31 -0400
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Message-ID: <8e940c5d-8e54-4e3d-a64d-f0417a293498@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

>On Sat, Jun 11, 2011 at 11:05 AM, Hans Verkuil <hverkuil@xs4all.nl>
>wrote:
>> Second version of this patch series.
>>
>> It's the same as RFCv1, except that I dropped the g_frequency and
>> g_tuner/s_tuner patches (patch 3, 6 and 7 in the original patch
>series)
>> because I need to think more on those, and I added a new fix for
>tuner_resume
>> which was broken as well.
>
>Hi Hans,
>
>I appreciate your taking the time to refactor this code (no doubt it
>really needed it).  All that I ask is that you please actually *try*
>the resulting patches with VLC and a tuner that supports standby in
>order to ensure that it didn't cause any regressions.  This stuff was
>brittle to begin with, and there are lots of opportunities for
>obscure/unexpected effects resulting from what appear to be sane
>changes.
>
>The last series of patches that went in were in response to this stuff
>being very broken, and I would hate to see a regression in existing
>applications after we finally got it working.
>
>Thanks,
>
>Devin
>
>-- 
>Devin J. Heitmueller - Kernel Labs
>http://www.kernellabs.com
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Its not a refactor; drivers are broken.  Hans noticed it when testing the newer hvr1600s analog tuner with a standard other than NTSC.

I appreciate that we don't want fixes now to break things, but the past changes did indeed break things.

Regards,
Andy
