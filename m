Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:59582 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752333Ab1C1W6D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 18:58:03 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: [PATCH] Ngene cam device name
Date: Tue, 29 Mar 2011 00:57:03 +0200
Cc: linux-media@vger.kernel.org
References: <777PcLohh6368S03.1299940473@web03.cms.usa.net> <4D7B8A07.70602@linuxtv.org> <19855.55774.192407.326483@morden.metzler>
In-Reply-To: <19855.55774.192407.326483@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103290057.03664@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 28 March 2011 02:44:14 Ralph Metzler wrote:
> Hi,
> 
> since I just saw cxd2099 appear in staging in the latest git kernel, a
> simple question which has been pointed out to me before:
> 
> Why is cxd2099.c in staging regarding the device name question?
> It has nothing to do with the naming.

Well, it was a political decision. ;-)

Afaics there were 3 alternatives:
(1) Do not submit the cxd driver.
(2) Move cxd to staging.
(3) Move ngene to staging.

Imho option (2) was the one with minimal impact.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
