Return-path: <linux-media-owner@vger.kernel.org>
Received: from s250.sam-solutions.net ([217.21.49.219]:49388 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab3EPNFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 09:05:51 -0400
Message-ID: <5194D9AB.3030608@sam-solutions.com>
Date: Thu, 16 May 2013 16:05:47 +0300
From: Andrei Andreyanau <a.andreyanau@sam-solutions.com>
Reply-To: a.andreyanau@sam-solutions.com
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: mt9p031 shows purple coloured capture
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent,
I have an issue with the mt9p031 camera. The kernel version I use
uses soc camera framework as well as camera does. And I have
the following thing which appears randomly while capturing the
image using gstreamer. When I start the capture for the first time, it
shows the correct image (live stream). When I stop and start it again
it may show the image in purple (it can appear on the third or fourth
time). Or it can show the correct image every time I start the capture.
Do you have any idea why it appears so?

Thanks in advance,
Andrei Andreyanau
