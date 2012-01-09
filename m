Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53253 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2AIMPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 07:15:50 -0500
Received: by iaeh11 with SMTP id h11so6558128iae.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2012 04:15:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPwv0JmTGPadH++PEKsP6T9Kc+O2sA7ndwn1BFoeUQLTvpxDHw@mail.gmail.com>
References: <20120108163343.2973.20888.reportbug@saturn.home.lan>
	<1326047805.13595.307.camel@deadeye>
	<CAPwv0JmTGPadH++PEKsP6T9Kc+O2sA7ndwn1BFoeUQLTvpxDHw@mail.gmail.com>
Date: Mon, 9 Jan 2012 13:15:50 +0100
Message-ID: <CAPwv0JnALuTQcHqk5Eonoe3QyFGKafgmhebQdb67dWLgjm+vWg@mail.gmail.com>
Subject: Re: Bug#655109: linux-2.6: BUG in videobuf-core triggered by mplayer
 on HVR-1300
From: Rik Theys <rik.theys@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: 655109@bugs.debian.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[Reformatted as plain-text so it will get accepted by the vger.kernel.org list]

On Mon, Jan 9, 2012 at 1:14 PM, Rik Theys <rik.theys@gmail.com> wrote:
>
> Hi,
>
> On Sun, Jan 8, 2012 at 7:36 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>>
>> > Jan  8 17:12:52 saturn kernel: [ 1623.655341] ------------[ cut here ]------------
>> > Jan  8 17:12:52 saturn kernel: [ 1623.655363] kernel BUG at /home/blank/debian/kernel/release/linux-2.6/linux-2.6-3.1.6/debian/build/source_amd64_none/drivers/media/video/videobuf-core.c:300!
>>
>> The 'BUG' indicates that the video capture queue hasn't been initialised
>> properly or has been corrupted.  However, after looking at the driver
>> for a while I just can't see how that can happen.
>>
>> >
>> >
>> > I've experienced this bug with previous kernel versions as well but didn't report it before.
>>
>> Do you remember which was the first version where this bug appeared?
>>
>
> I bought the card when squeeze was still testing (but frozen). I never got the card to work 100% and ran into different issues and kernel messages since 2.6.32. I'm not 100% sure the videobug-core bug was present in that kernel but I believe it was.
>
> It could have been an issue before 2.6.32 but I never tried an older kernel.
>
> Regards,
>
> Rik
>



--

Rik
