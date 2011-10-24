Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:43027 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753326Ab1JXHJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 03:09:44 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: "Linux Media Mailing List" <linux-media@vger.kernel.org>
To: =?iso-8859-1?q?S=E9bastien_RAILLARD?= (COEXSI) <sr@coexsi.fr>
Subject: Re: [DVB] Digital Devices Cine CT V6 support
Date: Mon, 24 Oct 2011 09:06:16 +0200
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
References: <004c01cc7a03$064111c0$12c33540$@coexsi.fr>
In-Reply-To: <004c01cc7a03$064111c0$12c33540$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201110240906.24543@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> Using your latest development tree (hg clone
> http://linuxtv.org/hg/~endriss/media_build_experimental), I have made a
> small modification in ddbridge-core.c (see below) to make the new "Cine CT
> V6" card detected by the ddbridge module.
> 
> With this small patch, the card is now detected, but not the double C/T
> tuner onboard.

This cannot work, as the cards requires different frontend drivers.

Please try a fresh check-out from 
  http://linuxtv.org/hg/~endriss/media_build_experimental

The Cine CT v6 is supported now.

> Also, I was wondering why they put a male and a female RF connectors on the
> "Cine CT V6" (maybe a loop-through?) where there are two female RF
> connectors on the "DuoFlex CT" card.

The second connector of the Cine CT is the loop-through output.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
