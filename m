Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58608 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2CBF3D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 00:29:03 -0500
Received: by iagz16 with SMTP id z16so1835142iag.19
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2012 21:29:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330662942.8460.229.camel@deadeye>
References: <1321422581.2885.50.camel@deadeye>
	<20120302034545.GA31860@burratino>
	<1330662942.8460.229.camel@deadeye>
Date: Thu, 1 Mar 2012 21:29:03 -0800
Message-ID: <CAA7C2qhhE7F2L6b1XsmArzmXWuw3HzJedZLbFTybEU5a+QBVTA@mail.gmail.com>
Subject: Re: [PATCH 1/5] staging: lirc_serial: Fix init/exit order
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a few questions about lirc_serial...  It seems that it's now a
part of v4l and currently residing in the driver staging area. I was
told it will not move from staging until it has been converted to
rc_core. I was also told there are no plans for anyone to do this so
it would seem lirc_serial will be stuck indefinitely in staging..

My questions are:

Rather than keep working on a driver that apparently won't be moved
out of staging, doesn't it make more sense to just convert the thing
to rc_core so it can be properly accepted, and then continue work from
there?

Is anyone, or will anyone consider converting the driver to rc_core?

Thanks
