Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:43049
	"EHLO QMTA02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbZGBQbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jul 2009 12:31:00 -0400
From: George Czerw <gczerw@comcast.net>
Reply-To: gczerw@comcast.net
To: Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] Hauppauge HVR-1800 not working at all
Date: Thu, 2 Jul 2009 12:31:01 -0400
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200906301301.04604.gczerw@comcast.net> <200906301749.05168.gczerw@comcast.net> <4A4A88C3.9020608@linuxtv.org>
In-Reply-To: <4A4A88C3.9020608@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907021231.01853.gczerw@comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 30 June 2009 05:50:59 pm Michael Krufky wrote:
> George Czerw wrote:
> > On Tuesday 30 June 2009 15:56:08 Devin Heitmueller wrote:
> >> On Tue, Jun 30, 2009 at 3:48 PM, George Czerw<gczerw@comcast.net> wrote:
> >>> Devin, thanks for the reply.
> >>>
> >>> Lsmod showed that "tuner" was NOT loaded (wonder why?), a "modprobe
> >>> tuner" took care of that and now the HVR-1800 is displaying video
> >>> perfectly and the tuning function works.  I guess that I'll have to add
> >>> "tuner" into modprobe.preload.d????  Now if only I can get the sound
> >>> functioning along with the video!
> >>>
> >>> George
> >>
> >> Admittedly, I don't know why you would have to load the tuner module
> >> manually on the HVR-1800.  I haven't had to do this on other products?
> >>
> >> If you are doing raw video capture, then you need to manually tell
> >> applications where to find the ALSA device that provides the audio.
> >> If you're capturing via the MPEG encoder, then the audio will be
> >> embedded in the stream.
> >>
> >> Devin
> >
> > I don't understand why the audio/mpeg ports of the HVR-1800 don't show up
> > in output of lspci:
> >
> > 03:00.0 Multimedia video controller: Conexant Systems, Inc. Device 8880
> > (rev 0f)
> >         Subsystem: Hauppauge computer works Inc. Device 7801
> >         Flags: bus master, fast devsel, latency 0, IRQ 17
> >         Memory at f9c00000 (64-bit, non-prefetchable) [size=2M]
> >         Capabilities: [40] Express Endpoint, MSI 00
> >         Capabilities: [80] Power Management version 2
> >         Capabilities: [90] Vital Product Data
> >         Capabilities: [a0] MSI: Mask- 64bit+ Count=1/1 Enable-
> >         Capabilities: [100] Advanced Error Reporting
> >         Capabilities: [200] Virtual Channel <?>
> >         Kernel driver in use: cx23885
> >         Kernel modules: cx23885
> >
> >
> > even though the dmesg output clearly shows this:
> >
> > tveeprom 0-0050: decoder processor is CX23887 (idx 37)
> > tveeprom 0-0050: audio processor is CX23887 (idx 42)
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Please try this:
>
> When you have tvtime open and running with video working already, do:
>
> mplayer /dev/video1
>
> (assuming that tvtime is open on video0)
>
> Then, you'll get mplayer complete with both audio and video.
>
> -Mike

OK, I tried this again after downloading the firmware 
(HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip) from Stoth's webpage and re-ran 
mplayer  using a command that I found on a Ubuntu wikki:

*****************

$ mplayer /dev/video1 -vo x11 -nobps -autosync 30 -forceidx -hardframedrop -vc 
ffmpeg12 -idle -menu -cache 16384 -cache-seek-min 50 -mc 0 -ni     
MPlayer SVN-1.rc2.23.r28791.2mdv2009.1-4.3.2 (C) 2000-2009 MPlayer Team           
mplayer: could not connect to socket                                              
mplayer: No such file or directory                                                
Failed to open LIRC support. You will not be able to use your remote control.     
Struct fs_cfg doesn't have any auto-close field                                   
[MENU] bad attribute auto-close=yes in menu 'open_list' at line 57                
Menu initialized: /home/george/.mplayer/menu.conf                                 

Playing /dev/video1.
Cache fill: 19.63% (3293184 bytes)   
MPEG-PS file format detected.        
VIDEO:  MPEG2  720x480  (aspect 2)  29.970 fps  8000.0 kbps (1000.0 kbyte/s)
==========================================================================  
Forced video codec: ffmpeg12
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
Unsupported PixelFormat -1
Selected video codec: [ffmpeg12] vfm: ffmpeg (FFmpeg MPEG-1/2)
==========================================================================
==========================================================================
Trying to force audio codec driver family libmad...
Opening audio decoder: [libmad] libmad mpeg audio decoder
AUDIO: 48000 Hz, 2 ch, s16le, 224.0 kbit/14.58% (ratio: 28000->192000)
Selected audio codec: [mad] afm: libmad (libMAD MPEG layer 1-2-3)
==========================================================================
[pulse] working around probably broken pause functionality,
        see http://www.pulseaudio.org/ticket/440
socket(): Address family not supported by protocol
AO: [pulse] Init failed: Connection refused
Failed to initialize audio driver 'pulse'
AO: [alsa] 48000Hz 2ch s16le (2 bytes per sample)
Starting playback...
VDec: vo config request - 720 x 480 (preferred colorspace: Planar YV12)
VDec: using Planar YV12 as output csp (no 0)
Movie-Aspect is 1.33:1 - prescaling to correct movie aspect.
VO: [x11] 720x480 => 720x540 Planar YV12  [zoom]
[swscaler @ 0x8958820]using unscaled yuv420p -> rgb32 special converter
[mpegvideo @ 0x88aff40]ac-tex damaged at 7 0
[mpegvideo @ 0x88aff40]Warning MVs not available
[mpegvideo @ 0x88aff40]concealing 1350 DC, 1350 AC, 1350 MV errors
A:  79.2 V:  79.3 A-V: -0.078 ct:  0.000 2369/2369  7% 15%  0.8% 4 0 17%
Exiting... (Quit)
****************
1.  I had disabled pulse audio and only had alsa loaded, so I guess that the 
pulse audio error is normal here.

