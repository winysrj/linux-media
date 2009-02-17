Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from paja.nic.funet.fi ([193.166.3.10])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kouhia@nic.funet.fi>) id 1LZWnJ-0003X3-KU
	for linux-dvb@linuxtv.org; Tue, 17 Feb 2009 21:43:56 +0100
Received: (from localhost user: 'kouhia' uid#241 fake: STDIN
	(kouhia@paja.nic.funet.fi)) by nic.funet.fi id S95672AbZBQUntw3OD4
	for <linux-dvb@linuxtv.org>; Tue, 17 Feb 2009 22:43:49 +0200
From: Juhana Sadeharju <kouhia@nic.funet.fi>
To: linux-dvb@linuxtv.org
Message-Id: <S95672AbZBQUntw3OD4/20090217204349Z+4425@nic.funet.fi>
Date: Tue, 17 Feb 2009 22:43:49 +0200
Subject: [linux-dvb] Klear?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Hello.
Ubuntu has Klear DVB viewer/recorder. I like the GUI:
Video image appears at one GUI drawing area, making
switches between 4:3 and 16:9 modes transparent.
Non-fullscreen and arbitrarily resizeable window is
very practical.
http://www.klear.org

However, Klear has last update 2006, and it does not
support subtitles which are very important here in Finland.

I already wrote 50+ item feedback list which I posted to
developers but because it is a freezed project, perhaps
my list finds use here. What would be equivalent active
DVB viewer/recorder project? I will contact them with my list
if they are not here.

Juhana

 == Klear feedback follows ==

Hello. Klear has problems. Below is a quick list.
The problem (1) on subtitles should be solved immediately.
The problem (2) hints a quick alternative solution which
would work when waiting proper solution.

(1) No subtitles (of YLE channels in Finland).
I have to switch away from Klear very quickly if there
is no quick solution to subtitles.
(In a couple of days, we have had programs in english, hindi,
french, italian, spain, german, russian; all this in just
3 national channels; many other languages have occured in the
recent past: asian and south-american languages. All subtitled.)

What software supports subtitles already? And is in Debian/Ubuntu?
I may take a look at how they implement the subtitles: what kind
of code is needed to support subtitles, etc.

I will check the source code of Klear in any case, but I may be
unable to implement anything.

(2) Are subtitles recorded? If they would be recorded, I could
view the recordings later with a program which knows how to
display the subtitles.

If not yet, please record the subtitles and all other channel
features from now on. In any recording, it is best to record
all what comes and not drop any extra data: there are more extra
data than subtitles and are broadcasted by YLE now.

If you don't understand the extra data, it is better to record
them than skip them. I don't know details of DVB stream. Just
record the data as it comes. Topfield recorders records the
original stream and it works fine.

If the original one channel DVB stream is available at some
stage inside Klear, I will look at how to record it to disk.
But you may be faster coders than me.

(3) Is the recording bit-by-bit the same as what comes from
the DVB-T device? Does the device give out exactly what is in
the air?

If DVB is carrying mpeg data, does Klear convert the video to
different mpeg or is it the original mpeg data bit-by-bit?
Please don't downgrade the video image.

Note: the video looks like blocky MPEG. I did not notice such with
Topfield TF6000COT, but Topfield had some kind of staircased gradients
(in blue sky, in channel logos). If the staircased gradients are not
part of DVB system, I'm more happy with blocky than with staircasy.

(3b) If you prefer converted mpeg, then simultaneous recording of the
original stream and the mpeg would be nice too.

(4) The video is interlaced but deinterlacing button has no effect.
Where the deinterlacing is done?

(5) Record button is easily hidden by other apps.
Move the record button to far right. Or have buttons in a toolbar
at top, optional/alternative. When I'm not actively watching, I may
have other apps on top of klear. Buttons at top or sides of screen
are easier not to hide.

(6) Starting and stopping recording freezes the video display.
What kind of engine klear has? It would be nice if recording is
going on continuously with 10 minutes buffer (configurable).

(7a) Trying to view a crypted channel caused freeze, timeout, and crash.
I got this error with a valid channel as well. That channel
has worked ok many times before, and worked without clearing the
configure file.
I got this error as well with a valid channel after/within a minute
of ok view.

(7b) After crash, klear fails to start because that problem channel
stays as the default channel. Klear crashes again.
Suggestion: The default channel should be the last channel which
worked. That is, don't change the default channel in klear.conf
before the channel is working.

Now I have to delete the klear config file at every crash.

(8) Klear uses Desktop/ as default directory but better place is
Videos/. In any case, I don't want any file to visually clutter
my display. Who wants?

