Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36437 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753755AbdC3Jd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 05:33:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Oliver Neukum <oneukum@suse.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        David Mosberger <davidm@egauge.net>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-rpi-kernel@lists.infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        John Youn <johnyoun@synopsys.com>,
        Roger Quadros <rogerq@ti.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 22/22] usb: document that URB transfer_buffer should be aligned
Date: Thu, 30 Mar 2017 12:34:32 +0300
Message-ID: <3181783.rVmBcEVlbi@avalon>
In-Reply-To: <1490861491.8660.2.camel@suse.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com> <1822963.cezI9HmAB6@avalon> <1490861491.8660.2.camel@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

On Thursday 30 Mar 2017 10:11:31 Oliver Neukum wrote:
> Am Donnerstag, den 30.03.2017, 01:15 +0300 schrieb Laurent Pinchart:
> > > +   may also override PAD bytes at the end of the ``transfer_buffer``,
> > > up to the
> > > +   size of the CPU word.
> > 
> > "May" is quite weak here. If some host controller drivers require buffers
> > to be aligned, then it's an API requirement, and all buffers must be
> > aligned. I'm not even sure I would mention that some host drivers require
> > it, I think we should just state that the API requires buffers to be
> > aligned.
> 
> That effectively changes the API. Many network drivers are written with
> the assumption that any contiguous buffer is valid. In fact you could
> argue that those drivers are buggy and must use bounce buffers in those
> cases.
> 
> So we need to include the full story here.

I personally don't care much about whose side is responsible for handling the 
alignment constraints, but I want it to be documented before "fixing" any USB 
driver.

-- 
Regards,

Laurent Pinchart
