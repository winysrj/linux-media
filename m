Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:42915 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaI0MF4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Sep 2014 08:05:56 -0400
Received: by mail-ob0-f172.google.com with SMTP id wp18so1937280obc.17
        for <linux-media@vger.kernel.org>; Sat, 27 Sep 2014 05:05:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WWEocLTVeZSOtRaJYa6ieJyCzF9BiacZgrdWvKnt3P78Q@mail.gmail.com>
References: <CAL9G6WWEocLTVeZSOtRaJYa6ieJyCzF9BiacZgrdWvKnt3P78Q@mail.gmail.com>
Date: Sat, 27 Sep 2014 14:05:55 +0200
Message-ID: <CAL9G6WUWCjKMt0+_svowHtQkLh8rpLqvPk_JKMFAg0Y3hJC8qg@mail.gmail.com>
Subject: Re: TeVii S480 in Debian Wheezy
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks and sorry, I have a S482 device, not the S480 (confused in the topic).

I get it working with s2-liplianin-v39 tree:

# ls -l /dev/dvb/
total 0
drwxr-xr-x 2 root root 120 sep 27 13:52 adapter0
drwxr-xr-x 2 root root 120 sep 27 13:52 adapter1

Will this code merge in the Linux kernel?

Best regards.

-- 
Josu Lazkano
