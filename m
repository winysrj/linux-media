Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:64449 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab0DZA7e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Apr 2010 20:59:34 -0400
Subject: Re: tuner XC5000 race condition??
From: Andy Walls <awalls@md.metrocast.net>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20100426104446.01bca601@glory.loctelecom.ru>
References: <20100426104446.01bca601@glory.loctelecom.ru>
Content-Type: text/plain
Date: Sun, 25 Apr 2010 21:00:10 -0400
Message-Id: <1272243610.3060.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-04-26 at 10:44 +1000, Dmitri Belimov wrote:
> Hi
> 
> Sometimes tuner XC5000 crashed on boot. This PC is dual-core.
> It can be race condition or multi-core depend problem.
> 
> Add mutex for solve this problem is correct?

Dmitri,

This problem may be related to the firmware loading race described here:

https://bugzilla.kernel.org/show_bug.cgi?id=15294

I still have not fixed that bug yet.

But for your problem, perhaps you can try:

	echo 120 > /sys/class/firmware/timeout

as root in the initialization scripts to lengthen the firmware loading
timeout to 120 seconds.  Maybe that will work around the crash.

I'll try and look at what is going on in your crash dumps, if I have
time.

Regards,
Andy


