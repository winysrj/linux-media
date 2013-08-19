Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38664 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3HSMW1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 08:22:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Peter A. Bigot" <pab@pabigot.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [v2] mt9v032: Use the common clock framework
Date: Mon, 19 Aug 2013 14:23:37 +0200
Message-ID: <1530924.fdkyRj1ebt@avalon>
In-Reply-To: <5209FCF2.9050907@pabigot.com>
References: <1376047457-11512-1-git-send-email-laurent.pinchart@ideasonboard.com> <5209FCF2.9050907@pabigot.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

On Tuesday 13 August 2013 04:31:30 Peter A. Bigot wrote:
> FWIW: I found it necessary to use this along with
> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/board/overo/
> mt9v032 to get the Caspa to work on Gumstix under Linux 3.10.

That's expected :-) Work is still needed to implement device tree support in 
the OMAP3 ISP driver, after that we shouldn't need any board code modification 
anymore.

> (Without configuring the clock the device won't respond to I2C operations.
> It still doesn't work "right", but that may not be a driver problem. It's
> also necessary under 3.8, which has serious problems with CCDC idle messages
> that I haven't tracked down yet.)

-- 
Regards,

Laurent Pinchart

