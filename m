Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:35482 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbbD0LvC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 07:51:02 -0400
Received: by iejt8 with SMTP id t8so123830868iej.2
        for <linux-media@vger.kernel.org>; Mon, 27 Apr 2015 04:51:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALzAhNWUM2ZPnO_fik6HNE5CCOmZR0qF2uY5GcYYjjNTS_n8Ow@mail.gmail.com>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
	<1429823471-21835-2-git-send-email-olli.salonen@iki.fi>
	<5539E96C.1000407@gmail.com>
	<CAAZRmGzPZaJoMtHXYuFo081xbG3Eb_1+WwePziKfp6R5kREGDw@mail.gmail.com>
	<CAAZRmGwUd1gj2FmkX1ODeb+-q2oZXuZc6urgoR6i8W2VsLgGPA@mail.gmail.com>
	<CALzAhNWUM2ZPnO_fik6HNE5CCOmZR0qF2uY5GcYYjjNTS_n8Ow@mail.gmail.com>
Date: Mon, 27 Apr 2015 13:51:01 +0200
Message-ID: <CAAZRmGwVQzNr-zDF8c4WwMCnLNMHs8+7jAO3Nz=bPCf6OnmgVw@mail.gmail.com>
Subject: Re: [PATCH 02/12] dvbsky: use si2168 config option ts_clock_gapped
From: Olli Salonen <olli.salonen@iki.fi>
To: Steven Toth <stoth@kernellabs.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you Steven,

That's helpful to know. I've been bumping into some issues with
another Si2168-based device and certain DVB-C streams. Will try to see
if this could help in that case...

Cheers,
-olli

On 24 April 2015 at 15:16, Steven Toth <stoth@kernellabs.com> wrote:
>> I've also seen that the Hauppauge HVR-2205 Windows driver enables this
>> option, but it seems to me that that board works ok also without this.
>
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
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
