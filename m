Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:34710 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755306AbcJ1Tgs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Oct 2016 15:36:48 -0400
Received: by mail-qt0-f170.google.com with SMTP id n6so7306917qtd.1
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2016 12:36:48 -0700 (PDT)
Message-ID: <1477683405.5533.5.camel@gmail.com>
Subject: Re: Still images and v4l2?
From: Nicolas Dufresne <nicolas.dufresne@gmail.com>
Reply-To: nicolas@ndufresne.ca
To: Michael Haardt <michael@moria.de>, linux-media@vger.kernel.org
Date: Fri, 28 Oct 2016 15:36:45 -0400
In-Reply-To: <E1c063j-00071G-Hv@fangorn.moria.de>
References: <E1c063j-00071G-Hv@fangorn.moria.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le vendredi 28 octobre 2016 à 14:14 +0200, Michael Haardt a écrit :
> I am currently developing a new image v4l2 sensor driver to acquire
> sequences of still images and wonder how to interface that to the
> v4l2 API.
> 
> Currently, cameras are assumed to deliver an endless stream of images
> after being triggered internally with VIDIOC_STREAMON.  If supported
> by
> the driver, a certain frame rate is used.
> 
> For precise image capturing, I need two additional features:
> 
> Limiting the number of captured images: It is desirable not having to
> stop
> streaming from user space for camera latency.  A typical application
> are single shots at random times, and possibly with little time in
> between the end of one image and start of a new one, so an image that
> could not be stopped in time would be a problem.  A video camera
> would
> only support the limit value "unlimited" as possible capturing limit.
> Scientific cameras may offer more, or possibly only limited
> capturing.
> 
> Configuring the capture trigger: Right now sensors are implicitly
> triggered internally from the driver.  Being able to configure
> external
> triggers, which many sensors support, is needed to start capturing at
> exactly the right time.  Again, video cameras may only offer
> "internal"
> as trigger type.
> 
> Perhaps v4l2 already offers something that I overlooked.  If not,
> what
> would be good ways to extend it?

In order to support the new Android Camera HAL (and other use cases),
there is work in progress to introduce some new API, they call it the
Request API.

https://lwn.net/Articles/641204/

> 
> Regards,
> 
> Michael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
