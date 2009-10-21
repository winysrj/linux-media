Return-path: <linux-media-owner@vger.kernel.org>
Received: from dangerbird.closetothewind.net ([82.134.87.117]:54909 "EHLO
	dangerbird.closetothewind.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbZJUSsS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 14:48:18 -0400
Received: from [192.168.1.22] ([213.153.15.207])
	by dangerbird.closetothewind.net (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id n9LIGAnd024476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 21 Oct 2009 20:16:10 +0200
Message-ID: <4ADF4FEA.1040907@closetothewind.net>
Date: Wed, 21 Oct 2009 20:16:10 +0200
From: Jonas Kvinge <linuxtv@closetothewind.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Corruption and decoding problems on SD channels with Hauppauge WinTV-Nova-HD-S2,
 HD channels are fine.]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

I'm having frequently "Unknown audio decoding error", "Header missing",
"ac-tex damaged" on what seem to be all SD channels, which resutls in
prebuffering pause in MythTV. All HD channels are fine and no problems.
The channels  which are worst are also very hard to lock. Sometimes some
channels are not watchable at all.

I am using Canal Digital in Norway, channel listing can be found here:

http://www.telenorsbc.com/templates/Page.aspx?id=678


I have had this problem for about a month. I know that Canal
Digital have done some changes to the transponders around the same time
that this happened. But I don't know if this has anything to do with it.
I have deleted all transponders and channels in MythTV and rescanned
everything.

It seem like a bad signal, but when testing with the set-top box from
the provider it shows signal strength 80% and signal quality 90%. Also
it is strange that all HD channels would work fine if there was a poor
signal.

* I got a Hauppauge Nova-HD-S2 card. Using Kernel 2.6.30.9 and MythTV
trunk revision 22257

* My dish is pointed correctly using a satellite finder. it shows 9 out
of 10 when the db button is set at the lowest. This is the best signal I
have ever had. I've tried to slightly adjust the dish anyway without any
change.

* I have replaced the LNB, it is a Triax Quad LNB.

* I got two cables from the dish, same problem with both cables.

* In MYthTV signal is shown as 85-86%. BE is 0. This is the same as I
have always had when it was working.

I have also tested with a Technotrend Budget S-3200 card, which had the
same problems, except that this card does not work on HD channels at
all, which it never have.

Here is the log when this happens:

2009-10-08 15:58:43.381 mythfrontend version: trunk [22257] www.mythtv.org
2009-10-08 15:58:43.406 Using runtime prefix = /usr/local
2009-10-08 15:58:43.406 Using configuration directory = /home/jonas/.mythtv
2009-10-08 15:58:44.147 Unable to read configuration file mysql.txt
2009-10-08 15:58:44.148 Empty LocalHostName.
2009-10-08 15:58:44.148 Using localhost value of linuxtv
2009-10-08 15:58:44.151 New DB connection, total: 1
2009-10-08 15:58:44.154 Connected to database 'mythconverg' at host:
localhost
2009-10-08 15:58:44.155 Closing DB connection named 'DBManager0'
2009-10-08 15:58:44.188 DPMS is active.
2009-10-08 15:58:44.189 Primary screen: 0.
2009-10-08 15:58:44.190 Connected to database 'mythconverg' at host:
localhost
2009-10-08 15:58:44.191 Using screen 0, 1920x1080 at 0,0
2009-10-08 15:58:44.233 MythUI Image Cache size set to 20971520 bytes
2009-10-08 15:58:44.233 Enabled verbose msgs:  important general
2009-10-08 15:58:44.237 Primary screen: 0.
2009-10-08 15:58:44.237 Using screen 0, 1920x1080 at 0,0
2009-10-08 15:58:44.238 Using theme base resolution of 800x600
2009-10-08 15:58:44.244 LIRC: Successfully initialized '/dev/lircd'
using '/home/jonas/.mythtv/lircrc' config
2009-10-08 15:58:44.396 Using the Qt painter
2009-10-08 15:58:44.398 Unknown tag size:small in font 'small'
2009-10-08 15:58:44.398 Specified base font 'small' does not exist for
font medium
2009-10-08 15:58:44.398 Specified base font 'small' does not exist for
font large
2009-10-08 15:58:44.404 Loading base theme from
/usr/local/share/mythtv/themes/G.A.N.T/base.xml
2009-10-08 15:58:44.527 Loading base theme from
/usr/local/share/mythtv/themes/default/base.xml
2009-10-08 15:58:44.529 Current MythTV Schema Version (DBSchemaVer): 1244
2009-10-08 15:58:44.859 Desktop video mode: 1920x1080 60.0024 Hz
2009-10-08 15:58:44.960 Registering Internal as a media playback plugin.
2009-10-08 15:58:44.974 Cannot load language en_gb for module mytharchive
2009-10-08 15:58:44.975 Cannot load language en_gb for module mythbrowser
2009-10-08 15:58:44.976 Registering WebBrowser as a media playback plugin.
2009-10-08 15:58:44.977 Cannot load language en_gb for module mythbrowser
2009-10-08 15:58:44.983 Cannot load language en_gb for module mythflix
2009-10-08 15:58:45.016 MonitorRegisterExtensions(0x100, gif,jpg,png)
2009-10-08 15:58:45.016 Cannot load language en_gb for module mythgallery
2009-10-08 15:58:45.020 Cannot load language en_gb for module mythgame
2009-10-08 15:58:45.022 Cannot load language en_gb for module mythmovies
2009-10-08 15:58:45.032 Current MythMusic Schema Version
(MusicDBSchemaVer): 1017
2009-10-08 15:58:45.059 MonitorRegisterExtensions(0x40,
mp3,mp2,ogg,oga,flac,wma,wav,ac3,oma,omg,atp,ra,dts,aac,m4a,aa3,tta,mka,aiff,swa,wv)
2009-10-08 15:58:45.062 Cannot load language en_gb for module mythmusic
2009-10-08 15:58:45.065 Cannot load language en_gb for module mythnews
2009-10-08 15:58:45.070 Current MythVideo Schema Version
(mythvideo.DBSchemaVer): 1028
2009-10-08 15:58:45.091 Cannot load language en_gb for module mythvideo
2009-10-08 15:58:45.096 Cannot load language en_gb for module mythweather
2009-10-08 15:58:45.100 Specified base font 'small' does not exist for
font clock
2009-10-08 15:58:45.179 Loading window theme from
/usr/local/share/mythtv/themes/G.A.N.T/menu-ui.xml
2009-10-08 15:58:45.235 Loading menu theme from
/usr/local/share/mythtv/themes/defaultmenu//mainmenu.xml
2009-10-08 15:58:45.236 Found mainmenu.xml for theme 'G.A.N.T'
2009-10-08 15:58:45.257 MythContext: Connecting to backend server:
127.0.0.1:6543 (try 1 of 1)
2009-10-08 15:58:45.258 Using protocol version 50
2009-10-08 15:58:49.342 New DB connection, total: 2
2009-10-08 15:58:49.343 Connected to database 'mythconverg' at host:
localhost
2009-10-08 15:58:49.454 TV: Attempting to change from None to Watching
WatchingLiveTV
2009-10-08 15:58:49.455 MythContext: Connecting to backend server:
127.0.0.1:6543 (try 1 of 1)
2009-10-08 15:58:49.455 Using protocol version 50
2009-10-08 15:58:49.465 Spawning LiveTV Recorder -- begin
2009-10-08 15:58:49.679 Spawning LiveTV Recorder -- end
2009-10-08 15:58:49.684 We have a
playbackURL(/mnt/store/livetv/2502_20091008155849.mpg) & cardtype(DUMMY)
2009-10-08 15:58:49.684 We have a RingBuffer
2009-10-08 15:58:49.685 TV: StartPlayer(0, Watching WatchingLiveTV,
main) -- begin
2009-10-08 15:58:49.701 NVP(0): Disabling Audio, params(-1,2,44100)
2009-10-08 15:58:49.714 VideoOutputXv: XVideo Adaptor Name: 'NV17 Video
Texture'
2009-10-08 15:58:49.737 OSD Theme Dimensions W: 640 H: 480
2009-10-08 15:58:49.919 TV: StartPlayer(0, Watching WatchingLiveTV,
main) -- end ok
2009-10-08 15:58:49.919 TV: Changing from None to Watching WatchingLiveTV
2009-10-08 15:58:49.919 TV: State is LiveTV & mctx == ctx
2009-10-08 15:58:49.919 New DB connection, total: 3
2009-10-08 15:58:49.920 New DB connection, total: 4
2009-10-08 15:58:49.920 Realtime priority would require SUID as root.
2009-10-08 15:58:49.920 Connected to database 'mythconverg' at host:
localhost
2009-10-08 15:58:49.920 Connected to database 'mythconverg' at host:
localhost
2009-10-08 15:58:49.921 TV: UpdateOSDInput done
2009-10-08 15:58:49.921 TV: UpdateLCD done
2009-10-08 15:58:49.921 TV: ITVRestart done
2009-10-08 15:58:49.923 Video timing method: USleep with busy wait
2009-10-08 15:58:49.943 ScreenSaverX11Private: DPMS Deactivated 1
2009-10-08 15:58:51.681 [mp2 @ 0x7fba415d07e0]Header missing
2009-10-08 15:58:52.458 VideoOutputXv: XVideo Adaptor Name: 'NV17 Video
Texture'
2009-10-08 15:58:52.593 AFD: Opened codec 0x7fba21a4b080, id(MPEG2VIDEO)
type(Video)
2009-10-08 15:58:52.593 AFD: codec MP2 has 2 channels
2009-10-08 15:58:52.593 AFD: Opened codec 0x7fba21d06020, id(MP2)
type(Audio)
2009-10-08 15:58:52.688 Opening audio device '/dev/dsp'. ch 2(2) sr 48000
2009-10-08 15:58:52.688 Opening OSS audio device '/dev/dsp'.
2009-10-08 15:58:52.691 NVP(0): Enabling Audio
2009-10-08 16:00:01.974 [mp2 @ 0x7fba415d07e0]incomplete frame
2009-10-08 16:00:01.974 AFD Error: Unknown audio decoding error
2009-10-08 16:00:01.974 LiveTV forcing JumpTo 1
2009-10-08 16:02:30.472 NVP(0): prebuffering pause
2009-10-08 16:18:00.325 NVP(0): prebuffering pause
2009-10-08 16:19:15.211 NVP(0): prebuffering pause
2009-10-08 16:19:16.812 NVP(0): Prebuffer wait timed out 10 times.
2009-10-08 16:19:18.412 NVP(0): Prebuffer wait timed out 20 times.
2009-10-08 16:19:20.013 NVP(0): Prebuffer wait timed out 30 times.
2009-10-08 16:19:20.045 [mp2 @ 0x7fba415d07e0]Header missing
2009-10-08 16:19:20.045 AFD Error: Unknown audio decoding error
2009-10-08 16:19:20.590 [mpeg2video @ 0x7fba415d07e0]00 motion_type at 31 31
2009-10-08 16:19:20.590 [mpeg2video @ 0x7fba415d07e0]Warning MVs not
available
2009-10-08 16:19:20.799 NVP(0): prebuffering pause
2009-10-08 16:19:29.792 TV: ASK_RECORDING 1 29 0 0 hasrec: 0 haslater: 0
2009-10-08 16:19:29.970 TV: ASK_RECORDING 2 29 0 0 hasrec: 0 haslater: 0
2009-10-08 16:20:05.875 [mp2 @ 0x7fba415d07e0]Header missing
2009-10-08 16:20:07.192 NVP(0): Prebuffer wait timed out 10 times.
2009-10-08 16:20:08.792 NVP(0): Prebuffer wait timed out 20 times.
2009-10-08 16:20:08.838 AFD: Opened codec 0x7fba231a2660, id(MPEG2VIDEO)
type(Video)
2009-10-08 16:20:08.838 AFD: codec MP2 has 2 channels
2009-10-08 16:20:08.838 AFD: Opened codec 0x7fba231ae350, id(MP2)
type(Audio)
2009-10-08 16:20:24.774 [mp2 @ 0x7fba415d07e0]Header missing
2009-10-08 16:20:24.774 AFD Error: Unknown audio decoding error
2009-10-08 16:20:24.774 [mp2 @ 0x7fba415d07e0]Header missing
2009-10-08 16:20:24.774 AFD Error: Unknown audio decoding error
2009-10-08 16:20:25.971 NVP(0): prebuffering pause
2009-10-08 16:20:27.572 NVP(0): Prebuffer wait timed out 10 times.
2009-10-08 16:20:28.980 [mp2 @ 0x7fba415d07e0]Header missing
2009-10-08 16:20:28.980 AFD Error: Unknown audio decoding error
2009-10-08 16:20:29.173 NVP(0): Prebuffer wait timed out 20 times.
2009-10-08 16:20:29.283 [mpeg2video @ 0x7fba415d07e0]ac-tex damaged at 34 30
2009-10-08 16:20:29.283 [mpeg2video @ 0x7fba415d07e0]Warning MVs not
available
2009-10-08 16:20:29.910 NVP(0): prebuffering pause
2009-10-08 16:20:44.588 NVP(0): prebuffering pause
2009-10-08 16:20:46.189 NVP(0): Prebuffer wait timed out 10 times.
2009-10-08 16:20:47.790 NVP(0): Prebuffer wait timed out 20 times.
2009-10-08 16:20:48.568 [mp2 @ 0x7fba415d07e0]Header missing
2009-10-08 16:20:48.568 AFD Error: Unknown audio decoding error
2009-10-08 16:20:48.614 NVP(0): prebuffering pause
2009-10-08 16:20:48.991 [mpeg2video @ 0x7fba415d07e0]ac-tex damaged at 35 15
2009-10-08 16:20:48.991 [mpeg2video @ 0x7fba415d07e0]Warning MVs not
available
2009-10-08 16:21:04.432 NVP(0): prebuffering pause
2009-10-08 16:21:06.032 NVP(0): Prebuffer wait timed out 10 times.
2009-10-08 16:21:07.633 NVP(0): Prebuffer wait timed out 20 times.
2009-10-08 16:21:09.234 NVP(0): Prebuffer wait timed out 30 times.
2009-10-08 16:21:10.835 NVP(0): Prebuffer wait timed out 40 times.
2009-10-08 16:21:12.435 NVP(0): Prebuffer wait timed out 50 times.
2009-10-08 16:21:14.036 NVP(0): Prebuffer wait timed out 60 times.
2009-10-08 16:21:15.637 NVP(0): Prebuffer wait timed out 70 times.
2009-10-08 16:21:17.238 NVP(0): Prebuffer wait timed out 80 times.
2009-10-08 16:21:18.574 [mp2 @ 0x7fba415d07e0]Header missing
2009-10-08 16:21:18.574 AFD Error: Unknown audio decoding error
2009-10-08 16:21:18.616 NVP(0): prebuffering pause
2009-10-08 16:21:18.764 [mpeg2video @ 0x7fba415d07e0]ac-tex damaged at 34 11
2009-10-08 16:21:34.352 NVP(0): prebuffering pause
2009-10-08 16:21:35.953 NVP(0): Prebuffer wait timed out 10 times.
2009-10-08 16:21:37.554 NVP(0): Prebuffer wait timed out 20 times.
2009-10-08 16:21:38.416 [mp2 @ 0x7fba415d07e0]Header missing
2009-10-08 16:21:38.416 AFD Error: Unknown audio decoding error
2009-10-08 16:21:38.463 NVP(0): prebuffering pause
2009-10-08 16:21:38.898 [mpeg2video @ 0x7fba415d07e0]invalid mb type in
B Frame at 29 8
2009-10-08 16:21:54.552 NVP(0): prebuffering pause
2009-10-08 16:21:56.153 NVP(0): Prebuffer wait timed out 10 times.
2009-10-08 16:21:57.754 NVP(0): Prebuffer wait timed out 20 times.
2009-10-08 16:21:59.355 NVP(0): Prebuffer wait timed out 30 times.
2009-10-08 16:22:00.956 NVP(0): Prebuffer wait timed out 40 times.
2009-10-08 16:22:02.556 NVP(0): Prebuffer wait timed out 50 times.
2009-10-08 16:22:04.157 NVP(0): Prebuffer wait timed out 60 times.
2009-10-08 16:22:05.758 NVP(0): Prebuffer wait timed out 70 times.
2009-10-08 16:22:07.359 NVP(0): Prebuffer wait timed out 80 times.
2009-10-08 16:22:08.960 NVP(0): Prebuffer wait timed out 90 times.
2009-10-08 16:22:10.561 NVP(0): Prebuffer wait timed out 100 times.
2009-10-08 16:22:10.561 NVP(0), Error: Timed out waiting for
prebuffering too long. Exiting..
2009-10-08 16:22:10.790 TV: Attempting to change from Watching
WatchingLiveTV to None
2009-10-08 16:22:10.790 [mp2 @ 0x7fba415d07e0]Header missing
2009-10-08 16:22:10.790 AFD Error: Unknown audio decoding error
2009-10-08 16:22:10.855 TV: Changing from Watching WatchingLiveTV to None
2009-10-08 16:22:10.877 ScreenSaverX11Private: DPMS Reactivated 1
2009-10-08 16:22:10.877 TV: Attempting to change from None to None
2009-10-08 16:22:10.913 TV: Attempting to change from None to Watching
WatchingLiveTV
2009-10-08 16:22:10.915 MythContext: Connecting to backend server:
127.0.0.1:6543 (try 1 of 1)
2009-10-08 16:22:10.915 Using protocol version 50
2009-10-08 16:22:10.925 Spawning LiveTV Recorder -- begin
2009-10-08 16:22:11.063 Spawning LiveTV Recorder -- end
2009-10-08 16:22:11.069 We have a
playbackURL(/mnt/store/livetv/2508_20091008162211.mpg) & cardtype(DUMMY)
2009-10-08 16:22:11.071 We have a RingBuffer
2009-10-08 16:22:11.072 TV: StartPlayer(0, Watching WatchingLiveTV,
main) -- begin
2009-10-08 16:22:11.072 playCtx, Error: Attempting to setup a player,
but it already exists.
2009-10-08 16:22:11.072 TV: StartPlayer(0, Watching WatchingLiveTV,
main) -- end error
2009-10-08 16:22:11.072 TV Error: LiveTV not successfully started
2009-10-08 16:22:11.093 ScreenSaverX11Private: DPMS Deactivated 1
2009-10-08 16:22:11.093 ScreenSaverX11Private: DPMS Reactivated 1


Jonas

