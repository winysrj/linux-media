Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1454 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3BJMuR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:17 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id r1ACoEAf019070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 13:50:16 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.lan (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 7930811E00BA
	for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 13:50:13 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEWv2 PATCH 00/19] bttv v4l2-compliance fixes
Date: Sun, 10 Feb 2013 13:49:55 +0100
Message-Id: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second version of my v4l2-compliance patches for bttv.
It's identical to the first, except for the last patch which is new, and
it includes the tda7432 control framework conversion which I skipped for
some reason in v1.

This patch series has been tested with the following bttv cards:

Simple bttv cards:

39, 77, 41, 33

msp34xx based cards:

10 (with msp3410d)
1 (with msp3410c)

tvaudio based card:

40 (with tda7432, tea6420 and tda9850)

The last one is now finally working. I doubt audio has worked at all in the
last few years for that card.

If there are no comments, then I'll post the final pull request on Friday.

Regards,

	Hans

