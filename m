Return-path: <linux-media-owner@vger.kernel.org>
Received: from ny01.nytud.hu ([193.6.194.1]:37248 "EHLO ny01.nytud.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab0EDUqL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 May 2010 16:46:11 -0400
Received: (from oravecz@localhost)
	by ny01.nytud.hu (8.11.6/8.11.6) id o44KVGv14553
	for linux-media@vger.kernel.org; Tue, 4 May 2010 22:31:16 +0200
Message-Id: <201005042031.o44KVGv14553@ny01.nytud.hu>
Subject: MSI DigiVox A/D II (analog sound) problem reloaded
To: linux-media@vger.kernel.org
Date: Tue, 4 May 2010 22:31:16 +0200 (CEST)
From: Oravecz Csaba <oravecz@nytud.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

quite some time ago there was some discussion on this issue but i suspect it
has not been resolved ever since.

On Thu, 15 Jan 2009 09:32:14 Bastian Beekes wrote:

> So I tried modprobe em28xx card=50, which is my MSI DigiVox A/D II - the
> video was alright, but when I ran arecord -D hw:1,0 -f dat | aplay -f dat , I
> only got buffer underruns. So I pulled a fresh copy from hg, compiled &
> installed it, rebooted, plugged - now the stick gets detected without the
> card=50 option, but still only buffer underruns in arecord | aplay.
> what now?

In the old days, in Markus Rechberger's mcentral driver beside the em28xx-audio
module there was another module, called em28xx-audioep, which was, i assume,
dedicated to this kind of devices, and had to be loaded to get analogue
sound. Now that mcentral has gone into oblivion and kernels evolve, this
device has become unusable with recent linux distros, i.e. with the stock
kernel drivers video is nice but there is no sound whatsoever.

Lacking the necessary competence myself to look into this matter, i'm humbly
asking whether someone on this list could help make this card working. I could
of course provide diagnostics and also the source file for em28xx-audioep if
the issue is taken up.

Best,
csaba oravecz

