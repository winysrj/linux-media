Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:43105 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbZJCOjg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 10:39:36 -0400
Received: by bwz6 with SMTP id 6so1635536bwz.37
        for <linux-media@vger.kernel.org>; Sat, 03 Oct 2009 07:39:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b4619a970910030606r25fdebe3u41883c695434426d@mail.gmail.com>
References: <b4619a970910030606r25fdebe3u41883c695434426d@mail.gmail.com>
Date: Sat, 3 Oct 2009 16:39:38 +0200
Message-ID: <846899810910030739n4b33c9a3nc3ef6ef0b61be85c@mail.gmail.com>
Subject: Re: Viewing HD?
From: HoP <jpetrous@gmail.com>
To: Mikhail Ramendik <mr@ramendik.ru>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Seems your installed ffmpeg libavcodec library
has no support for PAFF+spatial. Check if update
of such library can help.

Good starting point for PAFF understanging:
http://forum.doom9.org/showthread.php?p=927675

and mplayer with PAFF:
http://forum.doom9.org/archive/index.php/t-130797.html

/Honza

PS: I'm not sure if this ML is correct target for your question
as it is main development ML for linux-media (v4l2+dvb)
subsystem inside kernel. Your question is rather application specific.

2009/10/3 Mikhail Ramendik <mr@ramendik.ru>:
> Hello,
>
> I have an AverMedia Pro A700 DVB-S card, working well with Kaffeine;
> the dish is tuned to Astra 28.2E (in Ireland).
>
> However, I am unable to view HD. I tried BBC HD and nothing is shown;
> the terminal output mentions "illegal aspect ratio".
>
> Instant recording worked. In mplayer, the result was viewed very
> jerkily, with many messages saying "PAFF + spatial direct mode is not
> implemented"; the codec was ffmpeg h.264. CPU load was maxed out
> (Pentium 3 GHz).
>
> Is there any way to view HD - live or recorded? Or if the CPU is not
> powerful enough, which will be? And, as a CPU workaround, is there a
> way to recode in non-realtime, without losing data? (With the "not
> implemented" messages, I am wary of using mencoder).
>
> --
> Yours, Mikhail Ramendik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
