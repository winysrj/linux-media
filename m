Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61632 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbbJNWLS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2015 18:11:18 -0400
Received: from minime.bse ([77.20.40.102]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0LgptO-1aOJjW1IYw-00oDXo for
 <linux-media@vger.kernel.org>; Thu, 15 Oct 2015 00:11:16 +0200
Date: Thu, 15 Oct 2015 00:11:24 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] rtl28xxu: fix control message flaws
Message-ID: <20151014221124.GA31954@minime.bse>
References: <1444495530-1674-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1444495530-1674-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 10, 2015 at 07:45:30PM +0300, Antti Palosaari wrote:
> Add lock to prevent concurrent access for control message as control
> message function uses shared buffer. Without the lock there may be
> remote control polling which messes the buffer causing IO errors.

This patch fixes the Problems I had with my Astrometa stick's I2C bus
locking up at the end of each dvbv5-scan run until it is disconnected.
There is another source of IO errors in the current driver, though.
The delayed work closing the I2C gate to the tuner is often executed
after rtl2832_power_ctrl has disabled the PLL. This will cause the
USB transfer accessing the gate control register to fail with -EPIPE.

Best regards,

  Daniel
