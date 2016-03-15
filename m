Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:43181 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbcCOLFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 07:05:22 -0400
Subject: Re: gstreamer and v4l2
To: Antonio Ospite <ao2@ao2.it>, Ran Shalit <ranshalit@gmail.com>
References: <CAJ2oMhJpGaQwhbTB6x+KmtGBV0cG8ykZWNL6KAotDyH40Krwow@mail.gmail.com>
 <20160315112808.8ad0c7dfb8eec41a873ec8e2@ao2.it>
CC: <linux-media@vger.kernel.org>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <56E7EC6E.1070102@mentor.com>
Date: Tue, 15 Mar 2016 13:05:18 +0200
MIME-Version: 1.0
In-Reply-To: <20160315112808.8ad0c7dfb8eec41a873ec8e2@ao2.it>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15.03.2016 12:28, Antonio Ospite wrote:
> On Tue, 15 Mar 2016 09:10:59 +0200
> Ran Shalit <ranshalit@gmail.com> wrote:
> 
>> Hello,
>>
>> This is a bit offtopic, so I will understand if you rather not discuss that...
>>
>> I am trying to use gstreamer with v4l2 vivi device,
>> I first check the capabilities with
>>
>> gst-launch-1.0 --gst-debug=v4l2src:5 v4l2src device="/dev/video0" !
>> fakesink 2>&1
>>
>> and it gives many capabilities such as the following:
>>
>> video/x-raw-yuv, format=(string)YUY2, framerate=(fraction)[1/1000,
>> 1000/1], width=(int) 640, height=(int)180, interlaced=(boolean)true
>>
> 
> A cleaner way to enumerate capabilities of a video device in GStreamer
> is like that:
> 
>   gst-device-monitor-1.0 Video
> 
> on Debian distributions gst-device-monitor-1.0 is in the
> gstreamer1.0-plugins-base-apps package.

No, you add some redundant GStreamer app instead of using just
GStreamer framework internals, this is not a cleaner way.

>> So I tried to run as following:
>>
>> gst-launch-0.10 v4l2src device="/dev/video0" !
>> video/x-raw,width=640,height=180,framerate=30 ! autovideosink

According to the received caps use

* video/x-raw-yuv
* framerate=30/1
* and start from fakesink

>>
>> But it keeps giving me auto negotiation error -4.
>> Trying to give other values did not help neither.
> 
> BTW, the need for videoconvert is more likely because of the pixelformat
> rather than the frame dimensions.
> 

--
With best wishes,
Vladimir

