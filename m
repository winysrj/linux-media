Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35356 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbZDPNeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 09:34:46 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n3GDYfdk023114
	for <linux-media@vger.kernel.org>; Thu, 16 Apr 2009 08:34:46 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id n3GDYell029062
	for <linux-media@vger.kernel.org>; Thu, 16 Apr 2009 08:34:40 -0500 (CDT)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep20.itg.ti.com (8.12.11/8.12.11) with ESMTP id n3GDYem6004659
	for <linux-media@vger.kernel.org>; Thu, 16 Apr 2009 08:34:40 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 16 Apr 2009 08:34:37 -0500
Subject: [RFC] V4L2 CID for Testpattern mode
Message-ID: <A24693684029E5489D1D202277BE89442ED66B69@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

During the omap3camera development, we came across with the case of imaging sensors which can produce test patterns instead of capturing images from the CCD.

What we did in an attempt to keep an standard interface, is that we created a CID named V4L2_CID_TEST_PATTERN of integer type, so 0 is "no test pattern", and from 1 to any supported quantity, to select between supported pattern modes.

So, do you think this is good approach? Or is it something which supports already this kind of setting? I think it is a pretty common feature in capturing devices.

Regards,
Sergio
