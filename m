Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KnEOz-0004vS-BW
	for linux-dvb@linuxtv.org; Tue, 07 Oct 2008 17:23:11 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8D00919K0JZ9B0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 07 Oct 2008 11:22:35 -0400 (EDT)
Date: Tue, 07 Oct 2008 11:21:55 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <002d01c9282d$9494aa20$bdbdfe60$@net>
To: Dustin Coates <dcoates@systemoverload.net>
Message-id: <48EB7E93.5080200@linuxtv.org>
MIME-version: 1.0
References: <000001c91f6f$e23ab920$a6b02b60$@net>
	<000001c921f0$7d4aede0$77e0c9a0$@net> <48E11A2F.5030901@linuxtv.org>
	<48E130EB.20006@systemoverload.net> <48E135F0.60808@systemoverload.net>
	<48E14224.6090309@linuxtv.org> <48E1470F.6000207@systemoverload.net>
	<48E2EADB.3050209@systemoverload.net>
	<48E2FAC4.2020202@systemoverload.net>
	<48E3026A.6050904@systemoverload.net>
	<002d01c9282d$9494aa20$bdbdfe60$@net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1800 Analouge Issues
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

Dustin Coates wrote:
> 
> 
> Dustin Coates wrote:
>> Dustin Coates wrote:
>>   
>>> Dustin Coates wrote:
>>>   
>>>     
>>>> Steven Toth wrote:
>>>>     
>>>>       
>>>>> Dustin Coates wrote:
>>>>>       
>>>>>         
>>>>>> Dustin Coates wrote:
>>>>>>         
>>>>>>           
>>>>>>> Steven Toth wrote:
>>>>>>>  
>>>>>>>           
>>>>>>>             
>>>>>>>> Dustin Coates wrote:
>>>>>>>>  
>>>>>>>>             
>>>>>>>>               
>>>>>>>>>  
>>>>>>>>>
>>>>>>>>>  
>>>>>>>>>
>>>>>>>>> *From:* linux-dvb-bounces@linuxtv.org 
>>>>>>>>> [mailto:linux-dvb-bounces@linuxtv.org] *On Behalf Of *Dustin Coates
>>>>>>>>> *Sent:* Thursday, September 25, 2008 7:36 PM
>>>>>>>>> *To:* linux-dvb@linuxtv.org
>>>>>>>>> *Subject:* [linux-dvb] HVR-1800 Analouge Issues
>>>>>>>>>
>>>>>>>>>  
>>>>>>>>>
>>>>>>>>> Hi Everyone,
>>>>>>>>>
>>>>>>>>>  
>>>>>>>>>
>>>>>>>>>                 Ok I've recently decided to start seeing if I can 
>>>>>>>>> figure out the issue with the Analouge, on this card, first my 
>>>>>>>>> normal dmesg.
>>>>>>>>>       
>>>>>>>>>               
>>>>>>>>>                 
>>>>>>>> The analog encoder works fine for me.
>>>>>>>>
>>>>>>>> In my case the basic analog tuner is usually /dev/video0 and the 
>>>>>>>> encoder is video1.
>>>>>>>>
>>>>>>>> Launch tvtime (which opens video0) tune and everything is fine, 
>>>>>>>> then cat /dev/video1 >test.mpg is working as expected.
>>>>>>>>
>>>>>>>> - Steve
>>>>>>>>
>>>>>>>>
>>>>>>>>     
>>>>>>>>             
>>>>>>>>               
>>>>>>> Ok, TVTime works, still some static on a mostly the lower, and higher
>>>>>>> channels.
>>>>>>>
>>>>>>> Mythtv is only showing a green screen.
>>>>>>>
>>>>>>>
>>>>>>> _______________________________________________
>>>>>>> linux-dvb mailing list
>>>>>>> linux-dvb@linuxtv.org
>>>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>>>>   
>>>>>>>           
>>>>>>>             
>>>>>> Mythbackend.log is showing these errors.
>>>>>>
>>>>>> VIDIOCGCHAN: Invalid argument
>>>>>> VIDIOCMCAPTUREi0: Invalid argument
>>>>>> VIDIOCMCAPTUREi1: Invalid argument
>>>>>> VIDIOCMCAPTURE0: Invalid argument
>>>>>> VIDIOCMCAPTURE1: Invalid argument
>>>>>>
>>>>>>
>>>>>> I think if i can get past these errors it might just work...
>>>>>>         
>>>>>>           
>>>>> When tvtime was running can you try cat /dev/video1 >test.mpg as I 
>>>>> suggested?
>>>>>
>>>>> - Steve
>>>>>       
>>>>>         
>>>> OK, when i load tvtime as tvtime --device=/dev/video1
>>>>
>>>> I get the an error.
>>>>
>>>> Videoinput: Driver refuses to set norm: Invalid argument
>>>>
>>>> When i load tvtime as /dev/video0
>>>>
>>>> I get a picture, but it's interlaced with a lot of static
>>>>
>>>> Then when i try to cat /dev/video0 i get a Device or resource busy
>>>>
>>>> cat /dev/video1, no errors . I play the file, and i get static, barley 
>>>> see picture, i can hear audio though.
>>>>
>>>> Uploaded the video file to: (only 14MB) 
>>>> http://systemoverload.net/test.mpg
>>>>
>>>> When  i set it up in mythtv i set it up as an analogue card.
>>>>
>>>> Setting it to /dev/video1 gives me these errors in mythbackend.log.
>>>>
>>>> 2008-09-29 16:15:40.761 Channel(/dev/video1) Error: 
>>>> SetInputAndFormat(2, NTSC)
>>>>            while setting format (v4l v2)
>>>>            eno: Invalid argument (22)
>>>> 2008-09-29 16:15:40.763 Channel(/dev/video1) Error: 
>>>> SetInputAndFormat(2, NTSC)
>>>>            while setting format (v4l v2)
>>>>            eno: Invalid argument (22)
>>>> 2008-09-29 16:15:40.764 Channel(/dev/video1) Error: 
>>>> SetInputAndFormat(2, ATSC)
>>>>            while setting format (v4l v2)
>>>>            eno: Invalid argument (22)
>>>> 2008-09-29 16:15:40.765 Channel(/dev/video1): SetInputAndFormat() failed
>>>> 2008-09-29 16:15:40.765 TVRec(2) Error: Failed to set channel to 2.
>>>> 2008-09-29 16:15:40.787 TVRec(2) Error: GetProgramRingBufferForLiveTV()
>>>>            ProgramInfo is invalid.
>>>> ProgramInfo: channame() startts(Mon Sep 29 16:15:40 2008) endts(Mon 
>>>> Sep 29 16:15:40 2008)
>>>>             recstartts(Mon Sep 29 16:15:40 2008) recendts(Mon Sep 29 
>>>> 16:15:40 2008)
>>>>             title()
>>>> VIDIOCGMBUF:: Invalid argument
>>>> 2008-09-29 16:15:41.849 AutoExpire: CalcParams(): Max required Free 
>>>> Space: 2.0 GB w/freq: 15 min
>>>> 2008-09-29 16:16:21.869 TVRec(2): Changing from WatchingLiveTV to None
>>>> 2008-09-29 16:16:21.888 Finished recording : channel 4294967295
>>>> 2008-09-29 16:16:21.892 scheduler: Finished recording: : channel 
>>>> 4294967295
>>>>
>>>> Setting it to /dev/video0 gives me the errors posted in my last email.
>>>>
>>>>
>>>>     
>>>>       
>>> To update myself.
>>>
>>> I got it working in mythtv. Still *alot *of static. Hangs on changing 
>>> channels in mythtv.
>>>
>>> Errors in dmesg are these.
>>>
>>> [ 4538.192246] format_by_fourcc(0x32315559) NOT FOUND
>>> [ 4538.193849] format_by_fourcc(0x32315559) NOT FOUND
>>> [ 4538.195655] format_by_fourcc(0x32315559) NOT FOUND
>>> [ 4538.204829] format_by_fourcc(0x32315559) NOT FOUND
>>> [ 4538.206956] format_by_fourcc(0x32315559) NOT FOUND
>>> [ 4538.208796] format_by_fourcc(0x32315559) NOT FOUND
>>> [ 4538.231697] format_by_fourcc(0x32315559) NOT FOUND
>>> [ 4538.250161] format_by_fourcc(0x32315559) NOT FOUND
>>> [ 4909.035067] Firmware and/or mailbox pointer not initialized or 
>>> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
>>> [ 4909.035089] Firmware and/or mailbox pointer not initialized or 
>>> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
>>> [ 4909.035106] Firmware and/or mailbox pointer not initialized or 
>>> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
>>> [ 4909.035123] Firmware and/or mailbox pointer not initialized or 
>>> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
>>> [ 4909.035138] Firmware and/or mailbox pointer not initialized or 
>>> corrupted, signature = 0xfeffffff, cmd = SET_AUDIO_PROPERTIES
>>> [ 4909.035880] Firmware and/or mailbox pointer not initialized or 
>>> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
>>> [ 4909.035897] Firmware and/or mailbox pointer not initialized or 
>>> corrupted, signature = 0xfeffffff, cmd = SET_BIT_RATE
>>> [ 4909.037081] Firmware and/or mailbox pointer not initialized or 
>>> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
>>> [ 4909.037097] Firmware and/or mailbox pointer not initialized or 
>>> corrupted, signature = 0xfeffffff, cmd = SET_BIT_RATE
>>> [ 4909.038460] Firmware and/or mailbox pointer not initialized or 
>>> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
>>> [ 4910.041384] Firmware and/or mailbox pointer not initialized or 
>>> corrupted, signature = 0xfeffffff, cmd = PING_FW
>>>
>>>
>>> I belive if we can get these sorted out....it will be working good
>>>
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>   
>>>     
>> I figured out the format_by_fourcc errors are due to an incorrect 
>> compression format set in cx23885-video.c. Refering to this post, 
>> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29935.html. I made 
>> the changes suggest. The errors are gone, but video is black, audio is 
>> static on and off. Akin to switching channels when the cable is out.
>>
>> So question. How would i go about finding the correct compression format 
>> for the HVR-1800. I think this would bring us one step closer...
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>   
> With a little tinkering i got rid of the forcecc error by changing one 
> line in the cx23885-video.c,  while keeping the video as it is...
> 
> diff -r cx23885-video.c cx23885-video.bak
> 148c148
> <         .depth    = 16,
> ---
>  >         .depth    = 32,
> 
> 
> Still same old static picture on the video (refer to uploaded video 
> earlier post). Hangs while changing channels. Still getting the firmware 
> errors.
> 
> [  170.043529] Firmware and/or mailbox pointer not initialized or 
> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
> [  170.043552] Firmware and/or mailbox pointer not initialized or 
> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
> [  170.043568] Firmware and/or mailbox pointer not initialized or 
> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
> [  170.043584] Firmware and/or mailbox pointer not initialized or 
> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
> [  170.043600] Firmware and/or mailbox pointer not initialized or 
> corrupted, signature = 0xfeffffff, cmd = SET_AUDIO_PROPERTIES
> [  170.044920] Firmware and/or mailbox pointer not initialized or 
> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
> [  170.044937] Firmware and/or mailbox pointer not initialized or 
> corrupted, signature = 0xfeffffff, cmd = SET_BIT_RATE
> [  170.046521] Firmware and/or mailbox pointer not initialized or 
> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
> [  170.046536] Firmware and/or mailbox pointer not initialized or 
> corrupted, signature = 0xfeffffff, cmd = SET_BIT_RATE
> [  170.047762] Firmware and/or mailbox pointer not initialized or 
> corrupted, signature = 0xfeffffff, cmd = SET_OUTPUT_PORT
> [  171.045396] Firmware and/or mailbox pointer not initialized or 
> corrupted, signature = 0xfeffffff, cmd = PING_FW
> 
> 
> [Dustin Coates] 
> 
> Well, I've blacklisted the module, I'm tired of fooling with it, and not
> getting any help. Guess it's a $140 paper weight till sometimes gets time or
> cares. 

Pity, I can run all of these things concurrently:

1. tvtime watching live TV (no audio though)
2. cat /dev/video1 >mpg (or using mplayer and reading the input) I get 
good video and audio
3. azap -r WABC-DT (and streaming ATSC or QAM).

I can't say I've tried MythTV, I haven't.

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
