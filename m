Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:51920 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030246Ab2JKUue convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 16:50:34 -0400
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 276218C
	for <linux-media@vger.kernel.org>; Thu, 11 Oct 2012 20:50:31 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas2.st.com [10.75.90.16])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id C4AE94F93
	for <linux-media@vger.kernel.org>; Thu, 11 Oct 2012 20:50:31 +0000 (GMT)
From: Alain VOLMAT <alain.volmat@st.com>
To: "Linux Media Mailing List (linux-media@vger.kernel.org)"
	<linux-media@vger.kernel.org>
Date: Thu, 11 Oct 2012 22:50:29 +0200
Subject: Proposal for the addition of a binary V4L2 control type
Message-ID: <E27519AE45311C49887BE8C438E68FAA01012C91166A@SAFEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

In the context of supporting the control of our HDMI-TX via V4L2 in our SetTopBox, we are facing interface issue with V4L2 when trying to set some information from the application into the H/W.

As an example, in the HDCP context, an application controlling the HDMI-TX have the possibility to inform the transmitter that it should fail authentication to some identified HDMI-RX because for example they might be known to be "bad" HDMI receiver that cannot be trusted. This is basically done by setting the list of key (BKSV) into the HDMI-TX H/W.

Currently, V4L2 ext control can be of the following type:

enum v4l2_ctrl_type {
        V4L2_CTRL_TYPE_INTEGER       = 1,
        V4L2_CTRL_TYPE_BOOLEAN       = 2,
        V4L2_CTRL_TYPE_MENU          = 3,
        V4L2_CTRL_TYPE_BUTTON        = 4,
        V4L2_CTRL_TYPE_INTEGER64     = 5,
        V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
        V4L2_CTRL_TYPE_STRING        = 7,
        V4L2_CTRL_TYPE_BITMASK       = 8,
}

There is nothing here than could efficiently be used to push this kind of long (several bytes long .. not fitting into an int64) key information.
STRING exists but actually since they are supposed to be strings, the V4L2 core code (v4l2-ctrls.c) is using strlen to figure out the length of data to be copied and it thus cannot be used to push this kind of blob data.

Would you consider the addition of a new v4l2_ctrl_type, for example called V4L2_CTRL_TYPE_BINARY or so, that basically would be pointer + length. That would be helpful to pass this kind of control from the application to the driver.
(here I took the example of HDCP key blob but that isn't of course the only example we can find of course).

Regards,

Alain
