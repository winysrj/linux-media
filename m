Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s25.blu0.hotmail.com ([65.55.111.100]:30060 "EHLO
	blu0-omc2-s25.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330Ab1I3PGz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 11:06:55 -0400
Message-ID: <BLU0-SMTP38756A737C4DEE1B28C76BFD8F70@phx.gbl>
Date: Fri, 30 Sep 2011 17:01:43 +0200
From: Tuxoholic <tuxoholic@hotmail.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, abraham.manu@gmail.com,
	johns98@gmx.net
Subject: Re: [PATCH v2] stb0899: Fix slow and not locking DVB-S transponder(s)
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Sep 2011 23:22, Lutz Sammer wrote:

> With the patch more transponder could be locked and locks about 2* faster.

I second that, tested against vanilla kernel 3.0.1 with and w.o patch 
and the Twinhan 1041.

Manu, you know there's sth wrong with the algo, so please review, 
comment and ack - same goes for the Mantis Remote patch.

Thanks!
