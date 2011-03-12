Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:47580 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752584Ab1CLXnM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 18:43:12 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] Ngene cam device name
Date: Sun, 13 Mar 2011 00:42:48 +0100
Cc: Martin Vidovic <xtronom@gmail.com>, linux-media@vger.kernel.org
References: <alpine.LNX.2.00.1103101608030.9782@hp8540w.home> <4D7A97BB.4020704@gmail.com> <4D7B7524.2050108@linuxtv.org>
In-Reply-To: <4D7B7524.2050108@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103130042.49199@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Saturday 12 March 2011 14:29:08 Andreas Oberritter wrote:
> On 03/11/2011 10:44 PM, Martin Vidovic wrote:
> > Andreas Oberritter wrote:
> >> It's rather unintuitive that some CAMs appear as ca0, while others as
> >> cam0.
> >>   
> > Ngene CI appears as both ca0 and cam0 (or sec0). The ca0 node is used
> > as usual, to setup the CAM. The cam0 (or sec0) node is used to read/write
> > transport stream. To me it  looks like an extension of the current API.
> 
> I see. This raises another problem. How to find out, which ca device
> cam0 relates to, in case there are more ca devices than cam devices?

Hm, I do not see a problem here. The API extension is simple:

(1) camX is optional. If camX exists, it is tied to caX.

(2) If there is no camX, the CI/CAM operates in 'legacy mode'.

(3) If camX exists, the encrypted transport stream of the CI/CAM is sent
    through camX, and the decrypted stream is received from camX.
    caX behaves the same way as in (2).

Btw, we should choose a more meaningful name for 'camX'.
I would prefer something like cainoutX or caioX or cinoutX or cioX.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
