Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:33732 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761AbaJIVpi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 17:45:38 -0400
Date: Thu, 9 Oct 2014 16:45:36 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, <hverkuil@xs4all.nl>
Subject: v4l2-compliance revision vs Kernel version
Message-ID: <20141009214536.GF973@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Can someone point me toward a mapping of v4l2-compliance release vs kernel version?

I am currently working with a 3.14 kernel and would like to find the matching v4l2-compliance version.
I am  using git://linuxtv.org/v4l-utils.git commit id:
3719cef libdvbv5: reimplement the logic that gets a full section

But on 3.14 running that version against vivi.ko shows a few failures and a bunch of "Not Supported".

Thanks,
Benoit