(9) Text-TV does not work. Black window with "001".
Quitting with "x" in window frame leads to a not responding
alert, and force quit will quit the whole klear.

(10) The filenames should be based on the start time, not on
the end time of recording.

(11) The channel names may have spaces ("YLE TV1"). I would
like to have them replaced with "_" because double click
copy-selection in terminals does not work with spaces.

(12) Use 20090215 date format. It is better because files listed
becomes sorted by date. Make this configurable if you prefer
the current style. You may add date(1) style format string to
configure if you wish. E.g., %Y%m%d gives 20090215 style.
Define new controls for the channel name (%K if free) if you wish.
E.g., "klear_%K_%Y%m%d.mpg" or "%Y%m%d_%K.mpeg" etc.
If you do that, always prepare to add an extra running number
"_001" if file exists. That is much better than asking if to
overwrite.
Note: Check also scheduled recording dialog. It is USA format now.
Make it configurable as well: 31/10/2009 for europeans, or
2009/10/31.
Note: I find "." char in times and dates poor: "15.02.09-03.20.41.mpeg".

(13) Scheduled recording should include feature "everyday",
"every weekend day", "every friday", "every thursday and friday"
etc. Perhaps as 7 flags, one per day.

(13b) It would be ok if schedules could be easily copied.
E.g., add this schedule to following 7 days, and add this
week's schedule to next week.

(14) My Gnome has ok aspect ratio but Klear has not. I suggest to
add an aspect ratio multiplier. In configuring the multiplier, do
display a test screen with a square rectangle. I may then measure
the square and adjust until it really is square in real.
Only for display, not for recording.
I could adjust the monitor but because Gnome looks ok, give me
the option to adjust the displayed video image instead.

(15) One TV program displayed with 4:3 ratio instead of widescreen.
Include a menu entry to switch the aspect ratio manually.
(Do not put it to configure.)

(16) Crypted channels and radio channels could be marked somehow.

(17) A test to check automatically if crypted channels are still
crypted. This would be useful in notifying if a commercial movie
channel has a free weekend.

(18) Someone modified "/var/lib/alsa/asound.state" without my will
(at the install time?). Worse, speaker channels were disabled somehow,
only headphones worked. I have disabled modification of asound.state
at the shutdown (/etc/init.d/). It should stay fixed because reboot
should work as a restore.

(19) I would need the display effect gamma, brightness, contrast
as a post processor, for display only. Monitor's brightness and
contrast does not work as I want.

(20) Adjustable delay between audio and video would be nice.
The lipsync has been ok, but now when I'm checking YLE's news,
a slight delay would be needed. Plus/minus valued delay.

(21) One document had problems with audio: while interviewed
people were heard stereo, the narrator and music came out
only from the left channel. Is Klear skipping an audio
mode control signal?

(22) Use of scroller of the mouse in video area crashed Klear.

(23) Scheduled recording dialog could have alternative way to
give the time: start and duration. Make sure both ways are updated
so that user may click between them and adjust the end time
in any mode.

(24) Does the DVB signal include date and time? That time should
be used for scheduled recording. The time could be displayed in
the GUI.

(25) Video display shows, say, block-copy artifacts. These shows
when video image is panning. I don't know what makes them: mpeg
decoder, copy operation of X, etc.

(26) EPG has missing entries. It shows this program (1 hour),
the next program (25 minutes), skips 1 hour, shows the following
program. I waited for 10 minutes, refreshed, closed and reopened
EPG window without changing channel.

(27) User may open multiple EPG windows, but each window points to
the current channel. It would be nice if the EPG window stays at
the channel until refresh is pressed. Now the EPG changes when
day is switched.

(28) EPG window with channel selector would be nice. The displayed
channel would not change, only the EPG channel. Now I actually have
to switch the channel before I may browse the EPG data.

(29) When I watch a channel, EPG data of all channels in the same
frequency should be collected and kept. EPG data should stay. The
data should stay over channel switch, exit, and restart, i.e.,
saved to ".klear/". It may take 7 minutes before the data is complete,
often the data of the next few programs comes last (in Topfield box).
The old EPG should only be updated.

(29b) Archive of EPG data. I have downloaded program listings from
the web and have used the archives. EPG archive could be browsed
as the EPG now. Separate archive section so that the EPG is not
cluttered with years old data. Later: search within the EPG archive.
Note: A few times I have checked a program and later wondered
what was it, or what earlier episodes were broadcasted in a series
I partially missed. So, archive is useful.

(30) "o'clock" in EPG should be removed.

(31) EPG displays the program text in two languages.
Is Klear skipping some EPG control signal? Topfield shows
only the other language.
Example program entry in the EPG list: "SkithouseFlabbdass".
Should be "Skithouse" only.

