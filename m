Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:49893 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab3GZNT3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 09:19:29 -0400
Received: by mail-vc0-f176.google.com with SMTP id ha11so482639vcb.35
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 06:19:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51F24C01.8050703@schinagl.nl>
References: <51DFF8A9.2030705@schinagl.nl> <CAJNvB=ydGohcEQLs+6rUCrUganMkB4dZXhpiTVyMSYkzSKha8Q@mail.gmail.com>
 <51F24C01.8050703@schinagl.nl>
From: Huei-Horng Yo <hiroshiyui@gmail.com>
Date: Fri, 26 Jul 2013 21:18:57 +0800
Message-ID: <CAJNvB=wUAfPWTB46ghu_uJ+5L-fLxM91ctuj+ipTw5jLmbFnGg@mail.gmail.com>
Subject: Re: [RFC] Dropping of channels-conf from dtv-scan-tables
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Manu Abraham <abraham.manu@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/7/26 Oliver Schinagl <oliver+list@schinagl.nl>:
> On 26-07-13 10:14, Huei-Horng Yo wrote:
>>
>> Sorry for my off-topic, because dvb-apps' 'scan' utility output wrong
>> encoding of channels-conf in Taiwan, that's why 'tw-All' channels-conf
>> is still useful for some Taiwan people. Or someone could review my
>> patch about this encoding issue? ([PATCH][dvb-apps] Fix 'scan' utility
>> region 0x14 encoding from BIG5 to UTF-16BE)
>
> Did you notify the maintainer? of the dvb-apps? I think manu is still one of
> the dvb-apps maintainers.

Oliver:

Thanks, I looked at the Mercurial repositories at
http://www.linuxtv.org/hg/, it shows 'unknown' at contact field.
