Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbaKTP4G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 10:56:06 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: [PATCH 0/9] sun6i / A31 ir receiver support
Date: Thu, 20 Nov 2014 16:55:19 +0100
Message-Id: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime, et al,

Here is a patch series adding support for the ir receiver found on sun6i,
it is the same one as found on sun5i (which is very similar to the sun4i
one we already support), except that as usual on sun6i it needs a reset
to be de-asserted.

More interesting is the clocking of it, it is clocked through a clock which
comes from the prcm module, I guess this is done so that the remote can keep
working with all the main clocks turned off. So this patch series starts
with adding support for this new ir clock.

I've discussed how to best upstream this with Mauro Chehab, the media
maintainer, and since this only touches sunxi-cir.c under the media tree, he
is fine with everything going upstream to your tree.

Regards,

Hans
