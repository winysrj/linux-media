Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36089 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaGQK7z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 06:59:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	m.chehab@samsung.com, nicolas.ferre@atmel.com,
	linux-arm-kernel@lists.infradead.org, grant.likely@linaro.org,
	galak@codeaurora.org, rob@landley.net, mark.rutland@arm.com,
	robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
	pawel.moll@arm.com, devicetree@vger.kernel.org,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH v2 3/3] [media] atmel-isi: add primary DT support
Date: Thu, 17 Jul 2014 13:00 +0200
Message-ID: <2360323.ktzTJnrmOX@avalon>
In-Reply-To: <53392FC9.9070706@atmel.com>
References: <1395744087-5753-1-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1403302313290.12008@axis700.grange> <53392FC9.9070706@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

What's the status of this patch set ? Do you plan to rebase and resubmit it ?

On Monday 31 March 2014 17:05:13 Josh Wu wrote:
> Dear Guennadi
> 
> On 3/31/2014 5:20 AM, Guennadi Liakhovetski wrote:
> > Hi Josh,
> > 
> > Please correct me if I'm wrong, but I don't see how this is going to work
> > without the central part - building asynchronous V4L2 data structures from
> > the DT, something that your earlier patch
> 
> Here you mean Bryan Wu not me, right?   ;-)
> Bryan write the patch "[v2] media: soc-camera: OF cameras" in:
> https://patchwork.linuxtv.org/patch/22288/.
> And I saw Ben Dooks already sent out his patch to support soc-camera OF
> now (https://patchwork.linuxtv.org/patch/23304/) which is simpler than
> Bryan's.
> 
> > "media: soc-camera: OF cameras"
> > was doing, but which you stopped developing after a discussion with Ben
> > (added to Cc).
> 
> And yes, atmel-isi dt patch should not work without above SoC-Camera of
> support patch.
> But as the atmel-isi dt binding document and port node can be finalized.
> So I think this patch is ready for the mainline.
> 
> BTW: I will test Ben's patch with atmel-isi.

-- 
Regards,

Laurent Pinchart

