Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:60628 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab1CFEtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 23:49:13 -0500
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p264nDjV009305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 5 Mar 2011 22:49:13 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id p264nD6X001925
	for <linux-media@vger.kernel.org>; Sat, 5 Mar 2011 22:49:13 -0600 (CST)
Received: from dsbe71.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p264nDXX029102
	for <linux-media@vger.kernel.org>; Sat, 5 Mar 2011 22:49:13 -0600 (CST)
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Sat, 5 Mar 2011 22:49:13 -0600
Subject: [Query] What is the best way to handle V4L2_PIX_FMT_NV12 buffers?
Message-ID: <A24693684029E5489D1D202277BE89448861F7E6@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I was curious in how to handle properly buffers of pixelformat V4L2_PIX_FMT_NV12.

I see that the standard convention for determining a bytesize of an image buffer is:

bytesperline * height

However, for NV12 case, the bytes per line is equal to the width, _but_ the actual buffer size is:

For the Y buffer: width * height
For the UV buffer: width * (height / 2)
Total size = width * (height + height / 2)

Which I think renders the bytesperline * height formula not valid for this case.

Any ideas how this should be properly handled?

NOTE: See here for more details: http://www.fourcc.org/yuv.php#NV12

Regards,
Sergio