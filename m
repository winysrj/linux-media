Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:45827 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab1JKNUo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 09:20:44 -0400
Message-ID: <4E9442A9.1060202@mlbassoc.com>
Date: Tue, 11 Oct 2011 07:20:41 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: OMAP3 ISP ghosting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As a number of us have seen, when using the OMAP3 ISP with a BT-656
sensor, e.g. TVP5150, the results are not 100% correct.  Some number
of frames (typically 2) will be correct, followed by another set (3)
which are incorrect and show only partially correct data.  Note: I
think the numbers (2 correct, 3 wrong) are not cast in stone and may
be related to some other factors like number of buffers in use, etc.

Anyway, I've observed that in the incorrect frames, 1/2 the data is
correct (even lines?) and the other 1/2 is wrong.  One of my customers
pointed out that it looks like the incorrect data is just what was
left in memory during some previous frame.  I'd like to prove this
by "zeroing" the entire frame data memory before the frame is captured.
That way, there won't be stale data from a previous frame, but null
data which should show up strongly when examined.  Does anyone in this
group have a suggestion the best way/place to do this?

Final question: given a properly connected TVP5150->CCDC, including
all SYNC signals, could this setup be made to work in RAW, non BT-656
mode?  My board at least has all of these signals routed, so it should
just be a matter of configuring the software...

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
