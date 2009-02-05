Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:36807 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbZBEXmP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Feb 2009 18:42:15 -0500
Message-ID: <498B7945.4060200@gmail.com>
Date: Fri, 06 Feb 2009 03:41:57 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org, oscarmax3@gmail.com
Subject: Mantis Update was Re: [linux-dvb] Twinhan DTV Ter-CI (3030 Mantis)
 ???
References: <4984E294.6020401@gmail.com>
In-Reply-To: <4984E294.6020401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Carl Oscar Ejwertz wrote:
> I was wondering if the support for this card is fixed or is going to be 
> fixed in some tree?
> I know that there has been support for the card in manu:s Mantis tree 
> but hasn't been working for a long time.
> For some reason the interface has been disabled in the sourcecode.

Have added initial support for this card, as well as a large
overhaul of the driver for a couple of performance impacts.

Please do test with the latest updates from http://jusst.de/hg/mantis.


Regards,
Manu
