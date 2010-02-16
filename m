Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:17126 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab0BPLXd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 06:23:33 -0500
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1GBNRnS000984
	for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 13:23:30 +0200
Received: from [172.22.211.19] (masi.nmp.nokia.com [172.22.211.19])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1GBNJYr015372
	for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 13:23:20 +0200
Subject: V4L2 devices, subdevices, ops and fops.
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <4B78900A.6040607@linuxstation.net>
References: <4B78900A.6040607@linuxstation.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Feb 2010 13:23:19 +0200
Message-ID: <1266319399.29892.6.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

I have been writing this FM radio driver and I'm now trying to implement
it as a platform driver that passes IOCTL calls to a subdevice driver
that handles the communication with the hardware etc. 

For IOCTLs there's a macro v4l2_device_call_until_err in v4l2-device.h
that makes the calls pretty convenient to write. But for file operations
there's not such define.

This leads me to the question: should there be such a define for fops or
should they be treated in a different way? To me the IOCTL callbacks and
the file operation callbacks look pretty similar...

Cheers,
Matti






