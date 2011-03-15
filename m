Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57652 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1COMXk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 08:23:40 -0400
Received: by iyb26 with SMTP id 26so502399iyb.19
        for <linux-media@vger.kernel.org>; Tue, 15 Mar 2011 05:23:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110315121126.GD8113@aniel>
References: <AANLkTimexhCMBSd7UNr1gizgbnarwS9kucZC0nWSBJxX@mail.gmail.com>
	<20110315121126.GD8113@aniel>
Date: Tue, 15 Mar 2011 13:23:40 +0100
Message-ID: <AANLkTingP4tLViGTMvKeBM4XNj-cRZtqECh4WjLgZM40@mail.gmail.com>
Subject: Re: [PATCH] DVB-APPS: azap gets -p argument
From: Christian Ulrich <chrulri@gmail.com>
To: Janne Grunau <j@jannau.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, thank you for your feedback.

Indeed, I never used -r alone, but only with -p.
So with your patch, [acst]zap -r will be the same as -rp. That looks good to me.

Chris

2011/3/15 Janne Grunau <j@jannau.net>:
> Hi,
>
> On Sat, Mar 05, 2011 at 03:16:51AM +0100, Christian Ulrich wrote:
>>
>> I've written a patch against the latest version of azap in the hg
>> repository during the work of my Archos Gen8 DVB-T / ATSC project.
>>
>> Details of patch:
>> - add -p argument from tzap to azap
>> - thus ts streaming to dvr0 includes the pat/pmt
>
> I would prefer if you simply add PAT/PMT filters to -r. I'll send a
> patch which does the same for [cst]zap. The reulting files without
> PAT/PMT are simply invalid. It wasn't a serious problem as long as
> the used codecs were always mpeg2 video and mpeg1 layer 2 audio but
> that has changed.
> Since people use "[acst]zap -r" + cat/dd/... for recording we should
> make the life of playback software easier by producing valid files.
>
> patch looks good otherwise. thanks
>
> Janne
>
