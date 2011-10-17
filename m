Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay01.ispgateway.de ([80.67.29.23]:41962 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1JQGN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Oct 2011 02:13:29 -0400
Received: from [188.174.123.244] (helo=zwergkolibri.home.noschinski.de)
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <lars@public.noschinski.de>)
	id 1RFgIV-0008NF-N9
	for linux-media@vger.kernel.org; Mon, 17 Oct 2011 08:03:39 +0200
Received: from lars by zwergkolibri.home.noschinski.de with local (Exim 4.76)
	(envelope-from <lars@public.noschinski.de>)
	id 1RFgIV-0004PV-5y
	for linux-media@vger.kernel.org; Mon, 17 Oct 2011 08:03:39 +0200
Date: Mon, 17 Oct 2011 08:03:34 +0200
From: Lars Noschinski <lars@public.noschinski.de>
To: linux-media@vger.kernel.org
Subject: pac7311
Message-ID: <20111017060334.GA16001@lars.home.noschinski.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm using a webcam (Philipps SPC500NC) which identifies itself as

    093a:2603 Pixart Imaging, Inc. PAC7312 Camera

and is sort-of supported by the gspca_pac7311 module. "sort-of" because
the image alternates quickly between having a red tint or a green tint
(using the gspac driver from kernel 3.0.0, but this problem is present
since at least 2.6.31).

If I remove and re-plugin the camera a few times (on average around 3
times), the colors are stable. Then a second issue becomes apparent:
There is almost no saturation in the image. Toying around with Contrast,
Gamma, Exposure or Gain does not help. What _does_ help is the Vflip
switch: If I enable it, the image is flipped vertically (as expected),
but also the color become a lot better.

Is there something I can do to debug/fix this problem?
