Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:52195 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562AbaKQORK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 09:17:10 -0500
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 02A7E2A0376
	for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 15:16:55 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 0/8] improve colorspace support
Date: Mon, 17 Nov 2014 15:16:46 +0100
Message-Id: <1416233814-40579-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series improves the V4L2 colorspace support. Specifically
it adds support for AdobeRGB and BT.2020 (UHDTV) colorspaces and it allows
configuring the Y'CbCr encoding and the quantization explicitly if
non-standard methods are used.

It's almost identical to the version shown during the mini-summit in Düsseldorf,
but the V4L2_QUANTIZATION_ALT_RANGE has been replaced by LIM_RANGE and
FULL_RANGE. After some more research additional YCbCr encodings have
been added as well:

- V4L2_YCBCR_ENC_BT2020NC
- V4L2_YCBCR_ENC_SYCC
- V4L2_YCBCR_ENC_SMPTE240M

The SYCC encoding was missing (I thought I could use ENC_601 for this, but
it's not quite the same) and the other two were implicitly defined via
YCBCR_ENC_DEFAULT and the current colorspace. That's a bit too magical
and these encodings should be defined explicitly.

The first three patches add the new defines and fields to the core. The 
changes are very minor.

The fourth patch completely overhauls the Colorspace chapter in the spec.
There is no point trying to read the diff, instead I've made the html
available here:

http://hverkuil.home.xs4all.nl/colorspace.html#colorspaces

The remaining patches add support for the new colorspace functionality
to the test pattern generator and the vivid driver.

Regards,

        Hans

