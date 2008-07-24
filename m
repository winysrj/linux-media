Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1KLzZ4-00089x-00
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 14:05:01 +0200
Message-ID: <48886FF0.5080206@iinet.net.au>
Date: Thu, 24 Jul 2008 20:05:04 +0800
From: Tim Farrington <timf@iinet.net.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------060609050809080201090901"
Subject: [linux-dvb] [Fwd: Re:  dvb mpeg2?]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------060609050809080201090901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------060609050809080201090901
Content-Type: message/rfc822;
 name="Re: [linux-dvb] dvb mpeg2?.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Re: [linux-dvb] dvb mpeg2?.eml"

X-Mozilla-Keys: 
Message-ID: <48886D1D.20305@iinet.net.au>
Date: Thu, 24 Jul 2008 19:53:01 +0800
From: Tim Farrington <timf@iinet.net.au>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: tobi@to-st.de
Subject: Re: [linux-dvb] dvb mpeg2?
References: <488860FE.5020500@iinet.net.au> <4888623F.5000108@to-st.de> <488863EF.8000402@iinet.net.au> <4888694F.3000509@to-st.de>
In-Reply-To: <4888694F.3000509@to-st.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Tobias Stoeber wrote:
> Hi Tim,
>
> well if its an TS it should look similiar like this (saying something 
> like "TS demuxer" etc.
>
> Playing /tmp/ProSieben_13.10.07-04.32.27.mpeg.
> Cache fill:  0.00% (0 bytes)    TS file format detected.
> DEMUX OPEN, AUDIO_ID: -1, VIDEO_ID: -1, SUBTITLE_ID: -1,
> PROBING UP TO 2000000, PROG: 0
> VIDEO MPEG2(pid=305)AUDIO MPA(pid=306) NO SUBS (yet)!  PROGRAM N. 0
> Opened TS demuxer, audio: 50(pid 306), video: 10000002(pid 
> 305)...POS=23688
> VIDEO:  MPEG2  720x576  (aspect 2)  25.000 fps  15000.0 kbps (1875.0 
> kbyte/s)
> ========================================================================== 
>
> Trying to force audio codec driver family libmad...
> Opening audio decoder: [libmad] libmad mpeg audio decoder
> AUDIO: 48000 Hz, 2 ch, s16le, 192.0 kbit/12.50% (ratio: 24000->192000)
> Selected audio codec: [mad] afm:libmad (libMAD MPEG layer 1-2-3)
> ========================================================================== 
>
> ID_FILENAME=/tmp/ProSieben_13.10.07-04.32.27.mpeg
> ID_VIDEO_FORMAT=0x10000002
> ID_VIDEO_BITRATE=15000000
> ID_VIDEO_WIDTH=720
> ID_VIDEO_HEIGHT=576
> ID_VIDEO_FPS=25.000
> ID_VIDEO_ASPECT=1.3333
> ID_AUDIO_CODEC=mad
> ID_AUDIO_FORMAT=80
> ID_AUDIO_BITRATE=192000
> ID_AUDIO_RATE=48000
> ID_AUDIO_NCH=2
> ID_LENGTH=2
>
> Cheers, Tobias
>
Hi Tobias,

Yes, that first one worked fine (even with all the frame data).
I can see that it's:
VIDEO MPEG2(pid=305)AUDIO MPA(pid=306) NO SUBS (yet)!  PROGRAM N. 0
Opened TS demuxer, audio: 50(pid 306), video: 10000002(pid 305)...POS=23688
VIDEO:  MPEG2  720x576  (aspect 2)  25.000 fps  15000.0 kbps (1875.0 
kbyte/s)

in mine, so that must mean that all is ok through the system - it is a 
MPEG2-TS stream
being dumped to file.

Now to figure out how to install replex!

Very many thanks for your help,
Tim Farrington



--------------060609050809080201090901
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------060609050809080201090901--
