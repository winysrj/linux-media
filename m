Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48633 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1KOHk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 02:40:58 -0500
Received: by eye27 with SMTP id 27so5413656eye.19
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 23:40:57 -0800 (PST)
Date: Tue, 15 Nov 2011 17:40:52 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org
Subject: good programm for FM radio
Message-ID: <20111115174052.1dee9737@glory.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Right now the gnomeradio don't work with tm6000 USB stick. No any audio.
I try use this script:

#!/bin/sh

if [ -f /usr/bin/arecord ]; then
arecord -q -D hw:1,0 -r 48000 -c 2 -f S16_LE | aplay -q - &
fi

if [ -f /usr/bin/gnomeradio ]; then
gnomeradio -f 102.6
fi

pid=`pidof arecord`

if [ $pid ]; then 
kill -9 $pid 
fi

But arecord return input/output error.
Anyone know good programm for FM radio worked with v4l2 and alsa??
I can't understand tm6000 work with FM radio or not.

With my best regards, Dmitry.
