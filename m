Return-path: <mchehab@pedra>
Received: from mx6.orcon.net.nz ([219.88.242.56]:57938 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab1D3MKE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 08:10:04 -0400
Received: from Debian-exim by mx6.orcon.net.nz with local (Exim 4.69)
	(envelope-from <mstuff@read.org.nz>)
	id 1QG8zq-00068w-Qm
	for linux-media@vger.kernel.org; Sun, 01 May 2011 00:10:02 +1200
Message-ID: <4DBBFC18.2000900@read.org.nz>
Date: Sun, 01 May 2011 00:10:00 +1200
From: Morgan Read <mstuff@read.org.nz>
MIME-Version: 1.0
To: Robert Longbottom <rongblor@googlemail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: OK szap is looking better, and I feel so close...
References: <BANLkTimi5Tz2ER=6y93SH3JFXqb-w=7A0g@mail.gmail.com> <4DBBDDBF.4020704@googlemail.com> <4DBBED3F.4040000@read.org.nz> <4DBBF7A1.5050504@googlemail.com>
In-Reply-To: <4DBBF7A1.5050504@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 30/04/11 23:50, Robert Longbottom wrote:
> On 30/04/2011 12:06, Morgan Read wrote:
>> On 30/04/11 22:00, Robert Longbottom wrote:
>>> On 30/04/2011 10:37, Morgan Read wrote:
>>>> OK, think I might be getting somewhere...
>>>>
>>> <snip>
>>>
>>>> [user@vortexbox ~]$ szap -r TV2
>>>> reading channels from file '/home/user/.szap/channels.conf'
>>
>> ...
>>
>>>> But, nothing happens at Playing /dev/dvb/adapter0/dvr0. ...  Where
>>>> should I see what's playing?
>>>
>>> I usually do:
>>>
>>> $ cat /dev/dvb/adapter0/dvr0>  recording.mpg
>>>
>>> and then in another terminal
>>>
>>> $ mplayer recording.mpg
>>>
>>> Though it doesn't look like thats your problem, but at least you can see
>>> if any data is being retrieved if the file grows in size.
>>
>> Robert, thanks for your help!!!
>> Didn't get far with
>>
>> $ cat /dev/dvb/adapter0/dvr0>  recording.mpg
>> $ mplayer recording.mpg
>> [vortexbox.lan ~]# cat /dev/dvb/adapter0/dvr0>  recording.mpg
>> ^C
>> [vortexbox.lan ~]# ls -l
>> total 36
>> -rw-rw-r-- 1 user user  368 Apr 30 21:11 channels.conf
>> drwxr-xr-x 2 user user 4096 Apr 30 12:55 Desktop
>> drwxr-xr-x 2 user user 4096 Apr 29 22:22 Documents
>> drwxr-xr-x 2 user user 4096 Apr 29 22:34 Downloads
>> drwxr-xr-x 2 user user 4096 Apr 25 00:06 Music
>> drwxr-xr-x 2 user user 4096 Apr 25 00:06 Pictures
>> drwxr-xr-x 2 user user 4096 Apr 25 00:06 Public
>> -rw-rw-r-- 1 user user    0 Apr 30 22:53 recording.mpg
>> drwxr-xr-x 2 user user 4096 Apr 25 00:06 Templates
>> drwxr-xr-x 2 user user 4096 Apr 25 00:06 Videos
>> [vortexbox.lan ~]#
> 
> Yes, I'm not that surpised that made no difference.  The problem it
> looks like you are having with the szap approach is that szap isn't
> locking onto a channel for some reason.  You aren't seeing those
> FE_HAS_LOCK messages in the szap output.  If you can sort that out, then
> szap + (cat +) mplayer should work.
> 
>> BUT, that gave me an idea...
>>
>> [vortexbox.lan ~]# dvbstream -f 1183 -s 22500 -p h -o 512 650>
>> recording.mpg
>> dvbstream v0.5 - (C) Dave Chapman 2001-2004
>> Released under the GPL.
>> Latest version available from http://www.linuxstb.org/
>> Using DVB card "Conexant CX24123/CX24109"
>> tuning DVB-S to L-Band:1, Pol:H Srate=22500000, 22kHz=off
>> ERROR setting tone
>> : Invalid argument
>> polling....
>> Getting frontend event
>> FE_STATUS:
>> polling....
>> Getting frontend event
>> FE_STATUS: FE_HAS_SIGNAL
>> polling....
>> Getting frontend event
>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
>> FE_HAS_SYNC
>> Event:  Frequency: 11783000
>>          SymbolRate: 22500000
>>          FEC_inner:  3
>>
>> Bit error rate: 0
>> Signal strength: 61952
>> SNR: 57635
>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
>> FE_HAS_SYNC
>> Setting filter for PID 512
>> Setting filter for PID 650
>> Output to stdout
>> Streaming 2 streams
>>
>> Which produced this:
>>
>> [user@vortexbox ~]$ mplayer recording.mpg
>> MPlayer SVN-r33254-snapshot-4.5.1 (C) 2000-2011 MPlayer Team
>> 162 audio&  360 video codecs
>> Can't open joystick device /dev/input/js0: No such file or directory
>> Can't init input joystick
>> mplayer: could not connect to socket
>> mplayer: No such file or directory
>> Failed to open LIRC support. You will not be able to use your remote
>> control.
>>
>> Playing recording.mpg.
>> TS file format detected.
>> VIDEO MPEG2(pid=512) AUDIO MPA(pid=650) NO SUBS (yet)!  PROGRAM N. 0
>> VIDEO:  MPEG2  720x576  (aspect 3)  25.000 fps  15000.0 kbps (1875.0
>> kbyte/s)
>> Load subtitles in ./
>> ==========================================================================
>>
>> Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
>> Selected video codec: [ffmpeg2] vfm: ffmpeg (FFmpeg MPEG-2)
>> ==========================================================================
>>
>> ==========================================================================
>>
>> Opening audio decoder: [mp3lib] MPEG layer-2, layer-3
>> AUDIO: 48000 Hz, 2 ch, s16le, 192.0 kbit/12.50% (ratio: 24000->192000)
>> Selected audio codec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
>> ==========================================================================
>>
>> AO: [pulse] 48000Hz 2ch s16le (2 bytes per sample)
>> Starting playback...
>> [VD_FFMPEG] Trying pixfmt=0.
>> Could not find matching colorspace - retrying with -vf scale...
>> Opening video filter: [scale]
>> The selected video_out device is incompatible with this codec.
>> Try appending the scale filter to your filter list,
>> e.g. -vf spp,scale instead of -vf spp.
>> [VD_FFMPEG] Trying pixfmt=1.
>> Could not find matching colorspace - retrying with -vf scale...
>> Opening video filter: [scale]
>> The selected video_out device is incompatible with this codec.
>> Try appending the scale filter to your filter list,
>> e.g. -vf spp,scale instead of -vf spp.
>> [VD_FFMPEG] Trying pixfmt=2.
>> Could not find matching colorspace - retrying with -vf scale...
>> Opening video filter: [scale]
>> The selected video_out device is incompatible with this codec.
>> Try appending the scale filter to your filter list,
>> e.g. -vf spp,scale instead of -vf spp.
>> Movie-Aspect is 1.78:1 - prescaling to correct movie aspect.
>> VO: [xv] 720x576 =>  1024x576 Planar YV12
>> A:90135.5 V:90135.5 A-V:  0.001 ct:  0.093 13786/13786  6%  0%  0.5% 0 0
>>
>>
>> MPlayer interrupted by signal 2 in module: sleep_timer
>> A:90135.6 V:90135.6 A-V:  0.001 ct:  0.093 13787/13787  6%  0%  0.5% 0 0
>>
>> Exiting... (Quit)
>> [user@vortexbox ~]$
>>
>> And, moving pictures!!!
> 
> At least you know your hardware is working :-)
> 
>>
>> BUT what the frig am I watching of all the channels that have been
>> defined...?
> 
> I'd say you are watching "U", because you passed arguments "512 650" to
> dvbstream (I'm not really familiar with dvbstream) and your channel list
> from when you ran dvsscan earlier listed these channels:
> 
>> Network Name 'Freeview'
>> dumping lists (10 services)
>> Maori TV:12483:h:0:22500:514:652:1025
>> TV ONE:12483:h:0:22500:515:653:1035
>> TV2:12483:h:0:22500:516:654:1036
>> TVNZ 7:12483:h:0:22500:518:656:1038
>> U:12483:h:0:22500:512:650:1904
>> TV ONE:12483:h:0:22500:519:657:1908
>> TV ONE:12483:h:0:22500:513:651:1909
>> TV ONE:12483:h:0:22500:517:655:1910
>> TS 22 IEPG DATA SERVICE:12483:h:0:22500:0:0:9022
>> [000-fffe]:12483:h:0:22500:0:0:65534
>> Done.
> 
> and the channel "U" is U:12483:h:0:22500:512:650:1904, note the "512"
> and the "650".
> 
> Presumably if you run dvbstream with (eg) "515 653" instead you would
> get "TV ONE".
> 
> 
>>
>> Thanks very much for your help!!!  Now I just need to work out what's
>> going on!
>>
>> Or, is the tuner simply stuck on what ever it was last put on?  And, if
>> so - how to change channels?
> 
> As I understand it and based on my experience, if you run szap (and it
> gets a lock on a channel, which is looks like yours isn't for some
> reason) and then you stop szap the tuner will remain locked onto the
> channel for some period of time after you ^C szap.  But the tuner may
> (and usually does) drift off station and so out of tune.  I don't know
> what determines how long the tuner stays locked onto channel for and
> whether this is some specific timeout thats in the drivers, or whether
> it's just down to the way the electronics work.  This is why you need to
> keep szap running to keep the tuner locked onto the channel if you are
> doing this sort of thing with command line tools.  Of course if you use
> a "tv viewing application" it deals with all of this for you.
> 
> Keep trying!
> Robert.
Hay, thanks Robert - Now I can both watch tv and change channels!!!
That's enough success for 1 night zzzzzzzzzzzz

Thanks,
m.

-- 
Morgan Read
NEW ZEALAND
<mailto:mstuffATreadDOTorgDOTnz>

Confused about DRM?
Get all the info you need at:
http://drm.info/
