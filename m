Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:40435 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010AbaC0WNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Mar 2014 18:13:39 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so2270288wes.15
        for <linux-media@vger.kernel.org>; Thu, 27 Mar 2014 15:13:38 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: dib0700 NEC scancode question
Date: Thu, 27 Mar 2014 23:13:35 +0100
Message-ID: <1464013.AGHbqAynQ4@lappi3>
In-Reply-To: <20140327214041.GA21302@hardeman.nu>
References: <20140327120728.GA13748@hardeman.nu> <20140327214041.GA21302@hardeman.nu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

On Thursday 27 March 2014 22:40:41 David Härdeman wrote:
> On Thu, Mar 27, 2014 at 01:07:28PM +0100, David Härdeman wrote:
> >Hi Patrick,
> >
> >a quick question regarding the dib0700 driver:
> 
> >in ./media/usb/dvb-usb/dib0700_core.c the RC RX packet is defined as:
> ...
> 
> >The NEC protocol transmits in the order:
> ...
> 
> >Does the dib0700 fw really reorder the bytes, or could the order of
> >not_system and system in struct dib0700_rc_response have been
> >accidentally reversed?

It feels like a hundred years I haven't work on that. I'm not sure whether 
this knowledge can still be retrieved as of today or not. I would lie if I 
told you that I look the archives... and I can't want to do that (lying and 
looking).

However, I realize that your assumption might not be totally far-fetched. If 
you can find another IR-receiver just check whether the same remote control 
delivers swapped bytes or not (if I understood it correctly, that's your real 
question). Then you have you answer, haven't you? 

-- 
Patrick.
