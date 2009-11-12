Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36628 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbZKLWbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 17:31:08 -0500
Received: by bwz27 with SMTP id 27so2791751bwz.21
        for <linux-media@vger.kernel.org>; Thu, 12 Nov 2009 14:31:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AFC8B2C.4010905@email.it>
References: <4AFC8B2C.4010905@email.it>
Date: Thu, 12 Nov 2009 17:31:12 -0500
Message-ID: <829197380911121431v34525d38vf81453a59f7c6033@mail.gmail.com>
Subject: Re: How can I create a patch?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: xwang1976@email.it
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 12, 2009 at 5:24 PM,  <xwang1976@email.it> wrote:
> Hi to all,
> I've a usb hybrid tuner which does not work with the main v4l driver.
> I've found a way to use it modifying some lines in the em28xx-dvb.c and
> em28xx-cards.c files (thanks to Dainius Ridzevicius).
> Can someone explain me how to create a diff between the main v4l
> driver and the patched version so that I can share it in order to have it
> merged upstream?
> Thank you,
> Xwang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Run the following:

hg diff > output.patch

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
