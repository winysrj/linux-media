Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:44340 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754719AbeALKGI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 05:06:08 -0500
Date: Fri, 12 Jan 2018 11:06:06 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Florian Boor <florian.boor@kernelconcepts.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: MT9M131 on I.MX6DL CSI color issue
Message-ID: <20180112110606.47499410@crub>
In-Reply-To: <20180112105840.75260abb@crub>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
        <20180112105840.75260abb@crub>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 12 Jan 2018 10:58:40 +0100
Anatolij Gustschin agust@denx.de wrote:
...
> gst-launch v4l2src device=/dev/video4 num-buffers=1 ! \
>            videoparse format=5 width=1280 height=1024 framerate=25/1 ! \
>            jpegenc ! filesink location=capture1.jpeg

I forgot the videoconvert, sorry. Try

  gst-launch v4l2src device=/dev/video4 num-buffers=1 ! \
             filesink location=frame.raw

  gst-launch filesrc num-buffers=1 location=frame.raw ! \
             videoparse format=5 width=1280 height=1024 framerate=25/1 ! \
             videoconvert ! jpegenc ! filesink location=capture1.jpeg

Anatolij
