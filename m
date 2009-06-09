Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:50494 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936AbZFIBtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 21:49:31 -0400
Received: by pzk1 with SMTP id 1so2646018pzk.33
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2009 18:49:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <625E57E0-150D-40A1-AF90-7B0112D16931@flyn.org>
References: <4f363d5e6b409da696b35f7e2a966952.squirrel@mail.voxel.net>
	 <829197380906071921g54469ee7uac77c10d380a7e0a@mail.gmail.com>
	 <625E57E0-150D-40A1-AF90-7B0112D16931@flyn.org>
Date: Mon, 8 Jun 2009 21:49:33 -0400
Message-ID: <829197380906081849x5714c363x77d5cd96d49a82c2@mail.gmail.com>
Subject: Re: funny colors from XC5000 on big endian systems
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "W. Michael Petullo" <mike@flyn.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 8, 2009 at 7:09 PM, W. Michael Petullo<mike@flyn.org> wrote:
>
>>>> You indicated that you had reason to believe it's a PowerPC issue.  Is
>>>> there any reason that you came to that conclusion other than that you're
>>>> running on ppc?  I'm not discounting the possibility, but it would be
>>>> good to know if you have other information that supports your theory.
>>>
>>> It was a hypothesis, but based on experience in "seeing" endian bugs in
>>> video code and "hearing" endian bugs in audio code. After using PowerPC
>>> long enough, you learn to jump to the endian conclusion pretty quickly. I
>>> was wrong!
>>
>> Ok, well that's good to know.  I did look at the code and couldn't see
>> how it could possibly be an endianness bug.
>>
>> Bear in mind that the analog support for the 950q is still relatively
>> new, and its entirely possible there are some application specific
>> bugs to be worked out as there is more testing.
>>
>> Could you please describe in more detail the *exact* configuration you
>> are attempting, including the versions of the applications you are
>> using and command line arguments you are passing.  If I can reproduce
>> the issue here then I can probably debug it much faster.
>
> I have a VCR connected to my 950Q using the coaxial interface.
>
> Kernel is 2.6.29.4.
>
> I am using streamer from Fedora's xawtv-3.95-11.fc11.ppc:
>
> v4lctl setchannel 3
> streamer -r 30 -s 640x480 -f jpeg -i Television -n NTSC-M -c /dev/video0 -o
> ~/Desktop/foo.avi -t 00:60:00
>
> I am using gstreamer-plugins-good-0.10.14-2.fc11.ppc:
>
> gst-launch v4l2src ! ffmpegcolorspace ! ximagesink
>
> Mike
>

Looks like the gst-launch picks I420 colorspace mode by default (and
the 950q expects UYVY).  Try the following and see if your situation
improves:

gst-launch -v v4l2src !
'video/x-raw-yuv,width=720,height=480,format=(fourcc)UYVY' !
ffmpegcolorspace ! ximagesink

I haven't looked yet though to how gst-launch decides to use i420 by
default.  Perhaps the 950q isn't properly advertising it's
capabilities.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
