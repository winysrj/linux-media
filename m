Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52313 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaIBSoM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 14:44:12 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so7970957wib.6
        for <linux-media@vger.kernel.org>; Tue, 02 Sep 2014 11:44:10 -0700 (PDT)
Received: from x220.optiplex-networks.com (81-178-2-118.dsl.pipex.com. [81.178.2.118])
        by mx.google.com with ESMTPSA id s7sm11134245wjo.48.2014.09.02.11.44.08
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Sep 2014 11:44:09 -0700 (PDT)
Message-ID: <54060FF5.2030502@gmail.com>
Date: Tue, 02 Sep 2014 19:44:05 +0100
From: Kaya Saman <kayasaman@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Fwd: Hauppauge WinTV-HVR 1900 high BER and unable to switch to Composite
 input
References: <53FF7425.9050106@gmail.com>
In-Reply-To: <53FF7425.9050106@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

a quick update on this one. I found out the image and sound corruption 
seems to be mainly due to the TV Headend plugin.

Using the tool: femon -H

and the output from TV Headend directly it clearly shows that yes there 
is a high BER however, most of it seems to be corrected. The uncorrected 
figure shown in femon seems to be 1958 though on occasion it will jump 
up pretty high.

Viewing through VLC or the browser plugin doesn't seem to be an issue 
however, as the image is pretty stable and clear.

So that simply leaves the remaining issue of accessing the devices 
analog inputs?

Both composite and S-video.

Disabling the running PVR software in this case TVH (as I am also 
testing with MythTV), then running mplayer /dev/video0 on the box simply 
doesn't work:

The direct output is this:

==========================================================================
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
libavcodec version 55.52.102 (internal)
Selected video codec: [ffmpeg2] vfm: ffmpeg (FFmpeg MPEG-2)
==========================================================================
==========================================================================
Opening audio decoder: [mpg123] MPEG 1.0/2.0/2.5 layers I, II, III
AUDIO: 48000 Hz, 2 ch, s16le, 224.0 kbit/14.58% (ratio: 28000->192000)
Selected audio codec: [mpg123] afm: mpg123 (MPEG 1.0/2.0/2.5 layers I, 
II, III)
==========================================================================
[AO OSS] audio_setup: Can't open audio device /dev/dsp: No such file or 
directory
[AO_ALSA] alsa-lib: pcm_hw.c:1557:(snd_pcm_hw_open) open 
'/dev/snd/pcmC1D7p' failed (-16): Device or resource busy
[AO_ALSA] alsa-lib: pcm_dmix.c:1022:(snd_pcm_dmix_open) unable to open slave
[AO_ALSA] Playback open error: Device or resource busy
AO: [pulse] Init failed: Connection refused
connect(2) call to /dev/shm/jack-1000/default/jack_0 failed (err=No such 
file or directory)
attempt to connect to server failed
[JACK] cannot open server
[AO SDL] Samplerate: 48000Hz Channels: Stereo Format s16le
[AO_ALSA] alsa-lib: pcm_hw.c:1557:(snd_pcm_hw_open) open 
'/dev/snd/pcmC1D7p' failed (-16): Device or resource busy
[AO_ALSA] alsa-lib: pcm_dmix.c:1022:(snd_pcm_dmix_open) unable to open slave
[AO SDL] Unable to open audio: No available audio device
DVB card number must be between 1 and 4
AO: [null] 48000Hz 2ch s16le (2 bytes per sample)
Starting playback...
The selected video_out device is incompatible with this codec.
Try appending the scale filter to your filter list,
e.g. -vf spp,scale instead of -vf spp.
Movie-Aspect is 1.33:1 - prescaling to correct movie aspect.
VO: [x11] 720x480 => 720x540 Planar YV12
Shared memory not supported
Reverting to normal Xlib
[swscaler @ 0x7f1ef7587a00]using unscaled yuv420p -> bgra special converter
A:   0.9 V:   0.8 A-V:  0.101 ct: -0.004   3/  3 ??% ??% ??,?% 1 0
[VD_FFMPEG] DRI failure.
A:  10.8 V:   2.8 A-V:  8.048 ct: -0.086  52/ 52 11% 829%  4.5% 50 0


            ************************************************
            **** Your system is too SLOW to play this!  ****
            ************************************************

Possible reasons, problems, workarounds:
- Most common: broken/buggy _audio_ driver
   - Try -ao sdl or use the OSS emulation of ALSA.
   - Experiment with different values for -autosync, 30 is a good start.
- Slow video output
   - Try a different -vo driver (-vo help for a list) or try -framedrop!
