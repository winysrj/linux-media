Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:55986 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZGJBF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2009 21:05:26 -0400
Received: by yxe14 with SMTP id 14so169207yxe.33
        for <linux-media@vger.kernel.org>; Thu, 09 Jul 2009 18:05:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A4E2B45.8080607@powercraft.nl>
References: <4A4481AC.4050302@powercraft.nl> <4A4D34B3.8050605@iki.fi>
	 <4A4E2B45.8080607@powercraft.nl>
Date: Thu, 9 Jul 2009 21:05:25 -0400
Message-ID: <829197380907091805h10bcf548kbf5435feeb30e067@mail.gmail.com>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jelle de Jong <jelledejong@powercraft.nl>,
	Antti Palosaari <crope@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 3, 2009 at 12:01 PM, Jelle de Jong<jelledejong@powercraft.nl> wrote:
> Antti Palosaari wrote:
>> On 06/26/2009 11:07 AM, Jelle de Jong wrote:
>>> Hi all,
>>>
>>> Because i now use a new kernel and new mplayer versions I did some
>>> testing again on one of my long standing issues.
>>>
>>> My Afatech AF9015 DVB-T USB2.0 stick does not work with mplayer, other
>>> em28xx devices do work with mplayer.
>>>
>>> Would somebody be willing to do some tests and see if mplayers works on
>>> your devices?
>>>
>>> Debian 2.6.30-1
>>>
>>> /usr/bin/mplayer -identify -v -dvbin timeout=10 dvb://"3FM(Digitenne)"
>>>
>>> See the attachments for full details.
>>
>> For me, this works. I tested this with MT2060 tuner device, as you have
>> also. If I remember correctly it worked for you also when channel is
>> selected by using tzap. I don't know what mplayer does differently.
>>
>> Do the television channels in that same multiplex work with mplayer?
>> /usr/bin/mplayer -identify -v -dvbin timeout=10 dvb://"TELEVISION CHANNEL"
>>
>> I added some delay for demod to wait lock. Could you try if this helps?
>> http://linuxtv.org/hg/~anttip/af9015_delay/
>>
>> regards
>> Antti
>
> Hi Antti,
>
> I will get back to this next week, its a lot of work for me to compile
> the drivers but I will see if i can get it running. (a pre-compiled
> driver and some insmod for the 686 2.9.30 kernel would be an fast track
> option if you want to test it a.s.a.p.)
>
> Thanks in advance,
>
> Jelle de Jong
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Antti,

Thanks to Jelle providing an environment to debug the issue in, I
isolated the problem.  This is actually a combination of bugs in
mplayer and the af9013 driver not handling the condition as gracefully
as some other demods.

First the bugs in mplayer:

The following is the line from the channels.conf where tuning failed:

Frequency in question:
3FM(Digitenne):722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO:0:7142:1114

Mplayer does not support "TRANSMISSION_MODE_AUTO",
"GUARD_INTERVAL_AUTO" and "QAM_AUTO" (for the constellation).  In the
case of the transmission mode and constellation, mplayer does not
populate the field at all in the struct sent to the ioctl(), so you
get whatever garbage is on the stack.  For the guard interval field,
it defaults to GUARD_INTERVAL_1_4 if it is an unrecognized value.

I confirmed the mplayer behavior with the version Jelle has, as well
as checking the source code in the svn trunk for the latest mplayer.

So, why does it work with some tuners but not the af9013?  Well, some
demodulators check to see if *any* of the fields are "_AUTO" and if
any of them are, then it puts the demod into auto mode and disregards
whatever is in the other fields.  However, the af9013 looks at each
field, and if any of them are an unrecognized value, the code bails
out in af9013_set_ofdm_params().   As a result, the tuning never
actually happens.

The behavior should be readily apparent if you were to put the above
line into your channels.conf and try to tune (note I had to add
printk() lines to af9013_set_ofdm_params() to see it bail out in the
first switch statement.

Anitti, do you want to take it from here, or would you prefer I rework
the routine to put the device into auto mode if any of the fields are
auto?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
