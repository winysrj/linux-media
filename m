Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37207 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbbDXOBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 10:01:41 -0400
Received: by widdi4 with SMTP id di4so21439255wid.0
        for <linux-media@vger.kernel.org>; Fri, 24 Apr 2015 07:01:40 -0700 (PDT)
Message-ID: <553A4CC3.2000808@gmail.com>
Date: Fri, 24 Apr 2015 16:01:39 +0200
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>,
	Olli Salonen <olli.salonen@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 02/12] dvbsky: use si2168 config option ts_clock_gapped
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>	<1429823471-21835-2-git-send-email-olli.salonen@iki.fi>	<5539E96C.1000407@gmail.com>	<CAAZRmGzPZaJoMtHXYuFo081xbG3Eb_1+WwePziKfp6R5kREGDw@mail.gmail.com>	<CAAZRmGwUd1gj2FmkX1ODeb+-q2oZXuZc6urgoR6i8W2VsLgGPA@mail.gmail.com> <CALzAhNWUM2ZPnO_fik6HNE5CCOmZR0qF2uY5GcYYjjNTS_n8Ow@mail.gmail.com>
In-Reply-To: <CALzAhNWUM2ZPnO_fik6HNE5CCOmZR0qF2uY5GcYYjjNTS_n8Ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven, Olli,
Steven, thanks for your comment

So maybe this should also go into cx23885?
I'm in Europe and only have DVB-C

I'll add it to my saa716x driver as well

Op 24-04-15 om 15:16 schreef Steven Toth:
>> I've also seen that the Hauppauge HVR-2205 Windows driver enables this
>> option, but it seems to me that that board works ok also without this.
> Olli, I found out why this is, I thought you'd appreciate the comment....
>
> Apparently the issue only occurs with DVB streams faster than
> approximately 50Mbps, which standard DVB-T/T2, ATSC and QAM-B never
> are.
>
> The issue apparently, is with some QAM-A (DVB-C) streams in
> Europe..... This explains why I've never seen it. That's being said, I
> do plan to add the gapped clock patch to the SAA7164 shortly - for
> safety.
>

