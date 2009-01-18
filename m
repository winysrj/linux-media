Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:11709 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761561AbZARONF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 09:13:05 -0500
Received: by ug-out-1314.google.com with SMTP id 39so140631ugf.37
        for <linux-media@vger.kernel.org>; Sun, 18 Jan 2009 06:13:03 -0800 (PST)
Date: Sun, 18 Jan 2009 15:12:54 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Uri Shkolnik <urishk@yahoo.com>
cc: =?UTF-8?Q?St=C3=A5le_Helleberg_=2F_drc=2Eno?= <staale@drc.no>,
	linux-dvb <linux-dvb@linuxtv.org>, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Siano subsystem (DAB/DMB support) library for
 linux?
In-Reply-To: <743977.30000.qm@web110807.mail.gq1.yahoo.com>
Message-ID: <alpine.DEB.2.00.0901181431460.18169@ybpnyubfg.ybpnyqbznva>
References: <743977.30000.qm@web110807.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-388026259-1232287980=:18169"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-388026259-1232287980=:18169
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Sun, 18 Jan 2009, Uri Shkolnik wrote:

> > You know, it might help if I actually looked at the files
> > I'm
> > hacking on, instead of blindly assuming they work like
> > `MAKEDEV'
> > and create the node in the current directory  :-)

Well, I guess that has blown my chances of ever getting
a job again ;-)   Now the world will see this post and
say that something about my claim to having written an
operating system in my spare time just doesn't add up...

But now that the cat is out of the bag, and you've made
the Linux library available to all, I figure it's time
to post my hack to the public.

Attached as a file is a replacement for the MAKEDEV-like
script which can be found in contrib/ in the download
from Siano.  It tackles the following issues:

* eliminates the DOS-type line-endings, which did not
  agree with my flavour of /bin/sh
* attempts to figure out where the Siano library should
  be looking for its devices -- this is useful for the
  case where the desired major number 251 is already in
  use, and one has to specify a module load parameter
  (I think I've described this as best I could in an
  earlier message to linux-dvb)
* allows the user to specify the major and/or minor
  numbers given as module parameters
* unlinks potentially existing nodes in case of the need
  to recreate them with different major or minors

This is a total hack, and can be rewritten to probably
half the number of lines by anyone with a Clue, say,
using a for loop and simplifying my logic (note to future
employers:  look into my eyes, my eyes, not around the
eyes, you did not see this, you are suddenly interested
in the shiny toys on your desk)

So, feel free to improve on this, or to use it in place
of that supplied from the Siano ftp site.



> > > It was not hardware debugging needed, so it seems.  On

> > Or...  was it?  Not only with major 249 on the newer build,
> > but now, again with 249 on my notebook, I also see success.
> > 
> > Could it be that the USB device into which I plugged the
> > TerraTec Piranha caused the problems?  Maybe, because into
> > a different USB hub, I have success on the notebook...

> > Now, the interesting thing is that a USB2 DVB-S connected
> > through this same hub delivered streams that were corrupt
> > every few minutes, while the same device connected to a
> > different hub has been delivering flawless streams.  Now
> > I need to check whether the USB1 Piranha can deliver the
> > clean streams, or if again, cheap hardware will cause me
> > grief...

An update to this, in case it would be of interest...

After several attempts to tune potential if weak signals,
I once again reached the point where attempts to initialise
the device would timeout -- exactly what I had seen originally,
but this time after half a dozen successful attempts to use
it and at least get to the tuning stage.

So now I've moved the device to a different USB hub port,
and once again it's working fine.  How long will this last?

I still haven't tried it in the hub where my other DVB
device works flawlessly, but it may come to that...



> Cool, I'm just CC the ML
> I get questions (sometimes the exact same questions) from various of people. Lets use the ML to sync all...

Well, I hope that by making a fool of myself, I can post
this info so that others can benefit from it, and you
won't be bothered by these same questions.


In summary:

I've had success with DAB signals with the following:

The default_mode= module loading parameter works set to =2.

The firmware I've used is that which I downloaded some time
back as part of the DVB-T in-kernel siano support, and looks
like...
-r-xr-xr-x 1 beer besoffen 40096 May 17  2007 /usr/lib/hotplug/firmware/tdmb_stellar_usb.inp

There are firmware files of different size on the Siano ftp
server, such as
-rw-rw-r-- 1 beer staff 38428 2008-12-31 16:26 tdmb_stellar_usb_12mhz_downld.inp
-rw-rw-r-- 1 beer staff 38720 2008-12-31 16:26 tdmb_stellar_usb_12mhz_eeprom_a2.brn

I have not yet done anything with these to see if these might
be a better choice.


If, like me, your `cat /proc/devices` is full, and major 251
is assigned to something else, when you go to load the siano
smsmdtv.ko kernel module, you will need to specify an alternate
major number (minor can also be specified, should you need)
smschar_major=249  (tweak as you need), for example.

You can give the major number as 0...
smschar_major=0
In this case, the first available major number will be
automatically assigned.  The script which I attach attempts
to find this, assuming `procfs' is available and mounted,
and does its best to create the proper devices.

