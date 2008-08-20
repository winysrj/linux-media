Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KVuwt-0000k7-A6
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 23:10:36 +0200
Date: Wed, 20 Aug 2008 23:10:06 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080820211005.GA32022@raven.wolf.lan>
Mime-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] How to convert MPEG-TS to MPEG-PS on the fly?
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

Hello,

I'd like to convert live mpeg-ts streams from DVB-S on the fly into
a mpeg-ps stream.  I know that (for example)

  mencoder -oac copy -ovc copy -of mpeg -quiet infile -o outfile.mpg

can (almost) do what I want.  But I want to do it on the fly for
multiple streams in parallel and without any temporary files.  So I
decided to roll my own implementation.

I started demuxing the TS stream:

- first, I find the PIDs I am interested in (e.g. pids 110,120,121
  for the german ZDF channel on Astra).

- then, I extract all the PES packets from those streams, leaving
  the PES headers intact.  That is, I just snip off the four bytes
  TS header and throw away the adaptation field.

  Since the PES_packet_length for the video stream is zero, I assume
  I need to collect data until the payload_unit_start_indicator
  indicates the start of the next PES packet (ignoring TS header
  and adaptation_field, of course).
  

So, now I have (with the ZDF example) three streams of PES packets:

  -> video packets coming from PID 110
  -> first audio stream coming from PID 120
  -> second audio stream coming from PID 121

Both, mplayer and vlc play the audio streams fine.  But the video
stream gives lots of artefacts (blocks) with vlc.  mplayer completely
refuses to play it with the following message:

  Playing zdf.test.
  libavformat file format detected.
  Seek failed
  LAVF: no audio or video headers found - broken file?

Why that?  Maybe I should strip off the PES headers also to get a
valid ES?  Or is PES not suitable for playback at all?  Or maybe I
should strip off packets with specific Stream_id?  Here is the
sequence of stream_id's contained in the stream:

  jw@dvb1:~$ dvbsnoop -s pes -if zdf.test|grep Stream_id|head -40
  Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2 video stream]
  Stream_id: 0 (0x00)  [= picture_start_code]
  Stream_id: 181 (0xb5)  [= extension_start_code]
  Stream_id: 1 (0x01)  [= slice_start_code]
  Stream_id: 2 (0x02)  [= slice_start_code]
  [ consecutive lines deleted ]
  Stream_id: 34 (0x22)  [= slice_start_code]
  Stream_id: 35 (0x23)  [= slice_start_code]
  [ here the list of stream ids start over again and repeats ]

Maybe I should discard some of those to get a proper PES?


The next step would be to multiplex the three streams into a PS.
For this, I will have to insert the system_clock_reference_base(SCR).
Is this available somewhere in the PES headers?  Or can I reuse
(recalculate?) the program_clock_reference_base (PCR) from the
adaptation_field?


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
