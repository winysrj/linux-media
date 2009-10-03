Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:44182 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbZJCNGH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 09:06:07 -0400
Received: by ewy7 with SMTP id 7so2073270ewy.17
        for <linux-media@vger.kernel.org>; Sat, 03 Oct 2009 06:06:10 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 3 Oct 2009 14:06:10 +0100
Message-ID: <b4619a970910030606r25fdebe3u41883c695434426d@mail.gmail.com>
Subject: Viewing HD?
From: Mikhail Ramendik <mr@ramendik.ru>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have an AverMedia Pro A700 DVB-S card, working well with Kaffeine;
the dish is tuned to Astra 28.2E (in Ireland).

However, I am unable to view HD. I tried BBC HD and nothing is shown;
the terminal output mentions "illegal aspect ratio".

Instant recording worked. In mplayer, the result was viewed very
jerkily, with many messages saying "PAFF + spatial direct mode is not
implemented"; the codec was ffmpeg h.264. CPU load was maxed out
(Pentium 3 GHz).

Is there any way to view HD - live or recorded? Or if the CPU is not
powerful enough, which will be? And, as a CPU workaround, is there a
way to recode in non-realtime, without losing data? (With the "not
implemented" messages, I am wary of using mencoder).

-- 
Yours, Mikhail Ramendik
