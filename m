Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.work.de ([212.12.32.49]:49758 "EHLO smtp.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbZKPLnV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 06:43:21 -0500
From: Julian Scheel <julian@jusst.de>
To: Thomas Kernen <tkernen@deckpoint.ch>
Subject: Re: Ubuntu karmic, 2.6.31-14 + KNC1 DVB-S2 = GPF
Date: Mon, 16 Nov 2009 12:43:24 +0100
Cc: linux-media@vger.kernel.org
References: <4B004ABD.9090903@deckpoint.ch>
In-Reply-To: <4B004ABD.9090903@deckpoint.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911161243.24994.julian@jusst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> It would appear that since I've upgraded to Ubuntu Karmic and the
> 2.6.31-14 kernel, my KNC1 DVB-S2 now enjoys a GPF when I use scan-s2.
> 
> Has anyone else come across this issue with a KNC1 card? Any suggestions
> what I can do to trace the issue?

Which gcc version are you using?
If you run a gcc 4.4 could you try to compile the v4l-dvb tree with a gcc-4.3 
and see if it helps?
