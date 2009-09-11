Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63557 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbZIKSBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 14:01:32 -0400
Received: by fxm17 with SMTP id 17so971047fxm.37
        for <linux-media@vger.kernel.org>; Fri, 11 Sep 2009 11:01:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090911175030.GA10479@moon>
References: <d9def9db0909100358o14f07362n550b95a033c8a798@mail.gmail.com>
	 <20090910124807.GB18426@moon> <4AA8FB2F.2040504@iki.fi>
	 <20090910134139.GA20149@moon> <4AA9038B.8090404@iki.fi>
	 <4AA911B6.2040301@iki.fi> <20090910171631.GA4423@moon>
	 <20090910193916.GA4923@moon> <4AAA60D0.50706@iki.fi>
	 <20090911175030.GA10479@moon>
Date: Fri, 11 Sep 2009 14:01:34 -0400
Message-ID: <829197380909111101v41c7ea08r35eb157f3bee1f86@mail.gmail.com>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Markus Rechberger <mrechberger@gmail.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 11, 2009 at 1:50 PM, Aleksandr V. Piskunov
<aleksandr.v.piskunov@gmail.com> wrote:
> Ok, I did read basics of USB 2.0 protocol, gotta love these 600 page specs..
> So using my fresh knowledge I went away and hacked ce6230 to use Isochronous
> transfer endpoint instead of Bulk one. And it helped, tuner works, no
> corruption with af9015 running on same controller at the same time.
>
> Of course it isn't a fix per se, af9015 still corrupts if I start bulk
> reading from a flash drive, etc. And there are no Isochronous endpoints on
> af9015, so no alternative to bulk transfers :)
>
> But at least I'm getting closer to pinpointing the real problem and so far
> everything points to AMD SB700 chipset driver. Google says it has quite
> some hardware bugs and several workarounds in linux drivers...
>
> P.S. Rather unrelated question, what type of USB transfer is generally
> preferred for USB media stream devices, BULK or ISOC? Antti, why did you
> choose BULK for ce6230?

The core difference between bulk and isoc is that with bulk you use
get reliable delivery, but there is no reservation of bandwidth (bulk
uses all available bandwidth).  With isoc, you have reserved the
bandwidth up front, but don't have reliable delivery (no retry
mechanism, etc).

With something like a hard drive, you want to use all available
bandwidth, and you can do retries to ensure delivery, making bulk an
appropriate choice.  However, for streaming video, you usually want
the bandwidth reserved up front, because if two devices are using the
bus then frames will get dropped (and in a realtime streaming video
device, there is no "retry" capability for dropped packets).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
