Return-path: <mchehab@pedra>
Received: from ns2011.yellis.net ([79.170.233.11]:33089 "EHLO
	vds2011.yellis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab1FFQnu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 12:43:50 -0400
Message-ID: <4DED0412.4030708@anevia.com>
Date: Mon, 06 Jun 2011 18:45:06 +0200
From: Florent Audebert <florent.audebert@anevia.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: HVR-1300 analog inputs
References: <4DE65C6D.2060806@anevia.com> <BANLkTi=zUfg9hAN8X9nrPEOMgtUzsKrbOw@mail.gmail.com>
In-Reply-To: <BANLkTi=zUfg9hAN8X9nrPEOMgtUzsKrbOw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/01/2011 05:49 PM, Devin Heitmueller wrote:
> On Wed, Jun 1, 2011 at 11:36 AM, Florent Audebert
> <florent.audebert@anevia.com>  wrote:
>> I'm experimenting around with an Hauppauge HVR-1300 (cx88_blackbird) analog
>> inputs (PAL-I signal).
>>
> You probably won't be able to go any higher than a width of 720.  That
> said, it looks like either the driver is not responding properly or
> the application doesn't realize that the driver returned it's maximum
> field width (the V4L2 API specifies that in the S_FMT call that if the
> calling application specifies an invalid width, the driver can return
> a valid width and the application should recognize and use that
> value).

Thanks for your answer.

I've tried using mplayer as suggested in another post. Resolution is 
alright with both composite and s-video (PAL-I). I suppose something 
went wrong with qv4l2.

Nonetheless, I have vertical lines when using s-video at MPEG device 
output (more visible in white areas)[1].

Reading from capture device is alright whether s-video (input=2) or 
composite (input=1) is selected. I've tested it like this:

   mplayer tv:// -tv driver=v4l2:input=1:normid=4:device=/dev/video0

Note that I am using media_build.git and mplayer trunks.

Any idea why I'm getting those vertical lines with s-video from decoder 
output only ?


Regards,


[1] http://bit.ly/iEm8xd

-- 
Florent Audebert
