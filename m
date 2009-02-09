Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:55868 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbZBIO4V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 09:56:21 -0500
Date: Mon, 9 Feb 2009 15:55:35 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: =?ISO-8859-15?Q?Michael_M=FCller?= <mueller_michael@alice-dsl.net>
cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	linux-dvb@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add Elgato EyeTV Diversity to dibcom driver
In-Reply-To: <B7621984-DEB8-4F0C-B5EF-733CD30E7441@alice-dsl.net>
Message-ID: <alpine.LRH.1.10.0902091555120.3870@pub3.ifh.de>
References: <B7621984-DEB8-4F0C-B5EF-733CD30E7441@alice-dsl.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="579696399-1288789372-1234191335=:3870"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--579696399-1288789372-1234191335=:3870
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 8 Feb 2009, Michael Müller wrote:

> This patch introduces support for DVB-T for the following dibcom based card:
> 	Elgato EyeTV Diversity (USB-ID: 0fd9:0011)
>
> Support for the Elgato silver IR remote is added too (set parameter 
> dvb_usb_dib0700_ir_proto=0)
>
> Signed-off-by: Michael Müller <mueller_michael@alice-dsl.net>
>

Thanks, applied.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
--579696399-1288789372-1234191335=:3870--
