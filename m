Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38630 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693Ab3E3WM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 18:12:28 -0400
Received: by mail-ie0-f174.google.com with SMTP id aq17so2057319iec.33
        for <linux-media@vger.kernel.org>; Thu, 30 May 2013 15:12:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA1g13n2GknjeCZ2fJbXH1trz8aog01BqEB_JwqU8QX9bda2Cg@mail.gmail.com>
References: <CAA1g13mVO_buU8AeROBT3qSXsS2EQtAvHVHdEo5-RGMcRYC47A@mail.gmail.com>
	<CALF0-+XcBRxqOb5gARG9JkFNoubXouHv_MHqC7paS5E5M7oSUg@mail.gmail.com>
	<CAA1g13n2GknjeCZ2fJbXH1trz8aog01BqEB_JwqU8QX9bda2Cg@mail.gmail.com>
Date: Thu, 30 May 2013 19:12:27 -0300
Message-ID: <CALF0-+V5mShZmVt=gJmA6dAH+3JGtJFv-UOxCbbWoPtZvf1+SA@mail.gmail.com>
Subject: Re: Unrecognized decoder chip (not gm7113c)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Greg Horvath <horvath.105@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 30, 2013 at 6:22 PM, Greg Horvath <horvath.105@gmail.com> wrote:
> I am not running them at the same time. There are two sets of dmesg output.
> One for the stk1160 driver and the other when I attempted to load easycap
> driver without loading stk1160.
>
>

Right. In that case you can forget about the "easycap" driver.
I can only help you getting your stuff working with stk1160.

Do you have any chance to upgrade your kernel to a v3.7+ ?

Keep in mind it's very unlikely that you'll get much support from the community
using such an ancient kernel, and with a driver that you backported yourself
(although I'll investigate this a bit).

-- 
    Ezequiel
