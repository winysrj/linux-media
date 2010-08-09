Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48705 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab0HIOnP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 10:43:15 -0400
Received: by pvg2 with SMTP id 2so731698pvg.19
        for <linux-media@vger.kernel.org>; Mon, 09 Aug 2010 07:43:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100809143550.GZ6126@belle.intranet.vanheusden.com>
References: <20100809133252.GW6126@belle.intranet.vanheusden.com>
	<AANLkTimtHwW_PQ1vNQVaMKXXYdyVroZzwAfomu+Yw02C@mail.gmail.com>
	<20100809143550.GZ6126@belle.intranet.vanheusden.com>
Date: Mon, 9 Aug 2010 10:43:09 -0400
Message-ID: <AANLkTinJbdrHQPk9mudEAPtB7L_S11hS_ArX+DDsnBD6@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle Systems, Inc. PCTV 330e & 2.6.34 & /dev/dvb
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Mon, Aug 9, 2010 at 10:35 AM, folkert <folkert@vanheusden.com> wrote:
> Hi Devin,
>
>> > I have a:
>> > Bus 001 Device 006: ID 2304:0226 Pinnacle Systems, Inc. PCTV 330e
>> > inserted in a system with kernel 2.6.34.
>>
>> The PCTV 330e support for digital hasn't been merged upstream yet.
>> See here:
>> http://www.kernellabs.com/blog/?cat=35
>
> Does that mean teletext won't work either?

Teletext support is completely different that digital (DVB) support.
VBI support (including teletext) was added to the in-kernel em28xx
driver back in January.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
