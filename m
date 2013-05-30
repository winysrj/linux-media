Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52947 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab3E3TGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 15:06:03 -0400
Received: by mail-ie0-f171.google.com with SMTP id s9so1563292iec.30
        for <linux-media@vger.kernel.org>; Thu, 30 May 2013 12:06:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA1g13mVO_buU8AeROBT3qSXsS2EQtAvHVHdEo5-RGMcRYC47A@mail.gmail.com>
References: <CAA1g13mVO_buU8AeROBT3qSXsS2EQtAvHVHdEo5-RGMcRYC47A@mail.gmail.com>
Date: Thu, 30 May 2013 16:06:02 -0300
Message-ID: <CALF0-+XcBRxqOb5gARG9JkFNoubXouHv_MHqC7paS5E5M7oSUg@mail.gmail.com>
Subject: Re: Unrecognized decoder chip (not gm7113c)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Greg Horvath <horvath.105@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Thu, May 30, 2013 at 3:58 PM, Greg Horvath <horvath.105@gmail.com> wrote:
> I have ported the 3.2 version of driver to kernel version 3.0.8 running on
> an rk3066 (mk808) device.
>

That's cool.

> [13336.159017] stk1160: driver ver 0.9.5 successfully loaded
[...]

First of all, look here: you seem to have ported stk1160 successfully.
But...

> [15757.888105] easycap: module is from the staging directory, the quality is
> unknown, you have been warned.

Are you *also* running easycap?

Are both modules running at the same time?

If yes, then please blacklist the "easycap" driver as it's deprecated: stk1160
replaces it and you should not use both.

Thanks,
-- 
    Ezequiel
