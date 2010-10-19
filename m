Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63475 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab0JST0P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 15:26:15 -0400
Received: by ewy20 with SMTP id 20so3882270ewy.19
        for <linux-media@vger.kernel.org>; Tue, 19 Oct 2010 12:26:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com>
References: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com>
Date: Tue, 19 Oct 2010 15:26:13 -0400
Message-ID: <AANLkTim+QfU5hJwi_DkdpnAvUWSOLdEM5kXoTDK5+tsy@mail.gmail.com>
Subject: Re: rtl2832u support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Damjan Marion <damjan.marion@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Oct 19, 2010 at 1:42 PM, Damjan Marion <damjan.marion@gmail.com> wrote:
>
> Hi,
>
> Is there any special reason why driver for rtl2832u DVB-T receiver chipset is not included into v4l-dvb?
>
> Realtek published source code under GPL:
>
> MODULE_AUTHOR("Realtek");
> MODULE_DESCRIPTION("Driver for the RTL2832U DVB-T / RTL2836 DTMB USB2.0 device");
> MODULE_VERSION("1.4.2");
> MODULE_LICENSE("GPL");

Unfortunately, in most cases much more is "required" than having a
working driver under the GPL in order for it to be accepted upstream.
In some cases it can mean a developer spending a few hours cleaning up
whitespace and indentation, and in other cases it means significant
work to the driver is required.

The position the LinuxTV team has taken is that they would rather have
no upstream driver at all than to have a driver which doesn't have the
right indentation or other aesthetic problems which has no bearing on
how well the driver actually works.

This is one of the big reasons KernelLabs has tens of thousands of
lines of code adding support for a variety of devices with many happy
users (who are willing to go through the trouble to compile from
source), but the code cannot be accepted upstream.  I just cannot find
the time to do the "idiot work".

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
