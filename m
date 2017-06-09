Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34370 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751671AbdFIRyE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 13:54:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH 0/2] cec.txt: document common cec bindings
Date: Fri,  9 Jun 2017 19:53:59 +0200
Message-Id: <20170609175401.40204-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As requested by Rob Herring.

Sits on top of the earlier "cec improvements" patch series:

http://www.spinics.net/lists/dri-devel/msg143377.html

Regards,

	Hans

Hans Verkuil (2):
  dt-bindings: add media/cec.txt
  dt-bindings: media/s5p-cec.txt, media/stih-cec.txt: refer to cec.txt

 Documentation/devicetree/bindings/media/cec.txt      | 8 ++++++++
 Documentation/devicetree/bindings/media/s5p-cec.txt  | 6 ++----
 Documentation/devicetree/bindings/media/stih-cec.txt | 2 +-
 MAINTAINERS                                          | 1 +
 4 files changed, 12 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/cec.txt

-- 
2.11.0
