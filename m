Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:47157 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZBTXUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 18:20:21 -0500
Received: by gxk22 with SMTP id 22so3121026gxk.13
        for <linux-media@vger.kernel.org>; Fri, 20 Feb 2009 15:20:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090220225042.GA19663@phare.normalesup.org>
References: <20090220225042.GA19663@phare.normalesup.org>
Date: Fri, 20 Feb 2009 18:20:19 -0500
Message-ID: <412bdbff0902201520p6fbe68d0oaf53d76744184487@mail.gmail.com>
Subject: Re: Terratec Cinergy T USB XXS: remote does not work with 1.20
	firmware
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Nicolas George <nicolas.george@normalesup.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 20, 2009 at 5:50 PM, Nicolas George
<nicolas.george@normalesup.org> wrote:
> [This is a repost of a message sent to the obsolete linux-dvb@linuxtv.org list.]
>
> Hi.
>
> I am trying to get the remote controller with a Terratec Cinergy T USB XXS.
> With the firmware dvb-usb-dib0700-1.10.fw, the remote sends codes (not
> perfectly, but I can see where I am going).
>
> On the other hand, with dvb-usb-dib0700-1.20.fw, the remote does not detect
> anything. After some tracking, I found that in dib0700_rc_query_v1_20 (from
> dib0700_devices.c), the status from usb_bulk_msg is always -110
> (-ETIMEDOUT).
>
> Is there some way I can help fixing things? I do not mind using the old
> firmware, but I would like to help improving things.
>
> Regards,
>
> --
>  Nicolas George

That's code I wrote, based on information provided by Patrick over at Dibcom.

I would have to look at the code, but if I recall, the code is
designed to return -ETIMEDOUT during normal operation when no key
press is detected.  That said, seeing that return condition should not
be perceived as a problem.

Are there any cases where it returns something *other* than
-ETIMEDOUT?  Because if so, then the keypress is probably being
received but not processed properly.

I would recommend you add a line of code to printk() any return
condition other than -ETIMEDOUT, and see if something shows up in the
log when you try to use the remote control.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
