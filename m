Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35771 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754383AbZHKXPC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 19:15:02 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: manio <manio@skyboo.net>
Subject: Re: SAA7146 / TT1.3 stream corruption
Date: Wed, 12 Aug 2009 01:14:32 +0200
Cc: linux-media@vger.kernel.org
References: <4A7471D2.3070004@skyboo.net> <4A7E8121.4040406@skyboo.net>
In-Reply-To: <4A7E8121.4040406@skyboo.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908120114.33077@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

manio wrote:
> manio wrote:
> 
>  > Hello
>  > I am using Technotrend Rev1.3 for many years. But last time
>  > suddenly i find out strange problem. Seems that in some
>  > circumstances the card can't decode stream from satellite properly.
>  > I don't know for sure but it could be a driver problem, firmware
>  > or even (worse) a hardware problem.
> 
> Now i can reply myself to provide info for users with similar problem.
> 
> The parameter which i need is:
> hw_sections=1
> When i load dvb_ttpci module with this parameter the stream is correct.
> Just by the way: people on DVBN forum has similar issues, but this
> parameter was not sufficient - they also need to write a patch for
> select pid ranges for providers (in their case: BEV and DN)
> More info on dvbn topics#: 42822 and 42653

If you have very good soldering skills, there is the ultimate solution
for all kinds of stream corruption with full-featured cards:
http://www.escape-edv.de/endriss/dvb-full-ts-mod/

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
