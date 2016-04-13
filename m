Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55751 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbcDMWjz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 18:39:55 -0400
Subject: Re: tvp5150 regression after commit 9f924169c035
To: Wolfram Sang <wsa@the-dreams.de>
References: <56B204CB.60602@osg.samsung.com>
 <20160208105417.GD2220@tetsubishi> <56BE57FC.3020407@osg.samsung.com>
 <20160212221352.GY3500@atomide.com> <56BE5C97.9070607@osg.samsung.com>
 <20160212224018.GZ3500@atomide.com> <56BE65F0.8040600@osg.samsung.com>
 <20160212234623.GB3500@atomide.com> <56BE993B.3010804@osg.samsung.com>
 <20160412223254.GK1526@katana>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Message-ID: <570ECAB0.4050107@osg.samsung.com>
Date: Wed, 13 Apr 2016 18:39:44 -0400
MIME-Version: 1.0
In-Reply-To: <20160412223254.GK1526@katana>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Wolfram,

On 04/12/2016 06:32 PM, Wolfram Sang wrote:
> 
>> I'll try to find some time next week to dig deeper on this. Just
>> thought that may be related to the issue you found but it seems
>> that's not the case.
> 
> Any updates on this?
>

Sorry, I've been sick and then busy with other stuff so I didn't have time
to dig deeper on this.
 
> Thanks,
> 
>    Wolfram
> 

I'll write what I found so far in case someone with better knowledge about
the runtime PM API and the OMAP I2C controller driver can have an idea of
what could be causing this.

The problem is that after commit 9f924169c035 ("i2c: always enable RuntimePM
for the adapter device"), i2c_smbus_read_byte_data() fails and returns -110
(ETIMEDOUT) error in the tvp5150 I2C driver.

The call trace is the following:

i2c_device_probe
  tvp5150_probe
    tvp5150_read
      i2c_smbus_read_byte_data
        i2c_smbus_xfer
	  i2c_transfer
	    omap_i2c_xfer
              omap_i2c_xfer_msg

The fail in omap_i2c_xfer_msg() is due the wait_for_completion_timeout()
timeout, so it seems the omap_i2c_isr_thread() is not calling complete()
for the cmd_complete completion when runtime PM is enabled (no idea why).

If I revert commit 9f924169c035 then things works again or if I use the
following patch that basically disables runtime PM for the OMAP adapter
after it has been enabled by the I2C core due commit 9f924169c035: 

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 37a88f0ae179..0b72b21b379d 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1445,6 +1445,8 @@ omap_i2c_probe(struct platform_device *pdev)
 		goto err_unuse_clocks;
 	}
 
+	pm_runtime_disable(&adap->dev);
+
 	dev_info(omap->dev, "bus %d rev%d.%d at %d kHz\n", adap->nr,
 		 major, minor, omap->speed);

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
