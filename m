Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.23]:57272 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756127Ab1ELWfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 18:35:03 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Issa Gorissen <flop.m@usa.net>
Subject: Re: ngene CI problems
Date: Fri, 13 May 2011 00:34:23 +0200
Cc: linux-media@vger.kernel.org
References: <4D74E28A.6030302@gmail.com> <201105112059.21083@orion.escape-edv.de> <4DCC4304.2020205@usa.net>
In-Reply-To: <4DCC4304.2020205@usa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105130034.24038@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thursday 12 May 2011 22:28:52 Issa Gorissen wrote:
> On 11/05/11 20:59, Oliver Endriss wrote:
> >
> > I reworked the driver to strip those null packets. Please try
> > http://linuxtv.org/hg/~endriss/ngene-octopus-test/raw-rev/f0dc4237ad08
> 
> Tried your patch, but FFs have been replaced by 6Fs in null packets.
> Other than that, no improvement for me.

Please double check that the patch applied cleanly.
The 0x6F NULL packets should never be passed to userspace.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
