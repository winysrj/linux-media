Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33908 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbcCOHLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 03:11:00 -0400
Received: by mail-ig0-f180.google.com with SMTP id av4so80856482igc.1
        for <linux-media@vger.kernel.org>; Tue, 15 Mar 2016 00:11:00 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 15 Mar 2016 09:10:59 +0200
Message-ID: <CAJ2oMhJpGaQwhbTB6x+KmtGBV0cG8ykZWNL6KAotDyH40Krwow@mail.gmail.com>
Subject: gstreamer and v4l2
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is a bit offtopic, so I will understand if you rather not discuss that...

I am trying to use gstreamer with v4l2 vivi device,
I first check the capabilities with

gst-launch-1.0 --gst-debug=v4l2src:5 v4l2src device="/dev/video0" !
fakesink 2>&1

and it gives many capabilities such as the following:

video/x-raw-yuv, format=(string)YUY2, framerate=(fraction)[1/1000,
1000/1], width=(int) 640, height=(int)180, interlaced=(boolean)true

So I tried to run as following:

gst-launch-0.10 v4l2src device="/dev/video0" !
video/x-raw,width=640,height=180,framerate=30 ! autovideosink

But it keeps giving me auto negotiation error -4.
Trying to give other values did not help neither.

It is probaby more a gstreamer issue, but if someone is familiar and
can shed some light on this will will help.

Linux version is 3.10.0.

Regards,
Ran
