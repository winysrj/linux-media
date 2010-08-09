Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57740 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab0HIPBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 11:01:41 -0400
Received: by pzk26 with SMTP id 26so3635986pzk.19
        for <linux-media@vger.kernel.org>; Mon, 09 Aug 2010 08:01:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100809145621.GB6126@belle.intranet.vanheusden.com>
References: <20100809133252.GW6126@belle.intranet.vanheusden.com>
	<AANLkTimtHwW_PQ1vNQVaMKXXYdyVroZzwAfomu+Yw02C@mail.gmail.com>
	<20100809143550.GZ6126@belle.intranet.vanheusden.com>
	<AANLkTinJbdrHQPk9mudEAPtB7L_S11hS_ArX+DDsnBD6@mail.gmail.com>
	<20100809145621.GB6126@belle.intranet.vanheusden.com>
Date: Mon, 9 Aug 2010 11:01:38 -0400
Message-ID: <AANLkTikV=pGB4Ea=bf+oc-aFvE+S_8wFxtTmmX8sfuOZ@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle Systems, Inc. PCTV 330e & 2.6.34 & /dev/dvb
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: folkert <folkert@vanheusden.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Mon, Aug 9, 2010 at 10:56 AM, folkert <folkert@vanheusden.com> wrote:
> Ah and I see in the code that you are the maintainer :-)

I'm not sure I would call myself the maintainer, but I did do the VBI
support for both NTSC and PAL (including teletext).

> Something seems to be odd with the vbi support:
> mauer:~# alevt -vbi /dev/vbi0
> DMX_SET_FILTER: Invalid argument
> alevt: v4l2: broken vbi format specification
> alevt: cannot open device: /dev/vbi0

I'll have to look at the source code to alevt and see what exactly it
considers to be invalid.  The teletext support was tested with mtt,
but not alevt.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
