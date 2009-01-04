Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail962c35.nsolutionszone.com ([209.235.152.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ebauer71@centurytel.net>) id 1LJb29-0003lm-As
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 23:01:22 +0100
Message-ID: <496131A6.9050108@centurytel.net>
Date: Sun, 04 Jan 2009 16:01:10 -0600
From: Eric Bauer <ebauer71@centurytel.net>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <4960D592.9070400@centurytel.net>	<1231091162.3125.6.camel@palomino.walls.org>
	<49611FB9.2080409@centurytel.net>
In-Reply-To: <49611FB9.2080409@centurytel.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problem Searching Channels
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1010482261=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1010482261==
Content-Type: multipart/alternative;
 boundary="------------000206010804070602060905"

This is a multi-part message in MIME format.
--------------000206010804070602060905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Again Andy,

I was able to fix the problem reported by dmesg about the firmware.  I 
downloaded the firmware files from here:

 http://hauppauge.lightpath.net/software/install_cd/hauppauge_cd_3.4d1.zip

and installed the one I needed.  I restarted the system just to be 
safe.  Dmesg now does not report any problems with the firmware.  
However, scandvb still does not finish or find anything.  Any thoughts 
about it?

Thanks,

Eric

Eric Bauer wrote:
> Hello Andy,
>
> Thanks for the reply.  I am really stuck on this.  I am using Fedora8, 
> so I did a yum install of the latest dvb-tools application, but I'm 
> not sure which version it is.  I am executing this command:
>
> $ scandvb 
> /usr/share/dvb-apps/atsc/us-Cable-Standard-center-frequencies-QAM256
>
> On your advice, I checked as discovered that I was running verison 
> 1.0.0 of the cx18 drive.  I downloaded the latest cx18 driver and 
> installed it.  After running the modprobe as instructed, scandvb could 
> no longer find the device in the /dev directory.  After rebooting, 
> scandvb worked again and modinfo reports that I am running version 
> 1.0.4 of cx18.  Unfortunately, after several minutes of scanning, the 
> same thing is happening.  The scan will not complete.
>
> I don't know if this is important or not.  I tried scanning using a 
> couple other firequency files.  us-Cable-IRC-center-frequencies-QAM256 
> does the same thing, but us-Cable-HRC-center-frequencies-QAM256
>  completes without error, it just does not find any channels. 
>
> I found some interesting stuff in the dmesg output.  I have a 
> Happaugue HVR-1600 model 1178, but tveeprom is reporting that it is 
> model 74041.  Seems like this might explain where my problem is coming 
> from, but I don't know how to fix it.  Here is the dmesg output:
>
> /cx18:  Start initialization, version 1.0.4
> cx18-0: Initializing card #0
> cx18-0: Autodetected Hauppauge card
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 21 (level, low) -> IRQ 21
> cx18-0: Unreasonably low latency timer, setting to 64 (was 32)
> cx18-0: cx23418 revision 01010000 (B)
> tveeprom 1-0050: Hauppauge model 74041, rev C5B2, serial# 2884991
> tveeprom 1-0050: MAC address is 00-0D-FE-2C-05-7F
> tveeprom 1-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
> tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
> tveeprom 1-0050: audio processor is CX23418 (idx 38)
> tveeprom 1-0050: decoder processor is CX23418 (idx 31)
> tveeprom 1-0050: has no radio, has IR receiver, has IR transmitter
> cx18-0: Autodetected Hauppauge HVR-1600
> cx18-0: Raw VBI supported; Sliced VBI is not yet supported
> firewire_core: created device fw0: GUID 0090270001f82fe5, S400
> tuner 2-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
> cs5345 1-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
> tuner-simple 2-0061: creating new instance
> tuner-simple 2-0061: type set to 50 (TCL 2002N)
> cx18-0: Registered device video0 for encoder MPEG (64 x 32 kB)
> DVB: registering new adapter (cx18)
> MXL5005S: Attached at address 0x63
> DVB: registering adapter 0 frontend 3332 (Samsung S5H1409 QAM/8VSB 
> Frontend)...
> cx18-0: DVB Frontend registered
> cx18-0: Registered DVB adapter0 for TS (32 x 32 kB)
> cx18-0: Registered device video32 for encoder YUV (16 x 128 kB)
> cx18-0: Registered device vbi0 for encoder VBI (60 x 17328 bytes)
> cx18-0: Registered device video24 for encoder PCM audio (256 x 4 kB)
> cx18-0: Initialized card #0: Hauppauge HVR-1600
> cx18:  End initialization
> /
> And the a little further down...
>
> f/irmware: requesting v4l-cx23418-cpu.fw
> cx18-0: Unable to open firmware v4l-cx23418-cpu.fw
> cx18-0: Did you put the firmware in the hotplug firmware directory?
> cx18-0: Retry loading firmware
> firmware: requesting v4l-cx23418-cpu.fw
> cx18-0: Unable to open firmware v4l-cx23418-cpu.fw
> cx18-0: Did you put the firmware in the hotplug firmware directory?
> cx18-0: Failed to initialize firmware starting DVB feed
> cx18-0: Failed to initialize firmware starting DVB feed
> Press any key to continue.../
>
>
> Any thoughts about this?
>
> Thanks,
>
> Eric
>
>
> Andy Walls wrote:
>> On Sun, 2009-01-04 at 09:28 -0600, Eric Bauer wrote:
>>   
>>> Hello,
>>>
>>> I'm trying to set up my new Happaugue HVR-1600 card.  During the scan, 
>>> II get several minutes of output on the screen complaining about tuning 
>>> failures,
>>>     
>>
>> These are normal when no service is detected on those freqs.
>>
>>
>>   
>>>  and then I get the following message:
>>>
>>> start filter:1338: ERROR: ioctl DMX_SET_FILTER failed: 6 No such device 
>>> or address
>>>     
>>
>> Hmmm.  New one one me, I'll have to investigate.
>>
>> What specific tool, version and command line arguments are you using?
>>
>>
>>   
>>> I have to kill the scan with a control-c at this point.  Can anyone give 
>>> me some advice with this problem?
>>>     
>>
>> Make sure you are using the latest cx18 driver from:
>>
>> http://linuxtv.og/hg/v4l-dvb
>>
>> versions older than v1.0.4 of the cx18 driver have problems dealing with
>> the occasional PCI bus error.
>>
>>
>> Instructions can be found here:
>>
>> http://www.ivtvdriver.org/index.php/Cx18
>>
>>
>> Make sure you have a good clean signal coming in:
>>
>> http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality
>>
>>
>> Regards,
>> Andy
>>
>>   
>>> Thanks,
>>>
>>> Eric
>>>     
>>
>>
>>
>>   
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


--------------000206010804070602060905
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Hello Again Andy,<br>
<br>
I was able to fix the problem reported by dmesg about the firmware.&nbsp; I
downloaded the firmware files from here:<br>
<br>
&nbsp;<a class="moz-txt-link-freetext" href="http://hauppauge.lightpath.net/software/install_cd/hauppauge_cd_3.4d1.zip">http://hauppauge.lightpath.net/software/install_cd/hauppauge_cd_3.4d1.zip</a><br>
<br>
and installed the one I needed.&nbsp; I restarted the system just to be
safe.&nbsp; Dmesg now does not report any problems with the firmware.&nbsp;
However, scandvb still does not finish or find anything.&nbsp; Any thoughts
about it?<br>
<br>
Thanks,<br>
<br>
Eric<br>
<br>
Eric Bauer wrote:
<blockquote cite="mid:49611FB9.2080409@centurytel.net" type="cite">
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
Hello Andy,<br>
  <br>
Thanks for the reply.&nbsp; I am really stuck on this.&nbsp; I am using Fedora8,
so I did a yum install of the latest dvb-tools application, but I'm not
sure which version it is.&nbsp; I am executing this command:<br>
  <br>
$ scandvb
/usr/share/dvb-apps/atsc/us-Cable-Standard-center-frequencies-QAM256<br>
  <br>
On your advice, I checked as discovered that I was running verison
1.0.0 of the cx18 drive.&nbsp; I downloaded the latest cx18 driver and
installed it.&nbsp; After running the modprobe as instructed, scandvb could
no longer find the device in the /dev directory.&nbsp; After rebooting,
scandvb worked again and modinfo reports that I am running version
1.0.4 of cx18.&nbsp; Unfortunately, after several minutes of scanning, the
same thing is happening.&nbsp; The scan will not complete.<br>
  <br>
I don't know if this is important or not.&nbsp; I tried scanning using a
couple other firequency files.&nbsp; us-Cable-IRC-center-frequencies-QAM256
does the same thing, but us-Cable-HRC-center-frequencies-QAM256<br>
&nbsp;completes without error, it just does not find any channels.&nbsp; <br>
  <br>
I found some interesting stuff in the dmesg output.&nbsp; I have a Happaugue
HVR-1600 model 1178, but tveeprom is reporting that it is model 74041.&nbsp;
Seems like this might explain where my problem is coming from, but I
don't know how to fix it.&nbsp; Here is the dmesg output:<br>
  <br>
  <i>cx18:&nbsp; Start initialization, version 1.0.4<br>
cx18-0: Initializing card #0<br>
cx18-0: Autodetected Hauppauge card<br>
ACPI: PCI Interrupt 0000:04:00.0[A] -&gt; GSI 21 (level, low) -&gt; IRQ
21<br>
cx18-0: Unreasonably low latency timer, setting to 64 (was 32)<br>
cx18-0: cx23418 revision 01010000 (B)<br>
tveeprom 1-0050: Hauppauge model 74041, rev C5B2, serial# 2884991<br>
tveeprom 1-0050: MAC address is 00-0D-FE-2C-05-7F<br>
tveeprom 1-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)<br>
tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)<br>
tveeprom 1-0050: audio processor is CX23418 (idx 38)<br>
tveeprom 1-0050: decoder processor is CX23418 (idx 31)<br>
tveeprom 1-0050: has no radio, has IR receiver, has IR transmitter<br>
cx18-0: Autodetected Hauppauge HVR-1600<br>
cx18-0: Raw VBI supported; Sliced VBI is not yet supported<br>
firewire_core: created device fw0: GUID 0090270001f82fe5, S400<br>
tuner 2-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)<br>
cs5345 1-004c: chip found @ 0x98 (cx18 i2c driver #0-0)<br>
tuner-simple 2-0061: creating new instance<br>
tuner-simple 2-0061: type set to 50 (TCL 2002N)<br>
cx18-0: Registered device video0 for encoder MPEG (64 x 32 kB)<br>
DVB: registering new adapter (cx18)<br>
MXL5005S: Attached at address 0x63<br>
DVB: registering adapter 0 frontend 3332 (Samsung S5H1409 QAM/8VSB
Frontend)...<br>
cx18-0: DVB Frontend registered<br>
cx18-0: Registered DVB adapter0 for TS (32 x 32 kB)<br>
cx18-0: Registered device video32 for encoder YUV (16 x 128 kB)<br>
cx18-0: Registered device vbi0 for encoder VBI (60 x 17328 bytes)<br>
cx18-0: Registered device video24 for encoder PCM audio (256 x 4 kB)<br>
cx18-0: Initialized card #0: Hauppauge HVR-1600<br>
cx18:&nbsp; End initialization<br>
  </i><br>
And the a little further down...<br>
  <br>
f<i>irmware: requesting v4l-cx23418-cpu.fw<br>
cx18-0: Unable to open firmware v4l-cx23418-cpu.fw<br>
cx18-0: Did you put the firmware in the hotplug firmware directory?<br>
cx18-0: Retry loading firmware<br>
firmware: requesting v4l-cx23418-cpu.fw<br>
cx18-0: Unable to open firmware v4l-cx23418-cpu.fw<br>
cx18-0: Did you put the firmware in the hotplug firmware directory?<br>
cx18-0: Failed to initialize firmware starting DVB feed<br>
cx18-0: Failed to initialize firmware starting DVB feed<br>
Press any key to continue...</i><br>
  <br>
  <br>
Any thoughts about this?<br>
  <br>
Thanks,<br>
  <br>
Eric<br>
  <br>
  <br>
Andy Walls wrote:
  <blockquote cite="mid:1231091162.3125.6.camel@palomino.walls.org"
 type="cite">
    <pre wrap="">On Sun, 2009-01-04 at 09:28 -0600, Eric Bauer wrote:
  </pre>
    <blockquote type="cite">
      <pre wrap="">Hello,

I'm trying to set up my new Happaugue HVR-1600 card.  During the scan, 
II get several minutes of output on the screen complaining about tuning 
failures,
    </pre>
    </blockquote>
    <pre wrap=""><!---->
These are normal when no service is detected on those freqs.


  </pre>
    <blockquote type="cite">
      <pre wrap=""> and then I get the following message:

start filter:1338: ERROR: ioctl DMX_SET_FILTER failed: 6 No such device 
or address
    </pre>
    </blockquote>
    <pre wrap=""><!---->
Hmmm.  New one one me, I'll have to investigate.

What specific tool, version and command line arguments are you using?


  </pre>
    <blockquote type="cite">
      <pre wrap="">I have to kill the scan with a control-c at this point.  Can anyone give 
me some advice with this problem?
    </pre>
    </blockquote>
    <pre wrap=""><!---->
Make sure you are using the latest cx18 driver from:

<a moz-do-not-send="true" class="moz-txt-link-freetext"
 href="http://linuxtv.og/hg/v4l-dvb">http://linuxtv.og/hg/v4l-dvb</a>

versions older than v1.0.4 of the cx18 driver have problems dealing with
the occasional PCI bus error.


Instructions can be found here:

<a moz-do-not-send="true" class="moz-txt-link-freetext"
 href="http://www.ivtvdriver.org/index.php/Cx18">http://www.ivtvdriver.org/index.php/Cx18</a>


Make sure you have a good clean signal coming in:

<a moz-do-not-send="true" class="moz-txt-link-freetext"
 href="http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality">http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality</a>


Regards,
Andy

  </pre>
    <blockquote type="cite">
      <pre wrap="">Thanks,

Eric
    </pre>
    </blockquote>
    <pre wrap=""><!---->


  </pre>
  </blockquote>
  <br>
  <pre wrap="">
<hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre>
</blockquote>
<br>
</body>
</html>

--------------000206010804070602060905--


--===============1010482261==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1010482261==--