(32) Audio control should include left-only, right-only etc.
Sport events may have two channel audio: one channel finnish
language, second for swedish language. The audited channel
should be heard in both ears, i.e., mono-to-stereo conversion
must be performed. Topfield clearly gives audio options, there
might be proper channel configuration definitions in the stream.

(33) Disconnect Klear from the audio device. For scheduled recording
Klear may need to be kept running. But I cannot play music then.
Simple mute won't work. Best is to completely disconnect.
I'm not sure if it is needed to disconnect video. I may use another
desktop or minimize Klear window. But if CPU is used too much or
if GPU is used, then that is different case.

For scheduled recording only what is needed is a path from
TV-device to hard disk. When the original stream is recorded,
no video and audio decoding, display or auditing are needed.

(34) Player would be nice. For example, gmplayer opens a large
window for video display, larger than what is in Klear. 1:1 match
between Klear display and player display would be nice. Worse,
when I resize gmplayer window, the aspect ratio changes. gmplayer
does not obey standard X geometry definitions.

Note: xine cannot play Topfield's recordings (original stream).

And remember the switches between 3:4 and 16:9 modes. So, player in
Klear would be convenient. When the original stream is recorded,
Klear may fake that the played stream comes from the TV device
or so.

(35) Display of multiple channels simultaneously. As many channels
as comes in from one frequency if the TV device gives them out
as one stream.

(36) Display of multiple channels. Only one channel works at the
time. Others are just still images. The running channel may change
periodically.

(37) Picture in picture (PIP).

(38) Better startup doc. It took me hours to figure out what works.
Reference to klear.org won't help if user has no connection to
Internet. Docs included in distributions may be inadequate.
Here is miniguide:
1. scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/fi-Tampere > ~/.klear/channels.conf
2. klear

(39) What is the maximum file size nowadays? Klear could split
the recording to DVD sized pieces. In such a way that xine is able
to play them continuously. I don't remember exactly if xine plays
multiple files continuously, but
  cat part1.vob part2.vob > all.vob ; xine all.vob
worked.
(Any player should be able to play splitted file continuously.)
Multiple parts may be needed if user records 8-12 hours of Olympics
games. They often are broadcasted at inconvenient times.

(40) If Klear ever includes player, then the record button should
work normally. User may want record parts of the Olympics recording
without relying to video editors.

(41) Simultaneous recording of multiple channels.

(42) In scheduled recordings window, estimated total size of files
would be useful.

(43) Resize of the program detail subwindow in EPG.
When the EPG window is resized, only the program list is enlarged.

(44) Scheduled recording: If I stop a scheduled recording before
the end time, the scheduled recording is not removed. At next
exucution of klear later, the non-removed schedule gives an error.

(44b) That error message is wrong: "Start time must be after
current AND before end time." The error was given for situation
start time < end time < current time. That is an old scheduled
recording, not just a problem in start time. In fact, the problem
cannot be solved by adjusting the start time.

(44c) Solution could be to give no error (as it wastes users time)
and keep the schedule in the schedule list, possibly marked with
red color. User may want adjust it later at better time.

(44d) Allow user to mark schdules with "keep this after recording".
User may use the same entry at next day if TV program is periodic.

(44e) When scheduled via EPG, the name "test" caused an error.
Klear claims the name is in use, but I have no such recordings.

(44f) Even if the name is in use, Klear is supposed to use
the time or count postfix. Otherwise user's time is wasted with
these errors.

(45) Consider the case start time < current time < end time
as valid in scheduled recording. The recording should start immediately.
Starting recording in the middle of program via EPG gives this case.
User may use scheduled recording instead of the record button
if user needs a scheduled end time.

(46) ITR style recording: first button press sets the recording
time to 30 minutes, second to 60 minutes, etc. This is problematic
in Klear because the record button is switched to stop button.
Hardware recorders have both record and stop buttons.

That was all for now.

I like the GUI. All necessary in one window. Resizeable window
is nice and practical. Embedding the video image to black canvas
is good as it allows transparent image 3:4/16:9 changes, and does
not change the main window size. It is now hard to go to Windows
and use the official program even it has working subtitles.

Klear is now only viewer which works in Ubuntu. kvdr did not work
at all for Artec T14, perhaps because Artec does not have MPEG decoder.
I will test other DVB applications when I get them. None of them
are included in Ubuntu DVD.

Finally, what are the best open source DVB-T recorders/viewers in
Linux? I may want check if my problems exists in there as well
and give feedback.

Juhana

 == End ==

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
