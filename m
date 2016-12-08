Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46012 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753220AbcLHSmk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 13:42:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] tvp5150: don't touch register TVP5150_CONF_SHARED_PIN if not needed
Date: Thu, 08 Dec 2016 20:43:04 +0200
Message-ID: <1854628.bcpkFtDWEj@avalon>
In-Reply-To: <CAGoCfiz3MNnt=8zZ5jHMQzZOyfNW_biSNU2iju4wROxQ4X=NBQ@mail.gmail.com>
References: <b47a9d956d740d63334bf0f07e6cfddd7f60e98b.1481204310.git.mchehab@s-opensource.com> <3810287.F7IvM3IBCA@avalon> <CAGoCfiz3MNnt=8zZ5jHMQzZOyfNW_biSNU2iju4wROxQ4X=NBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Thursday 08 Dec 2016 12:50:19 Devin Heitmueller wrote:
> Hi Mauro, Laurent,
> 
> I tried out Mauro's latest patch (9:46am EST), and it appears to at
> least partially address the issue, but still doesn't work.  In fact,
> whereas before I was getting stable video with a chroma issue, with
> the patch applied I'm now getting no video at all (i.e. tvtime is
> completely blocked waiting for frames to arrive).
> 
> First off, a register dump does show that register 0x03 is now 0x6F,
> so at least that part is working.  However, TVP5150_DATA_RATE_SEL,
> (register 0x0D) is now being set to 0x40, whereas it needs to be set
> to 0x47 to work properly.  Just to confirm, I started up tvtime and
> fed the device the following command, at which point video started
> rendering properly:
> 
> sudo v4l2-dbg --chip=subdev0 --set-register=0x0d 0x47
> 
> I'm not sitting in front of the datasheet right now so I cannot
> suggest what the correct fix is, but at first glance it looks like the
> first hunk of Mauro's patch isn't correct for em28xx devices.
> 
> Also worth noting for the moment I'm testing exclusively with
> composite on the HVR-850.  Once we've got that working, I'll dig out
> an s-video cable and make sure that is working too.

Thanks for your offer to test patches. I'm working on a proper fix and should 
be able to finish it tonight.

Feel free to contact me on IRC if you want to discuss the fix live, it could 
be faster than over e-mail.

-- 
Regards,

Laurent Pinchart

