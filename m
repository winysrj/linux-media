Return-path: <linux-media-owner@vger.kernel.org>
Received: from strictvertrouwelijk.xs4all.nl ([82.95.189.133]:64772 "EHLO
	nogrod.vanbest.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755220Ab0FGHN5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 03:13:57 -0400
Received: from www.vanbest.eu (localhost [127.0.0.1])
	by nogrod.vanbest.eu (Postfix) with ESMTP id 42AD919824D
	for <linux-media@vger.kernel.org>; Mon,  7 Jun 2010 09:07:24 +0200 (CEST)
Message-ID: <adfb4900eaf87661245f8e7da69cbcbd.squirrel@www.vanbest.eu>
Date: Mon, 7 Jun 2010 09:07:24 +0200 (CEST)
Subject: linuxtv.org Wiki pages not found by Google
From: "Jan-Pascal van Best" <janpascal@vanbest.org>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Not sure if this is the right list, but here it goes: Google does not seem
to find pages in the linuxtv.org wiki. Nor does any of the other search
engines I've tried. It seems indexers are blocker by robots.txt:

User-agent: *
Disallow: /cgi-bin/
Disallow: /hg/
Disallow: /git/
Disallow: /wiki/
Disallow: /irc/
Disallow: /irc/linuxtv/
Disallow: /irc/v4l/

I would think information in the wiki (such as on a DVB-C USB box I'm
researching,
http://www.linuxtv.org/wiki/index.php/TechniSat_CableStar_Combo_HD_CI )
should be findable by search engines!

Could the "Disallow: /wiki/" line please be removed from robots.txt?

Cheers

Jan-Pascal


