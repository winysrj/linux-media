Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41652 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab0HJMRO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 08:17:14 -0400
Received: by pwj7 with SMTP id 7so1708479pwj.19
        for <linux-media@vger.kernel.org>; Tue, 10 Aug 2010 05:17:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100810112258.GK6126@belle.intranet.vanheusden.com>
References: <20100809133252.GW6126@belle.intranet.vanheusden.com>
	<AANLkTimtHwW_PQ1vNQVaMKXXYdyVroZzwAfomu+Yw02C@mail.gmail.com>
	<20100809143550.GZ6126@belle.intranet.vanheusden.com>
	<AANLkTinJbdrHQPk9mudEAPtB7L_S11hS_ArX+DDsnBD6@mail.gmail.com>
	<20100810112258.GK6126@belle.intranet.vanheusden.com>
Date: Tue, 10 Aug 2010 08:17:13 -0400
Message-ID: <AANLkTin-eXj-78iDkU=FYTiuzRH1_qwRwYQskO2=g19B@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle Systems, Inc. PCTV 330e & 2.6.34 & /dev/dvb
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: folkert <folkert@vanheusden.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, Aug 10, 2010 at 7:22 AM, folkert <folkert@vanheusden.com> wrote:
>> Teletext support is completely different that digital (DVB) support.
>> VBI support (including teletext) was added to the in-kernel em28xx
>> driver back in January.
>
> That'll be the analogue interface probably? e.g. /dev/vbi0
> Because a.f.a.i.k. the dvb interface is /dev/dvb/adapter0/demux0 ?

Yes, VBI is an analog interface, and the teletext is provided via /dev/vbi0.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
