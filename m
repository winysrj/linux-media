Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.22]:56581 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751134Ab1EKTBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 15:01:41 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Subject: Re: ngene CI problems
Date: Wed, 11 May 2011 20:59:20 +0200
References: <4D74E28A.6030302@gmail.com>
In-Reply-To: <4D74E28A.6030302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105112059.21083@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Monday 07 March 2011 14:50:02 Martin Vidovic wrote:
> ...
> - SEC device generates NULL packets (ad infinitum):
> 
> When reading from SEC, NULL packets are read and interleaved with 
> expected packets. They can be even read with dd(1) when nobody is 
> writing to SEC and even when CAM is not ready.
> ...

I reworked the driver to strip those null packets. Please try
http://linuxtv.org/hg/~endriss/ngene-octopus-test/raw-rev/f0dc4237ad08

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
