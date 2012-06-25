Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36990 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2FYVSu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 17:18:50 -0400
Received: by pbbrp8 with SMTP id rp8so7088301pbb.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 14:18:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FDA2969.4010002@ims.uni-hannover.de>
References: <1339539568-7725-1-git-send-email-martin.blumenstingl@googlemail.com>
 <4FD818EC.6060300@ims.uni-hannover.de> <CAFBinCC9fZe84j9kVePVjA6y+HzGm3tf4sTgufhWTiTPLQ=KJg@mail.gmail.com>
 <4FDA2969.4010002@ims.uni-hannover.de>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Mon, 25 Jun 2012 23:18:30 +0200
Message-ID: <CAFBinCDuifSK0m8D8SkdSHFJzomF0oh7LUpbvzx3N8TjYEjPQQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] em28xx: Improve compatiblity with the Terratec
 Cinergy HTC Stick HD
To: =?ISO-8859-1?Q?S=F6ren_Moch?= <soeren.moch@ims.uni-hannover.de>
Cc: sven.pilz@gmail.com, linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Soren,

I just tested DVB-C (we got some local provider here).

> Correct. My Cinergy HTC Stick is not working for DVB-C with older drivers,
> too. (I didn't test DVB-T, since there are cheaper sticks for that and vdr
> opens the HTC stick for dvb-c)
Here's the first difference: it worked with a stock 3.4.4 kernel here.
The picture was completely broken for the first 10 seconds - after
that everything was fine.
This happened after each channel change with the vanilla kernel.
Afterwards I applied the drxk driver patch (see [0]) and my main patch
(see [1]) to the
3.4.4 kernel patched by Arch Linux (they don't have and media/dvb
related changes in
there though).
With my patch everything was working fine, no broken picture after
channel switching,
etc. :)

> Only the presumably "intentional error":
That's also what I see.

Let's start somewhere else:
How are you scanning for channels?
I used: w_scan -fc -c DE -X > channels.conf
Afterwards I opened channels.conf in VLC.
Which tool do you use for viewing the DVB-C stream?

PS: My patches will probably be included in linux 3.6.

Regards,
Martin

[0] http://git.linuxtv.org/media_tree.git/commitdiff/140534432e8a7edee5814d139dd59c20607479e3?hp=b144c98ca0962ee3cbdbbeafe77a1b300be0cb4f
[1] http://git.linuxtv.org/media_tree.git/commitdiff/c8dce0088a645c21cfb7e554390a4603e0e2139f?hp=729841ed0f41cfae494ad5c50df86af427078442
