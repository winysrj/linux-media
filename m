Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:34118 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbbDXNQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 09:16:11 -0400
Received: by qcyk17 with SMTP id k17so25321209qcy.1
        for <linux-media@vger.kernel.org>; Fri, 24 Apr 2015 06:16:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAZRmGwUd1gj2FmkX1ODeb+-q2oZXuZc6urgoR6i8W2VsLgGPA@mail.gmail.com>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
	<1429823471-21835-2-git-send-email-olli.salonen@iki.fi>
	<5539E96C.1000407@gmail.com>
	<CAAZRmGzPZaJoMtHXYuFo081xbG3Eb_1+WwePziKfp6R5kREGDw@mail.gmail.com>
	<CAAZRmGwUd1gj2FmkX1ODeb+-q2oZXuZc6urgoR6i8W2VsLgGPA@mail.gmail.com>
Date: Fri, 24 Apr 2015 09:16:10 -0400
Message-ID: <CALzAhNWUM2ZPnO_fik6HNE5CCOmZR0qF2uY5GcYYjjNTS_n8Ow@mail.gmail.com>
Subject: Re: [PATCH 02/12] dvbsky: use si2168 config option ts_clock_gapped
From: Steven Toth <stoth@kernellabs.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I've also seen that the Hauppauge HVR-2205 Windows driver enables this
> option, but it seems to me that that board works ok also without this.

Olli, I found out why this is, I thought you'd appreciate the comment....

Apparently the issue only occurs with DVB streams faster than
approximately 50Mbps, which standard DVB-T/T2, ATSC and QAM-B never
are.

The issue apparently, is with some QAM-A (DVB-C) streams in
Europe..... This explains why I've never seen it. That's being said, I
do plan to add the gapped clock patch to the SAA7164 shortly - for
safety.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
