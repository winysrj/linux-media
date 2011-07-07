Return-path: <mchehab@localhost>
Received: from mailout-de.gmx.net ([213.165.64.23]:47861 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751356Ab1GGXnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 19:43:40 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: "Hans von Marwijk" <ching@hispeed.ch>
Subject: Re: [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099 and ngene
Date: Fri, 8 Jul 2011 01:39:34 +0200
Cc: linux-media@vger.kernel.org
References: <201107031831.20378@orion.escape-edv.de> <00a001cc3a69$2e07ec30$8a17c490$@ch>
In-Reply-To: <00a001cc3a69$2e07ec30$8a17c490$@ch>
MIME-Version: 1.0
Content-Disposition: inline
Reply-To: linux-media@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107080139.35420@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Monday 04 July 2011 18:41:10 Hans von Marwijk wrote:
> In which GIT or HG repository can I find these patches.

They are not in any of my public repositories yet.

If you need a working driver, I recommend one of the following
repositories:

For kernel >= 2.6.32:
http://linuxtv.org/hg/~endriss/media_build_experimental

For kernel < 2.6.36, you might also use
http://linuxtv.org/hg/~endriss/ngene-octopus-test

They are equivalent and well tested.

The patchsets contain the same code, except that the code was
reformatted for kernel codingstyle. There is a small risk that
this processing introduced bugs. ;-(

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
