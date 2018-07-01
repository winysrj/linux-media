Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53482
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965704AbeGASEt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Jul 2018 14:04:49 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-usb@vger.kernel.org, joe@perches.com,
        Chengguang Xu <cgxu519@gmx.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/3] cast sizeof to int for comparison
Date: Sun,  1 Jul 2018 19:32:02 +0200
Message-Id: <1530466325-1678-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Comparing an int to a size, which is unsigned, causes the int to become
unsigned, giving the wrong result.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@safe disable not_int2@
int x;
position p;
binary operator op = {<,<=};
expression e;
@@

(
x < 0 || (x@p op e)
|
x <= 0 || (x@p op e)
|
x > 0 && (x@p op e)
|
x >= 0 && (x@p op e)
)

@@
int x;
type t;
expression e,e1;
identifier f != {strlen,resource_size};
position p != safe.p;
binary operator op = {<,<=};
@@

*x = f(...);
... when != x = e1
    when != if (x < 0 || ...) { ... return ...; }
(
*x@p op sizeof(e)
|
*x@p op sizeof(t)
)
// </smpl>

---

 drivers/input/mouse/elan_i2c_smbus.c |    2 +-
 drivers/media/usb/gspca/kinect.c     |    2 +-
 drivers/usb/wusbcore/security.c      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)
