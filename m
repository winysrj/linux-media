Return-path: <linux-media-owner@vger.kernel.org>
Received: from warsl404pip6.highway.telekom.at ([195.3.96.89]:11879 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751923AbZCHOVR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2009 10:21:17 -0400
Message-ID: <49B3D45B.6000606@yahoo.de>
Date: Sun, 08 Mar 2009 15:21:15 +0100
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

  Besides the direct replay issues I would like to stream the channels
to watch them on another computer anyway.

> ifconfig eth0 |g "inet Adress"
  inet Adresse:192.168.0.14  Bcast:192.168.255.255  Maske:255.255.0.0

> grep 3sat channels.conf
3sat;ZDFvision:11953:h:S19.2E:27500:210:220=deu,221=2ch;225=deu:230:0:28007:1:1079:0

> dvbstream -f 11953 -p H -s 27500 -v 210 -a 220 -udp -net 192.168.0.14:5100

promises to do the thing.
Is there any possibility to stream a file recorded by kaffeine as well?

----------------------------------------------------------------

 Nevertheless up to now I could not connect with any client:
>mplayer rtp://192.168.0.14:5100
...
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.

Playing rtp://192.168.0.14:5100.
STREAM_RTP, URL: rtp://192.168.0.14:5100
Failed to connect to server
rtp_streaming_start failed
No stream found to handle url rtp://192.168.0.14:5100


Exiting... (End of file)



  Chaining dumprtp and mplayer does not work either.
Insetead of ts2ps I had to use replex, because Opensuse
does not offer ts2ps:

> dumprtp 192.168.0.14 5100 | replex -t MPEG2 | mplayer -cache 2048 -
replex version 0.1.6.8
using stdin as input
using stdout as output
Rtp dump
Using 192.168.0.14:5100
bind failed: Cannot assign requested address
Checking for TS: failed
Checking for AVI: failed
Checking for PS: confirmed(maybe)
read 0.00 MB
Can't find all required streams
Please check if audio and video have standard IDs (0xc0 or 0xe0)
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

Playing -.
Reading from stdin...
Cache fill:  0.00% (0 bytes)


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

