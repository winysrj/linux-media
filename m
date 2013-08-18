Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50016 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab3HRPA7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Aug 2013 11:00:59 -0400
Received: from 3capp-gmx-bs32.server.lan ([172.19.170.84]) by
 mrigmx.server.lan (mrigmx001) with ESMTP (Nemesis) id
 0M3gWF-1W1w2i2VYP-00rKXx for <linux-media@vger.kernel.org>; Sun, 18 Aug 2013
 17:00:57 +0200
MIME-Version: 1.0
Message-ID: <trinity-f1bb3861-097c-4a3d-a374-a999bdb0fd9d-1376838057464@3capp-gmx-bs32>
From: Ulf <mopp@gmx.net>
To: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
Content-Type: text/plain; charset=UTF-8
Date: Sun, 18 Aug 2013 17:00:57 +0200 (CEST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>It is DVB-S driver. HVR-900 is DVB-T and DVB-C.
The si2168 is a DVB-T2, DVB-T, and DVB-C demodulator http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2168-A20-short.pdf.

I tried to apply the dvbsky-linux-3.9-hps-v2.diff to media_build.git (used do_patches.sh from http://www.selasky.org/hans_petter/distfiles/webcamd-3.10.0.7.tar.bz2), but I was not able to compile it. I already changed some includes, but then I got the next error.
I just wanted to test if the si2168 module will work with si2165, but as I don't expect it to work I stopped trying to compile the si2168.

