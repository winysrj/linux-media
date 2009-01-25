Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from echoes.night-light.net ([84.49.14.38] ident=root)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@night-light.net>) id 1LR80r-0000vm-FI
	for linux-dvb@linuxtv.org; Sun, 25 Jan 2009 17:39:12 +0100
Received: from [192.168.1.22] (mediastation.night-light.localnet
	[192.168.1.22])
	by echoes.night-light.net (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0PGcxnl023047
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Sun, 25 Jan 2009 17:39:05 +0100
Message-ID: <497C95A3.3020704@night-light.net>
Date: Sun, 25 Jan 2009 17:38:59 +0100
From: Jonas Kvinge <linuxtv@night-light.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on HD
	channels
Reply-To: linux-media@vger.kernel.org
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

I got a Technotrend Budget S2-3200 card and is using Canal Digital in
Norway. Channels are found on;
http://www.telenorsbc.com/templates/Page.aspx?id=399

It seems that I got all the DVB-S channels working fine.

Nat Geo HD and Histoy Channel HD are the only two HD channels I can
lock, and I have problems with digital artefacts, lines across the
screen missing data and tons of errors from the frontend. See below for
error log.

MythTV does not find Discovery HD at all while some other HD channels
only get partial lock.

I'm using kernel 2.6.28 with
http://mercurial.intuxication.org/hg/s2-liplianin

mythtv from http://svn.mythtv.org/svn/trunk/ with all the patches from
http://svn.mythtv.org/trac/ticket/5882

I've also tested http://linuxtv.org/hg/v4l-dvb with the same results.


2008-12-31 05:19:40.009 mythfrontend version: trunk [19415M] www.mythtv.org
2008-12-31 05:19:40.010 Using runtime prefix = /usr/local
2008-12-31 05:19:40.821 DBHostName is not set in mysql.txt
2008-12-31 05:19:40.822 Assuming localhost
2008-12-31 05:19:40.822 Empty LocalHostName.
2008-12-31 05:19:40.822 Using localhost value of mediastation
2008-12-31 05:19:40.826 New DB connection, total: 1
2008-12-31 05:19:40.829 Connected to database 'mythconverg' at host:
localhost
2008-12-31 05:19:40.829 Closing DB connection named 'DBManager0'
2008-12-31 05:19:40.864 DPMS is active.
2008-12-31 05:19:40.865 Primary screen: 0.
2008-12-31 05:19:40.865 Connected to database 'mythconverg' at host:
localhost
2008-12-31 05:19:40.866 Using screen 0, 1920x1080 at 0,0
2008-12-31 05:19:40.900 MythUI Image Cache size set to 20971520 bytes
2008-12-31 05:19:40.901 Enabled verbose msgs:  important general
2008-12-31 05:19:41.314 Primary screen: 0.
2008-12-31 05:19:41.315 Using screen 0, 1920x1080 at 0,0
2008-12-31 05:19:41.315 Switching to square mode (G.A.N.T)
2008-12-31 05:19:41.319 Using the Qt painter
mythtv: could not connect to socket
mythtv: No such file or directory
2008-12-31 05:19:41.319 lirc_init failed for mythtv, see preceding messages
2008-12-31 05:19:41.548 Loading from:
/usr/local/share/mythtv/themes/G.A.N.T/base.xml
2008-12-31 05:19:41.798 Loading from:
/usr/local/share/mythtv/themes/default/base.xml
2008-12-31 05:19:41.830 Current Schema Version: 1226
2008-12-31 05:19:41.833 Connecting to backend server: 127.0.0.1:6543
(try 1 of 5)
2008-12-31 05:19:41.834 Using protocol version 42
2008-12-31 05:19:41.912 Registering Internal as a media playback plugin.
2008-12-31 05:19:41.959 MonitorRegisterExtensions(0x100, gif,jpg,png)
2008-12-31 05:19:43.494 Failed to run 'cdrecord --scanbus' error code: 2
QProcess: Destroyed while process is still running.
2008-12-31 05:19:43.530 MonitorRegisterExtensions(0x40, ogg,mp3,aac,flac)
2008-12-31 05:19:43.565 SIP listening on IP Address 192.168.1.22:5060
NAT address 192.168.1.22
2008-12-31 05:19:43.567 SIP: Cannot register; proxy, username or
password not set
2008-12-31 05:19:44.765 Loading from:
/usr/local/share/mythtv/themes/G.A.N.T/menu-ui.xml
2008-12-31 05:19:44.770 Found mainmenu.xml for theme 'G.A.N.T'
2008-12-31 05:19:57.503 New DB connection, total: 2
2008-12-31 05:19:57.504 Connected to database 'mythconverg' at host:
localhost
2008-12-31 05:19:57.619 TV: Attempting to change from None to WatchingLiveTV
2008-12-31 05:19:57.620 Using protocol version 42
2008-12-31 05:19:59.996 NVP: Disabling Audio, params(-1,2,44100)
2008-12-31 05:20:00.065 VideoOutputXv: XVideo Adaptor Name: 'NV17 Video
Texture'
2008-12-31 05:20:00.087 OSD Theme Dimensions W: 640 H: 480
2008-12-31 05:20:00.262 TV: Changing from None to WatchingLiveTV
2008-12-31 05:20:00.262 New DB connection, total: 3
2008-12-31 05:20:00.263 New DB connection, total: 4
2008-12-31 05:20:00.263 Connected to database 'mythconverg' at host:
localhost
2008-12-31 05:20:00.264 Realtime priority would require SUID as root.
2008-12-31 05:20:00.264 Connected to database 'mythconverg' at host:
localhost
2008-12-31 05:20:00.365 Video timing method: USleep with busy wait
2008-12-31 05:20:00.367 DPMS Deactivated
2008-12-31 05:20:05.535 NVP: Prebuffer wait timed out 10 times.
2008-12-31 05:20:06.913 VideoOutputXv Error: XvMC output requested, but
is not supported by display.
Xlib:  extension "XVideo-MotionCompensation" missing on display ":0.0".
Xlib:  extension "XVideo-MotionCompensation" missing on display ":0.0".
XvMCWrapper: Could not open config file "/etc/X11/XvMCConfig".
XvMCWrapper: No such file or directory
2008-12-31 05:20:06.918 VideoOutputXv: Desired video renderer
'xvmc-blit' not available.
                        codec 'H.264' makes 'opengl,xv-blit,xshm,xlib,'
available, using 'opengl' instead.
2008-12-31 05:20:07.223 AFD: Opened codec 0x7fae3404d970, id(H264)
type(Video)
2008-12-31 05:20:07.223 AFD: codec MP3 has 2 channels
2008-12-31 05:20:07.223 AFD: Opened codec 0x7fae36f573c0, id(MP3)
type(Audio)
2008-12-31 05:20:07.223 AFD: Opened codec 0x7fae34090930,
id(DVB_SUBTITLE) type(Subtitle)
2008-12-31 05:20:07.223 AFD: Opened codec 0x7fae34054710,
id(DVB_SUBTITLE) type(Subtitle)
2008-12-31 05:20:07.223 AFD: Opened codec 0x7fae37e954b0,
id(DVB_SUBTITLE) type(Subtitle)
2008-12-31 05:20:07.275 Opening audio device 'default'. ch 2(2) sr 48000
2008-12-31 05:20:07.275 Opening ALSA audio device 'default'.
ALSA lib control.c:909:(snd_ctl_open_noupdate) Invalid CTL /dev/mixer
2008-12-31 05:20:07.322 AudioOutput Warning: Mixer attach error -2: No
such file or directory
                        Check Mixer Name in Setup: '/dev/mixer'
2008-12-31 05:20:07.322 NVP: Enabling Audio
2008-12-31 05:20:07.398 [h264 @ 0x7fae468ba3e0]B picture before any
references, skipping
2008-12-31 05:20:07.398 [h264 @ 0x7fae468ba3e0]decode_slice_header error
2008-12-31 05:20:07.398 [h264 @ 0x7fae468ba3e0]B picture before any
references, skipping
2008-12-31 05:20:07.398 [h264 @ 0x7fae468ba3e0]decode_slice_header error
2008-12-31 05:20:07.398 [h264 @ 0x7fae468ba3e0]B picture before any
references, skipping
2008-12-31 05:20:07.398 [h264 @ 0x7fae468ba3e0]decode_slice_header error
2008-12-31 05:20:07.398 [h264 @ 0x7fae468ba3e0]B picture before any
references, skipping
2008-12-31 05:20:07.398 [h264 @ 0x7fae468ba3e0]decode_slice_header error
2008-12-31 05:20:07.398 [h264 @ 0x7fae468ba3e0]B picture before any
references, skipping
2008-12-31 05:20:07.399 [h264 @ 0x7fae468ba3e0]decode_slice_header error
2008-12-31 05:20:07.399 [h264 @ 0x7fae468ba3e0]B picture before any
references, skipping
2008-12-31 05:20:07.399 [h264 @ 0x7fae468ba3e0]decode_slice_header error
2008-12-31 05:20:07.399 [h264 @ 0x7fae468ba3e0]no frame!
2008-12-31 05:20:07.399 AFD Error: Unknown decoding error
2008-12-31 05:20:07.737 NVP: Prebuffer wait timed out 10 times.
2008-12-31 05:20:08.536 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 66
2008-12-31 05:20:08.536 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
66, bytestream (404)
2008-12-31 05:20:08.655 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 61
2008-12-31 05:20:08.655 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
61, bytestream (14323)
2008-12-31 05:20:08.702 [h264 @ 0x7fae468ba3e0]error while decoding MB
116 42, bytestream (-9)
2008-12-31 05:20:09.351 [h264 @ 0x7fae468ba3e0]error while decoding MB
47 22, bytestream (-5)
2008-12-31 05:20:09.507 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 27
2008-12-31 05:20:09.508 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
27, bytestream (15764)
2008-12-31 05:20:09.516 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 49
2008-12-31 05:20:09.516 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
49, bytestream (16402)
2008-12-31 05:20:10.138 [dvbsub @ 0x7fae468ba3e0]Invalid y position!
2008-12-31 05:20:10.524 [dvbsub @ 0x7fae468ba3e0]Invalid y position!
2008-12-31 05:20:11.918 [h264 @ 0x7fae468ba3e0]error while decoding MB
111 43, bytestream (-4)
2008-12-31 05:20:14.965 [dvbsub @ 0x7fae468ba3e0]Invalid y position!
2008-12-31 05:20:15.326 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 37
2008-12-31 05:20:15.326 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
37, bytestream (21988)
2008-12-31 05:20:15.523 [dvbsub @ 0x7fae468ba3e0]Invalid y position!
2008-12-31 05:20:15.877 [h264 @ 0x7fae468ba3e0]error while decoding MB
23 56, bytestream (-5)
2008-12-31 05:20:15.905 [h264 @ 0x7fae468ba3e0]top block unavailable for
requested intra mode at 76 22
2008-12-31 05:20:15.905 [h264 @ 0x7fae468ba3e0]error while decoding MB
76 22, bytestream (19358)
2008-12-31 05:20:16.752 [h264 @ 0x7fae468ba3e0]top block unavailable for
requested intra mode at 32 22
2008-12-31 05:20:16.752 [h264 @ 0x7fae468ba3e0]error while decoding MB
32 22, bytestream (49962)
2008-12-31 05:20:18.181 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 8
2008-12-31 05:20:18.181 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
8, bytestream (10032)
2008-12-31 05:20:20.276 [dvbsub @ 0x7fae468ba3e0]Invalid y position!
2008-12-31 05:20:20.620 [dvbsub @ 0x7fae468ba3e0]Invalid y position!
2008-12-31 05:20:20.829 [h264 @ 0x7fae468ba3e0]top block unavailable for
requested intra4x4 mode -1 at 38 34
2008-12-31 05:20:20.830 [h264 @ 0x7fae468ba3e0]error while decoding MB
38 34, bytestream (18440)
2008-12-31 05:20:23.482 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 39
2008-12-31 05:20:23.482 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
39, bytestream (25890)
2008-12-31 05:20:24.299 [h264 @ 0x7fae468ba3e0]cabac decode of qscale
diff failed at 61 18
2008-12-31 05:20:24.299 [h264 @ 0x7fae468ba3e0]error while decoding MB
61 18, bytestream (8779)
2008-12-31 05:20:24.434 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 38
2008-12-31 05:20:24.434 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
38, bytestream (31214)
2008-12-31 05:20:24.907 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 26
2008-12-31 05:20:24.907 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
26, bytestream (37075)
2008-12-31 05:20:25.376 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 18
2008-12-31 05:20:25.377 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
18, bytestream (5335)
2008-12-31 05:20:25.420 [h264 @ 0x7fae468ba3e0]error while decoding MB
70 39, bytestream (-12)
2008-12-31 05:20:25.421 [h264 @ 0x7fae468ba3e0]cabac decode of qscale
diff failed at 3 46
2008-12-31 05:20:25.421 [h264 @ 0x7fae468ba3e0]error while decoding MB 3
46, bytestream (5208)
2008-12-31 05:20:25.423 [h264 @ 0x7fae468ba3e0]error while decoding MB
22 57, bytestream (-7)
2008-12-31 05:20:25.758 [h264 @ 0x7fae468ba3e0]cabac decode of qscale
diff failed at 101 47
2008-12-31 05:20:25.758 [h264 @ 0x7fae468ba3e0]error while decoding MB
101 47, bytestream (13301)
2008-12-31 05:20:26.052 [dvbsub @ 0x7fae468ba3e0]Invalid y position!
2008-12-31 05:20:26.408 [dvbsub @ 0x7fae468ba3e0]Invalid y position!
2008-12-31 05:20:27.121 [h264 @ 0x7fae468ba3e0]error while decoding MB
78 55, bytestream (-23)
2008-12-31 05:20:31.759 [dvbsub @ 0x7fae468ba3e0]Invalid y position!
2008-12-31 05:20:33.602 [h264 @ 0x7fae468ba3e0]error while decoding MB
94 55, bytestream (-8)
2008-12-31 05:20:33.625 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 25
2008-12-31 05:20:33.625 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
25, bytestream (24144)
2008-12-31 05:20:34.967 [dvbsub @ 0x7fae468ba3e0]Invalid y position!
2008-12-31 05:20:35.314 [h264 @ 0x7fae468ba3e0]left block unavailable
for requested intra mode at 0 38
2008-12-31 05:20:35.314 [h264 @ 0x7fae468ba3e0]error while decoding MB 0
38, bytestream (9157)
2008-12-31 05:20:35.332 TV: Attempting to change from WatchingLiveTV to None
2008-12-31 05:20:35.527 TV: Changing from WatchingLiveTV to None
2008-12-31 05:20:35.628 DPMS Reactivated.
2008-12-31 05:20:37.124 Deleting UPnP client...
Error in my_thread_global_end(): 1 threads didn't exit
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkl8laMACgkQpvOo+MDrK1GLFACeMjknThCY2re5Ag9I3tOCO+Ig
kuAAn10RyWd5nnWpMW8WBVRiWG3O0+/g
=qoTi
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
