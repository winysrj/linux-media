Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52406 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab1KVP4j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 10:56:39 -0500
Received: by wwe5 with SMTP id 5so507799wwe.1
        for <linux-media@vger.kernel.org>; Tue, 22 Nov 2011 07:56:38 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Nov 2011 16:56:38 +0100
Message-ID: <CAL9G6WXsUs9ZeARy5tFMkfYNWankPtu7nUt+vV+Fat1mZDQtDw@mail.gmail.com>
Subject: Revert the hand compilation
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, I am running Ubuntu 11.10 with the last 3.0.0 kernel, it works
great with all my DVB adapters but I want to try some patches to the
linux_media. I use to install this way:

git clone git://linuxtv.org/media_build.git
cd media_build
./build
patch -d linux -p1 < xxx.patch
make
sudo make install

Now I want to use the Ubuntu kernel drivers, how could I do that? I
want to delete all drivers compiled by hand.

Thanks and best regards.

-- 
Josu Lazkano
