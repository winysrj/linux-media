Return-path: <mchehab@localhost>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46177 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab0IEQGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Sep 2010 12:06:06 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimpDh36-edV9UkRyn-9Z0o1o7T4wFZFBVQje1Y9@mail.gmail.com>
References: <AANLkTimXP-3OkoNCjTgrQmo29F0t-TmA9p4utAG2M3Qp@mail.gmail.com>
	<AANLkTim_HujYzL5SyotRb7w6-ZTc3_BtO=+YhCpnSzBT@mail.gmail.com>
	<AANLkTimpDh36-edV9UkRyn-9Z0o1o7T4wFZFBVQje1Y9@mail.gmail.com>
Date: Mon, 6 Sep 2010 00:06:05 +0800
Message-ID: <AANLkTimYS+EqyGm=Bur4De3HDg+spNHLHejp0QJTcft_@mail.gmail.com>
Subject: Re: some question about
From: loody <miloody@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

hi:

2010/9/5 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Sun, Sep 5, 2010 at 11:48 AM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> On Sun, Sep 5, 2010 at 11:36 AM, loody <miloody@gmail.com> wrote:
>>> WinTV-HVR-1950 high performance USB TV tuner
>>> WinTV-HVR-950Q for laptop and notebooks
>>
>> Both these devices are supported under Linux, and in fact are unlikely
>> to work properly with only Full Speed USB.  At least the 950q
>> definitely requires High speed (I put a check in there to specifically
>> not load the driver otherwise).
>
> I perhaps misread your original email.  While the 950q does present
> itself as a USB audio class device, the 1950 does not.  It only
> provides MPEG encoded output (containing both the audio and video),
> and is not a USB audio class device.
>
> So while both these devices will work under Linux on a high speed
> interface, if you specifically require the device to identify itself
> as a USB audio class device, only the 950q does this.
>
> Devin
would you mind to send me the device descriptors for me?
I want to check whether the input/output unit and audio/video format
does meet the spec.
BTW, will the device support mp3 output?
since the spec define mp3 as one of input/output format.
that means if I put the raw data of mp3 to that device, it should
play/record well.

appreciate your help,
miloody
