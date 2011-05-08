Return-path: <mchehab@gaivota>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:39602 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1EHPv3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 11:51:29 -0400
From: Steve Kerrison <steve@stevekerrison.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: Andreas Oberritter <obi@linuxtv.org>
Subject: [PATCH 0/6] DVB-T2 API updates, documentation and accompanying small fixes
Date: Sun,  8 May 2011 16:51:07 +0100
Message-Id: <1304869873-9974-1-git-send-email-steve@stevekerrison.com>
In-Reply-To: <4DC417DA.5030107@redhat.com>
References: <4DC417DA.5030107@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro, Antti, Andreas,

I hope this patch set is formed appropriately - it is my first patch
submission direct to the linux-media group.

Following the pull of Antti's work on support for the cxd2820r and PCTV
nanoStick T2 290e, this patch set implements Andreas' modifications to the API
to give provisional DVB-T2 support and the removal of a workaround for this
in the cxd2820r module.

In addition, there are some minor fixes to compiler warnings as a result
of the expanded enums. I cannot test these myself but they treat unrecognized
values as *_AUTO and I can't see where a problem would be created.

I have updated the documentation a little. If I've done the right thing then
I guess there is incentive there for me continue to expand DVB related
elements of the API docs.

This patch set has been tested by me on two systems, with one running a MythTV
backend utilising a long-supported DVB tuner. MythTV works fine with the old
tuner and the nanoStick T2 290e works in VLC. I've yet to test the 290e in
MythTV - I was more intent on making sure the patches hadn't broken userland
or older devices.

Feedback, testing  and discussion of where to go next is welcomed!

Regards,
Steve Kerrison.

