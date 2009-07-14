Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:53122 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbZGNQcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 12:32:25 -0400
Received: by fg-out-1718.google.com with SMTP id e21so921611fga.17
        for <linux-media@vger.kernel.org>; Tue, 14 Jul 2009 09:32:24 -0700 (PDT)
Message-ID: <4A5CB315.5050300@googlemail.com>
Date: Tue, 14 Jul 2009 18:32:21 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
MIME-Version: 1.0
To: aldoric@gmx.de
CC: linux-media@vger.kernel.org
Subject: Re: [Question] USB-Web-Cam becomes slower as darker the image becomes
References: <20090714161428.49520@gmx.net>
In-Reply-To: <20090714161428.49520@gmx.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

aldoric@gmx.de wrote:
> Hello,
> 
> I'm new to v4l-development. I was able to get the raw image into my application successfully. But the current problem is not only in limited to my self-developed application.
> 
> All of my USB-webcams will get less FPS as darker the image becomes. In optimal cases I get around 30 frames per second. But if it's really dark I only get around 2-3 FPS.

I suppose the camera (or the driver) is increasing the exposure time to
compensate for the lack of light and/or reduce noise.

> I think that it might be the software gamma-correction. On v4l2ucp I didn't find a way to disable it.

I don't think that will help. But you may try to turn off auto-exposure.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
