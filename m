Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:54539 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754520Ab1AJR3q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 12:29:46 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH 07/16] ngene: CXD2099AR Common Interface driver
Date: Mon, 10 Jan 2011 18:20:06 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	Ralph Metzler <rjkm@metzlerbros.de>
References: <1294652184-12843-1-git-send-email-o.endriss@gmx.de> <1294652184-12843-8-git-send-email-o.endriss@gmx.de> <4D2B122E.3050803@linuxtv.org>
In-Reply-To: <4D2B122E.3050803@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101101820.07907@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 10 January 2011 15:05:34 Andreas Oberritter wrote:
> On 01/10/2011 10:36 AM, Oliver Endriss wrote:
> > From: Ralph Metzler <rjkm@metzlerbros.de>
> > 
> > Driver for the Common Interface Controller CXD2099AR.
> > Supports the CI of the cineS2 DVB-S2.
> > 
> > For now, data is passed through '/dev/dvb/adapterX/sec0':
> > - Encrypted data must be written to 'sec0'.
> > - Decrypted data can be read from 'sec0'.
> > - Setup the CAM using device 'ca0'.
> 
> Nack. In DVB API terms, "sec" stands for satellite equipment control,
> and if I remember correctly, sec0 already existed in the first versions
> of the API and that's why its leftovers can be abused by this driver.
> 
> The interfaces for writing data are dvr0 and demux0. If they don't fit
> for decryption of recorded data, then they should be extended.
> 
> For decryption of live data, no new user interface needs to be created.

There was an attempt to find a solution for the problem in thread
http://www.mail-archive.com/linux-media@vger.kernel.org/msg22196.html

As that discussion did not come to a final solution, and the driver is
still experimental, I left the original patch 'as is'.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
