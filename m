Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:61346 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760679AbZLJLZf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 06:25:35 -0500
Received: by pxi27 with SMTP id 27so2043105pxi.4
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 03:25:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B20B0E8.7080304@samsung.com>
References: <4B20B0E8.7080304@samsung.com>
Date: Thu, 10 Dec 2009 14:25:41 +0300
Message-ID: <208cbae30912100325qa2ea009q405c01281e2ed746@mail.gmail.com>
Subject: Re: Radio application using V4L2 on console?
From: Alexey Klimov <klimov.linux@gmail.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 10, 2009 at 11:27 AM, Joonyoung Shim
<jy0922.shim@samsung.com> wrote:
> Hi, all.
>
> I just wonder there is any radio application using the V4L2 on console.
> I found only the Kradio app of KDE, but the KDE is difficult to use the
> embedded system.
>
> I am testing using my simple radio test application on console, but it
> is also difficult to test correctly RDS - parsing problem etc...
>
> Please introduce to me the radio application satisfied above requests if
> it exists.

I use only two console applications: mplayer and fmtools. But i'm not
sure if they use v4l2 and if they have RDS support.

And i hope this link probably can help you:
http://linuxtv.org/wiki/index.php/Radio_Listening_Applications

-- 
Best regards, Klimov Alexey
