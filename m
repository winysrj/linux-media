Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:65492 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3GZIOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 04:14:52 -0400
Received: by mail-ve0-f170.google.com with SMTP id 14so1081715vea.29
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 01:14:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51DFF8A9.2030705@schinagl.nl>
References: <51DFF8A9.2030705@schinagl.nl>
From: Huei-Horng Yo <hiroshiyui@gmail.com>
Date: Fri, 26 Jul 2013 16:14:20 +0800
Message-ID: <CAJNvB=ydGohcEQLs+6rUCrUganMkB4dZXhpiTVyMSYkzSKha8Q@mail.gmail.com>
Subject: Re: [RFC] Dropping of channels-conf from dtv-scan-tables
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for my off-topic, because dvb-apps' 'scan' utility output wrong
encoding of channels-conf in Taiwan, that's why 'tw-All' channels-conf
is still useful for some Taiwan people. Or someone could review my
patch about this encoding issue? ([PATCH][dvb-apps] Fix 'scan' utility
region 0x14 encoding from BIG5 to UTF-16BE)

Thanks,

Huei-Horng Yo

2013/7/12 Oliver Schinagl <oliver+list@schinagl.nl>:
> Hey all,
>
> The channels-conf directory in the dtv-scan-tables repository is bitrotten.
> Besides tw-All, the newest addition is over 6 years ago, with some being as
> old as 9 years. While I'm sure it's possible that the channels-conf are
> still accurate, it's not really needed any longer.
>
> Unless valid reasons are brought up to keep it, I will move it to a seperate
> branch and delete it from the master branch in the next few weeks.
>
> Thanks,
>
> Oliver
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
