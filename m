Return-path: <mchehab@pedra>
Received: from acoma.acyna.com ([72.9.254.68]:52854 "EHLO acoma.acyna.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760012Ab1FAVtJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 17:49:09 -0400
Message-ID: <4DE6B3C6.5020706@hubstar.net>
Date: Wed, 01 Jun 2011 22:48:54 +0100
From: linuxtv <linuxtv@hubstar.net>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Florent Audebert <florent.audebert@anevia.com>,
	linux-media@vger.kernel.org
Subject: Re: HVR-1300 analog inputs
References: <4DE65C6D.2060806@anevia.com> <BANLkTi=zUfg9hAN8X9nrPEOMgtUzsKrbOw@mail.gmail.com>
In-Reply-To: <BANLkTi=zUfg9hAN8X9nrPEOMgtUzsKrbOw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Only FYI,

I am using the HVR-1300 with the build-media.git repo (sorry I forget
the correct name). UK PAL-I capturing fine at full res. Using mtythv and
tested using smplayer on /dev/video0 (or video1). (Full UK PAL res).

I know that won't directly help, but at least you know that is can/does
work at full res.

On 01/06/11 16:49, Devin Heitmueller wrote:
> On Wed, Jun 1, 2011 at 11:36 AM, Florent Audebert
> <florent.audebert@anevia.com> wrote:
>   
>> Hi,
>>
>> I'm experimenting around with an Hauppauge HVR-1300 (cx88_blackbird) analog
>> inputs (PAL-I signal).
>>
>> Using qv4l2 (trunk) and 2.6.36.4, I successfully get a clean image on both
>> composite and s-video inputs with resolutions of 640x480 or less.
>>
>> With any higher resolutions, I have thin horizontal lines at moving
>> positions (seems to cycle)[1].
>>
>> I've tried various settings using qv4l2 on /dev/video0 and /dev/video1 with
>> no success.
>>
>> Is there a way to get higher encoding resolution from this board ?
>>     
> You probably won't be able to go any higher than a width of 720.  That
> said, it looks like either the driver is not responding properly or
> the application doesn't realize that the driver returned it's maximum
> field width (the V4L2 API specifies that in the S_FMT call that if the
> calling application specifies an invalid width, the driver can return
> a valid width and the application should recognize and use that
> value).
>
> Devin
>
>   

