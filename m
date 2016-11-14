Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49667 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbcKNNb3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 08:31:29 -0500
Date: Mon, 14 Nov 2016 16:30:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org
Subject: Re: [bug report] [media] dib0700_core: don't use stack on I2C reads
Message-ID: <20161114133039.GK28558@mwanda>
References: <20161114132142.GA15220@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161114132142.GA15220@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Same for the legacy functions as well.

drivers/media/usb/dvb-usb/dib0700_core.c:338 dib0700_i2c_xfer_legacy() warn: inconsistent returns 'mutex:&d->i2c_mutex'.
  Locked on:   line 301
               line 322
  Unlocked on: line 287
               line 291
               line 338
drivers/media/usb/dvb-usb/dib0700_core.c:338 dib0700_i2c_xfer_legacy() warn: inconsistent returns 'mutex:&d->usb_mutex'.
  Locked on:   line 301
               line 322
  Unlocked on: line 287
               line 291
               line 338

regards,
dan carpenter

