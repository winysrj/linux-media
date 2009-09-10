Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45648 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbZIJQM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 12:12:27 -0400
Received: by fxm17 with SMTP id 17so212307fxm.37
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 09:12:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA92160.5080200@iki.fi>
References: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com>
	 <d9def9db0909100358o14f07362n550b95a033c8a798@mail.gmail.com>
	 <20090910124549.GA18426@moon> <20090910124807.GB18426@moon>
	 <4AA8FB2F.2040504@iki.fi> <20090910134139.GA20149@moon>
	 <4AA9038B.8090404@iki.fi> <4AA911B6.2040301@iki.fi>
	 <829197380909100826i3e2f8315yd6a0258f38a6c7b9@mail.gmail.com>
	 <4AA92160.5080200@iki.fi>
Date: Thu, 10 Sep 2009 12:12:29 -0400
Message-ID: <829197380909100912xdb34da0s55587f6fe9c0f1d5@mail.gmail.com>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Markus Rechberger <mrechberger@gmail.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 10, 2009 at 11:55 AM, Antti Palosaari<crope@iki.fi> wrote:
> Devin Heitmueller wrote:
>>
>> The URB size is something that varies on a device-by-device basis,
>> depending on the bridge chipset.   There really is no
>> "one-size-fits-all" value you can assume.
>
> I doubt no. I tested last week rather many USB chips and all I tested
> allowed to set it as x188 or x512 bytes. If it is set something than chip
> does not like it will give errors or packets that are not as large as
> requested. You can test that easily, look dvb-usb module debug uxfer and use
> powertop.
>
>> I usually take a look at a USB trace of the device under Windows, and
>> then use the same value.
>
> I have seen logs where different sizes of urbs used even same chip.

Yes, the URB size can change depending on who wrote the driver, or
what the required throughput is.  For example, the em28xx has a
different URB size depending on whether the target application is
19Mbps ATSC or 38Mbps QAM.  That just reinforces what I'm saying - the
size selected in many cases is determined by the requirements of the
chipset.

Making it some multiple of 188 for DVB is logical since that's the
MPEG packet size.  That seems pretty common in the bridges I have
worked with.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
