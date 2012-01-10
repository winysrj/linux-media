Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42375 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab2AJRbk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 12:31:40 -0500
Message-ID: <4F0C75F9.5000200@iki.fi>
Date: Tue, 10 Jan 2012 19:31:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] mxl5007t: bugfix DVB-T 7 MHz and 8 MHz bandwidth
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB-T did not work at all - only 6 MHz was working but it is not 
commonly used.
Fix it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
  drivers/media/common/tuners/mxl5007t.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/mxl5007t.c 
b/drivers/media/common/tuners/mxl5007t.c
index 8f4899b..69e453e 100644
--- a/drivers/media/common/tuners/mxl5007t.c
+++ b/drivers/media/common/tuners/mxl5007t.c
@@ -644,8 +644,10 @@ static int mxl5007t_set_params(struct dvb_frontend *fe)
  			break;
  		case 7000000:
  			bw = MxL_BW_7MHz;
+			break;
  		case 8000000:
  			bw = MxL_BW_8MHz;
+			break;
  		default:
  			return -EINVAL;
  		}
-- 
1.7.4.4
