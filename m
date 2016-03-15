Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35907 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbcCOHWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 03:22:19 -0400
Received: by mail-ig0-f178.google.com with SMTP id nk17so59006383igb.1
        for <linux-media@vger.kernel.org>; Tue, 15 Mar 2016 00:22:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56E7B72B.802@xs4all.nl>
References: <CAJ2oMhJpGaQwhbTB6x+KmtGBV0cG8ykZWNL6KAotDyH40Krwow@mail.gmail.com>
	<56E7B72B.802@xs4all.nl>
Date: Tue, 15 Mar 2016 09:22:18 +0200
Message-ID: <CAJ2oMh+8Ogmn-mM-kv8HOTPcqA=ggtBhROfDubtjE-ury5tOXw@mail.gmail.com>
Subject: Re: gstreamer and v4l2
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 15, 2016 at 9:18 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 03/15/2016 08:10 AM, Ran Shalit wrote:
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
>> So I tried to run as following:
>>
>> gst-launch-0.10 v4l2src device="/dev/video0" !
>> video/x-raw,width=640,height=180,framerate=30 ! autovideosink
>>
>> But it keeps giving me auto negotiation error -4.
>> Trying to give other values did not help neither.
>>
>> It is probaby more a gstreamer issue, but if someone is familiar and
>> can shed some light on this will will help.
>
> Actually, I suspect that vivi is the culprit. It had some non-standard
> behavior that might mess up gstreamer. One of the (many) reasons it was
> replaced with vivid.
>
> Regards,
>
>         Hans

Hi Hans,

Thanks for the quick response.
Well... a minue after posting...
I made another try and just added videoconvert  (or ffmpegcolorspace)
before  autovideosink, and now it works just fine !
probably the unique size (640x180) from vivi is not supported in
autovideosink, without conversion in between.

So this how it works in my case , if it helps anyone with similar issue:

 gst-launch-0.10 v4l2src device="/dev/video0" !
video/x-raw,width=640,height=180,framerate=30 ! ffmpegcolorspace !
autovideosink

Thank you very much,
Ran
