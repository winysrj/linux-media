Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:47102 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbaK0NYD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 08:24:03 -0500
Received: from durdane.cisco.com (173-38-208-170.cisco.com [173.38.208.170])
	by tschai.lan (Postfix) with ESMTPSA id 4CAC42A0088
	for <linux-media@vger.kernel.org>; Thu, 27 Nov 2014 14:23:48 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 0/9] Improve colorspace support
Date: Thu, 27 Nov 2014 14:23:43 +0100
Message-Id: <1417094632-31980-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since RFCv1:

- Added the adv7511 patch (so that this is used in a real driver)
- Made some small improvements to the DocBook patch (improved the xyY
  colorspace description, added links to other colorspace resources
  and mention the opRGB (aka AdobeRGB) standard.

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

http://hverkuil.home.xs4all.nl/media_api.html#colorspaces

The remaining patches add support for the new colorspace functionality
to the test pattern generator and the vivid driver and to adv7511. I
have tested that the adv7511 correctly sets the InfoFrame information
and that it can be received by an adv7604. In the near future support
for this for the adv7604 will be added as well.

I am planning to post a pull request for this some time next week if
there are no comments.

Regards,

        Hans

