Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:50459 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751260AbdASJpL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jan 2017 04:45:11 -0500
Message-ID: <1484819094.2989.5.camel@pengutronix.de>
Subject: Re: [PATCH v3] [media] coda: add Freescale firmware compatibility
 location
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-media@vger.kernel.org, Fabio Estevam <festevam@gmail.com>
Date: Thu, 19 Jan 2017 10:44:54 +0100
In-Reply-To: <20170118193309.vuqr72jklvaxttoy@tarshish>
References: <9828a30b479e1d96698402a38db2fb63e73374f0.1484476433.git.baruch@tkos.co.il>
         <1484739029.2356.7.camel@pengutronix.de>
         <20170118193309.vuqr72jklvaxttoy@tarshish>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Baruch,

On Wed, 2017-01-18 at 21:33 +0200, Baruch Siach wrote:
[...]
> > To increase the number of firmware paths, coda_fw_callback has to be
> > modified, too. Otherwise it will just ignore firmware[2]:
> 
> Thanks for catching that. But shouldn't we make the firmware files list a NULL 
> terminated array instead of spreading the array size knowledge all over the 
> code?

Maybe, although the array is not really variable length. Another
possibility would be to save that tiny amount of wasted space and add a
#define MAX_FIRMWARE_PATHS 3

> I have one more question below.
> 
> >  static void coda_fw_callback(const struct firmware *fw, void *context)
> >  {
> >  	struct coda_dev *dev = context;
> >  	struct platform_device *pdev = dev->plat_dev;
> >  	int i, ret;
> > 
> > -	if (!fw && dev->firmware == 1) {
> > +	if (!fw && dev->firmware == 2) {
> >  		v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
> >  		goto put_pm;
> >  	}
> >  	if (!fw) {
> > -		dev->firmware = 1;
> > +		dev->firmware++;
> >  		coda_firmware_request(dev);
> >  		return;
> >  	}
> > -	if (dev->firmware == 1) {
> > +	if (dev->firmware > 0) {
> 
> Why would vpu/vpu_fw_*.bin and v4l-coda960-*.bin be considered fallback 
> firmware?

That was meant in the sense of a firmware loaded from fallback location.

See the comment below, I needed a string to tell the user that the
preceding firmware not found error messages can be safely ignored. If
you have an idea for better wording, feel free submit a change.

> >  		/*                                                                                                                            
> >  		 * Since we can't suppress warnings for failed asynchronous
> >  		 * firmware requests, report that the fallback firmware was
> >  		 * found.
> >  		 */
> >  		dev_info(&pdev->dev, "Using fallback firmware %s\n",
> >  			 dev->devtype->firmware[dev->firmware]);
> >  	}
> 
> Thanks,
> baruch

regards
Philipp

