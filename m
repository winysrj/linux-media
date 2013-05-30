Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52587 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966916Ab3E3INy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 04:13:54 -0400
Received: by mail-ie0-f171.google.com with SMTP id s9so9757940iec.16
        for <linux-media@vger.kernel.org>; Thu, 30 May 2013 01:13:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130525070020.GA2122@dell.arpanet.local>
References: <519D6CFA.2000506@gmail.com>
	<CALF0-+UqJaNc7v86qakVTNEJx5npMFPqFp-=9rAByFV_+FEaww@mail.gmail.com>
	<519E41AC.3040707@gmail.com>
	<CALF0-+U5dFktwHwO5-h_7RJ1xyjc3JbHUWqG3g=WSPA=HcHnnw@mail.gmail.com>
	<519E6046.8050509@gmail.com>
	<CALF0-+UZnt9rfmQFSecqaf_9L29mwKeNV22w1XmMQQG0AE=jJw@mail.gmail.com>
	<519E76F3.4070006@gmail.com>
	<519EB8E6.5000503@gmail.com>
	<20130525070020.GA2122@dell.arpanet.local>
Date: Thu, 30 May 2013 05:13:53 -0300
Message-ID: <CALF0-+XS0urZ=G=jCLgKifs6NeC=rNqZB_ft2PXpcEVezuG=rw@mail.gmail.com>
Subject: Re: Audio: no sound
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: =?ISO-8859-1?B?IkFsZWphbmRybyBBLiBWYWxk6XMi?= <av2406@gmail.com>
Cc: =?ISO-8859-1?Q?Jon_Arne_J=F8rgensen?= <jonarne@jonarne.no>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alejandro,

See below.

On Sat, May 25, 2013 at 4:00 AM, Jon Arne Jørgensen <jonarne@jonarne.no> wrote:
> On Thu, May 23, 2013 at 09:48:38PM -0300, "Alejandro A. Valdés" wrote:
[...]
>> [  187.472216] easycap::0adjust_contrast: adjusting contrast to  0x3F
>> [  187.496207] easycap::0adjust_saturation: adjusting saturation to  0x2F
>> [  187.520220] easycap::0adjust_hue: adjusting hue to  0x00

Kernel dmesg should say stk1160.

> [...]
>
>> Module                  Size  Used by
[...]
>> easycap              1213860  1
>

As Jon says lsmod and dmesg should say stk1160, and not easycap.
It's my bad: the first kernel version that includes stk1160 instead of the
old driver is v3.7.x.

You'll have to re-try with a newer kernel.

Notice that you probably own a device with no AC97-compliant
audio output. For those devices, the sound does not work.
It's on my TODO list, but I'm not sure when I will be able to do it.

AFAIK, some devices have AC97 sound (and thus work), and some doesn't.

Sorry for the confusion,
-- 
    Ezequiel
