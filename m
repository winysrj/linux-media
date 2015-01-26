Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:61720 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbbAZMoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 07:44:09 -0500
Received: by mail-yk0-f169.google.com with SMTP id 200so3720376ykr.0
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 04:44:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADU0VqyzEdG=07O=9LufbZAYa0BVzgUbcBeVzUnfH+Mpup5=Fw@mail.gmail.com>
References: <CADU0VqyzEdG=07O=9LufbZAYa0BVzgUbcBeVzUnfH+Mpup5=Fw@mail.gmail.com>
Date: Mon, 26 Jan 2015 07:44:08 -0500
Message-ID: <CALzAhNVD3od1WSyi98icqhy4WveoutAoTJzqVV6g4yw+tMAEMg@mail.gmail.com>
Subject: Re: PCTV 800i
From: Steven Toth <stoth@kernellabs.com>
To: John Klug <ski.brimson@gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 26, 2015 at 12:50 AM, John Klug <ski.brimson@gmail.com> wrote:
> I have a new PCTV card with CX23880 (not CX23883 as shown in the picture):
>
> http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_(800i)
>
> The description is out of date with respect to my recent card.
>
> It did not work in 3.12.20, 3.17.7, and I finally downloaded the
> latest GIT of media_build to no avail (I have a 2nd card that is CX18,
> which is interspersed in the output).

The error messages suggest one or more of the components on the board,
or their I2C addresses have changed, or that your hardware is bad.

Other than the Conexant PCI bridge, do the other components listed in
the wiki page match the components on your physical device?

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
