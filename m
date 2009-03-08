Return-path: <linux-media-owner@vger.kernel.org>
Received: from warsl404pip4.highway.telekom.at ([195.3.96.117]:56560 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751930AbZCHOWS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2009 10:22:18 -0400
Message-ID: <49B3D498.8020506@yahoo.de>
Date: Sun, 08 Mar 2009 15:22:16 +0100
From: Elmar Stellnberger <estellnb@yahoo.de>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Technisat Skystar 2 on Suse Linux 11.1, kernel 2.6.27.19-3.2-default
References: <49B2BAAE.8040808@yahoo.de> <alpine.LRH.1.10.0903071945470.27410@pub5.ifh.de> <49B2F2E1.3090206@yahoo.de> <alpine.LRH.1.10.0903080837330.27410@pub5.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0903080837330.27410@pub5.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Having tried a couple of times to search for channels it suddenly has
worked. Kaffeine has found a lot of channels and offers to record them.
Nevertheless Kaffeine and xine are incapable of playing t-streams: no
plugin found.
  At least I had also success in creating a channels.conf via
scan -o vdr -p -x 0 Astra-19.2E. Nevertheless szap still does not terminate.
  Mplayer does not work either although I have linked channels.conf to
/etc/mplayer/channels.conf


> szap -r "3sat;ZDFvision"
reading channels from file '/home/elm/.szap/channels.conf'
zapping to 432 '3sat;ZDFvision':
sat 0, frequency = 11953 MHz H, symbolrate 27500000, vpid = 0x00d2, apid
= 0x00dc sid = 0x00e6
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal bf2e | snr 7410 | ber 000062fd | unc fffffffe |
status 1f | signal b676 | snr d49a | ber 000001db | unc fffffffe |
FE_HAS_LOCK
status 1f | signal b8d3 | snr d4c1 | ber 000000f7 | unc fffffffe |
FE_HAS_LOCK
status 1f | signal b809 | snr d4d0 | ber 00000000 | unc fffffffe |
FE_HAS_LOCK
status 1f | signal b72a | snr d4d3 | ber 00000000 | unc fffffffe |
FE_HAS_LOCK
status 1f | signal b721 | snr d4bb | ber 00000000 | unc fffffffe |
FE_HAS_LOCK
...

> mplayer dvb://'3sat;ZDFvision'
MPlayer dev-SVN-r27637-4.3-openSUSE Linux 11.1 (i686)-Packman (C)
2000-2008 MPlayer Team
CPU: AMD Athlon(TM) XP 3000+ (Family: 6, Model: 10, Stepping: 0)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 1 SSE: 1 SSE2: 0
Compiled with runtime CPU detection.
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.

Playing dvb://3sat;ZDFvision.
DVB CONFIGURATION IS EMPTY, exit
Failed to open dvb://3sat;ZDFvision.


Exiting... (End of file)
elm@fant:~> mplayer dvb://
MPlayer dev-SVN-r27637-4.3-openSUSE Linux 11.1 (i686)-Packman (C)
2000-2008 MPlayer Team
CPU: AMD Athlon(TM) XP 3000+ (Family: 6, Model: 10, Stepping: 0)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 1 SSE: 1 SSE2: 0
Compiled with runtime CPU detection.
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.

Playing dvb://.
DVB CONFIGURATION IS EMPTY, exit
Failed to open dvb://.


Exiting... (End of file)




Patrick Boettcher schrieb:
> Hi Elmar,
> 
> On Sat, 7 Mar 2009, Elmar Stellnberger wrote:
> 
>>> dvbscan -adapter 0 -frontend 0 -demux 0 /usr/share/dvb/dvb-s/Astra-19.2E
>> Failed to set frontend
> 
> I have the same problem with that scan, please use the older one called
> scan.
> 
> Are you running the szap below as root, but kaffeine as a normal user ?
> 
> If so, make sure that you are in the group video.
> 
>> downloading channel.conf from Astra1
>> has not brought me force.
>>
>>> szap 3sat
>> reading channels from file '/home/elm/.szap/channels.conf'
>> zapping to 20 '3sat':
>> sat 0, frequency = 11954 MHz V, symbolrate 27500000, vpid = 0x00d2, apid
>> = 0x00dc sid = 0x0000
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> status 00 | signal 0000 | snr 6b2b | ber 00000000 | unc fffffffe |
>> status 00 | signal 0000 | snr 7f02 | ber 00007e00 | unc fffffffe |
>> status 01 | signal aa7e | snr 3d47 | ber 0000ffe8 | unc fffffffe |
>> status 00 | signal 0000 | snr 7fc5 | ber 0000fff0 | unc fffffffe |
>> status 00 | signal 0000 | snr 2232 | ber 00006ef0 | unc fffffffe |
>> status 00 | signal 0000 | snr 1fdd | ber 00000058 | unc fffffffe |
>> status 00 | signal 0000 | snr 19b3 | ber 00000000 | unc fffffffe |
>> status 02 | signal 0000 | snr 192f | ber 00000000 | unc fffffffe |
>> status 00 | signal 0035 | snr 8469 | ber 00000000 | unc fffffffe |
> 
> This is the first proof that your device is present and the driver is
> correctly loaded. Please check the output of the dmesg-program to check
> for lines starting with b2c2-flexcop.
> 
>> what should that output mean?
> 
> it means, it can't synchronize the channel on that frequency. This can
> have a whole bunch of explaination - not necessarily only the driver.
> 
>> why does szap not terminate?
> 
> It stays in the monitoring loop. Normal.
> 
> Patrick.
> 
> -- 
>   Mail: patrick.boettcher@desy.de
>   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
> 


