Return-path: <mchehab@pedra>
Received: from mail-px0-f174.google.com ([209.85.212.174]:39682 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab0IORqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 13:46:43 -0400
Received: by pxi10 with SMTP id 10so133734pxi.19
        for <linux-media@vger.kernel.org>; Wed, 15 Sep 2010 10:46:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C90B29A.2040602@s5r6.in-berlin.de>
References: <AANLkTin53SY_xaed_tRfWRPOFmc65GmGzXrEt15ZyriW@mail.gmail.com>
	<4C90B29A.2040602@s5r6.in-berlin.de>
Date: Wed, 15 Sep 2010 19:46:42 +0200
Message-ID: <AANLkTi=aAKVkSx_dqSKviff48cDR=BhzWc=tnytV6LFd@mail.gmail.com>
Subject: Re: [PATCH] firedtv driver: support for PSK8 for S2 devices. To watch HD.
From: Tommy Jonsson <quazzie2@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Nice, thanks! I used gmail, never used a mailing-list or dealt with
patches before.
Never developed or even looked at the Linux source, so there might be
some strangeness in the code :]
I recently fixed a server-box and started using TvHeadend. Noticed
that the psk8 didn't work,
so i put the card back in a windows box and sniffed out the difference.

On Wed, Sep 15, 2010 at 1:48 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Tommy Jonsson wrote at linux-media:
>> This is the first i have ever developed for linux, cant really wrap my
>> head around how to submit this..
>> Hope im sending this correctly, diff made with 'hg diff' from latest
>> "hg clone http://linuxtv.org/hg/v4l-dvb"
>>
>> It adds support for tuning with PSK8 modulation, pilot and rolloff
>> with the S2 versions of firedtv.
>>
>> Signed-off-by: Tommy Jonsson <quazzie2@gmail.com>
> [...]
>
> Excellent!  This has been on the wishlist of FireDTV/FloppyDTV-S2 owners for
> quite some time.
>
> The patch was a little bit mangled by the mail user agent, and there appear to
> be some whitespace issues in it.  I will have a closer look at it later today
> and repost the patch so that Mauro can apply it without manual intervention.
> --
> Stefan Richter
> -=====-==-=- =--= -====
> http://arcgraph.de/sr/
>
