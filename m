Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4BDp1eA006885
	for <video4linux-list@redhat.com>; Sun, 11 May 2008 09:51:01 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.236])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4BDondJ008259
	for <video4linux-list@redhat.com>; Sun, 11 May 2008 09:50:50 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2147289rvb.51
	for <video4linux-list@redhat.com>; Sun, 11 May 2008 06:50:48 -0700 (PDT)
Message-ID: <e686f5060805110650x2cc1179bn380fcf9c0729f8b7@mail.gmail.com>
Date: Sun, 11 May 2008 09:50:48 -0400
From: "Brandon Jenkins" <bcjenkins@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1210460680.7632.64.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e686f5060805091255m70e5d959i1ee3169232aadda2@mail.gmail.com>
	<1210378476.3292.52.camel@palomino.walls.org>
	<e686f5060805091810h5ce89e7dide1c1138d2ad30b7@mail.gmail.com>
	<1210384088.3292.109.camel@palomino.walls.org>
	<e686f5060805100609y3e6813b4mcbf5daf21ad03a93@mail.gmail.com>
	<1210460680.7632.64.camel@palomino.walls.org>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Steven Toth <stoth@hauppauge.com>
Subject: Re: Is anyone else running a CX18 in 64bit OS?
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

On Sat, May 10, 2008 at 7:04 PM, Andy Walls <awalls@radix.net> wrote:
>
> On Sat, 2008-05-10 at 09:09 -0400, Brandon Jenkins wrote:
>  > On Fri, May 9, 2008 at 9:48 PM, Andy Walls <awalls@radix.net> wrote:
>  > > On Fri, 2008-05-09 at 21:10 -0400, Brandon Jenkins wrote:
>  > >> On Fri, May 9, 2008 at 8:14 PM, Andy Walls <awalls@radix.net> wrote:
>  > >> > On Fri, 2008-05-09 at 15:55 -0400, Brandon Jenkins wrote:
>  > >> >
>  > >> > Brandon,
>  > >> >
>  > >> > Yes I'm running the cx18 driver with an HVR-1600 on a 64 bit OS.
>  > >> >
>  > >> >> I have noticed an appreciable difference in video capture quality.
>  > >> >
>  > >> > The first analog capture after a modprobe of the cx18 is usually
>  > >> > terrible and unwatchable due to apparently lost frames or no initial
>  > >> > audio followed by audio and lost frames.  The work around is to stop the
>  > >> > analog capture and restart.
>  > >> >
>  > >> > Would you characterize the analog capture quality problems as being only
>  > >> > on weak channels or strong channels as well?
>  > >> >
>  > >> >>  The
>  > >> >> timeline for the change is exactly the same time that development
>  > >> >> ceased on the IVTV version of CX18 and moved to V4L.
>  > >> >
>  > >> > I'm not clear on exactly what versions you mean.  Do you have hg
>  > >> > repository names and change ID's?
>  > >> >
>  > >> >
>  > >> >>  I see heavy
>  > >> >> pixelation in analog capture and the dvb tuner module returns far
>  > >> >> fewer channels on a scan than before. I would like to troubleshoot,
>  > >> >> please let me know what is needed.
>  > >> >
>  > >> >
>  > >> > Since you have the two particular source trees at hand, could you do a
>  > >> > recursive diff so we can see the changes?  That hopefully will narrow
>  > >> > the search for potential causes.
>  > >> >
>  > >> > Regards,
>  > >> > Andy
>  > >> >
>  > >> >> I am attaching dmesg/channel.conf/channel scan output for v4l drivers
>  > >> >> comparing the results from a cx18 and a cx23885 card. (hvr-1600 and
>  > >> >> hvr-1800) If I switch back to the older ivtv and mxl500s dvb tuner all
>  > >> >> works fine.
>  > >> >>
>  > >> >> Thanks in advance
>  > >> >>
>  > >> >> Brandon
>  > >> >
>  > >> >
>  > >> >
>  > >> Andy,
>  > >>
>  > >> Thanks for the response.
>  > >>
>  > >> I am running the following command in rc.local to start a capture and
>  > >> then kill it.
>  > >>
>  > >> cat /dev/video3 > /dev/null & sleep 8 && kill $!
>  > >>
>  > >> Is that sufficient for an initial capture?
>  > >
>  > > Without testing it, I'm going to say, I imagine it would be from the
>  > > look of it.
>  > >
>  > >
>  > >> I am recording via svideo from a DirecTV signal. All signal levels are
>  > >> consistent.
>  > >
>  > > OK.  I looked at the cx28885 channels.conf, after I sent the questions,
>  > > and noticed you didn't have terrestrial over the air source.  I saw you
>  > > have the same local channels on QAM that I get over 8-VSB: WETA-HD,
>  > > WUSA-HD, 9-Radar, CW50, etc.
>  > >
>  > >> The driver base which works for me is cx18-8788bde67f6c it is the
>  > >> older cx18-ivtv branch
>  > >
>  > > This is precisely the version (with a small change for auto chroma
>  > > subcarrier locking) that I use when I need to leave my machine with a
>  > > reliable cx18 driver with digital capability for use with MythTV.
>  > > ("General Hospital" *must* be recorded properly daily!)
>  > >
>  > >
>  > >> The version I am having issues with was built from a v4l-dvb pull this morning.
>  > >>
>  > >> I did not mention this in my email but it was in the log files; I am
>  > >> scanning QAM for DVB. With the mxl500x.ko frontend everything works
>  > >> well. With mxl5005s.ko in the new v4l-dvb scanning is broken.
>  > >
>  > > OK.  Steve just introduced that mxl5005s driver from a separate code
>  > > base.  I've copied him on this e-mail to let him know of the problem.
>  > >
>  > > I'll have to do the pull and test scanning my 8VSB stations.
>
>  OK.  I did a scan this morning with the old cx18-mxl500x driver
>  combination.  After numerous household obligations, I finally built the
>  latest v4l-dvb (twice, the first time I forgot to make distclean and
>  didn't have the mxl5005s) and did another scan.
>
>  The result: the diff shows three less 8VSB channels/streams showing up
>  with the new driver, but there all on the same frequency for WUSA 9 in
>  Washington, D.C.  I've attached the scans.  Here's a short excerpt from
>  the diff:
>
>  -dumping lists (18 services)
>  +dumping lists (15 services)
>   Done.
>   WFDC DT:479028615:8VSB:49:52:3
>   MHz1:569028615:8VSB:49:52:1
>  @@ -1531,9 +1545,6 @@
>   MHz5:569028615:8VSB:113:116:5
>   WHUT-DT:587028615:8VSB:17:20:1
>   WHUT-TV:587028615:8VSB:0:0:65535
>  -WUSA-HD:593028615:8VSB:49:52:1
>  -9-Radar:593028615:8VSB:65:68:2
>  -WUSA-TV:593028615:8VSB:0:0:65535
>   WDCA DT:599028615:8VSB:49:52:3
>   WTTG DT:605028615:8VSB:49:52:3
>   WJLA-HD:623028615:8VSB:49:52:3
>
>  The really funny thing is that WUSA is typically a strong analog signal
>  and I believe the strongest digital signal I receive.  (I wonder if my
>  broadband TV amplifier's gain is set too high?)
>
>  According to the digital diagnostics on my Sony big screen right now, TV
>  channel 9.1 is at 593000 kHz with a SNR of 24 dB (signal power is 250
>  times that of the noise power!) and the tuner's AGC is at 23%.
>
Switching to ATSC OTA I gain the following services:

WWPX Digital Television:207028615:8VSB:49:52:3
WWPX qubo:207028615:8VSB:65:68:4
WWPX ion West:207028615:8VSB:81:84:5
WWPX Worship:207028615:8VSB:97:100:6
WFDC DT:479028615:8VSB:49:52:3
WETA-HD:551028615:8VSB:49:52:1
WETADT1:551028615:8VSB:65:68:2
WETADT2:551028615:8VSB:81:84:3
WETADT3:551028615:8VSB:97:100:4
MHz1:569028615:8VSB:49:52:1
MHz6:569028615:8VSB:65:68:2
MHz3:569028615:8VSB:81:84:3
MHz2:569028615:8VSB:97:100:4
MHz5:569028615:8VSB:113:116:5
WHUT-DT:587028615:8VSB:17:20:1
WHUT-TV:587028615:8VSB:0:0:65535
WUSA-HD:593028615:8VSB:49:52:1
9-Radar:593028615:8VSB:65:68:2
WUSA-TV:593028615:8VSB:0:0:65535
WDCA DT:599028615:8VSB:49:52:3
WJLA-HD:623028615:8VSB:49:52:3
WJLA-SD:623028615:8VSB:65:68:4
WJLA-SD:623028615:8VSB:113:116:5
WNUV-HD:629028615:8VSB:49:52:3
MPT-HD:641028615:8VSB:49:52:1
MPT Sel:641028615:8VSB:65:68:2
V-me:641028615:8VSB:81:84:3
ION:647028615:8VSB:49:52:3
WPXW qubo:647028615:8VSB:65:68:4
WPXW ION Life:647028615:8VSB:81:84:5
Worship:647028615:8VSB:97:100:6
WRC-1:677028615:8VSB:49:52:3
WRC-2:677028615:8VSB:65:68:4
CW50:695028615:8VSB:49:52:3
WBALDT:743028615:8VSB:49:52:3
WBALSD:743028615:8VSB:65:68:4

This leads me to believe QAM tuning is not functioning as well in the
new driver as it was in the older one, so I will leave it connected to
the rooftop antenna for now. FTR - QAM source is Verizon FiOS local
channel package.


>
>  > > -Andy
>  > >
>  > >> rdiff -r cx18-8788bde67f6c v4l-dvb output attached.
>  > >>
>  > >> Brandon
>  > >
>  > >
>  > Andy,
>  >
>  > I can also switch over to my roof antenna and scan. I'll do that
>  > today. Are you doing any analog capture and are you seeing any
>  > pixelation/blocking?
>
>  Nope, none.  I used:
>
>   $ mplayer -cache 16384 /dev/video1
>
>  On strong and weak channels with no difference and no artifacts.  If I
>  use -cache 8192, mplayer gripes a little about my system not being able
>  to keep up, but the up arrow resyncs everything.
>
>  For reference,  v4l-ctl -d /dev/video1 --log-status shows:
>
>    cx18-0: Video:  720x480, 30 fps
>    cx18-0: Video:  MPEG-2, 4x3, Variable Bitrate, 6000000, Peak 8000000
>    cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure
>    cx18-0: Audio:  48 kHz, Layer II, 224 kbps, Stereo, No Emphasis, No CRC
>    cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D Horizontal, 0
>    cx18-0: Temporal Filter: Manual, 8
>    cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
>
>  If the encoder made any blocks at all with no scaling (720x480) and a
>  peak rate of 8 Mbps, I'd be surprised.
>
>
>  > I have a 46MB/60sec sample capture that
>  > demonstrates it if interested.
>  >
>  > The pixelation/blocking is not present in the older cx18-8788bde67f6c build.
>
>  Hmmm.  What is your analog source?  If it's the tuner, can you
>  qualitatively describe the elements of the scene (people, sports, news,
>  high movement, low movement, etc.) and the SNR (strong, weak, really
>  crappy).
>

Happening on svideo input. Using DirecTV.

>  Does the blocking happen with the line in (use a DVD player or VCR)?
>
>  What are the image size and bit-rate you have set?
>
I can't get the utilities to build on my Ubuntu Hardy 8.04 server
system. I am missing Qt headers and other issues. I'll work on that
but I have adjusted the quality down in my PVR application to see if
it will lessen.

>  I'll pass on the file download.  My 56 kbps modem isn't the straw I'd
>  really like to suck 46 MB through if I don't have too. ;)
>
>
>
>  By the way, despite not being able to scan the channel:
>
>   $ mplayer dvb://9-Radar
>
>  Works just fine using my old channels.conf and so does
>
>   $ mplayer dvb://WUSA-HD -vf scale=960:540
>
>  (I don't have a screen large enough for the full 1920x1080 to display
>  properly)
>
>
>  Regards,
>  Andy
>
>  > Regards,
>  >
>  > Brandon
>
>

Thanks again for all the advice.

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
