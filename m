Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:37946 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754605AbdCGBYk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 20:24:40 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v270JPwC006806
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-media@vger.kernel.org>; Tue, 7 Mar 2017 00:19:25 GMT
Date: Tue, 7 Mar 2017 03:17:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: songjun.wu@microchip.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] [media] atmel-isc: add the isc pipeline function
Message-ID: <20170307001729.GA1588@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Songjun Wu,

The patch 93d4a26c3dab: "[media] atmel-isc: add the isc pipeline
function" from Jan 24, 2017, leads to the following static checker
warning:

	drivers/media/platform/atmel/atmel-isc.c:1494 isc_formats_init()
	error: we previously assumed 'fmt' could be null (see line 1480)

drivers/media/platform/atmel/atmel-isc.c
  1459  static int isc_formats_init(struct isc_device *isc)
  1460  {
  1461          struct isc_format *fmt;
  1462          struct v4l2_subdev *subdev = isc->current_subdev->sd;
  1463          unsigned int num_fmts, i, j;
  1464          struct v4l2_subdev_mbus_code_enum mbus_code = {
  1465                  .which = V4L2_SUBDEV_FORMAT_ACTIVE,
  1466          };
  1467  
  1468          fmt = &isc_formats[0];
  1469          for (i = 0; i < ARRAY_SIZE(isc_formats); i++) {
  1470                  fmt->isc_support = false;
  1471                  fmt->sd_support = false;
  1472  
  1473                  fmt++;
  1474          }
  1475  
  1476          while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
  1477                 NULL, &mbus_code)) {
  1478                  mbus_code.index++;
  1479                  fmt = find_format_by_code(mbus_code.code, &i);
  1480                  if (!fmt)
                             ^^^
Check for NULL.

  1481                          continue;
  1482  
  1483                  fmt->sd_support = true;
  1484  
  1485                  if (i <= RAW_FMT_IND_END) {
  1486                          for (j = ISC_FMT_IND_START; j <= ISC_FMT_IND_END; j++)
  1487                                  isc_formats[j].isc_support = true;
  1488  
  1489                          isc->raw_fmt = fmt;
  1490                  }
  1491          }
  1492  

We probably want to set: fmt = &isc_formats[0]; before the start of this
loop.

  1493          for (i = 0, num_fmts = 0; i < ARRAY_SIZE(isc_formats); i++) {
  1494                  if (fmt->isc_support || fmt->sd_support)
                            ^^^^^^^^^^^^^^^^
Unchecked dereference.

  1495                          num_fmts++;
  1496  
  1497                  fmt++;
  1498          }
  1499  
  1500          if (!num_fmts)
  1501                  return -ENXIO;

regards,
dan carpenter
