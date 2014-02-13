Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46267 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBMTw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 14:52:29 -0500
Date: Thu, 13 Feb 2014 20:52:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Video capture in FPGA -- simple hardware to emulate?
Message-ID: <20140213195224.GA10691@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I'm working on project that will need doing video capture from
FPGA. That means I can define interface between kernel and hardware.

Is there suitable, simple hardware we should emulate in the FPGA? I
took a look, and pxa_camera seems to be one of the simple ones...

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
