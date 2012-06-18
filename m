Return-path: <linux-media-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:55553 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2FRENl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 00:13:41 -0400
Received: from shed.thedillows.org ([IPv6:2001:470:8:bf8::2])
	by matrix.voodoobox.net (8.13.8/8.13.8) with ESMTP id q5I4Deet024252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 00:13:40 -0400
Received: from [192.168.0.10] (obelisk.thedillows.org [192.168.0.10])
	by shed.thedillows.org (8.14.4/8.14.4) with ESMTP id q5I4DdB5030836
	for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 00:13:39 -0400
Message-ID: <1339992819.32360.36.camel@obelisk.thedillows.org>
Subject: [PATCH 0/2] Fix audio on analog cx231xx devices
From: David Dillow <dave@thedillows.org>
To: linux-media@vger.kernel.org
Date: Mon, 18 Jun 2012 00:13:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the following patches, I get proper audio on my HVR850 and there
isn't a stutter when starting Live TV under MythTV. I think this also
fixes a number of odd crashes I've seen on the box, which can easily be
explained by DMA to unlucky addresses.

The first patch fixes DMA for the device; I think this also keeps MythTV
from being unhappy with the stream (VBI timeouts), though I've not
explicitly tested that -- I'm confident in the VBI change based on code
inspection.

I'm not sure the second patch is needed; on my system, audio seems to
work with and without the patch. However, the patch does not hurt my
hardware, and the value is never passed in to
cx231xx_initialize_stream_xfer() so I think there is a argument to be
made for using the provided names instead of magic numbers.



