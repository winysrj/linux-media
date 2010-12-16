Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35359 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0LPL6e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 06:58:34 -0500
Received: by wwa36 with SMTP id 36so2336909wwa.1
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 03:58:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101216111555.329df4fd@tele>
References: <cover.1291926689.git.mchehab@redhat.com>
	<20101209184236.53824f09@pedra>
	<20101210115124.57ccd43e@tele>
	<AANLkTim7iGe=tZXniHXG_33hCyiKFPZVuVDRLu43C3BQ@mail.gmail.com>
	<20101214200817.045422e7@tele>
	<AANLkTimeLZwRhP8GfyZbNRiv3JduKJg8ZA3XZ6q7r2uQ@mail.gmail.com>
	<20101216111555.329df4fd@tele>
Date: Thu, 16 Dec 2010 13:58:32 +0200
Message-ID: <AANLkTi=Non7GUken7gZy9LB2GpWziHYkaqEiZLSC3i4t@mail.gmail.com>
Subject: Re: [PATCH 3/6] [media] gspca core: Fix regressions gspca breaking
 devices with audio
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, Dec 16, 2010 at 12:15 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Tue, 14 Dec 2010 22:05:37 +0200
> Anca Emanuel <anca.emanuel@gmail.com> wrote:
>
>> The same bizzzzzzzzz ...
>
> Does this noise exist with all image resolutions?

Yes.

> Also, does it change when changing the frame rate or the light
> frequency?

Today, I can not reproduce the same noise. Only when I put my hand
near the camera. I tried to record it, but there is no sound.
The sound is only on the speakers.
I muted the output and disabled the "Webcam Classic", the same interference.
The camera don't have an microphone,
[ 2395.093550] usb 8-1: adding 8-1:1.1 (config #1, interface 1)
[ 2395.093621] ov519 8-1:1.1: usb_probe_interface
[ 2395.093627] ov519 8-1:1.1: usb_probe_interface - got id
[ 2395.093646] snd-usb-audio 8-1:1.1: usb_probe_interface
[ 2395.093653] snd-usb-audio 8-1:1.1: usb_probe_interface - got id
there is no need for snd-usb-audio on this model.
