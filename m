Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:46054 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933302AbeFGPaU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 11:30:20 -0400
Received: by mail-qt0-f171.google.com with SMTP id i18-v6so10242785qtp.12
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 08:30:20 -0700 (PDT)
Message-ID: <60598c40ee42167d955dc9f3bab2d79144050a36.camel@ndufresne.ca>
Subject: Re: Bug: media device controller node not removed when uvc device
 is unplugged
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Torleiv Sundre <torleiv@huddly.com>, linux-media@vger.kernel.org
Date: Thu, 07 Jun 2018 11:30:18 -0400
In-Reply-To: <fc69c83d-fbd6-d955-2e07-3960c052cb49@huddly.com>
References: <fc69c83d-fbd6-d955-2e07-3960c052cb49@huddly.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 07 juin 2018 à 14:07 +0200, Torleiv Sundre a écrit :
> Hi,
> 
> Every time I plug in a UVC camera, a media controller node is created at 
> /dev/media<N>.
> 
> In Ubuntu 17.10, running kernel 4.13.0-43, the media controller device 
> node is removed when the UVC camera is unplugged.
> 
> In Ubuntu 18.10, running kernel 4.15.0-22, the media controller device 
> node is not removed. For every time I plug the device, a new device node 
> with incremented minor number is created, leaving me with a growing list 
> of media controller device nodes. If I repeat for long enough, I get the 
> following error:
> "media: could not get a free minor"
> I also tried building a kernel from mainline, with the same result.
> 
> I'm running on x86_64.

I also observe this on 4.17.

> 
> Torleiv Sundre
