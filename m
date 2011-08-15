Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44879 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab1HOHds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 03:33:48 -0400
Received: by wwf5 with SMTP id 5so4589079wwf.1
        for <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 00:33:47 -0700 (PDT)
MIME-Version: 1.0
From: Andrew Hakman <andrew.hakman@gmail.com>
Date: Mon, 15 Aug 2011 01:33:27 -0600
Message-ID: <CABKuU7q6Wcouj0Rh8OZK6fZOiiSRqvsti9DcKiz3zRCRedjmLg@mail.gmail.com>
Subject: 16APSK / 32APSK / Constellation diagrams
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I see the constellation diagrams in the wiki for the 16APSK / 32APSK
support on the STV0900A based cards. How were these constellation
diagrams produced? Is there any source kicking around for this?

I would like to be able to give a frequency and symbolrate, and get a
similar constellation diagram back (in quasi realtime?), obviously
using a STV0900A based card. I know there's a windows program that
does this (crazyscan) but it would be nice to be able to do it in
linux. I don't expect any polished programs, but any source that shows
how to do this (i.e. get raw I and Q data from the card) would be very
handy.

Thanks,
Andrew
