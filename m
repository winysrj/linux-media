Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 246-113.netfront.net ([202.81.246.113] helo=akbkhome.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mailinglist@akbkhome.com>) id 1L81Zq-0006ZU-5I
	for linux-dvb@linuxtv.org; Thu, 04 Dec 2008 00:56:20 +0100
Received: from wideboy ([192.168.0.27]) by akbkhome.com with esmtp (Exim 4.69)
	(envelope-from <mailinglist@akbkhome.com>) id 1L81Zf-0005E6-SP
	for linux-dvb@linuxtv.org; Thu, 04 Dec 2008 07:56:08 +0800
Message-ID: <49371C96.7090301@akbkhome.com>
Date: Thu, 04 Dec 2008 07:56:06 +0800
From: Alan Knowles <mailinglist@akbkhome.com>
MIME-Version: 1.0
CC: linux-dvb@linuxtv.org
References: <60061.218.191.236.214.1216898395.squirrel@www.kshome-hk.com>
	<48891929.6060209@akbkhome.com>
	<38587.134.159.96.222.1216959940.squirrel@www.kshome-hk.com>
	<4889AA16.5050202@akbkhome.com>
	<63465.218.191.236.214.1217376684.squirrel@www.kshome-hk.com>
	<488FCE99.5060601@akbkhome.com>
	<63337.218.191.236.214.1217507560.squirrel@www.kshome-hk.com>
	<48932494.5080808@akbkhome.com>
	<14118.134.159.96.222.1227499740.squirrel@www.kshome-hk.com>
	<492A3C95.6000109@akbkhome.com>
	<63617.218.191.236.214.1227527237.squirrel@www.kshome-hk.com>
	<61445.218.191.236.214.1227534150.squirrel@www.kshome-hk.com>
	<492B39C5.4080309@akbkhome.com>
	<62147.218.191.236.214.1227610215.squirrel@www.kshome-hk.com>
	<61859.218.191.236.214.1227626213.squirrel@www.kshome-hk.com>
	<492C1A5D.7080403@akbkhome.com>
	<59753.218.191.236.214.1227946805.squirrel@www.kshome-hk.com>
	<4931ECAB.40908@akbkhome.com>
	<65345.218.191.236.214.1228051288.squirrel@www.kshome-hk.com>
In-Reply-To: <65345.218.191.236.214.1228051288.squirrel@www.kshome-hk.com>
Subject: Re: [linux-dvb] ASUS my cinema U3100 dmb-th linux source code
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


I'm cc'ing the linux-dvb list to see if they can offer suggestions
(basically - 2.6.27 kernel + v4l-dvb is giving choppy video with the
"recv bulk message failed" messages)

reducing the timeout in dvb-usb-urb.c / dvb_usb_generic_rw()

will fix the stability issues, but you still get messages.

ret = usb_bulk_msg(d->udev,usb_rcvbulkpipe(d->udev,
d->props.generic_bulk_ctrl_endpoint),rbuf,rlen,&actlen,
100);

PS. full channels.conf for HK is on my blog


Regards
Alan

