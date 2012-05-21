Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:42226 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab2EUOJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 10:09:13 -0400
Date: Mon, 21 May 2012 17:09:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] v4l/dvb: fix compiler warnings
Message-ID: <20120521140904.GA22885@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans Verkuil,

The patch fdf07b027b2d: "[media] v4l/dvb: fix compiler warnings" from 
Apr 20, 2012, leads to the following GCC warning:
	warning: value computed is not used [-Wunused-value]

The point of the patch was to get rid of a "set but not used" warning
which is turned off by default because there are too many of them and
they are mostly useless.  And instead we got this warning which is
turned on by default and usually indicates a nasty bug...

Grrr...  :P

regards,
dan carpenter

