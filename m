Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:39291 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2JBIbB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 04:31:01 -0400
Date: Tue, 2 Oct 2012 11:30:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hfvogt@gmx.net
Cc: linux-media@vger.kernel.org
Subject: re: [media] af9035: add Avermedia Volar HD (A867R) support
Message-ID: <20121002083049.GK12398@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans-Frieder Vogt,

The patch 540fd4ba0533: "[media] af9035: add Avermedia Volar HD
(A867R) support" from Apr 2, 2012, leads to the following Clang warning:
	drivers/media/dvb-frontends/af9033.c:467:20: warning: comparison
	of unsigned expression >= 0 is always true
	[-Wtautological-compare]

drivers/media/dvb-frontends/af9033.c
   464                  while (if_frequency > (adc_freq / 2))
                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
if_frequency is unsigned.  I worry that this loop doesn't handle integer
underflow properly.

   465                          if_frequency -= adc_freq;
   466  
   467                  if (if_frequency >= 0)
                            ^^^^^^^^^^^^^^^^^
This is always true.

   468                          spec_inv *= -1;
   469                  else
   470                          if_frequency *= -1;

regards,
dan carpenter

