Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:60703 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932744AbeALJ6n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 04:58:43 -0500
Date: Fri, 12 Jan 2018 10:58:40 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Florian Boor <florian.boor@kernelconcepts.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: MT9M131 on I.MX6DL CSI color issue
Message-ID: <20180112105840.75260abb@crub>
In-Reply-To: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 12 Jan 2018 01:16:03 +0100
Florian Boor florian.boor@kernelconcepts.de wrote:
...
>Basically it works pretty well apart from the really strange colors. I guess its
>some YUV vs. RGB issue or similar. Here [1] is an example generated with the
>following command.
>
>gst-launch v4l2src device=/dev/video4 num-buffers=1 ! jpegenc ! filesink
>location=capture1.jpeg
>
>Apart from the colors everything is fine.
>I'm pretty sure I have not seen such an effect before - what might be wrong here?

You need conversion to RGB before JPEG encoding. Try with

 gst-launch v4l2src device=/dev/video4 num-buffers=1 ! \
            videoparse format=5 width=1280 height=1024 framerate=25/1 ! \
            jpegenc ! filesink location=capture1.jpeg

For "format" codes see gst-inspect-1.0 videoparse.

HTH,

Anatolij
