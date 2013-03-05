Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:58097 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653Ab3CEGXt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Mar 2013 01:23:49 -0500
Received: from zeta.dmz-ap.st.com (ns6.st.com [138.198.234.13])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id B5E7DDA
	for <linux-media@vger.kernel.org>; Tue,  5 Mar 2013 06:15:34 +0000 (GMT)
Received: from Webmail-ap.st.com (eapex1hubcas1.st.com [10.80.176.8])
	by zeta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 1F851D17
	for <linux-media@vger.kernel.org>; Tue,  5 Mar 2013 06:23:44 +0000 (GMT)
From: Divneil Rai WADHAWAN <divneil.wadhawan@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 5 Mar 2013 14:23:43 +0800
Subject: DMX_SET_SOURCE documentation
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB6616AFB3CF680@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have been working on LinuxDVB port, where the application wants to switch dynamically from FRONT0 to DVR0 as DEMUX0 source, time and again.
The obvious way to handle this is to use DMX_SET_SOURCE which connects/disconnects the FRONT0/DVR0 to DEMUX0.

Before implementing that, I would like to have the some sort of documentation on this.
I have LinuxDVB specs V4, which has the equivalent DVB_DEMUX_SET_SOURCE and poses the restriction that device be opened in WRONLY mode.
The concern is; is there going to some updation on this interface? Can we update and merge the documentation in LinuxDVB doc pages.

Regards,
Divneil
