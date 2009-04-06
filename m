Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f134.google.com ([209.85.221.134])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oobe.trouble@gmail.com>) id 1LqoTq-0003Yh-Hq
	for linux-dvb@linuxtv.org; Mon, 06 Apr 2009 15:03:16 +0200
Received: by qyk40 with SMTP id 40so3550543qyk.3
	for <linux-dvb@linuxtv.org>; Mon, 06 Apr 2009 06:02:40 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Apr 2009 23:02:40 +1000
Message-ID: <21aab41d0904060602g27be0333oea45096381367b7c@mail.gmail.com>
From: Kemble Wagner <oobe.trouble@gmail.com>
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: [linux-dvb] My DVB-card is flooding the consol with "recv bulk
	message failed"
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0208441897=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0208441897==
Content-Type: multipart/alternative; boundary=0016363b85ca6ed3f80466e283c6

--0016363b85ca6ed3f80466e283c6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

im not sure if this is the most sensable way to do this but i am trying to
move this thread over to v4l-dvb

On Mon, Apr 6, 2009 at 10:51 PM, Kemble Wagner <oobe.trouble@gmail.com>wrot=
e:

>
>
> On Mon, Apr 6, 2009 at 10:47 PM, Kemble Wagner <oobe.trouble@gmail.com>wr=
ote:
>
>>
>>
>> ---------- Forwarded message ----------
>> From: Kemble Wagner <oobe.trouble@gmail.com>
>> Date: Mon, Apr 6, 2009 at 1:23 AM
>> Subject: [Bug 229879] Re: My DVB-card is flooding the consol with "recv
>> bulk message failed"
>> To: oobe.trouble@gmail.com
>>
>>
>> as mentioned im using 2.6.27-11-generic and as i said i havent had a
>> problem yet well the other day i did i experienced the same problems
>> that others here report including spam console etc. but i have not had
>> it before or since just chiming in to say that even when i have somthing
>> that i consider stable it still ends up like this on occasion so there
>> is yet to be a completely stable kernel or v4l-dvb tree on this matter.
>>
>>
>>  it would be sensable if someone started a thread on the v4l-dvb mailing
>> list about this  as ubuntu developers cannot fix this due to the fact
>> they only package the code that v4l-dvb produce which intern goes into
>> the kernel which distros then patch and package.
>>
>> --
>> My DVB-card is flooding the consol with "recv bulk message failed"
>> https://bugs.launchpad.net/bugs/229879
>> You received this bug notification because you are a direct subscriber
>> of the bug.
>>
>>
>>
>> "I also have this issue. I was originally running 7.10, then upgraded to
>> 8.10 via 8.04. I think the suggestion from Kemble to post to the v4l-dvb
>> mailing list is sound. If the OP can create an initial posting I'll also
>> post to the same thread to highlight that this is affecting multiple
>> users."
>>
>


 Hello, I am running Ubuntu 8.04 Server (amd64) and I have a "Devico
FusionHDTV DVB-T Dual Digital". It is a PCI-card but the second tuner is
plugged in thru USB2.
The first tuner (PCI-based) is working properly. I can tune signals, watch
livetv with it and I have not found any error messages when using it alone.
The PIC-tuner is located at "/dev/dvb/adapter0"
The second tuner is only found in cold state during boot and is not
activated. To solve that I had to download the "bluebird"-firmware from
http://www.linuxtv.org/downloads/firmware/dvb-usb-bluebird-01.fw and save i=
t
in /lib/firmware.

When I do a cold boot with the firmware available the second tuner
(USB-tuner) is found but I sometimes receive this message during boot:
"dvb-usb: bulk message failed: -71 (2/0)". The tuner is found and activated
anyway and I see the second tuner as "/dev/dvb/adapter1" with the same
nodes/files as the PCI-tuner (demux0, dvr0, frontend0, net0). I have not
tried to use it yet.

When the computer has been online, idling, for some short random time
(typically 10-15 minutes) I start to get floods of the following error
message in the consol (typically one per second): "dvb-usb: bulk message
failed: -110 (1/0)".

If I do a warm reboot I sometime reboot fine (without error messages shown
at boottime) and sometimes with some similar error messages. I have seen
"-71", "-22" and "-110".

During a forum-search I found this tread, but it does not seams related to
my problem: http://ubuntuforums.org/showthread.php?t=3D373192

Bug #78949 <https://bugs.launchpad.net/bugs/78949> seems to be related to
this one, but its old and not for my hardware.

$ lsb_release -rd
Description: Ubuntu 8.04
Release: 8.04

$ uname -a
Linux gandalf 2.6.24-16-server #1 SMP Thu Apr 10 13:15:38 UTC 2008 x86_64
GNU/Linux
 Update description /
tags<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/+edit>

Link a related branch<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/=
229879/+addbranch>
 Link to CVE<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/+l=
inkcve>
 Anders H=C3=A4ggstr=C3=B6m <https://bugs.launchpad.net/%7Ehagge> wrote on =
2008-05-13:
(permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/1>

   - lspci -vv <http://launchpadlibrarian.net/14489453/lspci.log> (17.1 KiB=
,
   text/plain)

  Anders H=C3=A4ggstr=C3=B6m <https://bugs.launchpad.net/%7Ehagge> wrote on=
 2008-05-13:
(permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/2>

   - lsusb -vv <http://launchpadlibrarian.net/14489465/lsusb.log> (21.7 KiB=
,
   text/plain)

  Anders H=C3=A4ggstr=C3=B6m <https://bugs.launchpad.net/%7Ehagge> wrote on=
 2008-06-04:
(permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/3>

Is there anyone that can help me with this bug, please?

Here is some more information I've discoverd.
When I try to install Mythbuntu 8.04 (amd64) with the usb-adapter installed
my keyborard acts wierd. First the keyboard acts normal (while the
DVB-adapter is in normal state) and when the adapter starts to flood
error-messages the keyboard takes aproximately 5seconds for each keypress
and at some random time the keyboard flood inputs when a key is pressed (if
I press "k" I get "kkkkkkkkkkkkkkkkkkkkkkkkkkkkk" of random length). After
the install I end up with a corrupt disk (Grub Error 5 after reboot from
LiveCD).

This is a very serious problem for me and I need help to solve it.

Another thing to know is that Mythbuntu comes bundled with the firmware on
the LiveCD and that causes this behaivor by default. Ubuntu does not have
the firmware loaded by default.
  Anders H=C3=A4ggstr=C3=B6m <https://bugs.launchpad.net/%7Ehagge> wrote on=
 2008-06-04:
(permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/4>

I found this tread and the post from 2007-12-15 looks intresting but I don'=
t
know if that is a sulotion for my card.
http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/<http://www.itee.uq.edu.a=
u/%7Echrisp/Linux-DVB/DVICO/>

What is the defenition of "a newer card"?
I have a "FuionHDTV DVB-T Dual Digital" is that the same card as the post
mention ("FusionHDTV DVB-T Dual Express")?

The new version of the firmware sounds interesting but is that one for my
hardware or not?
  Brendan Ragan <https://bugs.launchpad.net/%7Elordmortis-gmail> wrote on
2008-06-09: (permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/5>

The FusionHDTV DVT-T Dual Digital is different fromt he Dual Express - The
Dual Express is a PCI-Express card

DVICO makes two USB/PCI cards - the Dual Digital (2), which has an actual
USB port (that's the one I have, and i think the one you have?) and the dua=
l
digital 4 which has a pci -> usb bridge for the USB tuner.

I'm also running ubuntu 8.04 server and having the same problem Anders is
having - the PCI tuner loads fine:

[ 67.505751] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[ 67.505886] cx88[0]: subsystem: 18ac:db50, board: DViCO FusionHDTV DVB-T
Dual Digital [card=3D44,autodetected]
[ 67.505889] cx88[0]: TV tuner type 4, Radio tuner type -1
[ 67.511394] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded

but the USB one gives error messages after it loads:

[ 69.092019] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual USB' in cold
state, will try to load a firmware
[ 69.139716] dvb-usb: downloading firmware from file
'dvb-usb-bluebird-01.fw'
[ 69.236381] usb 2-3: USB disconnect, address 3
[ 69.240610] dvb-usb: generic DVB-USB module successfully deinitialized and
disconnected.
(so the firmware is loading fine, but then)
[ 71.057474] usb 2-3: new high speed USB device using ehci_hcd and address =
4
[ 71.209202] usb 2-3: configuration #1 chosen from 1 choice
[ 71.209539] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual USB' in warm
state.
[ 71.210596] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[ 71.220371] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual USB)
[ 71.222823] DVB: registering frontend 1 (Zarlink MT352 DVB-T)...
[ 71.224278] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:02.1/usb2/2-3/input/input6
[ 71.257178] dvb-usb: schedule remote query interval to 150 msecs.
[ 71.257185] dvb-usb: DViCO FusionHDTV DVB-T Dual USB successfully
initialized and connected.
[ 72.606458] dvb-usb: recv bulk message failed: -75
[ 82.039426] dvb-usb: bulk message failed: -71 (1/0)
[ 83.379617] dvb-usb: bulk message failed: -71 (1/0)
[ 84.057324] dvb-usb: bulk message failed: -71 (1/0)
[ 84.978737] dvb-usb: bulk message failed: -71 (1/0)
[ 85.730943] dvb-usb: bulk message failed: -71 (1/0)
[ 86.242278] dvb-usb: bulk message failed: -71 (1/0)
[ 87.117679] dvb-usb: bulk message failed: -71 (1/0)
[ 87.357889] dvb-usb: bulk message failed: -71 (1/0)
[ 88.003277] dvb-usb: bulk message failed: -71 (1/0)
... and so on.

I'm going to try the desktop kernel as i notice Anders is also running the
server kernel. Will post my findings shortly.
  Brendan Ragan <https://bugs.launchpad.net/%7Elordmortis-gmail> wrote on
2008-06-09: (permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/6>

Interestingly enough, the bulk message problems don't show up under the
generic kernel until i actually try to tune a channel, but the same errors
show up and I am still unable to tune anything.

I also think bug 93695 <https://bugs.launchpad.net/bugs/93695> is related
  damien_d <https://bugs.launchpad.net/%7Ed-dusha> wrote on
2008-06-29: (permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/7>

I too have a Dvico dual digital card, and can confirm that it likes to spam
the console.

In my case, it manifested itself by slowing down my keyboard responses to
sometimes waiting seconds before all my keys appeared in the console at onc=
e
(is it requiring a lot of kernel interrupts?)

It took a while for the drivers for this to become stable when I was using
fedora about 18 months ago, and had to compile them from source, but after
that, they worked well.

If I remember right, all I had to do for ubuntu was to install the firmware
for the card, and after that, it was all fine... until, now. I have
definately noticed it since 8.04, but it may have existed in 7.10 as well.

Here are some bits of the system log that alerted me to the problem:
{{{
898.916822] dvb-usb: bulk message failed: -110 (5/0)
[128899.915577] dvb-usb: bulk message failed: -110 (5/0)
[128900.914732] dvb-usb: bulk message failed: -110 (5/0)
[128901.913500] dvb-usb: bulk message failed: -110 (1/0)
[128902.912306] dvb-usb: bulk message failed: -110 (5/0)
[128903.911558] dvb-usb: bulk message failed: -110 (5/0)
[128904.909919] dvb-usb: bulk message failed: -110 (5/0)
[128905.908790] dvb-usb: bulk message failed: -110 (1/0)
[128906.907713] dvb-usb: bulk message failed: -110 (5/0)
[128907.906397] dvb-usb: bulk message failed: -110 (5/0)
[128908.905360] dvb-usb: bulk message failed: -110 (5/0)
[128909.903821] dvb-usb: bulk message failed: -110 (1/0)
[128910.902627] dvb-usb: bulk message failed: -110 (5/0)
[128911.901683] dvb-usb: bulk message failed: -110 (5/0)
[128912.900577] dvb-usb: bulk message failed: -110 (5/0)
[128913.899364] dvb-usb: bulk message failed: -110 (1/0)
[128914.898236] dvb-usb: bulk message failed: -110 (5/0)
[128915.896978] dvb-usb: bulk message failed: -110 (5/0)
[128916.895805] dvb-usb: bulk message failed: -110 (5/0)
[128917.894643] dvb-usb: bulk message failed: -110 (1/0)
[128918.893449] dvb-usb: bulk message failed: -110 (5/0)
[128919.892255] dvb-usb: bulk message failed: -110 (5/0)
[128920.891060] dvb-usb: bulk message failed: -110 (5/0)
[128921.889928] dvb-usb: bulk message failed: -110 (1/0)
[128922.888736] dvb-usb: bulk message failed: -110 (5/0)
[128923.887529] dvb-usb: bulk message failed: -110 (5/0)
[128925.365044] dvb-usb: bulk message failed: -110 (5/0)
[128926.505461] dvb-usb: bulk message failed: -110 (1/0)
[128927.504135] dvb-usb: bulk message failed: -110 (5/0)
[128928.503084] dvb-usb: bulk message failed: -110 (5/0)
[128929.501941] dvb-usb: bulk message failed: -110 (5/0)
[128930.500736] dvb-usb: bulk message failed: -110 (1/0)
[128931.499536] dvb-usb: bulk message failed: -110 (5/0)
[128932.498348] dvb-usb: bulk message failed: -110 (5/0)
[128933.497205] dvb-usb: bulk message failed: -110 (5/0)
[128934.496009] dvb-usb: bulk message failed: -110 (1/0)
[128935.494565] dvb-usb: bulk message failed: -110 (5/0)
[128936.493489] dvb-usb: bulk message failed: -110 (5/0)
[128937.492552] dvb-usb: bulk message failed: -110 (5/0)
[128938.950128] dvb-usb: bulk message failed: -110 (1/0)
}}}

Once reconnected, it caused lsusb to lock up, and I couldn't ctrl-c out of
it.

Once I reboot the system, I'll see if I can get better system logs and lsus=
b
o...

Read more...<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/co=
mments/7>
  Teej <https://bugs.launchpad.net/%7Exteejx> wrote on 2008-12-01: (permali=
nk)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/8>

Thank you for taking the time to report this bug and helping to make Ubuntu
better. You reported this bug a while ago and there hasn't been any activit=
y
in it recently. We were wondering is this still an issue for you? Can you
try with latest Ubuntu release? Thanks in advance.
  Teej <https://bugs.launchpad.net/%7Exteejx> on 2008-12-01
   *linux status*:  New =E2=86=92 Incomplete
  Javier Jard=C3=B3n <https://bugs.launchpad.net/%7Etorkiano> wrote on 2009=
-01-11:
(permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/9>

We are closing this bug report because it lacks the information we need to
investigate the problem, as described in the previous comments. Please
reopen it if you can give us the missing information, and don't hesitate to
submit bug reports in the future. To reopen the bug report you can click on
the current status, under the Status column, and change the Status back to
"New". Thanks again!
  Javier Jard=C3=B3n <https://bugs.launchpad.net/%7Etorkiano> on 2009-01-11
   *linux status*:  Incomplete =E2=86=92 Invalid
  Anders H=C3=A4ggstr=C3=B6m <https://bugs.launchpad.net/%7Ehagge> wrote on=
 2009-01-11:
(permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/10>

What information is missing? I have not seen anyone asking for more
information, other than me.

I own one of this cards and will help you with outputs and testing of the
hardware if anyone tells me what to do.

Please, don't close/ignore this bug, it's not fixed. The USB-part of the
hardware is not working.
  Javier Jard=C3=B3n <https://bugs.launchpad.net/%7Etorkiano> wrote on 2009=
-01-11:
(permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/11>

Hello Anders,

Thank you for your interest in this bug.

The issue that you reported is one that should be reproducible with the liv=
e
environment of the Desktop CD of the development release - Jaunty Jackalope=
.
It would help us greatly if you could test with it so we can work on gettin=
g
it fixed in the next release of Ubuntu. You can find out more about the
development release at http://www.ubuntu.com/testing/ . Thanks again and we
appreciate your help.
  Javier Jard=C3=B3n <https://bugs.launchpad.net/%7Etorkiano> on 2009-01-11
   *linux status*:  Invalid =E2=86=92 Incomplete
  Jimbot <https://bugs.launchpad.net/%7Ejkennon1> wrote on 2009-03-12:
(permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/12>

I also have a DVICO Dual Digital 4 (PCI, not PCIe) and am running amd64
architecture. I'm running Mythbuntu 8.04 - I'm assuming this is based on th=
e
desktop kernel. My card identifies itself as 0fe9:db78 in lsusb. I set it u=
p
based on the instructions shown here:
http://ubuntuforums.org/showthread.php?t=3D616103 and it works. However, I
have a similar problem to that which Anders describes.

Frequently when I do a warm boot, the system exhibits similar behaviour:

- I get the "dvb-usb: bulk message failed: -110" at a frequency of about
once a second
- I get similar keyboard issues with my usb keyboard (press k once and I ge=
t
a dozen or so: "kkkkkkkkkkkkkkkkkk")

The only way I can get my system back to 'normal' again is to remove the
dvb_usb_cxusb module:

modprobe -r dvb_usb_cxusb

of course I have to stop the mythbackend first.Doing all this is very
difficult when every few keypresses get repeated a heap of times. Especiall=
y
when I have to login as root to do it. Though my system is now usable, the
tuner card won't work (not without that module I just removed) so I have to
reboot for me to use the system as intended.

I could live with the issue on warm reboot; I just have to shutdown, wait a
bit, then start up again. However, the system has recently started doing it
whenever I shut down the mythbackend (for configuration for instance), and
when I tested connecting with XBMC from another machine it did it as well.

Based on the forum thread I followed to set the card up, this seems to be a
known issue among users of the card, but it's a royal pain in the neck and
it would be great if it got fixed some time. I'm happy to provide additiona=
l
information if that would be of assistance.

Cheers.
  Kemble Wagner <https://bugs.launchpad.net/%7Eoobe-trouble> wrote on
2009-03-13: *Re: [Bug 229879] Re: My DVB-card is flooding the consol with
"recv bulk message failed"* (permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/13>

you could try using building a vanilla kernel thats what i used on 8.04 and
now im using intrepid i have no problems with the stock kernel 2.6.27-11

On Thu, Mar 12, 2009 at 8:36 PM, Jimbot <jkennon1@gmail.com> wrote:

[...] <javascript:void(0);>
> I also have a DVICO Dual Digital 4 (PCI, not PCIe) and am running amd64
> architecture. I'm running Mythbuntu 8.04 - I'm assuming this is based on
> the desktop kernel. My card identifies itself as 0fe9:db78 in lsusb. I
> set it up based on the instructions shown here:
> http://ubuntuforums.org/showthread.php?t=3D616103 and it works. However, =
I
> have a similar problem to that which Anders describes.
>
> Frequently when I do a warm boot, the system exhibits similar behaviour:
>
> - I get the "dvb-usb: bulk message failed: -110" at a frequency of about
> once a second
> - I get similar keyboard issues with my usb keyboard (press k once and I
> get a dozen or so: "kkkkkkkkkkkkkkkkkk")
>
> The only way I can get my system back to 'normal' again is to remove the
> dvb_usb_cxusb module:
>
> modprobe -r dvb_usb_cxusb
>
> of course I have to stop the mythbackend first.Doing all this is very
> difficult when every few keypresses get repeated a heap of times.
> Especially when I have to login as root to do it. Though my system is
> now usable, the tuner card won't work (not without that module I just
> removed) so I have to reboot for me to use the system as intended.
>
> I could live with the issue on warm reboot; I just have to shutdown,
> wait a bit, then start up again. However, the system has recently
> started doing it whenever I shut down the mythbackend (for configuration
> for instance), and when I tested connecting with XBMC from another
> machine it did it as well.
>
> Based on the forum thread I followed to set the card up, this seems to
> be a known issue among users of the card, but it's a royal pain in the
> neck and it would be great if it got fixed some time. I'm happy to
> provide additional information if that would be of assistance.
>
> Cheers.
>
> --
> My DVB-card is flooding the consol with "recv bulk message failed"
> https://bugs.launchpad.net/bugs/229879
> You received this bug notification because you are a direct subscriber
> of the bug.
>
  moaxey <https://bugs.launchpad.net/%7Emoaxey> wrote on 2009-04-01:
(permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/14>

this is affecting me too.

I can avoid it by shutting down for time instead of restarting...

What information could I collect to cast more light on it?
  Kemble Wagner <https://bugs.launchpad.net/%7Eoobe-trouble> wrote on
2009-04-01: (permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/15>

has anyone tried installing newer v4l-dvb drivers

sudo -i

apt-get update

apt-get install install mercurial build-essential linux-headers-`uname -r`

hg clone http://linuxtv.org/hg/v4l-dvb

cd v4l-dvb

make && make install

exit

or as i mentioned above dowloading the newest kernel from
http://kernel.organd compiling it youself will also fix this
http://www.howtoforge.com/kernel_compilation_ubuntu

i for one can say that this used to fix the trouble for me however now in
intrepid the stock kernel works fine for me.
  Jean-Yves Avenard <https://bugs.launchpad.net/%7Ereg-jya-launchpad> wrote=
 on
2009-04-04: (permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/16>

Unfortunately, even with the latest v4l-dvb drivers I too experience those
bulk errors in the log

They show up every 2 seconds
  Kemble Wagner <https://bugs.launchpad.net/%7Eoobe-trouble> wrote 21 hours
ago: (permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/17>

as mentioned im using 2.6.27-11-generic and as i said i havent had a proble=
m
yet well the other day i did i experienced the same problems that others
here report including spam console etc. but i have not had it before or
since just chiming in to say that even when i have somthing that i consider
stable it still ends up like this on occasion so there is yet to be a
completely stable kernel or v4l-dvb tree on this matter.

 it would be sensable if someone started a thread on the v4l-dvb mailing
list about this as ubuntu developers cannot fix this due to the fact they
only package the code that v4l-dvb produce which intern goes into the kerne=
l
which distros then patch and package.
  Paul Elliott <https://bugs.launchpad.net/%7Eomahns-home> wrote 5 hours ag=
o:
(permalink)
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/comments/18>

I also have this issue. I was originally running 7.10, then upgraded to 8.1=
0
via 8.04. I think the suggestion from Kemble to post to the v4l-dvb mailing
list is sound. If the OP can create an initial posting I'll also post to th=
e
same thread to highlight that this is affecting multiple users.

--0016363b85ca6ed3f80466e283c6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

im not sure if this is the most sensable way to do this but i am trying to =
move this thread over to v4l-dvb<br><br><div class=3D"gmail_quote">On Mon, =
Apr 6, 2009 at 10:51 PM, Kemble Wagner <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:oobe.trouble@gmail.com">oobe.trouble@gmail.com</a>&gt;</span> wrote:<br=
>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div><div class=
=3D"h5"><br><br><div class=3D"gmail_quote">On Mon, Apr 6, 2009 at 10:47 PM,=
 Kemble Wagner <span dir=3D"ltr">&lt;<a href=3D"mailto:oobe.trouble@gmail.c=
om" target=3D"_blank">oobe.trouble@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br><br><div class=3D"gmail_quote"><div><div>---------- Forwarded message -=
---------<br>From: <b class=3D"gmail_sendername">Kemble Wagner</b> <span di=
r=3D"ltr">&lt;<a href=3D"mailto:oobe.trouble@gmail.com" target=3D"_blank">o=
obe.trouble@gmail.com</a>&gt;</span><br>


Date: Mon, Apr 6, 2009 at 1:23 AM<br>Subject: [Bug 229879] Re: My DVB-card =
is flooding the consol with &quot;recv bulk message failed&quot;<br>To: <a =
href=3D"mailto:oobe.trouble@gmail.com" target=3D"_blank">oobe.trouble@gmail=
.com</a><br>

<br>
<br>as mentioned im using 2.6.27-11-generic and as i said i havent had a<br=
>
problem yet well the other day i did i experienced the same problems<br>
that others here report including spam console etc. but i have not had<br>
it before or since just chiming in to say that even when i have somthing<br=
>
that i consider stable it still ends up like this on occasion so there<br>
is yet to be a completely stable kernel or v4l-dvb tree on this matter.<br>
<br>
<br>
=C2=A0it would be sensable if someone started a thread on the v4l-dvb maili=
ng<br>
list about this =C2=A0as ubuntu developers cannot fix this due to the fact<=
br>
they only package the code that v4l-dvb produce which intern goes into<br>
the kernel which distros then patch and package.<br>
</div></div><div><div><div><div><br>
--<br>
My DVB-card is flooding the consol with &quot;recv bulk message failed&quot=
;<br>
<a href=3D"https://bugs.launchpad.net/bugs/229879" target=3D"_blank">https:=
//bugs.launchpad.net/bugs/229879</a><br>
You received this bug notification because you are a direct subscriber<br>
of the bug.<br><br><br><br></div></div><div>&quot;I also have this issue. I=
 was originally running 7.10, then upgraded to<br>
8.10 via 8.04. I think the suggestion from Kemble to post to the v4l-dvb<br=
>
mailing list is sound. If the OP can create an initial posting I&#39;ll als=
o<br>
post to the same thread to highlight that this is affecting multiple<br>
users.&quot;</div></div></div></div></blockquote></div></div></div></blockq=
uote><div><br>
<br>
<br>

     =20
   =20





     =20
       =20

     =20
<div class=3D"report">
       =20

        <div id=3D"bug-description"><p>Hello,
I am running Ubuntu 8.04 Server (amd64) and I have a &quot;Devico FusionHDT=
V
DVB-T Dual Digital&quot;. It is a PCI-card but the second tuner is plugged
in thru USB2.<br>
The first tuner (PCI-based) is working properly. I can tune signals,
watch livetv with it and I have not found any error messages when using
it alone. The PIC-tuner is located at &quot;/dev/dvb/adapter0&quot;<br>
The second tuner is only found in cold state during boot and is not
activated. To solve that I had to download the &quot;bluebird&quot;-firmwar=
e from
<a rel=3D"nofollow" href=3D"http://www.linuxtv.org/downloads/firmware/dvb-u=
sb-bluebird-01.fw">http://www.linuxtv.org/downloads/firmware/dvb-usb-bluebi=
rd-01.fw</a> and save it in /lib/firmware.</p>
<p>When I do a cold boot with the firmware available the second tuner
(USB-tuner) is found but I sometimes receive this message during boot:
&quot;dvb-usb: bulk message failed: -71 (2/0)&quot;. The tuner is found and
activated anyway and I see the second tuner as &quot;/dev/dvb/adapter1&quot=
; with
the same nodes/files as the PCI-tuner (demux0, dvr0, frontend0, net0).
I have not tried to use it yet.</p>
<p>When the computer has been online, idling, for some short random
time (typically 10-15 minutes) I start to get floods of the following
error message in the consol (typically one per second): &quot;dvb-usb: bulk
message failed: -110 (1/0)&quot;.</p>
<p>If I do a warm reboot I sometime reboot fine (without error messages
shown at boottime) and sometimes with some similar error messages. I
have seen &quot;-71&quot;, &quot;-22&quot; and &quot;-110&quot;.</p>
<p>During a forum-search I found this tread, but it does not seams related =
to my problem: <a rel=3D"nofollow" href=3D"http://ubuntuforums.org/showthre=
ad.php?t=3D373192">http://ubuntuforums.org/showthread.php?t=3D373192</a></p=
>
<p><a href=3D"https://bugs.launchpad.net/bugs/78949" title=3D"Artec T1 USB1=
.1 TVBOX with AN2235 - Bulk message failed: -22">Bug #78949</a> seems to be=
 related to this one, but its old and not for my hardware.</p>
<p>$ lsb_release -rd<br>
Description:     Ubuntu 8.04<br>
Release:        8.04</p>
<p>$ uname -a<br>
Linux gandalf 2.6.24-16-server #1 SMP Thu Apr 10 13:15:38 UTC 2008 x86_64 G=
NU/Linux</p></div>

         =20

          <div style=3D"float: left;" class=3D"clearfix">
            <a style=3D"background: transparent url(/@@/edit) no-repeat scr=
oll left center; -moz-background-clip: -moz-initial; -moz-background-origin=
: -moz-initial; -moz-background-inline-policy: -moz-initial; line-height: 2=
0px; padding-left: 18px;" href=3D"https://bugs.launchpad.net/ubuntu/+source=
/linux/+bug/229879/+edit" class=3D"menu-link-editdescription">Update descri=
ption / tags</a>
           =20
          </div>

       =20
      </div>


     =20

     =20
<p>
        <a style=3D"background: transparent url(/@@/add) no-repeat scroll l=
eft center; -moz-background-clip: -moz-initial; -moz-background-origin: -mo=
z-initial; -moz-background-inline-policy: -moz-initial; line-height: 20px; =
padding-left: 18px;" href=3D"https://bugs.launchpad.net/ubuntu/+source/linu=
x/+bug/229879/+addbranch" class=3D"menu-link-addbranch">Link a related bran=
ch</a>
      </p>


     =20
     =20
<div class=3D"actions">
        <a style=3D"background: transparent url(/@@/add) no-repeat scroll l=
eft center; -moz-background-clip: -moz-initial; -moz-background-origin: -mo=
z-initial; -moz-background-inline-policy: -moz-initial; line-height: 20px; =
padding-left: 18px;" href=3D"https://bugs.launchpad.net/ubuntu/+source/linu=
x/+bug/229879/+linkcve" class=3D"menu-link-linktocve">Link to <abbr title=
=3D"Common Vulnerabilities and Exposures Index">CVE</abbr></a>
       =20
      </div>


     =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Ehagge" style=3D"background: =
transparent url(/@@/person) no-repeat scroll left center; padding-left: 18p=
x; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial=
; -moz-background-inline-policy: -moz-initial;">Anders H=C3=A4ggstr=C3=B6m<=
/a>
   =20
    wrote
    <span title=3D"2008-05-13 09:57:59 UTC">on 2008-05-13</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/1">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
    <ul style=3D"margin-bottom: 1em;"><li class=3D"download">
        <a href=3D"http://launchpadlibrarian.net/14489453/lspci.log">lspci =
-vv</a>
        (17.1 KiB,
        text/plain)
      </li></ul>

   =20
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Ehagge" style=3D"background: =
transparent url(/@@/person) no-repeat scroll left center; padding-left: 18p=
x; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial=
; -moz-background-inline-policy: -moz-initial;">Anders H=C3=A4ggstr=C3=B6m<=
/a>
   =20
    wrote
    <span title=3D"2008-05-13 09:59:09 UTC">on 2008-05-13</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/2">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
    <ul style=3D"margin-bottom: 1em;"><li class=3D"download">
        <a href=3D"http://launchpadlibrarian.net/14489465/lsusb.log">lsusb =
-vv</a>
        (21.7 KiB,
        text/plain)
      </li></ul>

   =20
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Ehagge" style=3D"background: =
transparent url(/@@/person) no-repeat scroll left center; padding-left: 18p=
x; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial=
; -moz-background-inline-policy: -moz-initial;">Anders H=C3=A4ggstr=C3=B6m<=
/a>
   =20
    wrote
    <span title=3D"2008-06-04 11:57:13 UTC">on 2008-06-04</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/3">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>Is there anyone that can help me with thi=
s bug, please?</p>
<p>Here is some more information I&#39;ve discoverd.<br>
When I try to install Mythbuntu 8.04 (amd64) with the usb-adapter
installed my keyborard acts wierd. First the keyboard acts normal
(while the DVB-adapter is in normal state) and when the adapter starts
to flood error-messages the keyboard takes aproximately 5seconds for
each keypress and at some random time the keyboard flood inputs when a
key is pressed (if I press &quot;k&quot; I get &quot;kkkkkkkkkkkkkkkkkkkkkk=
kkkkkkk&quot; of random length). After the install I end up with a corrupt =
disk (Grub Error 5 after reboot from LiveCD).</p>
<p>This is a very serious problem for me and I need help to solve it.</p>
<p>Another thing to know is that Mythbuntu comes bundled with the
firmware on the LiveCD and that causes this behaivor by default. Ubuntu
does not have the firmware loaded by default.</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Ehagge" style=3D"background: =
transparent url(/@@/person) no-repeat scroll left center; padding-left: 18p=
x; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial=
; -moz-background-inline-policy: -moz-initial;">Anders H=C3=A4ggstr=C3=B6m<=
/a>
   =20
    wrote
    <span title=3D"2008-06-04 13:22:07 UTC">on 2008-06-04</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/4">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>I found this tread and the post from 2007=
-12-15 looks intresting but I don&#39;t know if that is a sulotion for my c=
ard.  <a rel=3D"nofollow" href=3D"http://www.itee.uq.edu.au/%7Echrisp/Linux=
-DVB/DVICO/">http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/</a></p>

<p>What is the defenition of &quot;a newer card&quot;?<br>
I have a &quot;FuionHDTV DVB-T Dual Digital&quot; is that the same card as =
the post mention (&quot;FusionHDTV DVB-T Dual Express&quot;)?</p>
<p>The new version of the firmware sounds interesting but is that one for m=
y hardware or not?</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Elordmortis-gmail" style=3D"b=
ackground: transparent url(/@@/person) no-repeat scroll left center; paddin=
g-left: 18px; -moz-background-clip: -moz-initial; -moz-background-origin: -=
moz-initial; -moz-background-inline-policy: -moz-initial;">Brendan Ragan</a=
>
   =20
    wrote
    <span title=3D"2008-06-09 08:27:39 UTC">on 2008-06-09</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/5">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>The FusionHDTV DVT-T Dual Digital is diff=
erent fromt he Dual Express - The Dual Express is a PCI-Express card</p>
<p>DVICO makes two USB/PCI cards - the Dual Digital (2), which has an
actual USB port (that&#39;s the one I have, and i think the one you have?)
and the dual digital 4 which has a pci -&gt; usb bridge for the USB
tuner.</p>
<p>I&#39;m also running ubuntu 8.04 server and having the same problem Ande=
rs is having - the PCI tuner loads fine:</p>
<p>[   67.505751] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 load=
ed<br>
[   67.505886] cx88[0]: subsystem: 18ac:db50, board: DViCO FusionHDTV DVB-T=
 Dual Digital [card=3D44,autodetected]<br>
[   67.505889] cx88[0]: TV tuner type 4, Radio tuner type -1<br>
[   67.511394] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded</p>
<p>but the USB one gives error messages after it loads:</p>
<p>[   69.092019] dvb-usb: found a &#39;DViCO FusionHDTV DVB-T Dual USB&#39=
; in cold state, will try to load a firmware<br>
[   69.139716] dvb-usb: downloading firmware from file &#39;dvb-usb-bluebir=
d-01.fw&#39;<br>
[   69.236381] usb 2-3: USB disconnect, address 3<br>
[   69.240610] dvb-usb: generic DVB-USB module successfully deinitialized a=
nd disconnected.<br>
(so the firmware is loading fine, but then)<br>
[   71.057474] usb 2-3: new high speed USB device using ehci_hcd and addres=
s 4<br>
[   71.209202] usb 2-3: configuration #1 chosen from 1 choice<br>
[   71.209539] dvb-usb: found a &#39;DViCO FusionHDTV DVB-T Dual USB&#39; i=
n warm state.<br>
[   71.210596] dvb-usb: will pass the complete MPEG2 transport stream to th=
e software demuxer.<br>
[   71.220371] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual US=
B)<br>
[   71.222823] DVB: registering frontend 1 (Zarlink MT352 DVB-T)...<br>
[   71.224278] input: IR-receiver inside an USB DVB receiver as /devices/pc=
i0000:00/0000:00:02.1/usb2/2-3/input/input6<br>
[   71.257178] dvb-usb: schedule remote query interval to 150 msecs.<br>
[   71.257185] dvb-usb: DViCO FusionHDTV DVB-T Dual USB successfully initia=
lized and connected.<br>
[   72.606458] dvb-usb: recv bulk message failed: -75<br>
[   82.039426] dvb-usb: bulk message failed: -71 (1/0)<br>
[   83.379617] dvb-usb: bulk message failed: -71 (1/0)<br>
[   84.057324] dvb-usb: bulk message failed: -71 (1/0)<br>
[   84.978737] dvb-usb: bulk message failed: -71 (1/0)<br>
[   85.730943] dvb-usb: bulk message failed: -71 (1/0)<br>
[   86.242278] dvb-usb: bulk message failed: -71 (1/0)<br>
[   87.117679] dvb-usb: bulk message failed: -71 (1/0)<br>
[   87.357889] dvb-usb: bulk message failed: -71 (1/0)<br>
[   88.003277] dvb-usb: bulk message failed: -71 (1/0)<br>
... and so on.</p>
<p>I&#39;m going to try the desktop kernel as i notice Anders is also runni=
ng the server kernel. Will post my findings shortly.</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Elordmortis-gmail" style=3D"b=
ackground: transparent url(/@@/person) no-repeat scroll left center; paddin=
g-left: 18px; -moz-background-clip: -moz-initial; -moz-background-origin: -=
moz-initial; -moz-background-inline-policy: -moz-initial;">Brendan Ragan</a=
>
   =20
    wrote
    <span title=3D"2008-06-09 08:38:36 UTC">on 2008-06-09</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/6">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>Interestingly
enough, the bulk message problems don&#39;t show up under the generic
kernel until i actually try to tune a channel, but the same errors show
up and I am still unable to tune anything.</p>
<p>I also think <a href=3D"https://bugs.launchpad.net/bugs/93695" title=3D"=
DVB-T USB stick keeps spamming syslog">bug 93695</a> is related</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Ed-dusha" style=3D"background=
: transparent url(/@@/person) no-repeat scroll left center; padding-left: 1=
8px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initi=
al; -moz-background-inline-policy: -moz-initial;">damien_d</a>
   =20
    wrote
    <span title=3D"2008-06-29 05:37:23 UTC">on 2008-06-29</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/7">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>I too have a Dvico dual digital card, and=
 can confirm that it likes to spam the console.</p>
<p>In my case, it manifested itself by slowing down my keyboard
responses to sometimes waiting seconds before all my keys appeared in
the console at once (is it requiring a lot of kernel interrupts?)</p>
<p>It took a while for the drivers for this to become stable when I was
using fedora about 18 months ago, and had to compile them from source,
but after that, they worked well.</p>
<p>If I remember right, all I had to do for ubuntu was to install the
firmware for the card, and after that, it was all fine... until, now. I
have definately noticed it since 8.04, but it may have existed in 7.10
as well.</p>
<p>Here are some bits of the system log that alerted me to the problem:<br>
{{{<br>
898.916822] dvb-usb: bulk message failed: -110 (5/0)<br>
[128899.915577] dvb-usb: bulk message failed: -110 (5/0)<br>
[128900.914732] dvb-usb: bulk message failed: -110 (5/0)<br>
[128901.913500] dvb-usb: bulk message failed: -110 (1/0)<br>
[128902.912306] dvb-usb: bulk message failed: -110 (5/0)<br>
[128903.911558] dvb-usb: bulk message failed: -110 (5/0)<br>
[128904.909919] dvb-usb: bulk message failed: -110 (5/0)<br>
[128905.908790] dvb-usb: bulk message failed: -110 (1/0)<br>
[128906.907713] dvb-usb: bulk message failed: -110 (5/0)<br>
[128907.906397] dvb-usb: bulk message failed: -110 (5/0)<br>
[128908.905360] dvb-usb: bulk message failed: -110 (5/0)<br>
[128909.903821] dvb-usb: bulk message failed: -110 (1/0)<br>
[128910.902627] dvb-usb: bulk message failed: -110 (5/0)<br>
[128911.901683] dvb-usb: bulk message failed: -110 (5/0)<br>
[128912.900577] dvb-usb: bulk message failed: -110 (5/0)<br>
[128913.899364] dvb-usb: bulk message failed: -110 (1/0)<br>
[128914.898236] dvb-usb: bulk message failed: -110 (5/0)<br>
[128915.896978] dvb-usb: bulk message failed: -110 (5/0)<br>
[128916.895805] dvb-usb: bulk message failed: -110 (5/0)<br>
[128917.894643] dvb-usb: bulk message failed: -110 (1/0)<br>
[128918.893449] dvb-usb: bulk message failed: -110 (5/0)<br>
[128919.892255] dvb-usb: bulk message failed: -110 (5/0)<br>
[128920.891060] dvb-usb: bulk message failed: -110 (5/0)<br>
[128921.889928] dvb-usb: bulk message failed: -110 (1/0)<br>
[128922.888736] dvb-usb: bulk message failed: -110 (5/0)<br>
[128923.887529] dvb-usb: bulk message failed: -110 (5/0)<br>
[128925.365044] dvb-usb: bulk message failed: -110 (5/0)<br>
[128926.505461] dvb-usb: bulk message failed: -110 (1/0)<br>
[128927.504135] dvb-usb: bulk message failed: -110 (5/0)<br>
[128928.503084] dvb-usb: bulk message failed: -110 (5/0)<br>
[128929.501941] dvb-usb: bulk message failed: -110 (5/0)<br>
[128930.500736] dvb-usb: bulk message failed: -110 (1/0)<br>
[128931.499536] dvb-usb: bulk message failed: -110 (5/0)<br>
[128932.498348] dvb-usb: bulk message failed: -110 (5/0)<br>
[128933.497205] dvb-usb: bulk message failed: -110 (5/0)<br>
[128934.496009] dvb-usb: bulk message failed: -110 (1/0)<br>
[128935.494565] dvb-usb: bulk message failed: -110 (5/0)<br>
[128936.493489] dvb-usb: bulk message failed: -110 (5/0)<br>
[128937.492552] dvb-usb: bulk message failed: -110 (5/0)<br>
[128938.950128] dvb-usb: bulk message failed: -110 (1/0)<br>
}}}</p>
<p>Once reconnected, it caused lsusb to lock up, and I couldn&#39;t ctrl-c =
out of it.</p>
<p>Once I reboot the system, I&#39;ll see if I can get better system logs a=
nd lsusb o...</p></div>
    <p>
      <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/22987=
9/comments/7">Read more...</a>
    </p>
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Exteejx" style=3D"background:=
 transparent url(/@@/person) no-repeat scroll left center; padding-left: 18=
px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initia=
l; -moz-background-inline-policy: -moz-initial;">Teej</a>
   =20
    wrote
    <span title=3D"2008-12-01 12:51:30 UTC">on 2008-12-01</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/8">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>Thank
you for taking the time to report this bug and helping to make Ubuntu
better. You reported this bug a while ago and there hasn&#39;t been any
activity in it recently. We were wondering is this still an issue for
you? Can you try with latest Ubuntu release? Thanks in advance.</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20

         =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Exteejx" style=3D"background:=
 transparent url(/@@/person) no-repeat scroll left center; padding-left: 18=
px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initia=
l; -moz-background-inline-policy: -moz-initial;">Teej</a>
   =20
    <span title=3D"2008-12-01 12:51:30 UTC">on 2008-12-01</span>
  </div>
  <div class=3D"boardBugActivityBody">
    <div class=3D"bug-comment">
      <table>
        <tbody><tr>
          <td style=3D"text-align: right;">
            <b>linux status</b>:
          </td>
          <td>
            New =E2=86=92 Incomplete
          </td>
        </tr>
      </tbody></table>
    </div>
  </div>
</div>

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Etorkiano" style=3D"backgroun=
d: transparent url(/@@/person) no-repeat scroll left center; padding-left: =
18px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-init=
ial; -moz-background-inline-policy: -moz-initial;">Javier Jard=C3=B3n</a>
   =20
    wrote
    <span title=3D"2009-01-11 09:04:42 UTC">on 2009-01-11</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/9">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>We
are closing this bug report because it lacks the information we need to
investigate the problem, as described in the previous comments. Please
reopen it if you can give us the missing information, and don&#39;t
hesitate to submit bug reports in the future. To reopen the bug report
you can click on the current status, under the Status column, and
change the Status back to &quot;New&quot;. Thanks again!</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20

         =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Etorkiano" style=3D"backgroun=
d: transparent url(/@@/person) no-repeat scroll left center; padding-left: =
18px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-init=
ial; -moz-background-inline-policy: -moz-initial;">Javier Jard=C3=B3n</a>
   =20
    <span title=3D"2009-01-11 09:04:42 UTC">on 2009-01-11</span>
  </div>
  <div class=3D"boardBugActivityBody">
    <div class=3D"bug-comment">
      <table>
        <tbody><tr>
          <td style=3D"text-align: right;">
            <b>linux status</b>:
          </td>
          <td>
            Incomplete =E2=86=92 Invalid
          </td>
        </tr>
      </tbody></table>
    </div>
  </div>
</div>

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Ehagge" style=3D"background: =
transparent url(/@@/person) no-repeat scroll left center; padding-left: 18p=
x; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial=
; -moz-background-inline-policy: -moz-initial;">Anders H=C3=A4ggstr=C3=B6m<=
/a>
   =20
    wrote
    <span title=3D"2009-01-11 12:50:34 UTC">on 2009-01-11</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/10">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>What information is missing? I have not s=
een anyone asking for more information, other than me.</p>
<p>I own one of this cards and will help you with outputs and testing of th=
e hardware if anyone tells me what to do.</p>
<p>Please, don&#39;t close/ignore this bug, it&#39;s not fixed. The USB-par=
t of the hardware is not working.</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Etorkiano" style=3D"backgroun=
d: transparent url(/@@/person) no-repeat scroll left center; padding-left: =
18px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-init=
ial; -moz-background-inline-policy: -moz-initial;">Javier Jard=C3=B3n</a>
   =20
    wrote
    <span title=3D"2009-01-11 16:30:29 UTC">on 2009-01-11</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/11">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>Hello Anders,</p>
<p>Thank you for your interest in this bug.</p>
<p>The issue that you reported is one that should be reproducible with
the live environment of the Desktop CD of the development release -
Jaunty Jackalope. It would help us greatly if you could test with it so
we can work on getting it fixed in the next release of Ubuntu. You can
find out more about the development release at <a rel=3D"nofollow" href=3D"=
http://www.ubuntu.com/testing/">http://www.ubuntu.com/testing/</a> . Thanks=
 again and we appreciate your help.</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20

         =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Etorkiano" style=3D"backgroun=
d: transparent url(/@@/person) no-repeat scroll left center; padding-left: =
18px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-init=
ial; -moz-background-inline-policy: -moz-initial;">Javier Jard=C3=B3n</a>
   =20
    <span title=3D"2009-01-11 16:30:42 UTC">on 2009-01-11</span>
  </div>
  <div class=3D"boardBugActivityBody">
    <div class=3D"bug-comment">
      <table>
        <tbody><tr>
          <td style=3D"text-align: right;">
            <b>linux status</b>:
          </td>
          <td>
            Invalid =E2=86=92 Incomplete
          </td>
        </tr>
      </tbody></table>
    </div>
  </div>
</div>

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Ejkennon1" style=3D"backgroun=
d: transparent url(/@@/person) no-repeat scroll left center; padding-left: =
18px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-init=
ial; -moz-background-inline-policy: -moz-initial;">Jimbot</a>
   =20
    wrote
    <span title=3D"2009-03-12 09:36:58 UTC">on 2009-03-12</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/12">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>I
also have a DVICO Dual Digital 4 (PCI, not PCIe) and am running amd64
architecture. I&#39;m running Mythbuntu 8.04 - I&#39;m assuming this is bas=
ed
on the desktop kernel. My card identifies itself as 0fe9:db78 in lsusb.
I set it up based on the instructions shown here: <a rel=3D"nofollow" href=
=3D"http://ubuntuforums.org/showthread.php?t=3D616103">http://ubuntuforums.=
org/showthread.php?t=3D616103</a> and it works. However, I have a similar p=
roblem to that which Anders describes.</p>

<p>Frequently when I do a warm boot, the system exhibits similar behaviour:=
</p>
<p>- I get the &quot;dvb-usb: bulk message failed: -110&quot; at a frequenc=
y of about once a second<br>
- I get similar keyboard issues with my usb keyboard (press k once and I ge=
t a dozen or so: &quot;kkkkkkkkkkkkkkkkkk&quot;)</p>
<p>The only way I can get my system back to &#39;normal&#39; again is to re=
move the dvb_usb_cxusb module:</p>
<p>modprobe -r dvb_usb_cxusb</p>
<p>of course I have to stop the mythbackend first.Doing all this is
very difficult when every few keypresses get repeated a heap of times.
Especially when I have to login as root to do it. Though my system is
now usable, the tuner card won&#39;t work (not without that module I just
removed) so I have to reboot for me to use the system as intended.</p>
<p>I could live with the issue on warm reboot; I just have to shutdown,
wait a bit, then start up again. However, the system has recently
started doing it whenever I shut down the mythbackend (for
configuration for instance), and when I tested connecting with XBMC
from another machine it did it as well.</p>
<p>Based on the forum thread I followed to set the card up, this seems
to be a known issue among users of the card, but it&#39;s a royal pain in
the neck and it would be great if it got fixed some time. I&#39;m happy to
provide additional information if that would be of assistance.</p>
<p>Cheers.</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Eoobe-trouble" style=3D"backg=
round: transparent url(/@@/person) no-repeat scroll left center; padding-le=
ft: 18px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-=
initial; -moz-background-inline-policy: -moz-initial;">Kemble Wagner</a>
   =20
    wrote
    <span title=3D"2009-03-13 01:07:06 UTC">on 2009-03-13</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/13">
      <strong>Re: [Bug 229879] Re: My DVB-card is flooding the consol with =
&quot;recv 	bulk message failed&quot;</strong>
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>you could try using building a vanilla ke=
rnel thats what i used on 8.04 and<br>
now im using intrepid i have no problems with the stock kernel 2.6.27-11</p=
>
<p>On Thu, Mar 12, 2009 at 8:36 PM, Jimbot &lt;<a href=3D"mailto:jkennon1@g=
mail.com">jkennon1@gmail.com</a>&gt; wrote:</p>
<p><a href=3D"javascript:void(0);" style=3D"text-decoration: underline;">[.=
..]</a><span style=3D"display: none;" class=3D"foldable-quoted"><br>&gt; I =
also have a DVICO Dual Digital 4 (PCI, not PCIe) and am running amd64<br>
&gt; architecture. I&#39;m running Mythbuntu 8.04 - I&#39;m assuming this i=
s based on<br>
&gt; the desktop kernel. My card identifies itself as 0fe9:db78 in lsusb. I=
<br>
&gt; set it up based on the instructions shown here:<br>
&gt; <a rel=3D"nofollow" href=3D"http://ubuntuforums.org/showthread.php?t=
=3D616103">http://ubuntuforums.org/showthread.php?t=3D616103</a> and it wor=
ks. However, I<br>
&gt; have a similar problem to that which Anders describes.<br>
&gt;<br>
&gt; Frequently when I do a warm boot, the system exhibits similar behaviou=
r:<br>
&gt;<br>
&gt; - I get the &quot;dvb-usb: bulk message failed: -110&quot; at a freque=
ncy of about<br>
&gt; once a second<br>
&gt; - I get similar keyboard issues with my usb keyboard (press k once and=
 I<br>
&gt; get a dozen or so: &quot;kkkkkkkkkkkkkkkkkk&quot;)<br>
&gt;<br>
&gt; The only way I can get my system back to &#39;normal&#39; again is to =
remove the<br>
&gt; dvb_usb_cxusb module:<br>
&gt;<br>
&gt; modprobe -r dvb_usb_cxusb<br>
&gt;<br>
&gt; of course I have to stop the mythbackend first.Doing all this is very<=
br>
&gt; difficult when every few keypresses get repeated a heap of times.<br>
&gt; Especially when I have to login as root to do it. Though my system is<=
br>
&gt; now usable, the tuner card won&#39;t work (not without that module I j=
ust<br>
&gt; removed) so I have to reboot for me to use the system as intended.<br>
&gt;<br>
&gt; I could live with the issue on warm reboot; I just have to shutdown,<b=
r>
&gt; wait a bit, then start up again. However, the system has recently<br>
&gt; started doing it whenever I shut down the mythbackend (for configurati=
on<br>
&gt; for instance), and when I tested connecting with XBMC from another<br>
&gt; machine it did it as well.<br>
&gt;<br>
&gt; Based on the forum thread I followed to set the card up, this seems to=
<br>
&gt; be a known issue among users of the card, but it&#39;s a royal pain in=
 the<br>
&gt; neck and it would be great if it got fixed some time. I&#39;m happy to=
<br>
&gt; provide additional information if that would be of assistance.<br>
&gt;<br>
&gt; Cheers.<br>
&gt;<br>
&gt; --<br>
&gt; My DVB-card is flooding the consol with &quot;recv bulk message failed=
&quot;<br>
&gt; <a rel=3D"nofollow" href=3D"https://bugs.launchpad.net/bugs/229879">ht=
tps://bugs.launchpad.net/bugs/229879</a><br>
&gt; You received this bug notification because you are a direct subscriber=
<br>
&gt; of the bug.<br>
&gt;
</span></p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Emoaxey" style=3D"background:=
 transparent url(/@@/person) no-repeat scroll left center; padding-left: 18=
px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initia=
l; -moz-background-inline-policy: -moz-initial;">moaxey</a>
   =20
    wrote
    <span title=3D"2009-04-01 06:50:08 UTC">on 2009-04-01</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/14">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>this is affecting me too.</p>
<p>I can avoid it by shutting down for time instead of restarting...</p>
<p>What information could I collect to cast more light on it?</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Eoobe-trouble" style=3D"backg=
round: transparent url(/@@/person) no-repeat scroll left center; padding-le=
ft: 18px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-=
initial; -moz-background-inline-policy: -moz-initial;">Kemble Wagner</a>
   =20
    wrote
    <span title=3D"2009-04-01 09:00:35 UTC">on 2009-04-01</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/15">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>has anyone tried installing newer v4l-dvb=
 drivers</p>
<p>sudo -i</p>
<p>apt-get update</p>
<p>apt-get install install mercurial build-essential linux-headers-`uname -=
r`</p>
<p>hg clone <a rel=3D"nofollow" href=3D"http://linuxtv.org/hg/v4l-dvb">http=
://linuxtv.org/hg/v4l-dvb</a></p>
<p>cd v4l-dvb</p>
<p>make &amp;&amp; make install</p>
<p>exit</p>
<p>or as i mentioned above dowloading the newest kernel from <a rel=3D"nofo=
llow" href=3D"http://kernel.org/">http://kernel.org</a> and compiling it yo=
uself will also fix this<br>
<a rel=3D"nofollow" href=3D"http://www.howtoforge.com/kernel_compilation_ub=
untu">http://www.howtoforge.com/kernel_compilation_ubuntu</a></p>
<p>i for one can say that this used to fix the trouble for me however now i=
n intrepid the stock kernel works fine for me.</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Ereg-jya-launchpad" style=3D"=
background: transparent url(/@@/person) no-repeat scroll left center; paddi=
ng-left: 18px; -moz-background-clip: -moz-initial; -moz-background-origin: =
-moz-initial; -moz-background-inline-policy: -moz-initial;">Jean-Yves Avena=
rd</a>
   =20
    wrote
    <span title=3D"2009-04-04 05:10:21 UTC">on 2009-04-04</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/16">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>Unfortunately, even with the latest v4l-d=
vb drivers I too experience those bulk errors in the log</p>
<p>They show up every 2 seconds</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Eoobe-trouble" style=3D"backg=
round: transparent url(/@@/person) no-repeat scroll left center; padding-le=
ft: 18px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-=
initial; -moz-background-inline-policy: -moz-initial;">Kemble Wagner</a>
   =20
    wrote
    <span title=3D"2009-04-05 15:23:40 UTC">21 hours ago</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/17">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>as
mentioned im using 2.6.27-11-generic and as i said i havent had a
problem yet well the other day i did i experienced the same problems
that others here report including spam console etc. but i have not had
it before or since just chiming in to say that even when i have
somthing that i consider stable it still ends up like this on occasion
so there is yet to be a completely stable kernel or v4l-dvb tree on
this matter.</p>
<p>=C2=A0it would be sensable if someone started a thread on the v4l-dvb
mailing list about this as ubuntu developers cannot fix this due to the
fact they only package the code that v4l-dvb produce which intern goes
into the kernel which distros then patch and package.</p></div>
   =20
  </div>
 =20
</div>

           =20
         =20

         =20
       =20
       =20
         =20
           =20
             =20
<div class=3D"boardComment">
  <div class=3D"boardCommentDetails">
   =20
      <a href=3D"https://bugs.launchpad.net/%7Eomahns-home" style=3D"backgr=
ound: transparent url(/@@/person) no-repeat scroll left center; padding-lef=
t: 18px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-i=
nitial; -moz-background-inline-policy: -moz-initial;">Paul Elliott</a>
   =20
    wrote
    <span title=3D"2009-04-06 07:50:16 UTC">5 hours ago</span>:
    <a href=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/229879/=
comments/18">
     =20
      (permalink)
    </a>
  </div>

 =20

  <div class=3D"boardCommentBody">
   =20

    <div class=3D"bug-comment"><p>I
also have this issue. I was originally running 7.10, then upgraded to
8.10 via 8.04. I think the suggestion from Kemble to post to the
v4l-dvb mailing list is sound. If the OP can create an initial posting
I&#39;ll also post to the same thread to highlight that this is affecting
multiple users.</p></div>
   =20
  </div>
 =20
</div>
=C2=A0</div></div><br>

--0016363b85ca6ed3f80466e283c6--


--===============0208441897==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0208441897==--
