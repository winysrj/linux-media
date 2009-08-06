Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:37027 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZHFOR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 10:17:28 -0400
Received: by ywh13 with SMTP id 13so1079833ywh.15
        for <linux-media@vger.kernel.org>; Thu, 06 Aug 2009 07:17:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7AE0B0.20507@email.it>
References: <4A79EC82.4050902@email.it> <4A7AE0B0.20507@email.it>
Date: Thu, 6 Aug 2009 10:17:28 -0400
Message-ID: <829197380908060717ua009e78nc045f2940c7fc76e@mail.gmail.com>
Subject: Re: Issues with Empire Dual Pen: request for help and suggestions!!!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: xwang1976@email.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 6, 2009 at 9:54 AM, <xwang1976@email.it> wrote:
> Hi,
> I want to inform you that thanks to Douglas Schilling Landgraf, the first
> point (automatic recognition of the device when plugged in) ha been resolved
> (using his development tree driver).
> I've tried to scan for digital channels again and the result has not changed
> but in the dmesg attached there are a lot of messages created during the
> scan process. I hope they are useful to solve at list the issue related with
> the digital scanning.
> Thank you,
> Xwang
<snip>

Yeah, I've seen that before.  Open up em28xx-dvb.c, and move the following:

case EM2880_BOARD_EMPIRE_DUAL_TV:

from line 402 to line 492.  So it should look like this:

case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
case EM2880_BOARD_EMPIRE_DUAL_TV:
      dvb->frontend = dvb_attach(zl10353_attach,

&em28xx_zl10353_xc3028_no_i2c_gate,
                                              dev->i2c_adap);

Then unplug the device, recompile, reinstall and see if the dvb starts working.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