Should that fail, you can optionally specify the major (and,
should you wish, the minor) as options to the script, which
should explain itself in the comments if you read it.


Here's hoping this is useful...
(followup as appropriate; /dev/null is where this should have 
gone)
barry bouwsma
--8323328-388026259-1232287980=:18169
Content-Type: APPLICATION/x-sh; name=create_char_dev.sh
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.0901181512540.18169@ybpnyubfg.ybpnyqbznva>
Content-Description: Hacked version of contrib/create_char_dev.sh
Content-Disposition: attachment; filename=create_char_dev.sh

IyEvYmluL3NoCgojIFVTQUdFOiAgJDAgIG1ham9yICBtaW5vciAgKGFyZ3Vt
ZW50cyBvcHRpb25hbCkKIyAgaWYgbWFqb3IgaXMgMCBvciBub3Qgc3BlY2lm
aWVkLCB3aWxsIG1ha2UgYSBmZWVibGUgaGFsZi1oZWFydGVkCiMgIGF0dGVt
cHQgdG8gZGV0ZXJtaW5lIHdoaWNoIG1ham9yIGlzIGluIHVzZSBieSBzbXNt
ZHR2CiMgIGRlZmF1bHQgYmVpbmcgMjUxLiAgbWlub3IgaXMgMCB1bmxlc3Mg
c3BlY2lmaWVkIG90aGVyd2lzZQoKIyBIQUNLOiAgbWFqb3IgMjUxIGlzIHVz
ZWQgb24gbXkgdGVzdCBzeXN0ZW0uCiMgIGFsbG93IHVzZXIgdG8gc3BlY2lm
eSBtYWpvci4KIyAgZWxzZSB0cnkgdG8gZ2V0IGl0IGZyb20gL3Byb2MvZGV2
aWNlcy4KIyAgZWxzZSBmYWxsYmFjayB0byB0aGUgZGVmYXVsdCAoMjUxKQoK
IyBtb3JlIEhBQ0s6ICB0aGUgbW9kdWxlIGFsc28gYWxsb3dzIG9uZSB0byBz
cGVjaWZ5IGEgcGFydGljdWxhcgojICBzdGFydGluZyBtaW5vciBudW1iZXIu
ICBOb3Qgc3VyZSBob3cgdG8gZGV0ZWN0IHRoYXQgYXV0b21hZ2ljYWxseS4K
IyAgYXNzdW1lIDAsIGJ1dCBhbGxvdyB1c2VyIHRvIG92ZXJyaWRlIHRoaXMg
YXMgc2Vjb25kIGFyZ3VtZW50CiMgIChpbiB3aGljaCBjYXNlIGZpcnN0IGlz
IHJlcXVpcmVkLCBvciBwZXJoYXBzIDAgdG8gZGV0ZWN0KQoKU01TTUlOT1I9
MAppZiBbICJ4JDEiICE9ICJ4IiBdCnRoZW4KCVNNU0NIQVI9JDEKCWlmIFsg
IngkMiIgIT0gIngiIF0KCXRoZW4KCQlTTVNNSU5PUj0kMgoJZmkKCWlmIFsg
IngkU01TQ0hBUiIgPSAieDAiIF0KCXRoZW4KCQlTTVNDSEFSPSIiCglmaQpm
aQoKaWYgWyAieCRTTVNDSEFSIiA9ICJ4IiBdCnRoZW4KCVNNU0NIQVI9YGdy
ZXAgc21zY2hhciAvcHJvYy9kZXZpY2VzIDI+L2Rldi9udWxsIHwgY3V0IC1m
MSAtZCAnICcgfCBoZWFkIC0xIGAKZmkKCmlmIFsgIngkU01TQ0hBUiIgPSAi
eCIgXQp0aGVuCglTTVNDSEFSPSIyNTEiCmZpCmVjaG8gVXNpbmcgbWFqb3Ig
JFNNU0NIQVIsIHN0YXJ0aW5nIGF0IG1pbm9yICRTTVNNSU5PUi4uLgoKcm0g
L2Rldi9tZHR2Y3RybCAmJiBta25vZCAtbSA3NjYgL2Rldi9tZHR2Y3RybCBj
ICRTTVNDSEFSICQoKCRTTVNNSU5PUiArIDApKQpybSAvZGV2L21kdHYxICYm
IG1rbm9kIC1tIDc2NiAvZGV2L21kdHYxIGMgJFNNU0NIQVIgJCgoJFNNU01J
Tk9SICsgMSkpCnJtIC9kZXYvbWR0djIgJiYgbWtub2QgLW0gNzY2IC9kZXYv
bWR0djIgYyAkU01TQ0hBUiAkKCgkU01TTUlOT1IgKyAyKSkKcm0gL2Rldi9t
ZHR2MyAmJiBta25vZCAtbSA3NjYgL2Rldi9tZHR2MyBjICRTTVNDSEFSICQo
KCRTTVNNSU5PUiArIDMpKQpybSAvZGV2L21kdHY0ICYmIG1rbm9kIC1tIDc2
NiAvZGV2L21kdHY0IGMgJFNNU0NIQVIgJCgoJFNNU01JTk9SICsgNCkpCnJt
IC9kZXYvbWR0djUgJiYgbWtub2QgLW0gNzY2IC9kZXYvbWR0djUgYyAkU01T
Q0hBUiAkKCgkU01TTUlOT1IgKyA1KSkKcm0gL2Rldi9tZHR2NiAmJiBta25v
ZCAtbSA3NjYgL2Rldi9tZHR2NiBjICRTTVNDSEFSICQoKCRTTVNNSU5PUiAr
IDYpKQpybSAvZGV2L21kdHY3ICYmIG1rbm9kIC1tIDc2NiAvZGV2L21kdHY3
IGMgJFNNU0NIQVIgJCgoJFNNU01JTk9SICsgNykpCnJtIC9kZXYvbWR0djgg
JiYgbWtub2QgLW0gNzY2IC9kZXYvbWR0djggYyAkU01TQ0hBUiAkKCgkU01T
TUlOT1IgKyA4KSkKcm0gL2Rldi9tZHR2OSAmJiBta25vZCAtbSA3NjYgL2Rl
di9tZHR2OSBjICRTTVNDSEFSICQoKCRTTVNNSU5PUiArIDkpKQpybSAvZGV2
L21kdHYxMCAmJiBta25vZCAtbSA3NjYgL2Rldi9tZHR2MTAgYyAkU01TQ0hB
UiAkKCgkU01TTUlOT1IgKyAxMCkpCnJtIC9kZXYvbWR0djExICYmIG1rbm9k
IC1tIDc2NiAvZGV2L21kdHYxMSBjICRTTVNDSEFSICQoKCRTTVNNSU5PUiAr
IDExKSkKcm0gL2Rldi9tZHR2MTIgJiYgbWtub2QgLW0gNzY2IC9kZXYvbWR0
djEyIGMgJFNNU0NIQVIgJCgoJFNNU01JTk9SICsgMTIpKQpybSAvZGV2L21k
dHYxMyAmJiBta25vZCAtbSA3NjYgL2Rldi9tZHR2MTMgYyAkU01TQ0hBUiAk
KCgkU01TTUlOT1IgKyAxMykpCnJtIC9kZXYvbWR0djE0ICYmIG1rbm9kIC1t
IDc2NiAvZGV2L21kdHYxNCBjICRTTVNDSEFSICQoKCRTTVNNSU5PUiArIDE0
KSkKcm0gL2Rldi9tZHR2MTUgJiYgbWtub2QgLW0gNzY2IC9kZXYvbWR0djE1
IGMgJFNNU0NIQVIgJCgoJFNNU01JTk9SICsgMTUpKQpybSAvZGV2L21kdHYx
NiAmJiBta25vZCAtbSA3NjYgL2Rldi9tZHR2MTYgYyAkU01TQ0hBUiAkKCgk
U01TTUlOT1IgKyAxNikpCgo=

--8323328-388026259-1232287980=:18169--
