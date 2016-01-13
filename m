Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:36446 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754892AbcAMPEL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 10:04:11 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx08-00178001.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u0DEp69j015001
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 16:04:10 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
	by mx08-00178001.pphosted.com with ESMTP id 20ar7778pv-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 16:04:10 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id F158E31
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 15:03:23 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas6.st.com [10.75.90.73])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 6328AA541
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 15:04:09 +0000 (GMT)
From: Sebastien LEDUC <sebastien.leduc@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 13 Jan 2016 16:04:07 +0100
Subject: V4L2 encoder APIs
Message-ID: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F53E0@SAFEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all
I have seen on the linuxTV web site that there were some on-going discussions related to the Codec API.

In our SoCs, it is the HW encoder that is outputting both the slice data and the headers/metadata, but it does it using separate buffers.

So we are looking at how to expose that using V4L2 APIs.

We were thinking that we could use the MPLANE apis to achieve that, where one plane would contain  the header/metadata and another one for the slice data.

Any opinion on this ? 

Thanks in advance for your inputs

Regards,
Sébastien
