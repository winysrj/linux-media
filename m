Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:43941 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933761AbeALO7h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 09:59:37 -0500
Received: by mail-qt0-f175.google.com with SMTP id s3so6310717qtb.10
        for <linux-media@vger.kernel.org>; Fri, 12 Jan 2018 06:59:37 -0800 (PST)
Message-ID: <1515769174.3084.27.camel@ndufresne.ca>
Subject: Re: MT9M131 on I.MX6DL CSI color issue
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Anatolij Gustschin <agust@denx.de>,
        Florian Boor <florian.boor@kernelconcepts.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Fri, 12 Jan 2018 09:59:34 -0500
In-Reply-To: <20180112105840.75260abb@crub>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
         <20180112105840.75260abb@crub>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le vendredi 12 janvier 2018 à 10:58 +0100, Anatolij Gustschin a écrit :
> On Fri, 12 Jan 2018 01:16:03 +0100
> Florian Boor florian.boor@kernelconcepts.de wrote:
> ...
> > Basically it works pretty well apart from the really strange
> > colors. I guess its
> > some YUV vs. RGB issue or similar. Here [1] is an example generated
> > with the
> > following command.
> > 
> > gst-launch v4l2src device=/dev/video4 num-buffers=1 ! jpegenc !
> > filesink
> > location=capture1.jpeg
> > 
> > Apart from the colors everything is fine.
> > I'm pretty sure I have not seen such an effect before - what might
> > be wrong here?
> 
> You need conversion to RGB before JPEG encoding. Try with
> 
>  gst-launch v4l2src device=/dev/video4 num-buffers=1 ! \
>             videoparse format=5 width=1280 height=1024 framerate=25/1
> ! \
>             jpegenc ! filesink location=capture1.jpeg
> 
> For "format" codes see gst-inspect-1.0 videoparse.

A properly written driver should never permit this.

Nicolas
