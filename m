Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:33818 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbbLUWQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 17:16:15 -0500
Received: by mail-yk0-f180.google.com with SMTP id p130so145365944yka.1
        for <linux-media@vger.kernel.org>; Mon, 21 Dec 2015 14:16:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALzAhNUCJQJyS_aF1cFsOJ40R9n6mMb3VPefg_iwiw+dt_F1sw@mail.gmail.com>
References: <CALs+mqZH7EpEYLsi5H2DLH12TSMmeAxNbwfOuwNyrE8_U2Oxqg@mail.gmail.com>
	<CALzAhNUCJQJyS_aF1cFsOJ40R9n6mMb3VPefg_iwiw+dt_F1sw@mail.gmail.com>
Date: Mon, 21 Dec 2015 14:16:15 -0800
Message-ID: <CALs+mqaLeSo5oMj3ZQcFmGYz0osA41FsWsNOxYu6y-g3B0bBnA@mail.gmail.com>
Subject: Re: Raw ATSC Stream Capture
From: =?UTF-8?Q?Thom=C3=A1s_Inskip?= <tinskip@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you.  scan + azap did exactly what I needed.


On Mon, Dec 21, 2015 at 10:31 AM, Steven Toth <stoth@kernellabs.com> wrote:
>> on how to do this online.  Could someone please send me some info on
>> how to do this, or at least point me in the right direction?
>>
>> Oh, I'm using a Hauppauge HDR-955Q tuner.
>
> v4l2-ctl isn't used for ATSC transmissions, its generally used for
> analog TV only.
>
> Take a look at the 'azap' and 'dvbtraffic' tools. These are what you need.
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
