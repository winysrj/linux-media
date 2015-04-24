Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34795 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbbDXOKa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 10:10:30 -0400
Received: by qkgx75 with SMTP id x75so30419222qkg.1
        for <linux-media@vger.kernel.org>; Fri, 24 Apr 2015 07:10:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <553A4CC3.2000808@gmail.com>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
	<1429823471-21835-2-git-send-email-olli.salonen@iki.fi>
	<5539E96C.1000407@gmail.com>
	<CAAZRmGzPZaJoMtHXYuFo081xbG3Eb_1+WwePziKfp6R5kREGDw@mail.gmail.com>
	<CAAZRmGwUd1gj2FmkX1ODeb+-q2oZXuZc6urgoR6i8W2VsLgGPA@mail.gmail.com>
	<CALzAhNWUM2ZPnO_fik6HNE5CCOmZR0qF2uY5GcYYjjNTS_n8Ow@mail.gmail.com>
	<553A4CC3.2000808@gmail.com>
Date: Fri, 24 Apr 2015 10:10:29 -0400
Message-ID: <CALzAhNW3Ze3q+-ugWY8ry9GRq2T9dHbjQmu4t__Z3=oirFFXeA@mail.gmail.com>
Subject: Re: [PATCH 02/12] dvbsky: use si2168 config option ts_clock_gapped
From: Steven Toth <stoth@kernellabs.com>
To: =?UTF-8?Q?Tycho_L=C3=BCrsen?= <tycholursen@gmail.com>
Cc: Olli Salonen <olli.salonen@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Steven, thanks for your comment

You are very welcome.

>
> So maybe this should also go into cx23885?
> I'm in Europe and only have DVB-C

My understanding is that it applies to all USB/PCIe bridges.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
