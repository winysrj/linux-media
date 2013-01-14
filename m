Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fuel7.com ([74.222.0.51]:34050 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202Ab3ANWVd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 17:21:33 -0500
Message-ID: <50F484E9.9060103@fuel7.com>
Date: Mon, 14 Jan 2013 14:21:29 -0800
From: William Swanson <william.swanson@fuel7.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Ken Petit <ken@fuel7.com>, sakari.ailus@iki.fi
Subject: Re: [PATCH] omap3isp: Add support for interlaced input data
References: <1355796739-2580-1-git-send-email-william.swanson@fuel7.com> <1489481.HbZGQ48duQ@avalon> <50ECA285.2000909@fuel7.com> <2574136.Nmpnc7I1z4@avalon>
In-Reply-To: <2574136.Nmpnc7I1z4@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/09/2013 02:35 PM, Laurent Pinchart wrote:
> On Tuesday 08 January 2013 14:49:41 William Swanson wrote:
>> I believe the data is combined in a single buffer, with alternate fields
>> interleaved.
>
> Could you please double-check that ? I'd like to be sure, not just believe :-)

Sorry for the delay in getting back to you. I have checked it, and the 
fields are indeed interlaced into a single buffer. On the other hand, 
looking at this caused me to discover another problem with the patch.

According to the TI documentation, the CCDC_SDOFST register controls the 
deinterlacing process. My patch never configures this register, however, 
which is surprising. The reason things work on our boards is because we 
are carrying a separate patch which changes the register by accident. 
Oops! I have fixed this, and will be sending another patch with the 
CCDC_SDOFST changes.

> In that case the OMAP3 ISP driver should set the v4l2_pix_format::field to
> V4L2_FIELD_INTERLACED in the format-related ioctl when an interlaced format is
> used. I suppose this could be added later - Sakari, any opinion ?

I don't have a lot of time to work on this stuff, so my main focus is 
just getting the data to flow. Changing the output format information 
involves other parts of the driver that I am not familiar with, so I 
don't know if I will be able to work on that bit.

By the way, thanks for taking the time to review this, Laurent.

-William
