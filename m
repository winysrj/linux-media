Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50834 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab0JIPkc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Oct 2010 11:40:32 -0400
Received: by ewy20 with SMTP id 20so71855ewy.19
        for <linux-media@vger.kernel.org>; Sat, 09 Oct 2010 08:40:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB088DA.60508@redhat.com>
References: <4CB088DA.60508@redhat.com>
Date: Sat, 9 Oct 2010 11:40:31 -0400
Message-ID: <AANLkTi=gH10h5L1jpbWMUDBWbuVWRfEqVgPpzSazvMYs@mail.gmail.com>
Subject: Re: V4L/DVB: cx231xx: Colibri carrier offset was wrong for PAL/M
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-me >> Linux Media Mailing List" <linux-media@vger.kernel.org>,
	Sri Deevi <Srinivasa.Deevi@conexant.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Oct 9, 2010 at 11:23 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> cx231xx: Colibri carrier offset was wrong for PAL/M
>
> The carrier offset check at cx231xx is incomplete. I got here one concrete case
> where it is broken: if PAL/M is used (and this is the default for Pixelview SBTVD),
> the routine will return zero, and the device will be programmed incorrectly,
> producing a bad image. A workaround were to change to NTSC and back to PAL/M,
> but the better is to just fix the code ;)

Thanks for spotting this.  I've been focusing entirely on NTSC, so any
such fixes for other standards are very welcome.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
