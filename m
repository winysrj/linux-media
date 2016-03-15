Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:55555 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934095AbcCOHSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 03:18:10 -0400
Subject: Re: gstreamer and v4l2
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
References: <CAJ2oMhJpGaQwhbTB6x+KmtGBV0cG8ykZWNL6KAotDyH40Krwow@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56E7B72B.802@xs4all.nl>
Date: Tue, 15 Mar 2016 08:18:03 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhJpGaQwhbTB6x+KmtGBV0cG8ykZWNL6KAotDyH40Krwow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2016 08:10 AM, Ran Shalit wrote:
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
> So I tried to run as following:
> 
> gst-launch-0.10 v4l2src device="/dev/video0" !
> video/x-raw,width=640,height=180,framerate=30 ! autovideosink
> 
> But it keeps giving me auto negotiation error -4.
> Trying to give other values did not help neither.
> 
> It is probaby more a gstreamer issue, but if someone is familiar and
> can shed some light on this will will help.

Actually, I suspect that vivi is the culprit. It had some non-standard
behavior that might mess up gstreamer. One of the (many) reasons it was
replaced with vivid.

Regards,

	Hans
