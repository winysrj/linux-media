Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54936 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab0F1UGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 16:06:03 -0400
Received: by wwd20 with SMTP id 20so301395wwd.19
        for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 13:06:01 -0700 (PDT)
Message-ID: <4C290096.5080209@gmail.com>
Date: Mon, 28 Jun 2010 22:05:42 +0200
From: Matteo Sisti Sette <matteosistisette@gmail.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: linux-media@vger.kernel.org
Subject: Re: v4l-dvb unsupported device: Conceptronic CTVDIGUSB2 1b80:d393
 (Afatech) - possibly similar to CTVCTVDIGRCU v3.0?
References: <AANLkTikojhopHeY2WuHxK_tbCs99_SV7ksWnYv4UXM4W@mail.gmail.com> <4C28FCA8.5090005@hoogenraad.net>
In-Reply-To: <4C28FCA8.5090005@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2010 09:48 PM, Jan Hoogenraad wrote:
> Matteo:
>
> If I read this well, CTVDIGUSB2 1b80:d393 (Afatech) is not at all
> similar to the CTVDIGRCU.
> The CTVDIGRCU has a Realtek RTL2831U decoder, and is NOT included in the
> standard dvb list.

So is the table at http://linuxtv.org/wiki/index.php/DVB-T_USB_Devices 
incorrect?

It says:

Conceptronic USB2.0 DVB-T CTVDIGRCU V3.0 	
  ✔ Yes, in kernel since 2.6.31
1b80:e397 USB2.0 	
Afatech AF9015


Anyway, I see there are other sticks with chipsets by Afatech. Is there 
any chance that some of the currently implemented driver would work fine 
with my chipset if only I forced the driver to recognize the chipset as 
another one by touching the source code?
How could I try that? (if it deserves a try)

Thanks
m.
