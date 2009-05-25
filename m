Return-path: <linux-media-owner@vger.kernel.org>
Received: from caiajhbdcbef.dreamhost.com ([208.97.132.145]:34839 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752681AbZEYSMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 14:12:34 -0400
Message-ID: <4A1ADFE2.6060500@klepeis.net>
Date: Mon, 25 May 2009 11:13:54 -0700
From: N Klepeis <list1@klepeis.net>
Reply-To: list1@klepeis.net
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Temporary success with Pinnacle PCTV 801e (xc5000 chip)
References: <4A186764.4080007@klepeis.net> <829197380905242005p2cd41103rc1e0ecfb6c0e156f@mail.gmail.com>
In-Reply-To: <829197380905242005p2cd41103rc1e0ecfb6c0e156f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin,   Yup, works nice now.   Good work!  --Neil

Devin Heitmueller wrote:
> On Sat, May 23, 2009 at 5:15 PM, N Klepeis <list1@klepeis.net> wrote:
>> Hi,
>>
>> I installed the latest v4l-dvb from CVS with the latest firmware
>> (dvb-fe-xc5000-1.6.114.fw) for the 801e (XC5000 chip).   I can  scan for
>> channels no problem.   But after a first use with either mplayer or mythtv,
>> it then immediately stops working and won't start again until I unplug and
>> then reinsert the device from the USB port.       On the first time use
>> everything seems fine and I can watch TV through mplayer for as long as I
>> want.    On the 2nd use (restart mplayer), there's an error (FE_GET_INFO
>> error: 19, FD: 3).    On the 2nd use with mythtv, mythtv cannot connect to
>> the card at all in mythtvsetup, but on the first time use I can assign
>> channel.conf.      I know there have been recent updates to the xc5000
>> driver.    I only started trying this chip this week so I never confirmed
>> that any prior driver version worked.
>>
>> Any thoughts on how to proceed?     Below are the full console outputs when
>> using with mplayer and when running dmesg.   (This is fedora 10).
>>
>> --Neil
>>
> 
> Neil,
> 
> Already tracked down and a PULL has been requested for the patch:
> 
> http://kernellabs.com/hg/~dheitmueller/dvb-frontend-exit-fix
> 
> Cheers,
> 
> Devin
> 

