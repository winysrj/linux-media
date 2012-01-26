Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:54517 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2AZQCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 11:02:22 -0500
Received: from 188-222-111-86.zone13.bethere.co.uk ([188.222.111.86] helo=tiber)
	by mail81.extendcp.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.77)
	id 1RqRQt-0004G5-TW
	for linux-media@vger.kernel.org; Thu, 26 Jan 2012 15:40:15 +0000
Received: from [127.0.0.1] (helo=tiber)
	by tiber with esmtp (Exim 4.77)
	(envelope-from <h@realh.co.uk>)
	id 1RqRQt-0000j5-JG
	for linux-media@vger.kernel.org; Thu, 26 Jan 2012 15:40:15 +0000
Date: Thu, 26 Jan 2012 15:40:15 +0000
From: Tony Houghton <h@realh.co.uk>
To: linux-media@vger.kernel.org
Subject: DVB TS/PES filters
Message-ID: <20120126154015.01eb2c18@tiber>
Reply-To: linux-media@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I could do with a little more information about DMX_SET_PES_FILTER.
Specifically I want to use an output type of DMX_OUT_TS_TAP. I believe
there's a limit on how many filters can be set, but I don't know whether
the kernel imposes such a limit or whether it depends on the hardware,
If the latter, how can I read the limit?

I looked at the code for GStreamer's dvbsrc and that defines a limit of
32 filters. It also implies that using the "magic number" 8192 as the
pid requests the entire stream.

I can't find information about these things in the API docs. Is there
somewhere I can get more details.

If I ended up wanting enough pids to exceed the limit would it work to
allow LIMIT - 1 individual pid filters to be set, then after that set
one for 8192 instead and clear all the others?
