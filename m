Return-path: <mchehab@localhost>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45439 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab0IEQUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Sep 2010 12:20:24 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimYS+EqyGm=Bur4De3HDg+spNHLHejp0QJTcft_@mail.gmail.com>
References: <AANLkTimXP-3OkoNCjTgrQmo29F0t-TmA9p4utAG2M3Qp@mail.gmail.com>
	<AANLkTim_HujYzL5SyotRb7w6-ZTc3_BtO=+YhCpnSzBT@mail.gmail.com>
	<AANLkTimpDh36-edV9UkRyn-9Z0o1o7T4wFZFBVQje1Y9@mail.gmail.com>
	<AANLkTimYS+EqyGm=Bur4De3HDg+spNHLHejp0QJTcft_@mail.gmail.com>
Date: Sun, 5 Sep 2010 12:20:23 -0400
Message-ID: <AANLkTimi_Wbb414yxEfz57tjd0BkN9_oUhPLJLKzyc8a@mail.gmail.com>
Subject: Re: some question about
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: loody <miloody@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Sun, Sep 5, 2010 at 12:06 PM, loody <miloody@gmail.com> wrote:
> hi:
>
> 2010/9/5 Devin Heitmueller <dheitmueller@kernellabs.com>:
>> On Sun, Sep 5, 2010 at 11:48 AM, Devin Heitmueller
>> <dheitmueller@kernellabs.com> wrote:
>>> On Sun, Sep 5, 2010 at 11:36 AM, loody <miloody@gmail.com> wrote:
>>>> WinTV-HVR-1950 high performance USB TV tuner
>>>> WinTV-HVR-950Q for laptop and notebooks
>>>
>>> Both these devices are supported under Linux, and in fact are unlikely
>>> to work properly with only Full Speed USB.  At least the 950q
>>> definitely requires High speed (I put a check in there to specifically
>>> not load the driver otherwise).
>>
>> I perhaps misread your original email.  While the 950q does present
>> itself as a USB audio class device, the 1950 does not.  It only
>> provides MPEG encoded output (containing both the audio and video),
>> and is not a USB audio class device.
>>
>> So while both these devices will work under Linux on a high speed
>> interface, if you specifically require the device to identify itself
>> as a USB audio class device, only the 950q does this.
>>
>> Devin
> would you mind to send me the device descriptors for me?
> I want to check whether the input/output unit and audio/video format
> does meet the spec.
> BTW, will the device support mp3 output?
> since the spec define mp3 as one of input/output format.
> that means if I put the raw data of mp3 to that device, it should
> play/record well.

The device descriptors can be found here:

http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-950Q#Identification

The device does not support MP3 output (virtually no devices do as far
as I know).  It only provides raw 16-bit two channel PCM.

The video format would not be in the spec you mentioned.  It does work
as a standard V4L2 device though, providing raw YUYV video frames.

Perhaps if I better understood your intended application, I might be
able to give better advice.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
