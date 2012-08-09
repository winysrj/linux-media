Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42501 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759979Ab2HIWZc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 18:25:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 0/3] dvb-frontend statistic IOCTL validation
Date: Fri, 10 Aug 2012 01:24:58 +0300
Message-Id: <1344551101-16700-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I added some logic to prevent statistic queries in case demodulator is clearly in state statistic query is invalid. Currently there could be checks in device driver but usually not. Garbage is usually returned and in some cases even I/O errors are generated as demod is put sleep and cannot answer any request.

I selected EPERM as error code for such cases. There was some other potential codes, but this one sounds best. And after quick grepping it is used by V4L2 for similar situation.

Other error codes I found somehow suitable are:

#define EPERM        1  /* Operation not permitted */
#define EAGAIN      11  /* Try again */
#define EACCES      13  /* Permission denied */
#define EBUSY       16  /* Device or resource busy */
#define ENODATA     61  /* No data available */
#define ECANCELED   125 /* Operation Canceled */

Any comments?

Antti Palosaari (3):
  dvb_frontend: use Kernel dev_* logging
  dvb_frontend: return -ENOTTY for unimplement IOCTL
  dvb_frontend: do not allow statistic IOCTLs when sleeping

 drivers/media/dvb/dvb-core/dvb_frontend.c | 266 ++++++++++++++++--------------
 1 file changed, 144 insertions(+), 122 deletions(-)

-- 
1.7.11.2

