Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59413 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab1INH22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 03:28:28 -0400
Received: by qyk7 with SMTP id 7so1359355qyk.19
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2011 00:28:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMjpGUenjQbGAM69J7mAt4anP9advZcdngXNuMddt+=HUnVK+w@mail.gmail.com>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<1315938892-20243-3-git-send-email-scott.jiang.linux@gmail.com>
	<CAMjpGUenjQbGAM69J7mAt4anP9advZcdngXNuMddt+=HUnVK+w@mail.gmail.com>
Date: Wed, 14 Sep 2011 15:28:27 +0800
Message-ID: <CAHG8p1DaVN9sxBUxfZtGYg6Q==hHUDou=voJqRW-QQnis=-_3g@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 3/4] v4l2: add vs6624 sensor driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	uclinux-dist-devel@blackfin.uclinux.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>
> just use DEBUG ?
>
no, v4l2 use CONFIG_VIDEO_ADV_DEBUG

>> +       v4l_info(client, "chip found @ 0x%02x (%s)\n",
>> +                       client->addr << 1, client->adapter->name);
>
> is that "<< 1" correct ?  i dont think so ...
every driver under media I see use this, so what's wrong?
