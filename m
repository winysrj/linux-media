Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:34673 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440AbcCOK2N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 06:28:13 -0400
Date: Tue, 15 Mar 2016 11:28:08 +0100
From: Antonio Ospite <ao2@ao2.it>
To: Ran Shalit <ranshalit@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: gstreamer and v4l2
Message-Id: <20160315112808.8ad0c7dfb8eec41a873ec8e2@ao2.it>
In-Reply-To: <CAJ2oMhJpGaQwhbTB6x+KmtGBV0cG8ykZWNL6KAotDyH40Krwow@mail.gmail.com>
References: <CAJ2oMhJpGaQwhbTB6x+KmtGBV0cG8ykZWNL6KAotDyH40Krwow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 15 Mar 2016 09:10:59 +0200
Ran Shalit <ranshalit@gmail.com> wrote:

> Hello,
> 
> This is a bit offtopic, so I will understand if you rather not discuss that...
> 
> I am trying to use gstreamer with v4l2 vivi device,
> I first check the capabilities with
> 
> gst-launch-1.0 --gst-debug=v4l2src:5 v4l2src device="/dev/video0" !
> fakesink 2>&1
> 
> and it gives many capabilities such as the following:
> 
> video/x-raw-yuv, format=(string)YUY2, framerate=(fraction)[1/1000,
> 1000/1], width=(int) 640, height=(int)180, interlaced=(boolean)true
>

A cleaner way to enumerate capabilities of a video device in GStreamer
is like that:

  gst-device-monitor-1.0 Video

on Debian distributions gst-device-monitor-1.0 is in the
gstreamer1.0-plugins-base-apps package.

> So I tried to run as following:
> 
> gst-launch-0.10 v4l2src device="/dev/video0" !
> video/x-raw,width=640,height=180,framerate=30 ! autovideosink
> 
> But it keeps giving me auto negotiation error -4.
> Trying to give other values did not help neither.

BTW, the need for videoconvert is more likely because of the pixelformat
rather than the frame dimensions.

Ciao ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
