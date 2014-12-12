Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965849AbaLLLH4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 06:07:56 -0500
Message-ID: <548ACC7E.5070507@redhat.com>
Date: Fri, 12 Dec 2014 12:07:42 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Bastien Nocera <hadess@hadess.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Baytrail camera csi / isp support status ?
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

A college of mine has a baytrail bases tablet:

http://www.onda-tablet.com/onda-v975w-quad-core-win-8-tablet-9-7-inch-retina-screen-ram-2gb-wifi-32gb.html

And he is trying to get Linux to run on it, he has things mostly
working, but he would also like to get the cameras to work.

I've found this:

http://sourceforge.net/projects/e3845mipi/files/

Which is some not so pretty code, with the usual problems of using
custom ioctls to pass info from the statistics block of the isp
to userspace and then let some userspace thingie (blob?) handle it.

So I was wondering if anyone is working on proper support
(targeting upstream) for this ? It would be nice if we could at least
get the csi bits going, using the sensors or software auto-whitebal, etc.
for now.

Regards,

Hans
