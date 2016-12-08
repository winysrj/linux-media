Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36396
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752126AbcLHSuG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 13:50:06 -0500
Date: Thu, 8 Dec 2016 16:49:57 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] tvp5150: don't touch register TVP5150_CONF_SHARED_PIN
 if not needed
Message-ID: <20161208164957.489a79f2@vento.lan>
In-Reply-To: <CAGoCfiz3MNnt=8zZ5jHMQzZOyfNW_biSNU2iju4wROxQ4X=NBQ@mail.gmail.com>
References: <b47a9d956d740d63334bf0f07e6cfddd7f60e98b.1481204310.git.mchehab@s-opensource.com>
        <3555863.PStTa0BX6X@avalon>
        <20161208121608.1a95d3b6@vento.lan>
        <3810287.F7IvM3IBCA@avalon>
        <CAGoCfiz3MNnt=8zZ5jHMQzZOyfNW_biSNU2iju4wROxQ4X=NBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

Em Thu, 8 Dec 2016 12:50:19 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

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

Thanks for testing! Just tested here with S-Video, with WinTV USB2
(with interlaced video, generated with vivid + HVR-350).

I was able to reproduce the same issue as you: changing register 0x0d
to 0x47 indeed made it work.

I'm working on a followup patch.

Thanks,
Mauro
