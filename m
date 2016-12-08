Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46626 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932648AbcLHXRj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 18:17:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] [media] tvp5150: don't touch register TVP5150_CONF_SHARED_PIN if not needed
Date: Fri, 09 Dec 2016 01:18:04 +0200
Message-ID: <2666862.R2ElIJTlOr@avalon>
In-Reply-To: <20161208211607.6871d504@vento.lan>
References: <1358e218a098d1633d758ed63934d84da7619bd9.1481226269.git.mchehab@s-opensource.com> <1726705.V5pZ2YOHyk@avalon> <20161208211607.6871d504@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 08 Dec 2016 21:16:07 Mauro Carvalho Chehab wrote:
> Em Fri, 09 Dec 2016 00:33:22 +0200 Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > I've just sent a series of patches ("[PATCH 0/6] Fix tvp5150 regression
> > with em28xx") that should fix this problem properly. I unfortunately
> > haven't been able to test it with an em28xx device as I don't own any.
> 
> I'll try to test it tomorrow, with interlaced video. I guess I can
> test also VBI, but I need to double-check. I'm currently missing some
> way to test progressive video, though.

Thank you. I dug up an em28xx device I got years ago (had nearly forgotten 
about it) but it doesn't have a tvp5150, so I confirm I can't test this 
myself.

-- 
Regards,

Laurent Pinchart

