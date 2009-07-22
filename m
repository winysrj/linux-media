Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f197.google.com ([209.85.210.197]:34502 "EHLO
	mail-yx0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZGVFmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 01:42:20 -0400
Received: by yxe35 with SMTP id 35so141925yxe.33
        for <linux-media@vger.kernel.org>; Tue, 21 Jul 2009 22:42:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A668BB9.1020700@eyemagnet.com>
References: <4A6666CC.7020008@eyemagnet.com>
	 <829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>
	 <4A667735.40002@eyemagnet.com>
	 <829197380907211932v6048d099h2ebb50da05959d89@mail.gmail.com>
	 <4A668BB9.1020700@eyemagnet.com>
Date: Wed, 22 Jul 2009 01:42:20 -0400
Message-ID: <829197380907212242k298f3a64p9fa99018ddf787b5@mail.gmail.com>
Subject: Re: offering bounty for GPL'd dual em28xx support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Castellotti <sc@eyemagnet.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 21, 2009 at 11:47 PM, Steve Castellotti<sc@eyemagnet.com> wrote:
> On 07/21/2009 07:32 PM, Devin Heitmueller wrote:
>>
>> I agree that *in theory* you should be able to do two devices.  A back
>> of the envelope calculation of 640x480 at 30fps in YUVY capture should
>> be about 148Mbps.  That said, I don't think the scenario you are
>> describing has really been tested/debugged previously.  If I had to
>> guess, my suspicion would be a bug in the driver code that calculates
>> which USB alternate mode to operate in, which results in the driver
>> reserving more bandwidth than necessary.
>>
>> I would have dig into the code and do some testing in order to have a
>> better idea where the problem is.  Do you have a specific em28xx
>> product in mind that you intend to use?
>>
>
>    Well in theory there's no difference between theory and practice, but in
> practice there is (c:
>
>
>    More than happy to coordinate some testing of a variety of em28xx devices
> we have handy around the office if it would help isolate any bugs. We could
> throw some QA resource at the problem if nothing else.
>
>
>    One of the devices we're supposed to be able to acquire in bulk is
> no-name brand that simply says "VC-211A" on the label. "lsusb" output looks
> like this:
>
> ID eb1a:2861 eMPIA Technology, Inc.
>
>
>    The other says "GrabBeeX+ deluxe" and has this identifier:
>
>
> ID eb1a:2821 eMPIA Technology, Inc.
>
>
>    We have a 2-3 others on hand as well.
>
>
>    Once again, thanks for the responsiveness and please let me know what we
> can do to contribute.

Well, I think I own something like nine different em28xx products, so
I should be able to hook a couple of them up at the same time and
debug the issue.  The only issue at this point is that I already have
a rather full plate of issues I am currently working.

I'll see if I can schedule some cycles in the next couple of weeks to
take a look (unless someone else wants to step up and debug the
issue).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
