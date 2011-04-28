Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48146 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab1D1Khl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 06:37:41 -0400
Received: by gyd10 with SMTP id 10so903189gyd.19
        for <linux-media@vger.kernel.org>; Thu, 28 Apr 2011 03:37:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimHvVcQemhBq4XZR6G5=_5gTEww5Q@mail.gmail.com>
References: <BANLkTimHvVcQemhBq4XZR6G5=_5gTEww5Q@mail.gmail.com>
Date: Thu, 28 Apr 2011 15:07:40 +0430
Message-ID: <BANLkTikas4w3yT-N9a-i82cjdbaNWOyxVQ@mail.gmail.com>
Subject: Re: Some major problems of em28xx chip based TV devices in linux
From: a b <mjnhbg1@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello all

  Before anythings, i beg pardon of whom the matter of this e-mail is
not related to; please excuse me.
------------------------------------------------------------------
  Unfortunately i could not until now, use any DVB hardware on any
version of linux; i tested many of them but none of them can be
correctly used. :-(
  I tired from testing and testing all things about combination of my
linuxes and DVBs.
  Please help me with all things that you know, and please do not tell
the repeated things that i already tested, and please only think about
the exact problem.

  i myself is familiar with unix and linux from about 19 years ago,
and have done many low level programming on linux and unix in kernel
and user spaces, till now. Thus please don't explain the inexact
things and some non important things like options of /etc/syslog.conf
or hardware testing of computer main memory!!
  Please focus your mind, only on the problems, thanks.
------------------------------------------------------------------

  I this post i will explain in detail one of my efforts on a DVB
stick with hope to resolving my problems by one of you.
  I this recent case i bought a "Pinnacle PCTV Hybrid Pro Stick".
  The em28xx driver of dvb related modules claims to support this DVB-stick.
  But my testings were as follow and, at last, i could not get a
proper working from it.
----------------------------------------------------------------
  First of all i mention that, this DVB-stick (Pinnacle PCTV Hybride
Pro Stick) is supported under the Windows (XP and Vista) and i tested
this matter completely under the Win-XP with two softwares:
    1- Pinnacle PCTV MediaCenter version 4.4.1 that its CD was in its
own package, and
    2- Pinnacle PCTV TV_Center version 6.4.0.784. that i downloaded
from the pinnacle site: ( here:
http://www2.pctvdownloads.com/TV/application/TVC6/PCTV_TVCenter_6.4.0.784.exe
)
  The second software worked completely and could do all of its
features, for example with both Analog channels and Digital channels,
and only some minor misworking done, ( in some minor cases when the
CPU's load were high the sound had a few bad things. )
------------------------------------------------------------------
  After testing with Windows, please come with me to linux testing.
  I tested this DVB-Stick with 2 linux versions, Debian and Ubuntu.
Debian was lenny-i686 with kernel: 2.6.35.10 (that this kernel was
compiled by myself from is complete source downloaded from
www.kernel.org with complete activation of all device drivers as
kernel module) and Ubuntu was 10.10-amd64 (with 2 versions of kernel:
2.6.35.22 and 2.6.38.8, both of them was installed from the main
ubuntu repository "archive.ubuntu.com" )
  Both of linuxes were running on one computer, with a brief hardware
of 2.8-GHz Intel Core2due E7400 CPU & 1 Giga-Ram & 2 Sata Hard disk &
PK5PL Asus motherboard & Nvidia-G9500-GT graphic card.

  i will explain my testings after this brief writing about my main
(big) 7 problems:
    1- The only software that could show me some of TV programs, was
kaffeine, and no other softwares ( included mythtv & VLC & mplayer &
w_scan & scan of dvb-utils ) could show any things.
    2- No any software could find any digital (DVB) channels during
the scanning ( including even kaffeine).
    3- And even with kaffeine, the only way that i could watch some
TV, was in this manner: Before this DVB-stick i inserted another
DVB-USB stick in another linux computer and scan the channels with
kaffeine and after finding the channels, quit the kaffeine and copy
its database files ( $HOME/.kde/share/apps/kaffeine/* ) into the
testing computer for pinnacle DVB-USB hybrid stick. After that
copying, i could run kaffeine on the pinnacle DVB and without
scanning, thus i had a table of channels and in its main window and
when i clicked on a channel, that channel was shown.
    4- Another problem was that, only one of 14 digital TV channels
had sound, and no other 13 digital TV channels had sound.
    5- When i want to see another channel by clicking on another
channel, the kaffeine could not show it and after about 60 seconds
produces error message as: "Read error from:", and i must close and
quit the kaffeine and again run kaffeine, then it show that new
channel.
    6- About analog channels i have 2 problems (first one is a big
problem): No any analog channels has sound.
    7- Another problem with analog channels was when showing with some
software (mainly xawtv) sometimes the linux box hangs totally, and
only the mplayer could show the analog channels without video problem
( Of courses without sound).
  And my extra (minor) 2 problems:
    1- When the kaffeine is in fullscreen mode, not all of the movie
frames are shown, and then your eye can distinguish the frames from
each other; i guess about 12-18 frames per seconds are shown. In the
fullscreen mode i measured the CPU load and it has not about 99-100%
load, it only has about 80% load and thus dropping some frames per
seconds is not related to full loading of CPU.
    2- My computer's CPU was core2due E7400 with 2.8GHz speed ( 5595
bogomips), thus in such CPU the load of 80% was very high (and bad
matter) in compare to running a TV application on analog TV devices (
/dev/video0 v4l devices).
------------------------------------------------------------------------
  And now the explanation and characteristics of my testings:
  i provide you 5 files, as listed bellow for better understanding of problem:
  ( These files can be found here for you:
http://daftar.minidns.net/pctv/info.zip and
http://daftar.minidns.net/pctv/log.zip and
http://daftar.minidns.net/pctv/win-xp.zip and
http://daftar.minidns.net/pctv/kaffeine-conf.zip and
http://daftar.minidns.net/pctv/mplayer-output.zip )

    A- info.zip included some information of my testing computer and
linuxes. It includes:
      0- PCTV_Hybrid_Stick3.jpg: My DVB-Usb picture, itself.
      1- biosdecode : the output of "biosdecode" command.
      2- dmesg-2: the output of "dmesg" command after many testing.
      3- dmesg-1: the output of "dmesg" command after removing and
reinserting that DVB-USB stick.
      4- dmidecode: the output of "dmidecode" command.
      5- em28.conf: a file that i made in directory /etc/modprobe.d
for options of DVB-stick drivers.
      6- linuxinfo: the output of "linuxinfo" command.
      7- lshw: the output of "lshw" command.
      8- lspci: the output of "lspci" command.
      9- lspci-vvv: the output of "lspci -vvv" command.
      10-lsusb: the output of "lsusb" command.
      11-lsusb-vvv: the output of "lsusb -vvv" command.
      12-modules-all: the output of "lsmod" command.
      13-modules-tv: the output of "lsmod" command, and "grep" command
for only modules related to this DVB-stick including: em28xx,
em28xx_alsa, em28xx_dvb, tuner_xc2028, zl10353, tvp5150.
      14-uname-a: the output of "uname -a" command.
      15-vpddecode: the output of "vpddecode" command.
      16-xc3028-v27.fw: the firmware needed by xc2028,xc3028 chip of
the DVB-stick during the module loading.
      18-1.jpeg & 2.jpeg & 3.jpeg: some pictures from some kaffeine's windows.

    B- log.zip included some parts of /var/log/syslog during the
testings (will be explained later).

    C- win-xp.zip included channel information from the Windows
software TV showing.
      1- the file all-tv-channels.xml: containing the channel
information produced by above explained software (Pinnacle PCTV
TV_Center version 6.4.0.784).

    D- kaffeine-conf.zip: containing the configuration files of
kaffeine unzipped in $HOME/.kde/share/apps/kaffeine/

    E- mplayer-output.zip: containing 2 files of mplayer messages
during run for playing a channel.
      1- mplayer-dvb-debug-output.txt: during running the mplayer for
playing a digital TV channel (on DVB),
        that it could not be play it, at all.
      2- mplayer-tv-debug-output.txt:  during running the mplayer for
playing an analog TV channel,
        that it could play only its image, and without sound.
------------------------------------------------------------------------

    For my testings please assume, the linux box was booted after
inserting the DVB-USB stick, and after logging in, i ran kaffeine. But
because the kaffeine could not itself find any channel by its scan
tool, i must give it a table of channels before its running. Thus
before running the kaffeine, i provided its configuration files
(including channel list) from another linux box (files explained above
in file kaffeine-conf.zip) to its configuration directory (
$HOME/.kde/share/apps/kaffeine/ ).
    In this way, because the kaffeine had the some TV channels in its
channel table, after running it, it begins to play the last channel
played before its quit. And in this moment i saved some parts of
/var/log/syslog file related to debugging output of DVB-USB device
drivers in file "s5" (included in syslog.zip).
    Then i clicked on another channel on channel table (one of those
13 TV channels without sound), and saved the parts related to these
moments of /var/log/syslog in "s6".
    Then i closed the kafeine and reran it and, it showed that new
channel for some seconds, then i clicked on that specific channel (
"IRIB NOOR" that was with sound) and i saved the parts of
/var/log/syslog related to these moments in "s7".
    Then i closed the kaffeine and then reran it and, it showed that
channel for some seconds, and i closed the kaffeine and saved the
parts of /var/log/syslog related to these moments in "s8".
    And the file "s9" is a special file containing some part of
/var/log/syslog related to new experience: during the last test of
kaffeine it finally could find 18 (TV & radio) channels with its scan
function (but not out complete 25 digital channels). Thus file "s9" is
related to scan time of kaffeine.
    i hope that this s5 to s9 files can help some of you to debug the
functionality of device drivers of this DVB-USB and finding its
problems and fixing them.
    And the file "s10" is another special file containing some part of
/var/log/syslog related to when inserting the DVB-USB stick, and its
initial interaction with linux and its device driver modules, and the
file dmesg-1 (in info.zip file) is related to this moment, too.
--------------------------------------------------------------------------

    Some points:
    A- Although the same results were given by those 2 linuxes, the
above log files are all from the Ubuntu-amd64 computer. ( Those 2
linuxes mentioned above, were both run on same computer.)

    B- And of course, i gave same results by a 3th computer (my
notebook "Core2due 2.4MHz & 1Gig-Ram" ) running same Ubuntu linux.

    C- The firmware file named "xc3028-v27.fw"; i prepared this file
from http://www.testforme.com/download/misc/xc3028-v27.fw.tar.bz2 or
http://ubuntuforums.org/attachment.php?attachmentid=82736&d=1219665844
. If it is incorrect please report me and give me its correct one.

    D- All of my 40 channels ( 15 analog and 25 digital) can be
received by that software on Windows-XP over that DVB-stick. In this
Win-Xp software, some interesting points can be found about the
digital channels that was not in the channel information editor of
kaffeine in linux, and because i have only some limited knowledge
about the DVB channel characteristics i could not find out the cause
of those differences. For example if one of you know enough things
about such characteristics, he/she may find out why only one of TV
channels had sound by kaffeine, and my other 13 TV channels (with all
of the radio channels) had not sound. The only TV channel with sound
in that file was named "IRIB NOOR" with 3 audio PIDs, while other
channels ( TV and radio) have only at most 2 audio PIDs!!!

    E- When you are in main window of kaffeine and watching a TV
channel (as shown in file 3.jpg) an option tool in the bottom of this
windows near left corner can be seen (is indicated by a big arrow in
3.jpeg). A strange thing related to this option tool is when watching
that sound owning channel (IRIB NOOR) this option tool is selectable
and has 2 item for selecting, but when watching other 13 TV channels
and all radio channels, this option tool is not selectable, and is
shown as in the picture (3.jpeg). But practically, this strange
channel is the same as others in the Win-Xp and its softwares.

    G- Another difference is appeared in the editor of channel
specifications window of kaffeine: you can see an option tool in right
edge of 2.jpeg ( is indicated by a big arrow) that is related to audio
channel, and in this picture is not selectable. This picture (2.jpeg)
is for one of those 13 TV channels that kaffeine can not play their
sounds, but the 1.jpeg picture is related to channel "IRIB NOOR" that
its sound can be played by kaffeine, and in this picture (1.jpeg) you
can notice that that audio channel option can be selectable!!!

    H- I mentioned that i tested some other DVB-Usb sticks other the
Pinnacle, most of them could not show any video of digital TV channels
by linux unless one of them, and a strange thing was that, with that
other DVB-Usb stick only that "IRIB NOOR" channel was by sound and no
other 13 channels had sound, the same for my Pinnacle DVB-Usb!!!

    I- My another test was by recording a TV channel for some minutes.
An interesting thing was that, for all of 14 TV channels, when i
record that channel in a file and then play that movie file by
"mplayer", its sound is played, both for "IRIB NOOR" channel and other
13 TV channels!!!

    J- During all tests with kaffeine i sat the "Tuner timeout(ms)"
option of kaffeine configuration for the DVB-Tuner, to 5000 (thus 5
seconds), that is its maximum value.

  In the end i again ask you all, if and only if you are familiar and
experienced on a matter, recommend your opinion, and if not first do
exactly my testing on that matter and then do think about it.
  And you can notice that all of problems that i explained must be
solved so that, we can use this DVB-Usb stick in linux, and many many
other bothersome things i encountered in my testing that i did not
mention here yet, thus do not hurry up to resolve these matters in a
bypass way without finding the exact point of problem.

--------------------------------------------------------------------------------
  My guesses are:
    1- The big tricks that can make the mentioned manners very better,
would probably be working on timers used in the device driver modules
( em28xx & em28xx_dvb & em28xx_alsa & tuner_xc2028 & tvp5150 or some
others ), and the time out values that is coded in sources must be
reviewed.
    2- Some of the characteristics of my 25 digital channels is not
detected by kaffaine ( and linux DVB softwares) that is detected by
corresponding Windows-XP softwares. Thus it is better to consider this
characteristics in the linux softwares (both kernel side like en28xx
module and application side like kaffeine). You will probably agree
with this guess, if you focuse on the channel information file i
included (win-xp.zip) completely, and compare its elements step by
step with those can be found in kaffeine channel editor (shown in
1.jpeg & 2.jpeg) or channels.conf explained in
http://www.linuxtv.org/vdrwiki/index.php/Syntax_of_channels.conf .
    3- Some of violations from standard encoding of DVB packets is
done in my 25 digital channels, but experienced programmers of Win-Xp
softwares find them and make some work around for them and thus we
(linux programmers) must do the same things.
--------------------------------------------------------------------------------

    Please don't think about correcting the problems by myself,
because it is obvious that any one that worked on em28xx driver, can
find and fix the problems, for more than 10 times faster than me,
because i have not worked on this driver at all. And also if i want to
do so, i first must learn two considerable matter: a- the DVB
structure and its packets' protocols ( that is not little thing), b-
the manner of the em28xx and xc2038 chips ( that is not little thing
too).  :-(
                       ---------- we all, do not want to invent the
wheel again ---------


  Thanks to all previous works, and to all who want to improve this works.
Good Luck
