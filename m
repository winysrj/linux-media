Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:45576 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbZHRPdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 11:33:14 -0400
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate03.web.de (Postfix) with ESMTP id F096810E0F4D4
	for <linux-media@vger.kernel.org>; Tue, 18 Aug 2009 17:33:14 +0200 (CEST)
Received: from [77.25.177.7] (helo=mouldy.stevens.mnet-online.de)
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #314)
	id 1MdQgU-0003rY-00
	for linux-media@vger.kernel.org; Tue, 18 Aug 2009 17:33:14 +0200
From: Andrew Stevens <andrew.stevens@mnet-online.de>
Reply-To: andrew.stevens@mnet-online.de
To: linux-media@vger.kernel.org
Subject: CX24123 no FE_HAS_LOCK/tuning failed
Date: Tue, 18 Aug 2009 17:33:38 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908181733.38583.andrew.stevens@mnet-online.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi John, Rex,

As an extra data-point: John's patch worked fine for me (Quad LNB with 
integrated switch for Astra-28.2E).  I'd really like to build on John's patch
to work up a full fix.

To do this I'm trying to track down a cx24123 datasheet.  I don't suppose 
either of you guys has a pdf?

cheers,

	Andrew


