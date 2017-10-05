Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:48503 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdJEOKu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Oct 2017 10:10:50 -0400
Received: by mail-qk0-f174.google.com with SMTP id d67so11410152qkg.5
        for <linux-media@vger.kernel.org>; Thu, 05 Oct 2017 07:10:50 -0700 (PDT)
Message-ID: <1507212647.27175.25.camel@ndufresne.ca>
Subject: Re: platform: coda: how to use firmware-imx binary releases? / how
 to use VDOA on imx6?
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Martin Kepplinger <martink@posteo.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Thu, 05 Oct 2017 10:10:47 -0400
In-Reply-To: <e0335e29f79b719c6f315473b3db74ad@posteo.de>
References: <ef7cc5b91829f383842a1e4692af5b07@posteo.de>
         <1507108964.11691.6.camel@pengutronix.de>
         <7dd05afd338e81d293d0424e0b8e6b6a@posteo.de>
         <1507191578.8473.1.camel@pengutronix.de>
         <e0335e29f79b719c6f315473b3db74ad@posteo.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 05 octobre 2017 à 13:54 +0200, Martin Kepplinger a écrit :
> > This message is most likely just a result of the VDOA not supporting 
> > the
> > selected capture format. In vdoa_context_configure, you can see that 
> > the
> > VDOA only writes YUYV or NV12.
> 
> ok. I'll have to look into it, and just in case you see a problem on 
> first sight:
> this is what coda says with debug level 1, when doing
> 
> gst-launch-1.0 playbin uri=file:///data/test2_hd480.h264 
> video-sink=fbdevsink

A bit unrelated, but kmssink remains a better choice here.

Nicolas
