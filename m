Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:36656 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbbLUS21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 13:28:27 -0500
Received: by mail-yk0-f179.google.com with SMTP id x184so139441700yka.3
        for <linux-media@vger.kernel.org>; Mon, 21 Dec 2015 10:28:27 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Dec 2015 10:28:26 -0800
Message-ID: <CALs+mqZH7EpEYLsi5H2DLH12TSMmeAxNbwfOuwNyrE8_U2Oxqg@mail.gmail.com>
Subject: Raw ATSC Stream Capture
From: =?UTF-8?Q?Thom=C3=A1s_Inskip?= <tinskip@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

I do not know whether this is the appropriate forum for my question,
but as I cannot find a more suitable one, here it goes:

I have successfully built and installed the drivers using the
media_build distribution, as I have a slightly older kernel.  The
driver modules are loading correctly, and I'm able to w_scan and play
back live terrestrial ATSC TV using VLC.  However, what I really need
for my project is access to the raw ATSC MPEG2-TS, Ideally being able
to just read it from a device node.  I have tried various incantations
of v4l2-ctl without success, and have not been able to find any help
on how to do this online.  Could someone please send me some info on
how to do this, or at least point me in the right direction?

Oh, I'm using a Hauppauge HDR-955Q tuner.

Thanks!
