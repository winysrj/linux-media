Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2582 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab1JGCpB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 22:45:01 -0400
Received: from starbug-2.trinair2002 (c74072.upc-c.chello.nl [212.187.74.72])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id p972ZvBk014931
	for <linux-media@vger.kernel.org>; Fri, 7 Oct 2011 04:35:58 +0200 (CEST)
	(envelope-from maarten@treewalker.org)
Received: from hyperion.localnet (hyperion.trinair2002 [192.168.0.43])
	by starbug-2.trinair2002 (Postfix) with ESMTP id AF6822BCD1
	for <linux-media@vger.kernel.org>; Fri,  7 Oct 2011 04:35:57 +0200 (CEST)
From: Maarten ter Huurne <maarten@treewalker.org>
To: linux-media@vger.kernel.org
Subject: Signal strength threshold for hardware seek
Date: Fri, 07 Oct 2011 04:41:18 +0200
Message-ID: <1428635.yHD7DEIEQt@hyperion>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm writing a V4L2 driver for the RDA5807 FM receiver chip. This chip has 
hardware seek capability where it will search for a frequency on which the 
signal level is above a configurable threshold. I am wondering what would be 
the best way to configure that threshold in the driver:

a. Use a fixed hardcoded value?
b. Use a fixed value specified in the platform data?
c. Use a fixed value specified as a module parameter?
d. Add a control for it? (a CID would have to be added)
e. Add a field for it in struct v4l2_hw_freq_seek?

Since I'm pretty new at V4L2 and options d and e would introduce new 
interface elements, I could use some guidance.


If anyone is interested, the work in progress can be found here:

http://projects.qi-hardware.com/index.php/p/qi-kernel/source/tree/
  jz-3.0/drivers/media/radio/radio-rda5807.c

It has sufficient functionality to support playback and scanning using 
fmtools 2.0.1, but it needs more functionality and some cleanup before I can 
submit it for inclusion in the mainline kernel.

Bye,
		Maarten

