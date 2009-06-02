Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54293 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751300AbZFBUty (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jun 2009 16:49:54 -0400
Message-ID: <4A259071.3070500@gmx.de>
Date: Tue, 02 Jun 2009 22:49:53 +0200
From: "Soeren D. Schulze" <soeren.d.schulze@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Aspect ratio change does not take effect (DVB-S)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

for receiving DVB-S, I recently switched from a Technisat SkyStar USB
(v1) box to a TechnoTrend TT-connect S-2400 (AFAIK formerly known as
Technisat SkyStar USB Plus).

The former worked fine (until it was broken) and the latter works fine
right now, but there seems to be a little bug:  When watching the TV
stream using and szap and mplayer, changes in the aspect ratio of the TV
program do not take effect until mplayer is restarted.  This used to
work with the former device!

The problem appears even with the latest Hg checkout of v4l-dvb.

I'm afraid my knowledge on DVB drivers is very limited, so I've no clue
where to look.  I can do further experiments on the new device if you
ask me.


Thank you

Sören
