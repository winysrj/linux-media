Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:47336 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab0DNEeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 00:34:18 -0400
Message-ID: <4BC545C0.4030506@pobox.com>
Date: Wed, 14 Apr 2010 00:34:08 -0400
From: Mark Lord <mlord@pobox.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
Subject: Re: cx18: "missing audio" for analog recordings
References: <4B8BE647.7070709@teksavvy.com>
 <1267493641.4035.17.camel@palomino.walls.org> <4B8CA8DD.5030605@teksavvy.com>
 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
 <1270961760.5365.14.camel@palomino.walls.org>
 <1270986453.3077.4.camel@palomino.walls.org>  <4BC1CDA2.7070003@pobox.com>
 <1271012464.24325.34.camel@palomino.walls.org> <4BC37DB2.3070107@pobox.com>
 <1271107061.3246.52.camel@palomino.walls.org> <4BC3D578.9060107@pobox.com>
 <4BC3D73D.5030106@pobox.com>  <4BC3D81E.9060808@pobox.com>
 <1271154932.3077.7.camel@palomino.walls.org>  <4BC466A1.3070403@pobox.com>
 <1271209520.4102.18.camel@palomino.walls.org> <4BC54569.7020301@pobox.com>
In-Reply-To: <4BC54569.7020301@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/04/10 12:32 AM, Mark Lord wrote:
..
> Thanks. I'll have a go at that some night.
>
> Meanwhile, tonight, audio failed.
..

Oh, I forgot to include this:

Apr 13 22:00:05 duke kernel: cx18-0: =================  START STATUS CARD #0  =================
Apr 13 22:00:05 duke kernel: cx18-0: Version: 1.4.0  Card: Hauppauge HVR-1600
Apr 13 22:00:05 duke kernel: tveeprom 1-0050: Hauppauge model 74551, rev C1A3, serial# 1752579
Apr 13 22:00:05 duke kernel: tveeprom 1-0050: MAC address is 00:0d:fe:1a:be:03
Apr 13 22:00:05 duke kernel: tveeprom 1-0050: tuner model is TCL MFNM05-4 (idx 103, type 43)
Apr 13 22:00:05 duke kernel: tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
Apr 13 22:00:05 duke kernel: tveeprom 1-0050: audio processor is CX23418 (idx 38)
Apr 13 22:00:05 duke kernel: tveeprom 1-0050: decoder processor is CX23418 (idx 31)
Apr 13 22:00:05 duke kernel: tveeprom 1-0050: has radio
Apr 13 22:00:05 duke kernel: cx18-0 843: Video signal:              present
Apr 13 22:00:05 duke kernel: cx18-0 843: Detected format:           NTSC-M
Apr 13 22:00:05 duke kernel: cx18-0 843: Specified standard:        NTSC-M
Apr 13 22:00:05 duke kernel: cx18-0 843: Specified video input:     Composite 7
Apr 13 22:00:05 duke kernel: cx18-0 843: Specified audioclock freq: 48000 Hz
Apr 13 22:00:05 duke kernel: cx18-0 843: Detected audio mode:       forced mode
Apr 13 22:00:05 duke kernel: cx18-0 843: Detected audio standard:   forced audio standard
Apr 13 22:00:05 duke kernel: cx18-0 843: Audio muted:               no
Apr 13 22:00:05 duke kernel: cx18-0 843: Audio microcontroller:     running
Apr 13 22:00:05 duke kernel: cx18-0 843: Configured audio standard: BTSC
Apr 13 22:00:05 duke kernel: cx18-0 843: Configured audio mode:     MONO2 (LANGUAGE B)
Apr 13 22:00:05 duke kernel: cx18-0 843: Specified audio input:     Tuner (In8)
Apr 13 22:00:05 duke kernel: cx18-0 843: Preferred audio mode:      stereo
Apr 13 22:00:05 duke kernel: cx18-0 gpio-reset-ctrl: GPIO:  direction 0x00003001, value 0x00003001
Apr 13 22:00:05 duke kernel: tda9887 2-0043: Data bytes: b=0x14 c=0x30 e=0x44
Apr 13 22:00:05 duke kernel: tuner 2-0061: Tuner mode:      analog TV
Apr 13 22:00:05 duke kernel: tuner 2-0061: Frequency:       531.25 MHz
Apr 13 22:00:05 duke kernel: tuner 2-0061: Standard:        0x0000b000
Apr 13 22:00:05 duke kernel: cs5345 1-004c: Input:  1
Apr 13 22:00:05 duke kernel: cs5345 1-004c: Volume: 0 dB
Apr 13 22:00:05 duke kernel: cx18-0: Video Input: Tuner 1
Apr 13 22:00:05 duke kernel: cx18-0: Audio Input: Tuner 1
Apr 13 22:00:05 duke kernel: cx18-0: GPIO:  direction 0x00003001, value 0x00003001
Apr 13 22:00:05 duke kernel: cx18-0: Tuner: TV
Apr 13 22:00:05 duke kernel: cx18-0: Stream: MPEG-2 Program Stream
Apr 13 22:00:05 duke kernel: cx18-0: VBI Format: Private packet, IVTV format
Apr 13 22:00:05 duke kernel: cx18-0: Video:  720x480, 30 fps
Apr 13 22:00:05 duke kernel: cx18-0: Video:  MPEG-2, 4x3, Variable Bitrate, 12000000, Peak 14500000
Apr 13 22:00:05 duke kernel: cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure
Apr 13 22:00:05 duke kernel: cx18-0: Audio:  48 kHz, MPEG-1/2 Layer II, 224 kbps, Stereo, No Emphasis, No CRC
Apr 13 22:00:05 duke kernel: cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D Horizontal, 0
Apr 13 22:00:05 duke kernel: cx18-0: Temporal Filter: Manual, 8
Apr 13 22:00:05 duke kernel: cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
Apr 13 22:00:05 duke kernel: cx18-0: Status flags: 0x00200001
Apr 13 22:00:05 duke kernel: cx18-0: Stream encoder MPEG: status 0x0118, 0% of 2048 KiB (64 buffers) in use
Apr 13 22:00:05 duke kernel: cx18-0: Stream encoder YUV: status 0x0000, 0% of 2025 KiB (20 buffers) in use
Apr 13 22:00:05 duke kernel: cx18-0: Stream encoder VBI: status 0x0038, 5% of 1015 KiB (20 buffers) in use
Apr 13 22:00:05 duke kernel: cx18-0: Stream encoder PCM audio: status 0x0000, 0% of 1024 KiB (256 buffers) in use
Apr 13 22:00:05 duke kernel: cx18-0: Read MPEG/VBI: 190420992/476784 bytes
Apr 13 22:00:05 duke kernel: cx18-0: ==================  END STATUS CARD #0  ==================

-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
