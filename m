Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:35379 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbaLAKdC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 05:33:02 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3672A2A008F
	for <linux-media@vger.kernel.org>; Mon,  1 Dec 2014 11:32:44 +0100 (CET)
Message-ID: <547C43CC.3040504@xs4all.nl>
Date: Mon, 01 Dec 2014 11:32:44 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [RFC] vino: deprecate and remove
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I propose that this driver is deprecated and moved to staging and that
1-2 kernel cycles later this driver is removed.

The reason for this is that this is ancient hardware and it hasn't seen any
development in ages and no apparent users. It hasn't been tested with actual
hardware in many, many years.

To update it it would need to be converted to the control framework and vb2,
but without any hardware that's going to be impossible.

In my view it is time to retire this driver. The lack of hardware and users
and the fact that it uses deprecated APIs makes it a good candidate to removal.

Regards,

	Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
