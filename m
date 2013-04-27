Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab3D0O2o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Apr 2013 10:28:44 -0400
Date: Sat, 27 Apr 2013 11:28:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: linux-media@vger.kernel.org,
	Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick BOETTCHER <patrick.boettcher@parrot.com>
Subject: Re: [GIT PULL FOR 3.10] DiBxxxx: fixes and improvements
Message-ID: <20130427112833.203d7fbb@redhat.com>
In-Reply-To: <1411209.JetyNPSOgp@dibcom294>
References: <1411209.JetyNPSOgp@dibcom294>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

Em Mon, 22 Apr 2013 10:12:34 +0200
Patrick Boettcher <pboettcher@kernellabs.com> escreveu:

> Hi Mauro,
> 
> These patches contains some fixes and changes for the DiBcom demods and 
> SIPs.
> 
> Please merge for 3.10 if possible.
> 
> 
> The following changes since commit 60d509fa6a9c4653a86ad830e4c4b30360b23f0e:
> 
>   Linux 3.9-rc8 (2013-04-21 14:38:45 -0700)
> 
> are available in the git repository at:
> 
>   git://git.linuxtv.org/pb/media_tree.git/ master

Hmm... I suspect that there's something wrong with those changes.

Testing it with a dib8076 usb stick seems that the code is worse than
before, as it is now harder to get a lock here.

With the previous code:

INFO     Scanning frequency #1 725142857
Carrier(0x03) Signal= 67.46% C/N= 0.00% UCB= 0 postBER= 0
Viterbi(0x05) Signal= 67.08% C/N= 0.00% UCB= 0 postBER= 2097151
Viterbi(0x07) Signal= 67.54% C/N= 0.25% UCB= 165 postBER= 0
Sync   (0x0f) Signal= 67.06% C/N= 0.23% UCB= 151 postBER= 0
Lock   (0x1f) Signal= 67.58% C/N= 0.24% UCB= 160 postBER= 338688
Service #0 (60320) BAND HD channel 57.1.0
Service #1 (60345) BAND 1SEG channel 57.1.1

With the new code:

INFO     Scanning frequency #1 725142857
       (0x00) Signal= 68.80% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.78% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.69% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.82% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.29% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.27% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.28% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.27% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.55% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.50% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.43% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.65% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.75% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.29% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.28% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.25% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.43% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.46% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.43% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.90% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.50% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.28% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.22% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.22% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.43% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.41% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.41% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 68.96% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.42% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.24% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.22% C/N= 0.00% UCB= 0 postBER= 0
RF     (0x01) Signal= 69.25% C/N= 0.00% UCB= 0 postBER= 0

So, it seems that the changes broke something.

Regards,
Mauro
