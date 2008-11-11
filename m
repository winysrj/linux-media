Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.infomir.com.ua ([79.142.192.5] helo=infomir.com.ua)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdp@teletec.com.ua>) id 1KzrAU-0003H0-VQ
	for linux-dvb@linuxtv.org; Tue, 11 Nov 2008 12:12:25 +0100
Received: from [10.128.0.10] (iptv.infomir.com.ua [79.142.192.146])
	by infomir.com.ua with ESMTP id 1KzrAQ-00056C-K7
	for linux-dvb@linuxtv.org; Tue, 11 Nov 2008 13:12:18 +0200
Message-ID: <49196891.9060004@teletec.com.ua>
Date: Tue, 11 Nov 2008 13:12:17 +0200
From: Dmitry Podyachev <vdp@teletec.com.ua>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Compro VideoMate H900
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

v4l analogue TV question.
Could somebody (Andy Walls help me please) advice with next situation:
All my cards cx18 (Compro VideoMate H900) drop synchro - and TV
picture has problem.
This effect like broken analogue signal (I check, it was correct)
Are you have any idea what can helps (firmware, aplifier)?
This situation usually when all background too light and some part (at top) dark.
If picture not so brightness - all ok.


#v4l2-ctl -D
Driver info:
        Driver name   : cx18
        Card type     : Compro VideoMate H900
        Bus info      : 0000:05:00.0
        Driver version: 65536
        Capabilities  : 0x01070001
                Video Capture
                Tuner
                Audio
                Radio
                Read/Write

# v4l2-ctl --verbose --log-status -d /dev/video2
VIDIOC_QUERYCAP: ok
VIDIOC_LOG_STATUS: ok

Status Log:

   [3541824.473327] cx18-2: =================  START STATUS CARD #2  =================
   [3541824.473344] cx18-2: Video signal:              present
   [3541824.473347] cx18-2: Detected format:           PAL-BDGHI
   [3541824.473348] cx18-2: Specified standard:        PAL-BDGHI
   [3541824.473350] cx18-2: Specified video input:     Composite 2
   [3541824.473352] cx18-2: Specified audioclock freq: 32000 Hz
   [3541824.473369] cx18-2: Detected audio mode:       mono
   [3541824.473371] cx18-2: Detected audio standard:   A2-DK1
   [3541824.473373] cx18-2: Audio muted:               no
   [3541824.473374] cx18-2: Audio microcontroller:     running
   [3541824.473376] cx18-2: Configured audio standard: automatic detection
   [3541824.473378] cx18-2: Configured audio system:   automatic standard and mode detection
   [3541824.473381] cx18-2: Specified audio input:     Tuner (In5)
   [3541824.473383] cx18-2: Preferred audio mode:      stereo
   [3541824.473384] cx18-2: Selected 65 MHz format:    system DK
   [3541824.473386] cx18-2: Selected 45 MHz format:    A2-M
   [3541824.473391] tuner 5-0061: Tuner mode:      analog TV
   [3541824.473393] tuner 5-0061: Frequency:       127.25 MHz
   [3541824.473395] tuner 5-0061: Standard:        0x000000e0
   [3541824.473398] cx18-2: Video Input: Tuner 1
   [3541824.473399] cx18-2: Audio Input: Tuner 1
   [3541824.473402] cx18-2: GPIO:  direction 0x00008000, value 0x00008000
   [3541824.473403] cx18-2: Tuner: TV
   [3541824.473406] cx18-2: Stream: MPEG-2 Transport Stream
   [3541824.473408] cx18-2: VBI Format: No VBI
   [3541824.473410] cx18-2: Video:  720x576, 25 fps
   [3541824.473413] cx18-2: Video:  MPEG-2, 4x3, Variable Bitrate, 6000000, Peak 8000000
   [3541824.473416] cx18-2: Video:  GOP Size 15, 2 B-Frames, GOP Closure
   [3541824.473419] cx18-2: Audio:  32 kHz, MPEG-1/2 Layer II, 192 kbps, Stereo, No Emphasis, No CRC
   [3541824.473423] cx18-2: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D Horizontal, 0
   [3541824.473425] cx18-2: Temporal Filter: Manual, 8
   [3541824.473428] cx18-2: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
   [3541824.473430] cx18-2: Status flags: 0x00200001
   [3541824.473433] cx18-2: Stream encoder MPEG: status 0x0118, 0% of 2016 KiB (63 buffers) in use
   [3541824.473436] cx18-2: Stream encoder YUV: status 0x0000, 0% of 2048 KiB (16 buffers) in use
   [3541824.473439] cx18-2: Stream encoder PCM audio: status 0x0000, 0% of 1008 KiB (63 buffers) in use
   [3541824.473441] cx18-2: Read MPEG/VBI: 55101405228/0 bytes
   [3541824.473443] cx18-2: ==================  END STATUS CARD #2  ==================

