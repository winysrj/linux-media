Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49596 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbZILNdM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 09:33:12 -0400
Received: by bwz19 with SMTP id 19so1286434bwz.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 06:33:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AAB74BC.9050508@pragl.cz>
References: <4AAB74BC.9050508@pragl.cz>
Date: Sat, 12 Sep 2009 09:33:13 -0400
Message-ID: <829197380909120633o8b9e0e2i2b1295cc054afc14@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle 320e (em28xx/xc2028): scan finds just first
	channel
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 12, 2009 at 6:15 AM, Miroslav Pragl - mailing lists
<lists.subscriber@pragl.cz> wrote:
> Hello,
> I've compiled and installed latest v4l-dvb and dvb-apps, extracted xceive
> firmware, so far so good. Distro is Fedora 11, x64 (2.6.30.5-43.fc11.x86_64)
>
> Unfortunately scan finds only the first channel:
<snip>

Hello Miroslav,

Are you absolutely sure you installed the latest code, including "make
unload" to unload the currently running modules?  I fixed this exact
regression back in June, so I would be extremely surprised if you are
really seeing this in the latest code.

I would suggest using the following commands, and then reboot:

<unplug device>
hg clone http://linuxtv.org/hg/v4l-dvb
cd v4l-dvb
make && make install && make unload
reboot
<plug in device>

Then see if it still happens.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
