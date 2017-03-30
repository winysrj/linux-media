Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56427 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933451AbdC3IMg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 04:12:36 -0400
Message-ID: <1490861491.8660.2.camel@suse.com>
Subject: Re: [PATCH 22/22] usb: document that URB transfer_buffer should be
 aligned
From: Oliver Neukum <oneukum@suse.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: David Mosberger <davidm@egauge.net>,
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
Date: Thu, 30 Mar 2017 10:11:31 +0200
In-Reply-To: <1822963.cezI9HmAB6@avalon>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
         <ee3ea6944e095fa3b2383697a967f4bc9e2d9631.1490813422.git.mchehab@s-opensource.com>
         <1822963.cezI9HmAB6@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 30.03.2017, 01:15 +0300 schrieb Laurent Pinchart:
> > +   may also override PAD bytes at the end of the ``transfer_buffer``, up to
> > the
> > +   size of the CPU word.
> 
> "May" is quite weak here. If some host controller drivers require buffers to 
> be aligned, then it's an API requirement, and all buffers must be aligned. I'm 
> not even sure I would mention that some host drivers require it, I think we 
> should just state that the API requires buffers to be aligned.

That effectively changes the API. Many network drivers are written with
the assumption that any contiguous buffer is valid. In fact you could
argue that those drivers are buggy and must use bounce buffers in those
cases.

So we need to include the full story here.

	Regards
		Oliver
