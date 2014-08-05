Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34718 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbaHEWTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 18:19:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: alaganraj sandhanam <alaganraj.sandhanam@gmail.com>
Cc: linux-media@vger.kernel.org, sre@debian.org, sakari.ailus@iki.fi
Subject: Re: omap3isp device tree support
Date: Wed, 06 Aug 2014 00:19:45 +0200
Message-ID: <7469714.hULjr0WVDI@avalon>
In-Reply-To: <CALFbYK1kEnB2_3VqpLFNtaJ7hj9UHuhrL0iO_rFHD2VFt8THFw@mail.gmail.com>
References: <CALFbYK1kEnB2_3VqpLFNtaJ7hj9UHuhrL0iO_rFHD2VFt8THFw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alagan,

On Wednesday 06 August 2014 03:36:19 alaganraj sandhanam wrote:
> Hi Laurent,
> 
> I want to test mt9p031 with beagleboard-xm on 3.16 kernel.
> It seems device tree support for omap3isp is not upstreamed.
> can you please guide me to validate the same?

DT bindings for the OMAP3 ISP are unfortunately not available yet. Sakari is 
working on them, but I don't think he an commit to any date yet.

-- 
Regards,

Laurent Pinchart

