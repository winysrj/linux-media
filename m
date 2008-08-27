Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n73.bullet.mail.sp1.yahoo.com ([98.136.44.191])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KYQ3t-00043Y-To
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 20:48:11 +0200
Date: Wed, 27 Aug 2008 11:47:25 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org, goga777@bk.ru, Hans Werner <HWerner4@gmx.de>
In-Reply-To: <20080827174927.271630@gmx.net>
MIME-Version: 1.0
Message-ID: <412393.34790.qm@web46101.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] HVR 4000 recomneded driver and firmware for VDR
	1.7.0
Reply-To: free_beer_for_all@yahoo.com
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

--- On Wed, 8/27/08, Hans Werner <HWerner4@gmx.de> wrote:

> There still seems to be a problem though. All three FTA HD
> channels lock, but only Arte HD plays properly in mplayer. 

Which version  of `mplayer'?

You probably know, but it bears repeating:  mplayer is a
moving target, and significant features are added regularly.

Also, some things break from time to time but are usually
quickly fixed.

I tend to build a new mplayer binary once or twice a month,
and keep the old ones around.


> Mplayer crashes after less than a second for Anixe HD and
> Astra HD+ :
> 
> Playing testfile_anixe.ts.
> TS file format detected.
> VIDEO H264(pid=1535) AUDIO A52(pid=1539) NO SUBS (yet)! 
> PROGRAM N. 132
> FPS seems to be: 25.000000
> ==========================================================================
> Opening video decoder: [ffmpeg] FFmpeg's libavcodec
> codec family
> Selected video codec: [ffh264] vfm: ffmpeg (FFmpeg H.264)
> ==========================================================================

> Starting playback...
> [h264 @ 0xbc0b40]number of reference frames exceeds max
> (probably corrupt input), discarding one
> [h264 @ 0xbc0b40]number of reference frames exceeds max
> (probably corrupt input), discarding one
> [h264 @ 0xbc0b40]number of reference frames exceeds max
> (probably corrupt input), discarding one
> [h264 @ 0xbc0b40]number of reference frames exceeds max
> (probably corrupt input), discarding one

This looks like what I see when playing IYV-HD video (with
a patch), whereas I see something different with BBC-HD on
mplayer from the start of august:

[h264 @ 0x89e5d50]B picture before any references, skipping
[h264 @ 0x89e5d50]decode_slice_header error
[h264 @ 0x89e5d50]no frame!
Error while decoding frame!
VDec: vo config request - 1440 x 1080 (preferred colorspace: Planar YV12)

This is normal at the start of the file.

>From ITV;

[h264 @ 0x89e5d50]number of reference frames exceeds max (probably corrupt input), discarding one
[h264 @ 0x89e5d50]number of reference frames exceeds max (probably corrupt input), discarding one
[h264 @ 0x89e5d50]mmco: unref short failure
Overriding type of video from 0x10000002 to 0x10000005
Overriding type of video from 0x10000002 to 0x10000005
[h264 @ 0x89e5d50]mmco: unref short failure
Overriding type of video from 0x10000002 to 0x10000005
VDec: vo config request - 1440 x 1080 (preferred colorspace: Planar YV12)

Then it will play for me with relatively clean video.  The version
of mplayer about a month earlier did not play this same file with
clean video.

Perhaps your flavour of `mplayer' doesn't properly support the H.264
encoding used by the two problem channels?


Just a thought, try the latest SVN source of mplayer, if you aren't
already


barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
