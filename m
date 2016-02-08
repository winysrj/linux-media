Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:57142 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbcBHKL4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 05:11:56 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E393E180EBF
	for <linux-media@vger.kernel.org>; Mon,  8 Feb 2016 11:11:50 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [ANN] Dropped kernels 2.6.34 and 2.6.35 from the daily build
Message-ID: <56B869E6.6080606@xs4all.nl>
Date: Mon, 8 Feb 2016 11:11:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to recent rc changes relating to kfifo these two kernels no longer compiled and I saw no
easy way of fixing this.

I decided to drop support for these kernels from media_build and the daily build. As far as
I know most (all?) long term kernels are 3.0 or later, so I see no reason to keep support
for these kernels.

If someone disagrees: patches to fix the build are welcome :-)

I just did a full daily build locally and I got an OK again.

Regards,

	Hans
