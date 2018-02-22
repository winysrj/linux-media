Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43866 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752961AbeBVJrm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 04:47:42 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/3] Update MAINTAINERS file preparing for CEU inclusion
Date: Thu, 22 Feb 2018 10:47:16 +0100
Message-Id: <1519292839-7028-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
   this 3 patches update MAINTAINERS in preparation for CEU inclusion.

I have listed myself as contact for CEU driver, as well as for ov772x as
I've a access to a test platform but for "Odd fixes" only.
I listed tw9910 as unmaintained instead, as I've not been able to test it.

Thanks
   j

Jacopo Mondi (3):
  MAINTAINERS: Add entry for Renesas CEU
  MAINTAINERS: Add entry for Omnivision OV772x
  MAINTAINERS: Add entry for Techwell TW9910

 MAINTAINERS | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--
2.7.4
