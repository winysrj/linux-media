Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:33024 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755663Ab0J1SEW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 14:04:22 -0400
From: Lukas Ruetz <lukas.ruetz@gmx.at>
To: linux-media@vger.kernel.org
Subject: Re: Non-fluent V4L Playback with BTTV-card
Date: Thu, 28 Oct 2010 20:04:16 +0200
References: <201010141718.30593.lukas.ruetz@gmx.at>
In-Reply-To: <201010141718.30593.lukas.ruetz@gmx.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010282004.16959.lukas.ruetz@gmx.at>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Donnerstag 14 Oktober 2010, um 17:18:30 schrieb Lukas Ruetz:
> Hello everyone,
> 
> I have a Haupauge Impact capture card (bt878) and the problem that the
> playback of the captured PAL-video (no audio) isn't fluent. The video jumps
> every few seconds as if there were frames dropped. It occures (or is only
> then visible) if there is bigger movement in the video. This behaviour is
> nearly the same with mplayer, gstreamer and vlc depending on the output
> type.
[snip]

Now I've tried this capture card with a different PC and look, the problem is
gone. Don't know where's the incompatibility with this HP z400 Quad-Core ...
