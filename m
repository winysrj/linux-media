Return-path: <linux-media-owner@vger.kernel.org>
Received: from marvin.klingler.net ([212.254.248.170]:20001 "EHLO
        marvin.klingler.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbeBYNfz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 08:35:55 -0500
Received: from [10.0.20.9] (178-82-90-159.dynamic.hispeed.ch [178.82.90.159])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by marvin.klingler.net (Postfix) with ESMTPSA id 878E2B5630B
        for <linux-media@vger.kernel.org>; Sun, 25 Feb 2018 14:26:03 +0100 (CET)
Date: Sun, 25 Feb 2018 14:25:47 +0100
From: Richard Klingler <richard@klingler.net>
To: linux-media@vger.kernel.org
Message-ID: <20180225142547928722.711e5c0e@klingler.net>
Subject: Startup delay playing radio channel from DVB-C
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I just recently acquired two pctv 292e triplestick USB DVB-C dongles for testing
audio/video streaming on a Raspberry Pi 3.

For a simple test I wanted to play back a radio station with mpg123 like:

dvbv5-zap -c dvb_channel.conf "Sky Radio NL" -o - | ffmpeg -i - -c:a copy -f mp2 - | mpg123 -a hw:1,0 -


But until audio is hearable it takes around 3 - 4 minutes...
The same happens when I record the mp2 audio stream with ffmpeg in the pipe...


I hardly assume ffmpeg causes this delay as it maybe wants to find out
the duration of the stream as a similar delay is noticable when using mplayer instead of ffmpeg.


Is there a better/faster way that audio is played immediately?



thanks in advance
richard
