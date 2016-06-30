Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp02asnl.sandia.gov ([198.102.153.117]:41273 "EHLO
	smtp02asnl.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbcF3Mn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 08:43:28 -0400
From: "Greci, Matthew J" <mjgreci@sandia.gov>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: Caspa Driver mt9v032
Date: Thu, 30 Jun 2016 12:38:08 +0000
Message-ID: <1467290288890.97547@sandia.gov>
References: <1467209880585.21400@sandia.gov>,<1700455.NvClNHWQva@avalon>
In-Reply-To: <1700455.NvClNHWQva@avalon>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Could you give me an idea of what you mean in terms of C or from the Linux userspace?

Thank you,
Matthew Greci
505-280-1921

________________________________________
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Sent: Wednesday, June 29, 2016 5:23 PM
To: Greci, Matthew J
Subject: [EXTERNAL] Re: Caspa Driver mt9v032

Hi Matthew,

On Wednesday 29 Jun 2016 14:18:00 Greci, Matthew J wrote:
> Hello,
>
> I am running Poky Yocto on a Gumstix Overo board and I loaded the driver for
> the Gumstix Caspa board which is called 'mt9v023'. Running 'modinfo
> mt9v032' shows you are the author of mt9v032.ko.
>
> I was looking for a way to modify the driver source code to fix a yellow
> tint/hue from appearing in all the images. I have tied to make adjusts via
> ioctl() but it seems to V4L2 capabilities are possible.
>
> Please let me know if you are still working on this or not and if you can
> help or can direct me to someone that can help.

I'm not actively working on the mt9v032 driver anymore, but I can still try to
help you. I would recommend CC'ing the linux-media@vger.kernel.org mailing
list when requesting help from the community, as other developers subscribed
to that list might be able to assist you as well.

The MT9V032 sensor doesn't seem to have per-component gains, so I'm not sure
you would be able to fix the problem through the sensor driver. You could
however use the image processing feature of the OMAP3 ISP, and in particular
of the preview engine, to set per-channel gains or perform other processing
that could fix the problem.

--
Regards,

Laurent Pinchart