K.S.Ng wrote:
> Thanks! I've tried it and it compiled and installed well under 2.6.27.
>
> However when I inserted the device, the computer ran into a brief period
> of slow response (to keyboard, mouse, etc), and 'dmesg' keep logging
> "dvb-usb: recv bulk message failed: -110", about once every 1 or 2
> seconds. Vlc also showed somewhat unstable video, with intermittent frozen
> frames. Followings kept logged out by dmesg while vlc was running:
> [ 2197.072181] dvb-usb: recv bulk message failed: -110
> [ 2197.100176] Demod ID=e
> [ 2197.122672] Demod ID=e
> [ 2197.184296] DetectDemodMode return 1
> [ 2197.388024] SignalLockCheck
> [ 2198.120013] SignalLockCheck
> [ 2199.224040] dvb-usb: recv bulk message failed: -110
> [ 2199.251164] Demod ID=e
> [ 2199.255664] Demod ID=e
> [ 2199.324162] DetectDemodMode return 1
> [ 2199.528080] u3100DMBTH set freq=482
> [ 2200.308120] SignalLockCheck
> ==== repeating ====
>
> I've tried it on two machines with 2.6.27, one with Debian Etch, and the
> other with Ubuntu 8.0.4, with v4l-dvb compiled independently following
> same procedure, and got same result. I also did a manual merging of ASUS'
> changes into the v4l-dvb source tree (obtained by 'hg') by myself, but got
> same result.
>
> I'm sure it's not reception problem as the issue doesn't happen on the
> Ubuntu 8.0.4 machine with 2.6.21 - dmesg doesn't showed any error and the
> video is quite stable.
>
> Regards,
> KS
>
>   
>> http://www.akbkhome.com/svn/asus_dvb_driver/
>>
>> I think the instructions are in the notes file.
>>
>> Regards
>> Alan
>>
>>
>>
>> K.S.Ng wrote:
>>     
>>> Do you mind sending your converted source code for 2.6.27 to me?
>>>
>>> I'm now able to play all channels (except the HD ones which are jerky)
>>> after building the latest versions of libavcodec and vlc to run under my
>>> Ubuntu 8.0.4.
>>>
>>> Thanks,
>>> KS
>>>
>>>
>>>       
>>>> I've converted the code to use with a 2.6.27 kernel
>>>>
>>>> playing nicely with vlc now - most channels appear to work on vlc,
>>>> although reception can be problematic on some channels
>>>>
>>>> I'll try and bundle up patches soon
>>>>
>>>> Regards
>>>> Alan
>>>>
>>>> K.S.Ng wrote:
>>>>
>>>>         
>>>>> Have been playing around with following findings:
>>>>> 1. vlc works great with the :dvb-frequency parameter. Subtitle on/off
>>>>> and
>>>>> audio channel selection working fine.
>>>>> 2. Don't know how to select PID with vlc command line. Tried
>>>>> 'dvb-frequency=480000000 --programs=2' successfully selecting 'TVB
>>>>> Pearl',
>>>>> but it is intermittent - sometimes not working.
>>>>> 3. Another issue with vlc is that its GUI is still displayed even when
>>>>> invoked by command line. This may not be friendly enough as my plan is
>>>>> to
>>>>> use it for background recording in my Debian server.
>>>>> 4. Tried 'vlc dvb:// :dvb-frequency=482000000 --programs=2 --sout
>>>>> file/ps:vlc_pearl.avi' for recording. Video and audio channels are
>>>>> recorded fine but not subtitles.
>>>>> 5. Tried 'dvbstream -f 482000 841 842 -o >test1.mpg' to record.
>>>>> Resulting
>>>>> file cannot be played by vlc. Playing by mplayer and xine OK but
>>>>> subtitles
>>>>> and audio channels other than the default are lost. An issue is
>>>>> dvbstream
>>>>> cannot record other carrier frequencies (the new ATV and TVB channels)
>>>>> -
>>>>> not a big issue as I just like to record the old 4 TV stations
>>>>> initially.
>>>>>
>>>>> My plan is to record programs using a perl script triggered by
>>>>> crontab.
>>>>>
>>>>> Regards,
>>>>> KS
>>>>>
>>>>>
>>>>>
>>>>>           
>>>>>> It wonderfully works with vlc, which in my case is:
>>>>>> vlc dvb:// :dvb-frequency=482000000   - for the digital version of
>>>>>> the
>>>>>> old
>>>>>> analog stations
>>>>>>
>>>>>> It also works with 'vlc dvb:// :dvb-frequency=586000000' for the new
>>>>>> TVB
>>>>>> stations (J2, Interactive News and Jade HD)! Jade HD would result in
>>>>>> a
>>>>>> frozen screen, as expected.
>>>>>>
>>>>>> 'vlc dvb:// :dvb-frequency=586000000' (for the new ATV stations) got
>>>>>> segmentation fault.
>>>>>>
>>>>>> When running vlc with 482000000, I got the followings by running
>>>>>> 'scan
>>>>>> -c
>>>>>> -o zap' on another console:
>>>>>>
>>>>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>>>> Network Name 'SFN_TVB'
>>>>>> 0x0000 0x0052: pmt_pid 0x0334 TVB -- J2 (running)
>>>>>> 0x0000 0x0053: pmt_pid 0x033e TVB -- iNews (running)
>>>>>> 0x0000 0x0055: pmt_pid 0x0352 TVB -- High Definition Jade (running)
>>>>>> dumping lists (3 services)
>>>>>> J2:1565032704:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:82
>>>>>> iNews:1565032704:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:83
>>>>>> High Definition
>>>>>> Jade:1565032704:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:85
>>>>>> Done.
>>>>>>
>>>>>> I haven't tried vdr yet.
>>>>>> The outstanding issue is still on compatibility with tzap, w_scan,
>>>>>> etc,
>>>>>> such that I cannot record a program by 'cat /dev/dvb/adapter0/dvr0 >
>>>>>> <filename>'.
>>>>>>
>>>>>> Regards,
>>>>>> KS
>>>>>>
>>>>>>
>>>>>>
>>>>>>             
>>>>>>> Have a look at my last blog post, I got it running with the eeepc
>>>>>>> binaries under vmware -
>>>>>>>
>>>>>>> vlc is quite a good way to test it, and the antenna is very picky
>>>>>>> about
>>>>>>> which direction works - it's best to try a better antenna...
>>>>>>>
>>>>>>> Regards
>>>>>>> Alan
>>>>>>>
>>>>>>> K.S.Ng wrote:
>>>>>>>
>>>>>>>
>>>>>>>               
>>>>>>>> Further note: when running w_scan, it seems to pause for some time
>>>>>>>> before
>>>>>>>> displaying '482000' - the carrier frequency for the first digital
>>>>>>>> TV
>>>>>>>> cluster in my district. It looks like w_scan does receive
>>>>>>>> something.
>>>>>>>> I'll
>>>>>>>> add some debugging code later.
>>>>>>>>
>>>>>>>> I then did further testing as follows:
>>>>>>>>
>>>>>>>> 1.  Manually create a channel.conf file two lines:
>>>>>>>> Home:482000000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:111:112:11
>>>>>>>> Pearl:482000000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:841:842:2
>>>>>>>> (Most fields are wrong, I know, except the frequencies, video PIDs,
>>>>>>>> audio
>>>>>>>> PIDs and service IDs, which should be correct.)
>>>>>>>>
>>>>>>>> 2. Run 'tzap -c channel.conf Pearl' - it produces following output:
>>>>>>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>>>>>> tuning to 482000000 Hz
>>>>>>>> video pid 0x0349, audio pid 0x034a
>>>>>>>> status 1f | signal 521a | snr 0000 | ber b7f16ff4 | unc 00000001 |
>>>>>>>> FE_HAS_LOCK
>>>>>>>> status 1f | signal 521a | snr 0000 | ber b7f16ff4 | unc 00000001 |
>>>>>>>> FE_HAS_LOCK
>>>>>>>> status 1f | signal 521a | snr 0000 | ber b7f16ff4 | unc 00000001 |
>>>>>>>> FE_HAS_LOCK
>>>>>>>>   === above line keeps repeating ===
>>>>>>>>
>>>>>>>> 3. While tzap still running, I ran 'scan -c -o zap > c.conf', which
>>>>>>>> gives:
>>>>>>>> 0x0000 0x0001: pmt_pid 0x032a TVB -- Jade (running)
>>>>>>>> 0x0000 0x0002: pmt_pid 0x0348 TVB -- Pearl (running)
>>>>>>>> 0x0000 0x000b: pmt_pid 0x006e (null) -- Home  (running)
>>>>>>>> 0x0000 0x0010: pmt_pid 0x00a0 (null) -- World  (running)
>>>>>>>> dumping lists (4 services)
>>>>>>>> Done.
>>>>>>>> pc4:~/dvb$ cat c.conf
>>>>>>>> Jade:0:h:0:0:811:0:1
>>>>>>>> Pearl:0:h:0:0:841:0:2
>>>>>>>> Home :0:h:0:0:111:0:11
>>>>>>>> World :0:h:0:0:161:0:16
>>>>>>>>
>>>>>>>> 4. While tzap still running, I ran 'mplayer
>>>>>>>> /dev/dvb/adapter0/dvr0',
>>>>>>>> but
>>>>>>>> nothing displayed.
>>>>>>>>
>>>>>>>> This is the progress so far.
>>>>>>>>
>>>>>>>> Regards,
>>>>>>>> KS
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>                 
>>>>>>>>> I couldn't wait to give it a try, but w_scan is still not able to
>>>>>>>>> scan
>>>>>>>>> any
>>>>>>>>> station. Below's what I've got:
>>>>>>>>>
>>>>>>>>> test machine: Ubuntu 8.04 on AMD X2 4800+
>>>>>>>>> 1. As expected, it couldn't compile against kernel 2.6.24 - lot of
>>>>>>>>> errors.
>>>>>>>>> 2. Switched to custom built kernel 2.6.21.4
>>>>>>>>> 3. Compilation of source code without problem (except you need to
>>>>>>>>> chmod
>>>>>>>>> u+x to v4l/scripts, and to run a small script to change the
>>>>>>>>> \x0d\x0a
>>>>>>>>> to
>>>>>>>>> \x0a for the files in it).
>>>>>>>>> 4. Attached is the log obtained when the device is inserted. It
>>>>>>>>> looks
>>>>>>>>> fine.
>>>>>>>>> 5. w_scan failed to scan any station.
>>>>>>>>>
>>>>>>>>> Probably it's compatibility problem with w_scan.
>>>>>>>>>
>>>>>>>>> Regards,
>>>>>>>>> KS
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>                   
>>>>>>>>>> wow, this looks really promising, the code in dib3000mc.c is
>>>>>>>>>> significantly different from previous versions they have
>>>>>>>>>> released.
>>>>>>>>>>
>>>>>>>>>> I'll start having another play with it later this week
>>>>>>>>>>
>>>>>>>>>> Regards
>>>>>>>>>> Alan
>>>>>>>>>>
>>>>>>>>>> K.S.Ng wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>                     
>>>>>>>>>>> I chased up ASUS for an updated source file, and finally got the
>>>>>>>>>>> one
>>>>>>>>>>> attached. I haven't tried it but at least in dvb-usb-ids.h I can
>>>>>>>>>>> find
>>>>>>>>>>> the
>>>>>>>>>>> IDs 0x1721 and 0x1722.
>>>>>>>>>>>
>>>>>>>>>>> Regards,
>>>>>>>>>>> KS
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>                       
>>>>         
>>>       
>>
>>     
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
