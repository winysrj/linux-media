Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <n.wagenaar@xs4all.nl>) id 1KOSji-0003gF-H9
	for linux-dvb@linuxtv.org; Thu, 31 Jul 2008 09:38:11 +0200
Received: from webmail.xs4all.nl (dovemail5.xs4all.nl [194.109.26.7])
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id m6V7c0sF037890
	for <linux-dvb@linuxtv.org>; Thu, 31 Jul 2008 09:38:05 +0200 (CEST)
	(envelope-from n.wagenaar@xs4all.nl)
Message-ID: <11920.130.36.62.139.1217489885.squirrel@webmail.xs4all.nl>
Date: Thu, 31 Jul 2008 09:38:05 +0200 (CEST)
From: "Niels Wagenaar" <n.wagenaar@xs4all.nl>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] latest hvr-4000 driver patches
Reply-To: n.wagenaar@xs4all.nl
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

Op Do, 24 juli, 2008 11:20, schreef Goga777:
>> And what about vdr-1.7.0, is the multi frontend driver install
>> procedure mentioned in wiki ok for that one?
>> (http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000#Drivers)
>> or is there awailable some other patch set for that?
>
> I have vdr 170 , hvr4000 and fresh drivers form "Igor M. Liplianin's repo
> (repo includes hg multiproto + hvr4000 patch +
> some fixes)

I had the Igor repo working on a Hauppauge WinTV-NOVA-HD-S2 (aka HVR4000
Lite) with VDR 1.7.0 as well, until yesterday that is. The harddisk of my
VDR system died and I had to re-install everything on a new HDD. The
important configs were backupped, but I didn't backup the Igor repo.

Well, no biggie. I compiled the latest hg repo on Xubuntu 8.0.4.
Compilation and installation went without problems. DVB-S and DVB-S2 works
in VDR 1.7.0. Only I can't get the remote of the Hauppauge working any
more in combination with the vdr-remote plugin. VDR starts, but just hangs
when he wants to setup the remote:

- dmesg output:

[   40.705724] input: cx88 IR (Hauppauge WinTV-HVR400 as
/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/input/input4

- user.log output:

Jul 31 07:11:04 htpc vdr: [6610] remote control remote-event4 - learning keys
Jul 31 07:11:04 htpc vdr: [6610] device /dev/input/event4: cx88 IR
(Hauppauge WinTV-HVR400
Jul 31 07:11:42 htpc vdr: [6610] new remote-event4 code: 0000000100010067
= Up

Then it hangs. No output on the screen (I use the eHD for output). If I
change the input to lircd (which is for my mce_usb2 device) with
vdr-remote, the Remote setup comes up and I can complete it.

Has something changed to the remote functionality in the Igor repo? The
pull I did from last friday, did work with the vdr-remote plugin and my
remote.

> http://liplianindvb.sourceforge.net/cgi-bin/hgwebdir.cgi/liplianindvb/
> It works well. I recommend it for your case
> Of course it's not multifrontend drivers
>

I can agree, the Igor repo works very good! No more pulls from different
sources and add patches which breaks with newer multiproto revisions :)

> Goga

Regards,

Niels Wagenaar


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
