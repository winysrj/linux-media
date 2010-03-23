Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38147 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753954Ab0CWOmZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 10:42:25 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: =?iso-8859-1?q?Bj=F8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] V4L/DVB: saa7146: Making IRQF_DISABLED or IRQF_SHARED optional
Date: Tue, 23 Mar 2010 15:40:58 +0100
Cc: linux-media@vger.kernel.org
References: <1269202135-340-1-git-send-email-bjorn@mork.no> <87ocigwvrf.fsf@nemi.mork.no> <1269351981-12292-1-git-send-email-bjorn@mork.no>
In-Reply-To: <1269351981-12292-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003231541.03636@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Bjørn Mork wrote:
> As discussed many times, e.g. in http://lkml.org/lkml/2007/7/26/401
> mixing IRQF_DISABLED with IRQF_SHARED may cause unpredictable and
> unexpected results.
> 
> Add a module parameter to allow fine tuning the request_irq
> flags based on local system requirements.  Some may need to turn
> off IRQF_DISABLED to be able to share interrupt with drivers
> needing interrupts enabled, while others may want to turn off
> IRQF_SHARED to ensure that IRQF_DISABLED has an effect.

NAK. We should not add module parameters for this kind of crap.

Let's check whether IRQF_DISABLED is really required.
Afaics it can be removed.

@all:
Please check whether the first patch causes any problems.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
