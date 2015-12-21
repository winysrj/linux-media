Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35971 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbbLUSbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 13:31:36 -0500
Received: by mail-qk0-f177.google.com with SMTP id t125so140463825qkh.3
        for <linux-media@vger.kernel.org>; Mon, 21 Dec 2015 10:31:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALs+mqZH7EpEYLsi5H2DLH12TSMmeAxNbwfOuwNyrE8_U2Oxqg@mail.gmail.com>
References: <CALs+mqZH7EpEYLsi5H2DLH12TSMmeAxNbwfOuwNyrE8_U2Oxqg@mail.gmail.com>
Date: Mon, 21 Dec 2015 13:31:35 -0500
Message-ID: <CALzAhNUCJQJyS_aF1cFsOJ40R9n6mMb3VPefg_iwiw+dt_F1sw@mail.gmail.com>
Subject: Re: Raw ATSC Stream Capture
From: Steven Toth <stoth@kernellabs.com>
To: =?UTF-8?Q?Thom=C3=A1s_Inskip?= <tinskip@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> on how to do this online.  Could someone please send me some info on
> how to do this, or at least point me in the right direction?
>
> Oh, I'm using a Hauppauge HDR-955Q tuner.

v4l2-ctl isn't used for ATSC transmissions, its generally used for
analog TV only.

Take a look at the 'azap' and 'dvbtraffic' tools. These are what you need.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