- Slow CPU
   - Don't try to play a big DVD/DivX on a slow CPU! Try some of the 
lavdopts,
     e.g. -vfm ffmpeg -lavdopts lowres=1:fast:skiploopfilter=all.
- Broken file
   - Try various combinations of -nobps -ni -forceidx -mc 0.
- Slow media (NFS/SMB mounts, DVD, VCD etc)
   - Try -cache 8192.
- Are you using -cache to play a non-interleaved AVI file?
   - Try -nocache.
Read DOCS/HTML/en/video.html for tuning/speedup tips.
If none of this helps you, read DOCS/HTML/en/bugreports.html.

Xlib:  extension "GLX" missing on display "localhost:10.0".4.5% 53 0


Exiting... (Quit)


Again if I try PVR mode:

  mplayer pvr://dev/video
MPlayer SVN-r37224 (C) 2000-2014 MPlayer Team
210 audio & 441 video codecs
mplayer: could not open config files /home/htpc/.lircrc and /etc/lirc/lircrc
mplayer: No such file or directory
Failed to read LIRC config file ~/.lircrc.

Playing pvr://dev/video.
[v4l2] select channel list europe-east, entries 133
[v4l2] unable to find channel dev/video
[pvr] Using device /dev/video0
[pvr] Detected WinTV HVR-1900 Model 73xxx
[v4l2] Available video inputs: '#0, television' '#1, composite' '#2, 
s-video'
[v4l2] Available audio inputs: '#0, PVRUSB2 Audio'
[v4l2] Available norms: '#0, PAL' '#1, PAL-BG' '#2, PAL-H' '#3, PAL-I' 
'#4, PAL-DK' '#5, SECAM' '#6, SECAM-B' '#7, SECAM-G' '#8, SECAM-H' '#9, 
SECAM-DK' '#10, SECAM-L' '#11, SECAM-Lc'
[v4l2] Using current set frequency 61250, to set channel
[v4l2] unable to find frequency 61250
[pvr] can't set v4l2 settings
Failed to open pvr://dev/video.


Exiting... (End of file)


Wow, after doing a quick Google search to find out how to use ivtv-utils 
I managed to stumble across this:

http://comments.gmane.org/gmane.linux.drivers.pvrusb2/714

http://www.isely.net/pvrusb2/usage.html#V4L

http://ubuntuforums.org/archive/index.php/t-1088745.html

So using v4l2-utils --get-input it looks as though the system was 
pre-set to the TV input. Running v4l2-utils --set-input=1 now has 
switched over to Composite and now am able to view through mplayer!!


So the question now really becomes how can one switch between inputs 
using PVR software? How come TV Headend doesn't detect the 73xxx chip?


Is this something to do with TVH or v4l2?


Regards,


Kaya


-------- Forwarded Message --------
Subject: 	Hauppauge WinTV-HVR 1900 high BER and unable to switch to 
Composite input
Date: 	Thu, 28 Aug 2014 19:25:41 +0100
From: 	Kaya Saman <kayasaman@gmail.com>
To: 	linux-media@vger.kernel.org



Hi,

[p.s. sorry if this appears twice, I tried attaching the log output
files but not sure if the list software allows that, so have added to
Dropbox instead]


checking the wiki the WinTV HVR-1900 is suggested as supported:

http://www.linuxtv.org/wiki/index.php/Pvrusb2

http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1950

http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1900


I am running Arch Linux with Kernel 3.16.1-6 and all other libraries and
packages up to date as of writing this posting.

For some reason I am experiencing a quite high BER on the DVB-T tuner
side and also I'm unable to switch to the "composite" input for most of
the time. On some rare occasions the RCA input works but very rarely.

I have read a similar posting to my issues:

http://www.isely.net/pipermail/pvrusb2/2009-October/002646.html


The kernel and daemon output logs are attached.

[EDIT]
https://www.dropbox.com/sh/z3h7b1kctma9kh4/AAB_n_bi4EP1v86M0546-7Vka?dl=0

Having attempted to test out MythTV and TVHeadend, both work fine with
the DVB-T portion but have issues switching to the analog inputs. TVH in
particular keeps claiming "no MPEG encoder found", when the card does
have an MPEG2 encoder. MythTV says either "permission denied" or "unable
to connect"?


Running cat /dev/video0 > outputfile.avi does work however, the output
is just a black screen with a colored line bar flickering at the bottom
of the video space?


All suggested firmware files have been installed and loaded though the
logs suggest something wrong with the pvrusb2 driver?


Would anybody be able to help?


Thanks.


Kaya



