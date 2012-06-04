Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42038 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760601Ab2FDNf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 09:35:58 -0400
Received: by yenm10 with SMTP id m10so2982822yen.19
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 06:35:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FCCB8F4.7090407@interlinx.bc.ca>
References: <bug-827538-199927-UDXT6TGYkq@bugzilla.redhat.com>
	<4FC91D64.6090305@iki.fi>
	<4FCA41D7.2060206@iki.fi>
	<4FCACF9C.8060509@iki.fi>
	<4FCB76D3.7090800@interlinx.bc.ca>
	<4FCB77FB.50804@iki.fi>
	<4FCBD095.30901@iki.fi>
	<4FCCB8F4.7090407@interlinx.bc.ca>
Date: Mon, 4 Jun 2012 09:35:54 -0400
Message-ID: <CAGoCfixoe5jyYrgwNnadbFsvRqF1P3rk5jMZbmtmvhyvAieZ0g@mail.gmail.com>
Subject: Re: Fwd: [Bug 827538] DVB USB device firmware requested in module_init()
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 4, 2012 at 9:32 AM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:
> On 12-06-03 05:01 PM, Antti Palosaari wrote:
>>
>> That firmware downloading patch is done top of my new dvb-usb
>> development tree. I have converted very limited set of drivers for that
>> tree, af9015, au6610, ec168 and anysee (and those are only on my local
>> hard disk). I tried to backport patch for the current dvb-usb but I ran
>> many problems and gave up. Looks like it is almost impossible to convert
>> old dvb-usb without big changes...
>>
>> So what driver you are using?
>
> I'm using the hvr-950q per
> https://bugzilla.kernel.org/show_bug.cgi?id=43145 and
> https://bugzilla.kernel.org/show_bug.cgi?id=43146.
>
>> It is possible I can convert your driver
>> too and then it is possible to test.
>
> Great.  Ideally it would be great to get this backported and applied to
> the linux 3.2.0 release stream.

The 950q doesn't use the dvb-usb framework (nor does it load the
firmware at init).  Whatever is going on there is completely unrelated
to what Antti is debugging.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
