Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:65478 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751385AbdINKay (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 06:30:54 -0400
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/8] [media] ttusb_dec: Fine-tuning for some function
 implementations
Message-ID: <66b087d3-6dd3-1e1c-d33d-e34c9e2ffe25@users.sourceforge.net>
Date: Thu, 14 Sep 2017 12:30:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 14 Sep 2017 12:26:24 +0200

Some update suggestions were taken into account
from static source code analysis.

Markus Elfring (8):
  Use common error handling code in ttusb_dec_init_dvb()
  Adjust five checks for null pointers
  Improve a size determination in three functions
  Delete an error message for a failed memory allocation in ttusb_dec_probe()
  Move an assignment in ttusb_dec_probe()
  Reduce the scope for three variables in ttusb_dec_process_urb()
  Add spaces for better code readability
  Delete four unwanted spaces

 drivers/media/usb/ttusb-dec/ttusb_dec.c | 175 ++++++++++++++------------------
 1 file changed, 79 insertions(+), 96 deletions(-)

-- 
2.14.1
