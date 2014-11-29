Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46807 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbaK2Kya (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Nov 2014 05:54:30 -0500
Message-ID: <5479A5E1.2000304@xs4all.nl>
Date: Sat, 29 Nov 2014 11:54:25 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Huang Shijie <shijie8@gmail.com>
Subject: [RFC] tlg2300: deprecate and remove
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I propose that this driver is deprecated and moved to staging and that
1-2 kernel cycles later this driver is removed.

The reason for this is that hardware for this driver is impossible to find
anymore. I had one USB stick but it broke and I have been unable to find
another. The company behind the chip is gone for many years and cheap
alternatives are easily available.

This driver is still using vb1 and ioctl instead of unlocked_ioctl, and without
hardware this will be difficult if not impossible to fix. I am not aware of
any active users of this driver.

In my view it is time to retire this driver. The lack of hardware and users
and the fact that it uses deprecated APIs makes it a good candidate to removal.

Regards,

	Hans
