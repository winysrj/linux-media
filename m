Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab1FFRnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 13:43:03 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: stable@kernel.org
Subject: [PATCH for 3.0] pwc fix oops / reference of free-ed memory on unplug
Date: Mon,  6 Jun 2011 19:42:56 +0200
Message-Id: <1307382177-2708-1-git-send-email-hdegoede@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro et all,

I'm working on (much needed) large cleanup + v4l2 compliance series for the
pwc driver, more on that later (targetting 3.1). But this particular patch
(the first of the series) seems one which we should have in 3.0 and stable
releases for older kernels too, since it fixes a real (and nasty) bug.

Regards,

Hans
