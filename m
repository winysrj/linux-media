Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:56377 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752118AbdASMTl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jan 2017 07:19:41 -0500
Date: Thu, 19 Jan 2017 14:19:35 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] [media] coda: add Freescale firmware compatibility
 location
Message-ID: <20170119121935.a5jgtquv4uivqam2@tarshish>
References: <9828a30b479e1d96698402a38db2fb63e73374f0.1484476433.git.baruch@tkos.co.il>
 <1484739029.2356.7.camel@pengutronix.de>
 <20170118193309.vuqr72jklvaxttoy@tarshish>
 <1484819094.2989.5.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484819094.2989.5.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

(Adding firmware loader maintainers to Cc).

On Thu, Jan 19, 2017 at 10:44:54AM +0100, Philipp Zabel wrote:
> On Wed, 2017-01-18 at 21:33 +0200, Baruch Siach wrote:
> > > -	if (dev->firmware == 1) {
> > > +	if (dev->firmware > 0) {
> > 
> > Why would vpu/vpu_fw_*.bin and v4l-coda960-*.bin be considered fallback 
> > firmware?
> 
> That was meant in the sense of a firmware loaded from fallback location.
> 
> See the comment below, I needed a string to tell the user that the
> preceding firmware not found error messages can be safely ignored. If
> you have an idea for better wording, feel free submit a change.
> 
> > >  		/*                                                                                                                            
> > >  		 * Since we can't suppress warnings for failed asynchronous
> > >  		 * firmware requests, report that the fallback firmware was
> > >  		 * found.
> > >  		 */
> > >  		dev_info(&pdev->dev, "Using fallback firmware %s\n",
> > >  			 dev->devtype->firmware[dev->firmware]);
> > >  	}

For the context, we are talking about these boot time messages:

[    2.152822] coda 2040000.vpu: Direct firmware load for vpu_fw_imx6q.bin failed with error -2
[    2.162669] coda 2040000.vpu: Using fallback firmware vpu/vpu_fw_imx6q.bin

Looks bad. There must be a better way to load a firmware file from a few 
optional locations. Actually, this use of the 'cont' parameter of 
request_firmware_nowait() to retry firmware load does not look like the 
intended use for the callback.

How about extending the firmware loader to accept multiple possible firmware 
locations?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
