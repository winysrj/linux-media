Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3P8HkCC007660
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 04:17:46 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [217.30.184.167])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3P8HRxo014287
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 04:17:28 -0400
Message-ID: <49F2C710.2000906@iki.fi>
Date: Sat, 25 Apr 2009 11:17:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
References: <49D644CD.1040307@powercraft.nl>
	<49D64E45.2070303@powercraft.nl>	<49DC5033.4000803@powercraft.nl>
	<49F1B2A4.3060404@powercraft.nl> <49F20259.1090302@iki.fi>
	<49F2C312.4030808@powercraft.nl>
In-Reply-To: <49F2C312.4030808@powercraft.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: one dvb-t devices not working with mplayer the other is, what
 is going wrong?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On 04/25/2009 11:00 AM, Jelle de Jong wrote:
> Antti Palosaari wrote:
>> On 04/24/2009 03:37 PM, Jelle de Jong wrote:
>>> Jelle de Jong wrote:
>>>> Jelle de Jong wrote:
>>>>> Jelle de Jong wrote:
>>>>>> Hello everybody,
>>>>>>
>>>>>> As you may read in my previous thread, i am trying to switch from my
>>>>>> em28xx devices to a device that works with gpl compliant upstream kernel
>>>>>> source code.
>>>>>>
>>>>>> My em28xx devices all played back video and audio only dvb-t channels:
>>>>>> Pinnacle PCTV Hybrid Pro Stick 330e
>>>>>> Terratec Cinergy Hybrid T USB XS
>>>>>> Hauppauge WinTV HVR 900
>>>>>>
>>>>>> I build script for this to automate the process, however i now swiched to
>>>>>> my dvb-t only usb device:
>>>>>> Afatech AF9015 DVB-T USB2.0 stick
>>>>>>
>>>>>> And it with totem-xine it plays the same as the em28xx devices, so the
>>>>>> devices does kind of works (see the totem-xine bug, please commit to this
>>>>>> bug if you have the same behavior)
>>>>>>
>>>>>> # device info
>>>>>> http://debian.pastebin.com/d3e942c02
>>>>>>
>>>>>> # totem-xine bug
>>>>>> http://bugzilla.gnome.org/show_bug.cgi?id=554319
>>>>>>
>>>>>> # mplayer issue
>>>>>> http://debian.pastebin.com/d34d92e64
>>>>>> ^ anybody have any idea what the heck goes on why doesn't mplayer work
>>>>>> with this device, nothing changed in the commands i used.
>>>>>>
>>>>>> using:
>>>>>> mplayer
>>>>>> Version: 1:1.0.rc2svn20090330-0.0
>>>>>> linux-image-2.6.29-1-686
>>>>>> Version: 2.6.29-1
>>>>>>
>>>>>> Thanks in advance, for any help.
>>>>>>
>>>>>> Best regards,
>>>>>>
>>>>>> Jelle de Jong
>>>>> some more info:
>>>>>
>>>>> device0 (not working, Afatech AF9013 DVB-T)
>>>>> http://filebin.ca/ypxkw/mplayer0.log
>>>>>
>>>>> device1 (working, Micronas DRX3973D DVB-T, em28xx, markus not gpl code)
>>>>> http://filebin.ca/zecdjm/mplayer1.log
>>>>>
>>>>> device2 (working, Zarlink MT352 DVB-T, em28xx, markus not gpl code)
>>>>> http://filebin.ca/fzxtcx/mplayer2.log
>>>>>
>>>>> All devices work with totem-xine but only the em28xx devices works with
>>>>> mplayer, whats going on?
>>>>>
>>>> Anybody?
>>>>
>>>> Best regards,
>>>>
>>>> Jelle
>>>>
>>> Would somebody be willing to test this with there device, see the first
>>> mail for the commands I used, they are in the attached files.
>>>
>>> Being able to use mplayer to listen to dvb-t radio is mandatory for me.
>> I use tzap&  mplayer always when testing driver. Never seen troubles you
>> have. And I have very many AF9015 devices. How did you launch mplayer?
>>
>> Antti
>
>
> I don't use tzap directly.
>
> This is what I do:
>
> # step 1: I use wscan to to make a channel list, there are some serious
> issues under Linux that I cant solve but like to know what is being done
> about is. The wscan tool cant get the signal strength of the channel it
> found, so it may find duplicated channels on multiple frequencies with
> different strengths. wscan should be able to eliminate all the duplicated
> channels with inferiour quality. But there is no API in v4l to do this.
>
> ~/.wscan/wscan -t 3 -E 0 -O 0 -X tzap>  ~/.wscan/channels.conf
> cp --verbose ~/.wscan/channels.conf ~/.mplayer/channels.conf
>
> # step 2: I run the mplayer command to play one of the stream
> /usr/bin/mplayer -dvbin timeout=10 dvb://"3FM(Digitenne)"

Works just OK here.

> I automated this scanning and playing system with scripts, they are
> attached together with the logs of the commands I run.

device0.log
AF9015: you are using very old firmware. Otherwise it seems to be OK.

device3.log
em28xx: crashes the Kernel => sure have problems. Are you mixing the 
drivers from v4l-dvb and from mcentral.de?

> These systems work with the em28xx devices but not with the AF9015


I think the reason is that you have tainted your Kernel with em28xx 
drivers which makes it crashing. Please install clean v4l-dvb from 
linuxtv.org, install new firmware reboot machine and test again.

regards
Antti
-- 
http://palosaari.fi/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
