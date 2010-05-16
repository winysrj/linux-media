Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:35728 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab0EPHK4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 03:10:56 -0400
Received: by gxk9 with SMTP id 9so2596162gxk.8
        for <linux-media@vger.kernel.org>; Sun, 16 May 2010 00:10:55 -0700 (PDT)
MIME-Version: 1.0
From: Pshem Kowalczyk <pshem.k@gmail.com>
Date: Sun, 16 May 2010 19:10:35 +1200
Message-ID: <AANLkTik9j_Md07Ry17VXLY7-GKP6yKHi0YM0dFXX9GlX@mail.gmail.com>
Subject: Hauppage Nova-500-td problems
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've recently bought Hauppage nova-500-td for my mythtv backend. The
card works mostly fine, but every now and then it looks like it
doesn't tune to the channel properly (I think) - video and sound
remain garbled for prolonged periods of time (2-5 minutes), but
ultimately recover. This usually happens when the other tuner on the
card is tuned to the same mux. Signal quality I get is around 70% and
about 2.5dB of signal to noise (as reported by mythtv), but when the
issue occurs regardless of what the numbers show.

I'm not entirely sure if that's a hardware or software issue (have no
windows based pc to try with), but I already got the the card replaced
once, so if it's hardware it might be something else then the card
itself. I know that some other people reported issues as well as
suggested patches, but I haven't found anything conclusive. Currently
I run the hg tip version of v4l-dvb with 2.6.32 kernel on gentoo.

I would like to know if anyone else experienced something similar
issues, and probably the more important part -how can I help to
troubleshoot and debug the problem?

kind regards
Pshem
