Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:35631 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760275AbZJNNNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 09:13:00 -0400
Received: by fxm27 with SMTP id 27so11566038fxm.17
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 06:12:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091014122550.7c84bba5@ieee.org>
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
	 <20091014122550.7c84bba5@ieee.org>
Date: Wed, 14 Oct 2009 09:12:22 -0400
Message-ID: <829197380910140612t726251d6y7cff3873587101b4@mail.gmail.com>
Subject: Re: em28xx DVB modeswitching change: call for testers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Giuseppe Borzi <gborzi@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 14, 2009 at 6:25 AM, Giuseppe Borzi <gborzi@gmail.com> wrote:
>> Hello all,
>>
>> I have setup a tree that removes the mode switching code when
>> starting/stopping streaming.  If you have one of the em28xx dvb
>> devices mentioned in the previous thread and volunteered to test,
>> please try out the following tree:
>>
>> http://kernellabs.com/hg/~dheitmueller/em28xx-modeswitch
>>
>> In particular, this should work for those of you who reported problems
>> with zl10353 based devices like the Pinnacle 320e (or Dazzle) and were
>> using that one line change I sent this week.  It should also work with
>> Antti's Reddo board without needing his patch to move the demod reset
>> into the tuner_gpio.
>>
>> This also brings us one more step forward to setting up the locking
>> properly so that applications cannot simultaneously open the analog
>> and dvb side of the device.
>>
>> Thanks for your help,
>>
>> Devin
>>
> Hello Devin,
> I've just downloaded, compiled and installed em28xx-modeswitch.
> Unfortunately, it doesn't work and doesn't even
> create /dev/dvb, /dev/videoX, /dev/vbiX. Only /dev/dsp1 is created.
> The dmesg is attached to this email. As you can see it ends up in
> errors.
> One last note, I downloaded from the bz2 link.
>
> Cheers.

Did you run "make unload" before you plugged in the device?

Do me a favor - unplug the device, reboot the PC, plug it back in and
see if it still happens.  I just want to be sure this isn't some sort
of issue with conflict between the new and old modules before I debug
this any further.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
