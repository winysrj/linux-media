Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57500 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab1KLNrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 08:47:21 -0500
Received: by gyc15 with SMTP id 15so3721237gyc.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 05:47:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ebdacc2.04c6e30a.29e4.58ff@mx.google.com>
References: <CAB33W8dW0Yts_dxz=WyYEK9-bcoQ_9gM-t3+aR5s-G_5QswOyA@mail.gmail.com>
	<CAB33W8eMEG6cxM9x0aGRe+1xx6TwvjBZL4KSdRY4Ti2sTHk9hg@mail.gmail.com>
	<CAL9G6WXq_MSu+6Ogjis43bsszDri0y5JQrhHrAQ8tiTKv09YKQ@mail.gmail.com>
	<CAATJ+ftr76OMckcpf_ceX4cPwv0840C9HL+UuHivAtub+OC+jw@mail.gmail.com>
	<4ebdacc2.04c6e30a.29e4.58ff@mx.google.com>
Date: Sat, 12 Nov 2011 13:47:20 +0000
Message-ID: <CAB33W8eYnQbKAkNobiez0yH5tgCVN4s84ncT5cmKHxeqHm8P3Q@mail.gmail.com>
Subject: Re: AF9015 Dual tuner i2c write failures
From: Tim Draper <veehexx@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11 November 2011 23:16, Malcolm Priestley <tvboxspy@gmail.com> wrote:
> On Sat, 2011-11-12 at 09:51 +1100, Jason Hecker wrote:
>> I concur.  I have been using Malcolm Priestly's patches with both my
>> AF9015 dual tuner cards (which are PCI but still look like USB to the
>> kernel) for a few weeks now and have (finally!) got consistently
>> perfect recordings in MythTV simultaneously with both tuners on a
>> card. Malcolm, when do you think you'll submit these patches to the
>> tree for inclusion?  Is there anything else to test?
>>
>> I agree about the power cycling.  Every time I reboot I disconnect the
>> AC supply for 20secs to be sure the cards are power cycled properly -
>> you do the same thing by pulling out the stick.
>
> Yes, this is what is holding up the patches to media_build.
>
> The bug appears to be a race condition that appears in get config with
> some usb controllers.
>
> Josu, your patch is for the older hg version on s2, so this will not
> work on media_build.
>
> I have being trying to a way to do it without the bus lock, but can't
>
> I will try and finish the patches tomorrow.
>
> Regards
>
>
> Malcolm
>
>

thanks for the quick responses guys! i look forward to the update.
since i'm new to this mailing list, and have only used v4l in
pre-configured linux distro's, how will this fix be distributed to
people - as a patch i presume?
are there any how-to's with prerequisites of whats required to apply a patch?
