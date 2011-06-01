Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35768 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1FAPtw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 11:49:52 -0400
Received: by ewy4 with SMTP id 4so2035567ewy.19
        for <linux-media@vger.kernel.org>; Wed, 01 Jun 2011 08:49:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE65C6D.2060806@anevia.com>
References: <4DE65C6D.2060806@anevia.com>
Date: Wed, 1 Jun 2011 11:49:50 -0400
Message-ID: <BANLkTi=zUfg9hAN8X9nrPEOMgtUzsKrbOw@mail.gmail.com>
Subject: Re: HVR-1300 analog inputs
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Florent Audebert <florent.audebert@anevia.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 1, 2011 at 11:36 AM, Florent Audebert
<florent.audebert@anevia.com> wrote:
> Hi,
>
> I'm experimenting around with an Hauppauge HVR-1300 (cx88_blackbird) analog
> inputs (PAL-I signal).
>
> Using qv4l2 (trunk) and 2.6.36.4, I successfully get a clean image on both
> composite and s-video inputs with resolutions of 640x480 or less.
>
> With any higher resolutions, I have thin horizontal lines at moving
> positions (seems to cycle)[1].
>
> I've tried various settings using qv4l2 on /dev/video0 and /dev/video1 with
> no success.
>
> Is there a way to get higher encoding resolution from this board ?

You probably won't be able to go any higher than a width of 720.  That
said, it looks like either the driver is not responding properly or
the application doesn't realize that the driver returned it's maximum
field width (the V4L2 API specifies that in the S_FMT call that if the
calling application specifies an invalid width, the driver can return
a valid width and the application should recognize and use that
value).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
