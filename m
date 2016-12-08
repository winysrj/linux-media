Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37772
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753896AbcLHXQP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 18:16:15 -0500
Date: Thu, 8 Dec 2016 21:16:07 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] [media] tvp5150: don't touch register
 TVP5150_CONF_SHARED_PIN if not needed
Message-ID: <20161208211607.6871d504@vento.lan>
In-Reply-To: <1726705.V5pZ2YOHyk@avalon>
References: <1358e218a098d1633d758ed63934d84da7619bd9.1481226269.git.mchehab@s-opensource.com>
        <1726705.V5pZ2YOHyk@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 09 Dec 2016 00:33:22 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> I've just sent a series of patches ("[PATCH 0/6] Fix tvp5150 regression with 
> em28xx") that should fix this problem properly. I unfortunately haven't been 
> able to test it with an em28xx device as I don't own any.

I'll try to test it tomorrow, with interlaced video. I guess I can
test also VBI, but I need to double-check. I'm currently missing some
way to test progressive video, though.

Thanks,
Mauro
