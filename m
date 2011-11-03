Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35718 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933086Ab1KCMRB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 08:17:01 -0400
Received: by iage36 with SMTP id e36so1257079iag.19
        for <linux-media@vger.kernel.org>; Thu, 03 Nov 2011 05:17:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D945C405928A9949A0F33C69E64A1A3BD8D5EF@s-mail.siano-ms.ent>
References: <D945C405928A9949A0F33C69E64A1A3BD8D5EF@s-mail.siano-ms.ent>
Date: Thu, 3 Nov 2011 08:17:00 -0400
Message-ID: <CAOcJUbwqp7O=WWkaqzTo9zVxDhjUFRQhKbd2y51UDaZHTNQnvw@mail.gmail.com>
Subject: Re: Problem with DVB module during suspend/hibernate.
From: Michael Krufky <mkrufky@linuxtv.org>
To: Doron Cohen <doronc@siano-ms.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 3, 2011 at 8:00 AM, Doron Cohen <doronc@siano-ms.com> wrote:
> Hi,
> I am dealing with a problems with suspend/hibernate freeze during resume
> when DVB API is used. I found a workaround for it here
> <http://forum.xbmc.org/showthread.php?t=71490> which solve the problem
> but this is not a solution only a workaround.
>
> Problem is that when using USB DVB tuner the tuner is turned off/on
> during the suspend process, meaning that during the resume the USB
> disconnect and probe methods are running.
> The disconnect method is causing a call to dvb_unregister_frontend (or,
> if changing the order to dvb_dmxdev_release) This call hangs on
> wait_event until fepriv->dvbdev->users will free all users.
>
> This works fine when application is not playing the video, but if an
> application receives TV (tested with VLC and Kaffeine but true to all)
> Users will be free only when the application stops. It works if the
> device is plugged out during video display (users will be released when
> application closes the frontend and than the device will be free) but
> during the resume process, user interface is not working and there is a
> dead lock system must be hard power off and on.
>
> The workaround just causes the application to close force before the
> suspend.
>
> Since I only have Siano devices at hand, I couldn't prove if the problem
> is with our driver or in all USB receivers or only related to Siano
> driver, but exploring the code it seems that everybody are working in
> the same way.
>
> Can anyone approve that suspend and hibernate works fine when DVB is
> being watched by an application?

Doron,

Power management is a known problem in dvb-core -- it doesn't work
"properly" in *any* driver.  :-(

Patches welcome ;-)

Regards,

Michael Krufky
