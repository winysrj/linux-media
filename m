Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ye0-f169.google.com ([209.85.213.169]:63277 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab3FFBpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jun 2013 21:45:53 -0400
Received: by mail-ye0-f169.google.com with SMTP id m9so545198yen.28
        for <linux-media@vger.kernel.org>; Wed, 05 Jun 2013 18:45:50 -0700 (PDT)
Message-ID: <51AFE7DC.9040801@gmail.com>
Date: Wed, 05 Jun 2013 22:37:32 -0300
From: =?ISO-8859-1?Q?=22Alejandro_A=2E_Vald=E9s=22?= <av2406@gmail.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: =?ISO-8859-1?Q?Jon_Arne_J=F8rgensen?= <jonarne@jonarne.no>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Audio: no sound
References: <519D6CFA.2000506@gmail.com> <CALF0-+UqJaNc7v86qakVTNEJx5npMFPqFp-=9rAByFV_+FEaww@mail.gmail.com> <519E41AC.3040707@gmail.com> <CALF0-+U5dFktwHwO5-h_7RJ1xyjc3JbHUWqG3g=WSPA=HcHnnw@mail.gmail.com> <519E6046.8050509@gmail.com> <CALF0-+UZnt9rfmQFSecqaf_9L29mwKeNV22w1XmMQQG0AE=jJw@mail.gmail.com> <519E76F3.4070006@gmail.com> <519EB8E6.5000503@gmail.com> <20130525070020.GA2122@dell.arpanet.local> <CALF0-+XS0urZ=G=jCLgKifs6NeC=rNqZB_ft2PXpcEVezuG=rw@mail.gmail.com>
In-Reply-To: <CALF0-+XS0urZ=G=jCLgKifs6NeC=rNqZB_ft2PXpcEVezuG=rw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2013 05:13 AM, Ezequiel Garcia wrote:
> Hi Alejandro,
>
> See below.
>
> On Sat, May 25, 2013 at 4:00 AM, Jon Arne Jørgensen <jonarne@jonarne.no> wrote:
>> On Thu, May 23, 2013 at 09:48:38PM -0300, "Alejandro A. Valdés" wrote:
> [...]
>>> [  187.472216] easycap::0adjust_contrast: adjusting contrast to  0x3F
>>> [  187.496207] easycap::0adjust_saturation: adjusting saturation to  0x2F
>>> [  187.520220] easycap::0adjust_hue: adjusting hue to  0x00
> Kernel dmesg should say stk1160.
>
>> [...]
>>
>>> Module                  Size  Used by
> [...]
>>> easycap              1213860  1
> As Jon says lsmod and dmesg should say stk1160, and not easycap.
> It's my bad: the first kernel version that includes stk1160 instead of the
> old driver is v3.7.x.
>
> You'll have to re-try with a newer kernel.
>
> Notice that you probably own a device with no AC97-compliant
> audio output. For those devices, the sound does not work.
> It's on my TODO list, but I'm not sure when I will be able to do it.
>
> AFAIK, some devices have AC97 sound (and thus work), and some doesn't.
>
> Sorry for the confusion,
Well, upgraded to kernel 3.7, but with the same results: no audio. Now 
the lsmod output shows the stk1160 driver loaded instead of the former 
EasyCAP, so that one got solved. Not quite sure about ac97 compliance, 
but I already tested with 5 or 6 different machines, all of them running 
the kernel 3.7 or up, and all of them also showing the ac97 bus being 
used by the ac97 codec (from lsmod output too), and none did work so far.

Little bit frustrating. May be time now to toss the damn dongle away and 
start looking for linux certified hardware.

Thanks anyway. Alex.