User Controls

                     brightness (int)  : min=0 max=255 step=1 default=128 value=128 flags=slider
                       contrast (int)  : min=0 max=127 step=1 default=64 value=64 flags=slider
                     saturation (int)  : min=0 max=127 step=1 default=64 value=64 flags=slider
                            hue (int)  : min=-128 max=127 step=1 default=0 value=0 flags=slider
                         volume (int)  : min=0 max=65535 step=655 default=60928 value=60928 flags=slider
                        balance (int)  : min=0 max=65535 step=655 default=32768 value=32768 flags=slider
                           bass (int)  : min=0 max=65535 step=655 default=32768 value=32768 flags=slider
                         treble (int)  : min=0 max=65535 step=655 default=32768 value=32768 flags=slider
                           mute (bool) : default=0 value=1

MPEG Encoder Controls

                    stream_type (menu) : min=0 max=5 default=0 value=1 flags=update
              stream_vbi_format (menu) : min=0 max=0 default=0 value=0
       audio_sampling_frequency (menu) : min=0 max=2 default=1 value=1
                 audio_encoding (menu) : min=1 max=1 default=1 value=1 flags=update
         audio_layer_ii_bitrate (menu) : min=9 max=13 default=10 value=10
              audio_stereo_mode (menu) : min=0 max=3 default=0 value=0 flags=update
    audio_stereo_mode_extension (menu) : min=0 max=3 default=0 value=0 flags=inactive
                 audio_emphasis (menu) : min=0 max=2 default=0 value=0
                      audio_crc (menu) : min=0 max=1 default=0 value=0
                     audio_mute (bool) : default=0 value=0
                 video_encoding (menu) : min=0 max=1 default=1 value=1 flags=readonly
                   video_aspect (menu) : min=0 max=3 default=1 value=1
                 video_b_frames (int)  : min=0 max=33 step=1 default=2 value=2 flags=update
                 video_gop_size (int)  : min=1 max=34 step=1 default=12 value=15
              video_gop_closure (bool) : default=1 value=1
             video_bitrate_mode (menu) : min=0 max=1 default=0 value=0 flags=update
                  video_bitrate (int)  : min=0 max=27000000 step=1 default=6000000 value=6000000
             video_peak_bitrate (int)  : min=0 max=27000000 step=1 default=8000000 value=8000000
      video_temporal_decimation (int)  : min=0 max=255 step=1 default=0 value=0
                     video_mute (bool) : default=0 value=0
                 video_mute_yuv (int)  : min=0 max=16777215 step=1 default=32896 value=32896
            spatial_filter_mode (menu) : min=0 max=1 default=0 value=0 flags=update
                 spatial_filter (int)  : min=0 max=15 step=1 default=0 value=0 flags=slider
       spatial_luma_filter_type (menu) : min=0 max=4 default=1 value=1
     spatial_chroma_filter_type (menu) : min=0 max=1 default=1 value=1
           temporal_filter_mode (menu) : min=0 max=1 default=0 value=0 flags=update
                temporal_filter (int)  : min=0 max=31 step=1 default=8 value=8 flags=slider
             median_filter_type (menu) : min=0 max=4 default=0 value=0 flags=update
     median_luma_filter_minimum (int)  : min=0 max=255 step=1 default=0 value=0 flags=inactive slider
     median_luma_filter_maximum (int)  : min=0 max=255 step=1 default=255 value=255 flags=inactive slider
   median_chroma_filter_minimum (int)  : min=0 max=255 step=1 default=0 value=0 flags=inactive slider
   median_chroma_filter_maximum (int)  : min=0 max=255 step=1 default=255 value=255 flags=inactive slider
      insert_navigation_packets (bool) : default=0 value=0




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
