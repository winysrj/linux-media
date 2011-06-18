Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:48750 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752715Ab1FRVbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 17:31:14 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Hans Verkuil <hansverk@cisco.com>
Subject: Re: RFC: Add V4L2 decoder commands/controls to replace dvb/video.h
Date: Sat, 18 Jun 2011 23:30:46 +0200
Cc: linux-media@vger.kernel.org
References: <201106091445.53598.hansverk@cisco.com>
In-Reply-To: <201106091445.53598.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106182330.47020@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 09 June 2011 14:45:53 Hans Verkuil wrote:
> RFC: Proposal for a V4L2 decoder API
> ------------------------------------
> 
> This RFC is based on this discussion:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg32703.html
> 
> The purpose is to remove the dependency of ivtv to the ioctls in dvb/audio.h
> and dvb/video.h.
> ...

Whatever you define: You are not allowed to remove the old interface!
Linus always stated that breaking userspace is a no go.

So you may add a new interface, but you must not remove the old one.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
