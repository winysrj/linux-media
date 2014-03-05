Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2982 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaCEWZG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 17:25:06 -0500
Message-ID: <5317A434.8060407@xs4all.nl>
Date: Wed, 05 Mar 2014 23:24:52 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Please change v4l2_format_sdr to v4l2_sdr_format
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

While adding sdr support for v4l2-compliance I noticed that the sdr field
of v4l2_format has type struct v4l2_format_sdr. Can you change that to
v4l2_sdr_format to be consistent with the others? (pix/vbi/sliced_vbi_format).

It's unexpected and it can still be changed.

Sorry I missed that earlier.

Regards,

	Hans
