Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38256 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751805AbZHAQGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2009 12:06:46 -0400
From: Nils Kassube <kassube@gmx.net>
To: linux-media@vger.kernel.org
Subject: Re: Patch for  stack/DMA problems in Cinergy T2 drivers (2)
Date: Sat, 1 Aug 2009 18:00:26 +0200
References: <4A735330.1000406@magic.ms>
In-Reply-To: <4A735330.1000406@magic.ms>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908011800.26814.kassube@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

emagick@magic.ms wrote:
> Here's a patch for cinergyT2-core.c:
More like cinergyT2-fe.c according to the patch :)

Anyway, thanks for the patch. I can confirm the problem with the current 
Ubuntu Karmic alpha kernel (2.6.31-4.23). If I use the modules of the 
current hg tree from http://linuxtv.org/hg/v4l-dvb I still have the 
problem but with your patch I can use the Cinergy T². However it seems 
to be not yet perfect because I can't use the KDE4 version of kaffeine, 
only the KDE3 version (from Ubuntu 9.04). According to the error message 
the KDE4 version doesn't find a working adapter.


Nils

