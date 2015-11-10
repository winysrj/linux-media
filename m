Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46010 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbKJIww (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2015 03:52:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 04/19] v4l: omap3isp: fix handling platform_get_irq result
Date: Tue, 10 Nov 2015 10:53:01 +0200
Message-ID: <5162378.EBHhLPCzkm@avalon>
In-Reply-To: <56419356.5010603@samsung.com>
References: <1443103227-25612-1-git-send-email-a.hajda@samsung.com> <5373820.hJbPzosF9i@avalon> <56419356.5010603@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On Tuesday 10 November 2015 07:48:54 Andrzej Hajda wrote:
> On 11/09/2015 09:16 PM, Laurent Pinchart wrote:
> > On Thursday 24 September 2015 16:00:12 Andrzej Hajda wrote:
> >> The function can return negative value.
> >> 
> >> The problem has been detected using proposed semantic patch
> >> scripts/coccinelle/tests/assign_signed_to_unsigned.cocci [1].
> >> 
> >> [1]: http://permalink.gmane.org/gmane.linux.kernel/2046107
> >> 
> >> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >> ---
> >> Hi,
> >> 
> >> To avoid problems with too many mail recipients I have sent whole
> >> patchset only to LKML. Anyway patches have no dependencies.
> >> 
> >>  drivers/media/platform/omap3isp/isp.c | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/media/platform/omap3isp/isp.c
> >> b/drivers/media/platform/omap3isp/isp.c index 56e683b..df9d2c2 100644
> >> --- a/drivers/media/platform/omap3isp/isp.c
> >> +++ b/drivers/media/platform/omap3isp/isp.c
> >> @@ -2442,12 +2442,13 @@ static int isp_probe(struct platform_device
> >> *pdev)
> >>  	}
> >>  	
> >>  	/* Interrupt */
> >> -	isp->irq_num = platform_get_irq(pdev, 0);
> >> -	if (isp->irq_num <= 0) {
> >> +	ret = platform_get_irq(pdev, 0);
> >> +	if (ret <= 0) {
> > 
> > Looking at platform_get_irq() all error values are negative. You could
> > just test for ret < 0 here, and remove the ret = -ENODEV assignment below
> > to keep the error code returned by platform_get_irq().
> > 
> > If you're fine with that modification there's no need to resubmit, just
> > let me know and I'll fix it when applying it to my tree.
> 
> I left it as before, as it was not related to the patch. Additionally I have
> lurked little bit inside platform_get_irq and it looks little bit scary to
> me: platform_get_irq returns value of of_irq_get if ret >= 0,
> of_irq_get calls of_irq_parse_one which can return 0,
> in such case irq_create_of_mapping value is returned which is unsigned int
> and evaluates to 0 in case of failures.
> I am not sure if above scenario can ever occur, but the code looks so messy
> to me, that I gave up :)
> 
> Anyway if you are sure about your change I am OK with it also :)

You're right, that's indeed an issue. It looks like a 0 irq is valid or 
invalid depending on who you ask. NO_IRQ is defined differently depending on 
the architecture :-/ I'll thus keep your version of the patch.

Nonetheless, the core issue should be fixed. Do you feel adventurous ? :-)

> >>  		dev_err(isp->dev, "No IRQ resource\n");
> >>  		ret = -ENODEV;
> >>  		goto error_iommu;
> >>  	
> >>  	}
> >> 
> >> +	isp->irq_num = ret;
> >> 
> >>  	if (devm_request_irq(isp->dev, isp->irq_num, isp_isr, IRQF_SHARED,
> >>  	
> >>  			     "OMAP3 ISP", isp)) {

-- 
Regards,

Laurent Pinchart

