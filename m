Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47295 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752923AbeFILaP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2018 07:30:15 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: kieran.bingham+renesas@ideasonboard.com,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [RFC 0/2] GMSL bindings description update
Date: Sat,  9 Jun 2018 13:30:03 +0200
Message-Id: <1528543805-23945-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,
  as anticipated offline here you have an alternative bindings description
for max9286 and rdacm20 prepared before your GMSL upstreaming effort.
Sorry for not having shared this in advance.

I integrated some what you proposed in your bindings description here, feel
free to add other parts if yuo think that's the case.

Thanks
   j

Jacopo Mondi (1):
  dt-bindings: media: i2c: Add bindings for IMI RDACM20

Laurent Pinchart (1):
  dt/bindings: media: Add DT bindings for Maxim Integrated MAX9286

 .../devicetree/bindings/media/i2c/imi,rdacm20.txt  |  62 +++++++
 .../bindings/media/i2c/maxim,max9286.txt           | 180 +++++++++++++++++++++
 2 files changed, 242 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/imi,rdacm20.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt

--
2.7.4