2.  As soon as mplayer loaded, I was getting audio for the channel that 
TVtime was displaying, but the video screens in both the TVtime and mplayer 
screens was so corrupted and distorted that it was not viewable.  The video 
corruption is only solved by a reboot.

3.  I then enabled pulse audio, rebooted, and re-ran TVtime and mplayer:

*****************

$ mplayer /dev/video1 -vo x11 -nobps -autosync 30 -forceidx -hardframedrop -vc 
ffmpeg12 -idle -menu -cache 16384 -cache-seek-min 50 -mc 0 -ni     
MPlayer SVN-1.rc2.23.r28791.2mdv2009.1-4.3.2 (C) 2000-2009 MPlayer Team           
mplayer: could not connect to socket                                              
mplayer: No such file or directory                                                
Failed to open LIRC support. You will not be able to use your remote control.     
Struct fs_cfg doesn't have any auto-close field                                   
[MENU] bad attribute auto-close=yes in menu 'open_list' at line 57                
Menu initialized: /home/george/.mplayer/menu.conf                                 

Playing /dev/video1.
Cache fill: 19.82% (3325952 bytes)   
MPEG-PS file format detected.        
VIDEO:  MPEG2  720x480  (aspect 2)  29.970 fps  8000.0 kbps (1000.0 kbyte/s)
==========================================================================  
Forced video codec: ffmpeg12                                                
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family            
Unsupported PixelFormat -1                                                  
Selected video codec: [ffmpeg12] vfm: ffmpeg (FFmpeg MPEG-1/2)              
==========================================================================  
==========================================================================  
Trying to force audio codec driver family libmad...                         
Opening audio decoder: [libmad] libmad mpeg audio decoder                   
AUDIO: 48000 Hz, 2 ch, s16le, 224.0 kbit/14.58% (ratio: 28000->192000)      
Selected audio codec: [mad] afm: libmad (libMAD MPEG layer 1-2-3)           
==========================================================================  
[pulse] working around probably broken pause functionality,                 
        see http://www.pulseaudio.org/ticket/440                            
AO: [pulse] 48000Hz 2ch s16le (2 bytes per sample)                          
Starting playback...                                                        
VDec: vo config request - 720 x 480 (preferred colorspace: Planar YV12)     
VDec: using Planar YV12 as output csp (no 0)                                
Movie-Aspect is 1.33:1 - prescaling to correct movie aspect.                
VO: [x11] 720x480 => 720x540 Planar YV12  [zoom]
[swscaler @ 0x8958820]using unscaled yuv420p -> rgb32 special converter
[mpegvideo @ 0x88aff40]ac-tex damaged at 7 0
[mpegvideo @ 0x88aff40]Warning MVs not available
[mpegvideo @ 0x88aff40]concealing 1350 DC, 1350 AC, 1350 MV errors
Cannot sync MAD frame: -0.078 ct:  0.000 198/198 11% 22%  0.8% 18 0 0%
Cannot sync MAD frame
Cannot sync MAD frame: -0.078 ct:  0.000 199/199 11% 22%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 200/200 11% 21%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 201/201 11% 21%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 202/202 11% 21%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 203/203 11% 21%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 204/204 11% 21%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 205/205 10% 21%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 206/206 10% 21%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 207/207 10% 21%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 208/208 10% 21%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 209/209 10% 21%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 210/210 10% 21%  0.8% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 211/211 10% 21%  0.7% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 212/212 10% 21%  0.7% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 213/213 10% 21%  0.7% 18 0 0%
Cannot sync MAD frame: -0.078 ct:  0.000 214/214 10% 21%  0.7% 18 0 0%
A:   7.3 V:   7.4 A-V: -0.078 ct:  0.000 214/214 10% 21%  0.7% 18 0 0%

[1]+  Stopped                 mplayer /dev/video1 -vo x11 -nobps -autosync 30 
-forceidx -hardframedrop -vc ffmpeg12 -idle -menu -cache 16384 -cache-seek-min 
50 -mc 0 -ni

*****************

1.  As soon as mplayer loaded, I was getting audio for the channel that 
TVtime was displaying, but this time video screens in TVtime became so 
corrupted and distorted that it was not viewable, but no video displayed in 
the mplayer screen (it remained black) and mplayer aborted after 10 or so 
seconds.

2.  Why does the loading of mplayer corrupt the video????

*****************

I then tried redirecting the audio using sox (using a procedure found on 
another wikki) and got the following result:

$ sox -c 2 -s -r 44100 -t ossdsp /dev/dsp1 -t ossdsp -r 44100 /dev/dsp
sox formats: can't open input file `/dev/dsp1': No such file or directory

So I then did:

$ ls /dev/dsp*                                                  
/dev/dsp 

...and then:

$ cat /proc/asound/cards 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xf9af4000 irq 22

*****************

It still astounds me that linux is not detecting the audio portion of this 
HVR-1800 as an audio device.  Is this a kernel issue?

George


