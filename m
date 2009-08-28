Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:56171 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZH1VEp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 17:04:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dotan Cohen <dotancohen@gmail.com>
Subject: Re: Using MSI StarCam 370i Webcam with Kubuntu Linux
Date: Fri, 28 Aug 2009 23:07:10 +0200
Cc: linux-media@vger.kernel.org
References: <880dece00908281140r16385c1fr476b18f2fcfe3c1b@mail.gmail.com>
In-Reply-To: <880dece00908281140r16385c1fr476b18f2fcfe3c1b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908282307.10120.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 28 August 2009 20:40:38 Dotan Cohen wrote:
> I have the MSI StarCam 370i Webcam and I have trying to use it with
> Kubuntu Linux 9.04 Jaunty. According to this page, "The StarCam 370i
> is compliant with UVC, USB video class":
> http://gadgets.softpedia.com/gadgets/Computer-Peripherals/The-MSI-StarCam-3
>70i-3105.html

[snip]

> jaunty2@laptop:~$ dmesg | tail
> [ 2777.811972] sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers
> v1:1.47pre49
> [ 2777.814989] usb 2-1: SN9C105 PC Camera Controller detected (vid:pid
> 0x0C45:0x60FC)

There might be different StarCam 370i models out there. Yours is definitely 
not UVC compliant.

-- 
Regards,

Laurent Pinchart
