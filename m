Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47091 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZK1Nwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 08:52:40 -0500
Received: by ewy19 with SMTP id 19so2226923ewy.21
        for <linux-media@vger.kernel.org>; Sat, 28 Nov 2009 05:52:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259390126.26617.7.camel@localhost>
References: <1259356232.2353.13.camel@localhost>
	 <1259390126.26617.7.camel@localhost>
Date: Sat, 28 Nov 2009 08:52:45 -0500
Message-ID: <83bcf6340911280552s70609decgcba4fd5f85a6f82b@mail.gmail.com>
Subject: Re: cx25840: GPIO settings wrong for HVR-1850 IR Tx
From: Steven Toth <stoth@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, mkrufky@kernellabs.com,
	hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 28, 2009 at 1:35 AM, Andy Walls <awalls@radix.net> wrote:
> On Fri, 2009-11-27 at 16:11 -0500, Andy Walls wrote:
>
>
>> Steve and Hans,
>>
>> Any ideas?
>>
>> I know on the list I had bantered around a configure, enable, set, get
>> etc v4l2_subdev ops for gpio, but I can't remember the details nor the
>> requirements.
>>
>> The cx25840 module really needs a way for the cx23885 bridge driver to
>> set GPIOs cleanly.
>
> Nevermind, I've slapped something together at
>
>        http://linuxtv.org/hg/~awalls/cx23885-ir
>
> for setting up the IO pin multiplexing in the CX23888 A/V core from the
> bridge driver.
>
> It does what I need.  Reading GPIOs or setting GPIOs without setting up
> the pin config isn't implemented, as I didn't need it.  However, it
> should be easier to implement that now.

Hi Andy,

I looked over this today and from the 10,000 ft view I think it's
going to work nicely as a replacement for the current HVR1700
workaround and also for the IR pin requirements.

Reviewed-by: Steven Toth <stoth@kernellabs.com>

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
