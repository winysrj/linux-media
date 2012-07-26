Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60156 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2GZRIC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 13:08:02 -0400
Received: by ghrr11 with SMTP id r11so2216586ghr.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 10:08:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50109483.8030308@seiner.com>
References: <50108A15.8090005@seiner.com>
	<50109483.8030308@seiner.com>
Date: Thu, 26 Jul 2012 13:08:01 -0400
Message-ID: <CAGoCfix6X6k-GOQj2s0-xP8QQuW2YCYTd_ZykxCa=QSH4ZgoGQ@mail.gmail.com>
Subject: Re: cx231xx interlace-like artifacts
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Yan Seiner <yan@seiner.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 25, 2012 at 8:51 PM, Yan Seiner <yan@seiner.com> wrote:
> Yan Seiner wrote:
>>
>> I just recently changed my vidcap to a Hauppage .  Now I get these
>> interlace-like artifacts:
>>
>>
>> http://seiner.com/cz/rtpictures/2012_07_25T14h20m46sZ_0.451651_44.090619_-123.126059.jpg
>>
>> http://seiner.com/cz/rtpictures/2012_07_25T14h22m48sZ_0.224624_44.089669_-123.139100.jpg

The video you are capturing is inherently interlaced.  The Hauppauge
device does raw capture of interlaced video, and takes no
responsibility for deinterlacing.  You need your application to do
such deinterlacing (all the major applications support such:  mplayer,
vlc, tvtime, etc).

>> cxx231x.h has the following line:
>>
>> #define CX231XX_INTERLACED_DEFAULT      1
>>
>> Is there some way to turn off interlacing with a parameter?

This parameter doesn't do what you think.  It's used for cases where
progressive video is being delivered by the camera (or progressive
scan DVD player).  It doesn't cause the device to perform
deinterlacing.

In short, everything you are seeing is expected behavior.  If you want
to deinterlace the video, you need to do this in the application.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
