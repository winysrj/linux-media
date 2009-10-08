Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:34250 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZJHMqc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2009 08:46:32 -0400
Received: by ewy4 with SMTP id 4so2833539ewy.37
        for <linux-media@vger.kernel.org>; Thu, 08 Oct 2009 05:45:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ACDF829.3010500@xfce.org>
References: <4ACDF829.3010500@xfce.org>
Date: Thu, 8 Oct 2009 08:45:54 -0400
Message-ID: <37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>
Subject: Re: Hauppage WinTV-HVR-900H
From: Michael Krufky <mkrufky@kernellabs.com>
To: Ali Abdallah <aliov@xfce.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 8, 2009 at 10:33 AM, Ali Abdallah <aliov@xfce.org> wrote:
> Hi,
>
> Very unlucky, i bought a pinnacle hybrid pro and couldn't get it to work
> with linux, then i gave it up, and i found that HVR-900 card works well
> under linux, i got one, but i didn't know that the company is referring now
> for 900 same as 900H.
>
> 900H doesn't work under Linux, is there is way to get this card working?
>
> googling i didn't find much information, all i found is work under way to
> get this card supported (2008).
>
> Please help,

Mauro was working on this driver some time ago...  There is a current
thread about the tm6010 on the mailing list now, but I have not read
up on it.  Last I heard, progress on the driver has been minimal.

Almost all other Hauppauge products have relatively decent linux
support -- you were unlucky and picked the one usb stick that will
probably not be fully functional for a while.

If you're interested in helping the driver development, then take a
look at the related mailing list posts.  Otherwise, you might be
better off choosing a different product.

On the other hand, I think there's been some recent progress on the
PCTV hybrid pro -- Devin Heitmueller has been doing a lot of work on
those products lately.  For more information, see
http://kernellabs.com

Are you specifically looking for a hybrid analog / digital usb stick?
...or is digital-only good enough for your purposes?

-Mike
