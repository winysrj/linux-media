Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay07.ispgateway.de ([80.67.31.30]:59622 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZKEXqG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 18:46:06 -0500
Received: from [78.35.154.245] (helo=fruehjahrsmuede.home.noschinski.de)
	by smtprelay07.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <lars@public.noschinski.de>)
	id 1N6Buf-00089m-4C
	for linux-media@vger.kernel.org; Fri, 06 Nov 2009 00:38:45 +0100
Received: from lars by fruehjahrsmuede.home.noschinski.de with local (Exim 4.69)
	(envelope-from <lars@public.noschinski.de>)
	id 1N6Bue-0001eW-32
	for linux-media@vger.kernel.org; Fri, 06 Nov 2009 00:38:44 +0100
Date: Fri, 6 Nov 2009 00:38:43 +0100
From: Lars Noschinski <lars@public.noschinski.de>
To: linux-media@vger.kernel.org
Subject: pac7311
Message-ID: <20091105233843.GA27459@lars.home.noschinski.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I'm using a webcam which identifies itself as

    093a:2603 Pixart Imaging, Inc. PAC7312 Camera

and is sort-of supported by the gspca_pac7311 module. "sort-of" because
the image alternates quickly between having a red tint or a green tint
(using the gspca driver from http://linuxtv.org/hg/~jfrancois/gspca/ on
a 2.6.31 kernel; occurs also with plain 2.6.31).

Is there something I can do to debug/fix this problem?

 - Lars
