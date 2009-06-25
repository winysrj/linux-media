Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([76.76.67.137]:3203 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZFYWnC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 18:43:02 -0400
Message-ID: <4A43FD77.1020709@mlbassoc.com>
Date: Thu, 25 Jun 2009 16:43:03 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: linux-omap@vger.kernel.org
Subject: v4l2_int_device vs v4l2_subdev?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Still trying to wrap my head around the OMAP/34xx camera support.
I need to use the TVP5150 sensor/controller, but the existing
driver uses v4l_subdev.  The "working" examples I've found
(from Sergio's tree) use sensors like ov3640 with uses v4l2_int_device

Are these two totally separate beasts?
If I have an infrastructure (I assume) based on v4l2_int_device,
how do I use a v4l2_subdev device driver?  or need I move one to
the other?

... dizzy from traveling down too many twisty little passages :-(

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
