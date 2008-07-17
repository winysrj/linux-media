Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6I58D9a019558
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 01:08:13 -0400
Received: from cicero2.cybercity.dk (cicero2.cybercity.dk [212.242.40.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6I57s2W027686
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 01:07:58 -0400
Message-ID: <487FC316.30306@b4net.dk>
Date: Fri, 18 Jul 2008 00:09:26 +0200
From: Per Baekgaard <baekgaard@b4net.dk>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <487E7238.7030003@b4net.dk>	
	<1216252071.2669.56.camel@pc10.localdom.local>
	<487EF54E.8040704@b4net.dk>
	<1216317753.2659.85.camel@pc10.localdom.local>
In-Reply-To: <1216317753.2659.85.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Seeking help for a 713x based card
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

Thanks again -- quite a lot to digest.

I was working late yesterday, so unfortunately I was copying some 
incorrect lines from the 3xhybrid.inf file ;-(

The correct lines would be these ones, I think:

;******** Mercur, Tiger,... ***
;%PHILIPS_30.DeviceDesc% = 
PHILIPS_30.NTx86,PCI\VEN_1131&DEV_7130&SUBSYS_20181A7F
;%PHILIPS_33.DeviceDesc% = 
PHILIPS_33.NTx86,PCI\VEN_1131&DEV_7133&SUBSYS_20181A7F
;%PHILIPS_34.DeviceDesc% = 
PHILIPS_34.NTx86,PCI\VEN_1131&DEV_7134&SUBSYS_20181A7F
 
;******** Europa (1-3), Snake, Tough, Smart, Clever ***
%PHILIPS_30.DeviceDesc% = 
PHILIPS_30.NTx86,PCI\VEN_1131&DEV_7130&SUBSYS_20041A7F
%PHILIPS_33.DeviceDesc% = 
PHILIPS_33.NTx86,PCI\VEN_1131&DEV_7133&SUBSYS_20041A7F
%PHILIPS_34.DeviceDesc% = 
PHILIPS_34.NTx86,PCI\VEN_1131&DEV_7134&SUBSYS_20041A7F

;******** SAA7133 x32 ***
[PHILIPS_33.NTx86.CoInstallers]
CopyFiles     = SectionX32.CopyDll.NTx86
AddReg        = SectionX32.DllAddReg.NTx86
 
[PHILIPS_33.NTx86]
Include       = ks.inf, wdmaudio.inf, kscaptur.inf, bda.inf
Needs         = KS.Registration.NT, WDMAUDIO.Registration.NT, 
KSCAPTUR.Registration.NT, BDA.Installation.NT
CopyFiles     = SectionX32.CopyDriver.NTx86, SectionX32.CopyDll.NTx86
AddReg        = SectionX32.AddReg.NTx86, PHILIPS_33.AddReg
 
[PHILIPS_33.NTx86.Services]
AddService    = %SERVICE_NAME_X32%, 0x00000002, 
SectionX32.ServiceInstall.NTx86

;******** General DLL Registry Entries ***
;
 
[SectionX32.DllAddReg.NTx86]
HKR,,CoInstallers32,0x00010000,"34CoInstaller.dll, CoInstallerEntry"
 
 
;
;******** General Driver Registry Entries ***
;
 
[SectionX32.AddReg.NTx86]
 
HKR,,DevLoader,,*NTKERN
HKR,,NTMPDriver,,3xHybrid.sys
 
; --- Registry Entries For Audio Capture ---
 
HKR,,Driver,,3xHybrid.sys
HKR,,AssociatedFilters,,"wdmaud,swmidi,redbook"
 
HKR,Drivers,SubClasses,,"wave,mixer"
HKR,Drivers\wave\wdmaud.drv,Driver,,wdmaud.drv
HKR,Drivers\mixer\wdmaud.drv,Driver,,wdmaud.drv
HKR,Drivers\wave\wdmaud.drv,Description,,%PHILIPS.AudioDeviceDesc%
HKR,Drivers\mixer\wdmaud.drv,Description,,%PHILIPS.AudioDeviceDesc%
 
; add audio input and output pinnames
HKLM,SYSTEM\CurrentControlSet\Control\MediaCategories\%AVSTREAM_ANLG_AUDIO_IN_PIN%,"Name",,"Analog 
Audioinput"
HKLM,SYSTEM\CurrentControlSet\Control\MediaCategories\%AVSTREAM_ANLG_AUDIO_OUT_PIN%,"Name",,"Audio" 

HKLM,SYSTEM\CurrentControlSet\Control\MediaCategories\%AVSTREAM_ANLG_VIDEO_ITU_PIN%,"Name",,"Analog 
ITU Video"
HKLM,SYSTEM\CurrentControlSet\Control\MediaCategories\%AVSTREAM_ANLG_AUDIO_I2S_PIN%,"Name",,"I2S 
Audio"
HKLM,SYSTEM\CurrentControlSet\Control\MediaCategories\%AVSTREAM_MPEG_AES_PIN%,"Name",,"MPEG 
Audio ES"
HKLM,SYSTEM\CurrentControlSet\Control\MediaCategories\%AVSTREAM_MPEG_VES_PIN%,"Name",,"MPEG 
Video ES"
HKLM,SYSTEM\CurrentControlSet\Control\MediaCategories\%AVSTREAM_MPEG_PS_PIN%,"Name",, 
"MPEG2 Program"

;---- SAA7133 ----
[PHILIPS_33.AddReg]
 
; Prefix will be displayed in front of the device name on every filter
HKR, "Parameters","Prefix",,%PHILIPS_CUSTOM_TUNERNAME%
 
; Reduces second pair of video/audio inputs
HKR, "Parameters","SmallXBar",0x00010001,0x01



... so much for trying to reduce the amount of data. Apologies.

The entire file is here:

   http://www.b4net.dk/3xhybrid.inf

hermann pitton wrote:
> Hmm, subsystem 20041A7F not listed.
> From the eeprom the card looks like Philips TIGER hybrid.
> Some 3xHybrid.sys should be around then.
>   
Mea culpa. It is not a Proteus system but as you point out maybe a Tiger 
derivative of some sort "Snake, Tough, Smart, Clever" -- whatever that is!

> Is support for wireless network announced too?
>   
On the motherboard, yes, but not on the tuner as far as I can see.
> IIRC, it also comes with an USB remote, but I'm not sure.
>   
Yes, there is a remote, but not USB based, as far as I can tell.
> If you have saa7134-alsa loaded and you have a sound card/chip on the
> MB, something like sox can be used for testing.
> "sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -w -r 32000 /dev/dsp"
>   
I've tried something similar (arecord|aplay) but it doens't seem to 
capture any sound at all.
>   
> You might try with card=117 or card=96.
>   
Will do -- makes sense even if not a Proteus card (as I apparently 
copied some incorrect lines above)?
> Do you have two antenna input connectors or only one?
>   
One for this tuner only. There is a normal RCA video connector, a 
S-video of some sort and a mini-jack for sound input, I believe.
> Card=81 Philips Tiger would be better then.
>   
I'll try that too.
> That would be the tda10046 DVB-T demod.
>
>   
> Tuner=54 analog demod.
>   
So card 81 and tuner 54 would be a good quess then?
> Ah good, here we can see tuner address is 0x61.
> TV amux is for sure wrong on card=107.
>   
Yep... looks like it is ;-)
> If you have sometimes a flashing picture with card=81 or 78 on analog
> TV, or in case you get audio working and hear humming sound or you get
> DVB-T working, but unstable lock, such could indicate that it has a
> LowNoiseAmplifier that needs to be correctly configured, that is another
> story.
>   
I'll try and report back on my findings -- mainly card 81, 117 or 96 
then? Or are there other tiger based ones I should try?


-- Per.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
