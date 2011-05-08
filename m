Return-path: <mchehab@gaivota>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:55381 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab1EHTRg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 15:17:36 -0400
From: Steve Kerrison <steve@stevekerrison.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: Andreas Oberritter <obi@linuxtv.org>
Subject: [PATCH v2 0/5] DVB-T2 API updates, documentation and accompanying small fixes
Date: Sun,  8 May 2011 20:17:15 +0100
Message-Id: <1304882240-23044-1-git-send-email-steve@stevekerrison.com>
In-Reply-To: <4DC6BF28.8070006@redhat.com>
References: <4DC6BF28.8070006@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Good evening all,

This is the second version of my patch set for DVB-T2 and PCTV nanoStick T2
290e support.

Changes to cxd2820r_priv.h have been rolled into patch 1 as requested by Mauro.
I hope I have done this in an appropriate way.

I have updated my drxd and mxl5005 patches to include a comment to make clear
that the default case should fall through into BANDWIDTH_AUTO for bandwidth
selection.

My other cxd2820r patch is trivial and unchanged from the previous
submission. I considered also rolling it into the first patch in the set,
but it's a separate ehancement so I've kept it as it is.

Finally I've made some documentation changes. I've added a section of DVB-T2
specific parameters, but don't have the knowledge to contribute anything useful
to this section yet.

Any further feedback welcomed. I won't be likely to act upon it for a few days,
however. The mailing list could probably do with a break from me bungling my
way around git. :)

Regards,
Steve Kerrison.

