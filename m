Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7VIR6iG023849
	for <video4linux-list@redhat.com>; Sun, 31 Aug 2008 14:27:06 -0400
Received: from bay0-omc1-s6.bay0.hotmail.com (bay0-omc1-s6.bay0.hotmail.com
	[65.54.246.78])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7VIQpfu014526
	for <video4linux-list@redhat.com>; Sun, 31 Aug 2008 14:26:52 -0400
Message-ID: <BAY126-W51445FEADC96EC0484E7ABE35D0@phx.gbl>
From: Lee Alkureishi <lee_alkureishi@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Sun, 31 Aug 2008 19:26:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Cc: alkureishi.lee@gmail.com
Subject: em2820, Tena TNF-9533 and V4L
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


Hi all=2C

Hoping someone on this list can help me with this frustrating problem:

I'm running Mythbuntu 8.04=2C fully updated. I'm trying to set up a USB TV =
tuner box=2C and have made progress but haven't quite got it working.=20

The USB box is a Kworld PVR TV 2800 RF. It uses a Empia em2820 chipset=2C a=
nd a Tena TNF-9533-D/IF tuner. Other chips I found under the casing are:
RM-KUB03 04AEAAC6=2C HEF4052BT=2C TEA5767=2C SAA7113H.=20

The PCB has the following printed on it: EM2800TV_KW Ver:F

I followed the instructions to install v4l using mercurial=2C and have got =
it to the point where dmesg shows that the card is recognised and initialis=
ed:
------
dmesg:
[ 1844.847318] usb 5-1: new high speed USB device using ehci_hcd and addres=
s 3
[ 1844.979744] usb 5-1: configuration #1 chosen from 1 choice
[ 1844.980718] em28xx new video device (eb1a:2820): interface 0=2C class 25=
5
[ 1844.980727] em28xx: device is attached to a USB 2.0 bus
[ 1844.980730] em28xx: you're using the experimental/unstable tree from mce=
ntral.de
[ 1844.980732] em28xx: there's also a stable tree available but which is li=
mited to
[ 1844.980734] em28xx: linux <=3D2.6.19.2
[ 1844.980736] em28xx: it's fine to use this driver but keep in mind that i=
t will move
[ 1844.980738] em28xx: to http://mcentral.de/hg/~mrec/v4l-dvb-kernel as soo=
n as it's
[ 1844.980740] em28xx: proved to be stable
[ 1844.980743] em28xx #0: Alternate settings: 8
[ 1844.980746] em28xx #0: Alternate setting 0=2C max size=3D 0
[ 1844.980748] em28xx #0: Alternate setting 1=2C max size=3D 1024
[ 1844.980750] em28xx #0: Alternate setting 2=2C max size=3D 1448
[ 1844.980752] em28xx #0: Alternate setting 3=2C max size=3D 2048
[ 1844.980754] em28xx #0: Alternate setting 4=2C max size=3D 2304
[ 1844.980756] em28xx #0: Alternate setting 5=2C max size=3D 2580
[ 1844.980758] em28xx #0: Alternate setting 6=2C max size=3D 2892
[ 1844.980760] em28xx #0: Alternate setting 7=2C max size=3D 3072
[ 1845.271190] tuner 1-0060: TEA5767 detected.
[ 1845.271199] tuner 1-0060: chip found @ 0xc0 (em28xx #0)
[ 1845.271254] attach inform (default): detected I2C address c0
[ 1845.271260] tuner 0x60: Configuration acknowledged
[ 1845.271266] tuner 1-0060: type set to 61 (Tena TNF9533-D/IF/TNF9533-B/DF=
)
[ 1845.272189] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[ 1845.272215] attach inform (default): detected I2C address c2
[ 1845.272219] tuner 0x61: Configuration acknowledged
[ 1845.272223] tuner 1-0061: type set to 61 (Tena TNF9533-D/IF/TNF9533-B/DF=
)
[ 1845.302962] saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28=
xx #0)
[ 1845.332719] attach_inform: saa7113 detected.
[ 1845.346159] em28xx #0: V4L2 device registered as /dev/video0
[ 1845.346173] em28xx #0: Found Kworld PVR TV 2800 RF
----------

(I had to manally tell modprobe to set the card type (18) and tuner type (6=
1)=2C as it does not have an EPROM. Took me forever to figure that out!

The problem arises when I try to do anything with it=2C though: I've tried =
a few programs=2C including mythTV=2C tvtime and xawtv. I can't find a way =
to select the TUNER as the input source. The only options are "composite1" =
or "s-video1". I've got a cheap antenna attached to the antenna connector=
=2C and a DTV set-top box attached to the composite input. I can't seem to =
get any sort of picture to come up on either input=2C though... Tvtime just=
 gives a black screen=2C and lets me cycle between composite/s-video. MythT=
V just dumps me back to the main menu when I try to watch TV. Scanning for =
channels brings up nothing in Myth setup.=20

I tried tvtime-scanner=2C but it fails:

leeko@leeko-media:~$ tvtime-scanner &
Reading configuration from /etc/tvtime/tvtime.xml
Scanning using TV standard NTSC.
[1] 6918
leeko@leeko-media:~$=20
    No tuner found on input 0.  If you have a tuner=2C please
    select a different input using --input=3D<num>.
[1]+  Exit 1                  tvtime-scanner

I tried cycling through input=3D1 through 4=2C but they didn't work either =
(2 through 4 give an error about the card not being able to set its input).

Am I doing something wrong? Surely I should see an option to choose the tun=
er as an input? As far as I can tell=2C it looks like it should be working!

The only thing I can think of=2C is that the tuner may actually have origin=
ated outside the USA (i.e. the UK). Would that stop it from working with NT=
SC channels? And even so=2C should the composite input not still work? (And=
 why can't I even select the tuner!?).

If I do "ls /dev/video*"=2C the only entry is /dev/video0.=20

Thanks in advance for ANY help you can offer. This is driving me nuts! I've=
 been learning as I go along=2C but I've hit a brick wall now :(

Best regards=2C

Lee=20
=20

lee_alkureishi@hotmail.com=20

_________________________________________________________________
Win New York holidays with Kellogg=92s & Live Search=20
http://clk.atdmt.com/UKM/go/107571440/direct/01/=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
