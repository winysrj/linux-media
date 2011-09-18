Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50836 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1IRCws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 22:52:48 -0400
Received: by bkbzt4 with SMTP id zt4so4460007bkb.19
        for <linux-media@vger.kernel.org>; Sat, 17 Sep 2011 19:52:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHG8p1DaVN9sxBUxfZtGYg6Q==hHUDou=voJqRW-QQnis=-_3g@mail.gmail.com>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
 <1315938892-20243-3-git-send-email-scott.jiang.linux@gmail.com>
 <CAMjpGUenjQbGAM69J7mAt4anP9advZcdngXNuMddt+=HUnVK+w@mail.gmail.com> <CAHG8p1DaVN9sxBUxfZtGYg6Q==hHUDou=voJqRW-QQnis=-_3g@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 17 Sep 2011 22:52:26 -0400
Message-ID: <CAMjpGUft+KvyanM-AAqXRfCxdq-yC8mjpZ0NEQEGr=KEFRsGGg@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 3/4] v4l2: add vs6624 sensor driver
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	uclinux-dist-devel@blackfin.uclinux.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 14, 2011 at 03:28, Scott Jiang wrote:
>>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>>
>> just use DEBUG ?
>>
> no, v4l2 use CONFIG_VIDEO_ADV_DEBUG

ok, i was thinking this was something we added (since we have "ADVxxx" parts)

>>> +       v4l_info(client, "chip found @ 0x%02x (%s)\n",
>>> +                       client->addr << 1, client->adapter->name);
>>
>> is that "<< 1" correct ?  i dont think so ...
>
> every driver under media I see use this, so what's wrong?

meh, they're all wrong imo then :p.  they're shifting the address to
accommodate datasheets that incorrectly specify the i2c "address" with
the read/write as bit 0.  but it's fine for this driver to do that if
it's the standard that the rest of the v4l code has adopted.
-mike
