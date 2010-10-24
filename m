Return-path: <mchehab@pedra>
Received: from gateway11.websitewelcome.com ([69.93.164.12]:40368 "HELO
	gateway11.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932938Ab0JXWDA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 18:03:00 -0400
Received: from [209.85.216.46] (port=46992 helo=mail-qw0-f46.google.com)
	by gator1121.hostgator.com with esmtpsa (TLSv1:RC4-MD5:128)
	(Exim 4.69)
	(envelope-from <demiurg@femtolinux.com>)
	id 1PA8O2-000728-Jy
	for linux-media@vger.kernel.org; Sun, 24 Oct 2010 16:45:54 -0500
Received: by qwk3 with SMTP id 3so929080qwk.19
        for <linux-media@vger.kernel.org>; Sun, 24 Oct 2010 14:45:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinwb_7ErteoWcO2VC1nu9uNqUwu6N+HEhrDwwg-@mail.gmail.com>
References: <AANLkTint2Xw3bJuGh2voUpncWderrbUgbeOaPdp1-yNm@mail.gmail.com>
	<201010242055.30799.albin.kauffmann@gmail.com>
	<AANLkTinwb_7ErteoWcO2VC1nu9uNqUwu6N+HEhrDwwg-@mail.gmail.com>
Date: Sun, 24 Oct 2010 23:45:55 +0200
Message-ID: <AANLkTinVas23b2ZMuBxzdY6PUP-4JEMchNup9nSpxsf3@mail.gmail.com>
Subject: Re: Wintv-HVR-1120 woes
From: Sasha Sirotkin <demiurg@femtolinux.com>
To: Albin Kauffmann <albin.kauffmann@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Oct 24, 2010 at 10:22 PM, Sasha Sirotkin <demiurg@femtolinux.com> wrote:
> On Sun, Oct 24, 2010 at 8:55 PM, Albin Kauffmann
> <albin.kauffmann@gmail.com> wrote:
>> On Thursday 21 October 2010 23:25:29 Sasha Sirotkin wrote:
>>> I'm having all sorts of troubles with Wintv-HVR-1120 on Ubuntu 10.10
>>> (kernel 2.6.35-22). Judging from what I've seen on the net, including
>>> this mailing list, I'm not the only one not being able to use this
>>> card and no solution seem to exist.
>>>
>>> Problems:
>>> 1. The driver yells various cryptic error messages
>>> ("tda18271_write_regs: [1-0060|M] ERROR: idx = 0x5, len = 1,
>>> i2c_transfer returned: -5", "tda18271_set_analog_params: [1-0060|M]
>>> error -5 on line 1045", etc)
>>
>> yes, indeed :(
>> (cf "Hauppauge WinTV-HVR-1120 on Unbuntu 10.04" thread)
>>
>>> 2. DVB-T scan (using w_scan) produces no results
>>
>> Is this happening after each reboot? As far as I'm concerned, I've never had
>> problems with DVB-T scans.
>>
>
> Almost always. I think I had a lucky reboot or two, but most of the
> time DVB-T scan produces nothing.
>
>>> 3. Analog seems to work, but with very poor quality
>>
>> I just tried to use Analog TV in order to confirm the problem but I cannot get
>> any picture. Maybe I just don't know how to use it. I'm using commands like
>> (I'm located in France):
>>
>> mplayer tv:// -tv driver=v4l2:norm=SECAM:chanlist=france -tvscan autostart
>>
>> ... and just get some "snow" on scanned channels.
>> As I might have a problem with my antenna (an interior one), I am going to
>> test it under Windows and report back my experience.
>
> I'm using tvtime-scanner
>>
>> Cheers,
>>
>> --
>> Albin Kauffmann
>>
>
>
> I'm trying to downgrade the kernel now to see if it helps
>

I went back as far as 2.6.30 and I still have this problem. 2.6.29
does not recognize this card at all.
