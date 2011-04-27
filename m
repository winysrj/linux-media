Return-path: <mchehab@pedra>
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:52059 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1D0OYi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 10:24:38 -0400
Received: from [109.91.78.147] (helo=darkstar)
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.68)
	(envelope-from <lists@baums-on-web.de>)
	id 1QF5OL-000544-Gl
	for linux-media@vger.kernel.org; Wed, 27 Apr 2011 16:06:57 +0200
Date: Wed, 27 Apr 2011 16:06:31 +0200
From: Heiko Baums <lists@baums-on-web.de>
To: linux-media@vger.kernel.org
Subject: Terratec Cinergy 1400 DVB-T RC not working anymore
Message-ID: <20110427160631.1ab89fdb@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I've got a problem since a few days after a system update. I don't know
what was updated exactly, if it was the kernel, udev or lirc. I'm using
Arch Linux with kernel 2.6.38.4.

I've got a Terratec Cinergy 1400 DVB-T (a cx88 card). Its IR remote
control has worked perfectly with lirc for many years.

Suddenly it stopped working. 

This is my /etc/conf.d/lircd:

#
# Parameters for lirc daemon
#

LIRC_DEVICE=phys='pci*/ir0'
LIRC_DRIVER='dev/input'
LIRC_EXTRAOPTS=''
LIRC_CONFIGFILE='/etc/lirc/lircd.conf'

This is the according section of /proc/bus/input/devices:

I: Bus=0001 Vendor=153b Product=1166 Version=0001
N: Name="cx88 IR (TerraTec Cinergy 1400 "
P: Phys=pci-0000:03:06.2/ir0
S: Sysfs=/devices/pci0000:00/0000:00:14.4/0000:03:06.2/rc/rc0/input3
U: Uniq=
H: Handlers=kbd event3 
B: PROP=0
B: EV=100013
B: KEY=108fc210 204300000000 0 8000 208000000001 9e168000000000 ffc
B: MSC=10

So the device is detected.

irrecord -H dev/input -d phys='pci*/ir0' /tmp/remote finds the correct
device but gives only this output:

Hold down an arbitrary button.
irrecord: gap not found, can't continue
irrecord: closing '/dev/input/event3'

And irw while lircd is running doesn't do anything.

# cat /sys/class/rc/rc0/protocols
rc-5 nec rc-6 jvc sony lirc

I, of course, activated every protocol one after another and all at
once, but none of them is working except for lirc, but lirc doesn't
work as expected, too.

So I activated lirc for my attempts to get this working again:
# echo lirc > /sys/class/rc/rc0/protocols

# ir-keytable
Found /sys/class/rc/rc0/ (/dev/input/event4) with:
        Driver cx88xx, table rc-cinergy-1400
        Supported protocols: NEC RC-5 RC-6 JVC SONY LIRC
        Enabled protocols:
        Repeat delay = 500 ms, repeat period = 33 ms

Sometime I set ir-keytable to rc-cinergy-1400. I don't know which
ir-keytable was set before, but none of them worked.

There are some attempts to creating a new lircd.conf with irrecord:

# irrecord -H dev/input -d phys='pci*/ir0' /tmp/remote
Hold down an arbitrary button.
irrecord: gap not found, can't continue
irrecord: closing '/dev/input/event4'

# irrecord -H cx88xx -d /dev/lirc0 /tmp/remote
Driver `cx88xx' not supported.

# irrecord -d /dev/lirc0 /tmp/remote

This let me enter the keys and indeed creates a /tmp/remote but with a
very strange content. Copying this file to /etc/lirc/lircd.conf and
running lircd with this config, irw still doesn't do anything and my
keyboard doesn't work anymore, too, so that I need to hard reset my
computer.

This is the first part of my usual /etc/lirc/lircd.conf:

begin remote

  name  Terratec_Cinergy_1400_DVB-T
  bits           16
  eps            30
  aeps          100

  one             0     0
  zero            0     0
  pre_data_bits   16
  pre_data       0x8001
  gap          135787
  toggle_bit      0


      begin codes
          power                    0x0074
          1                        0x0002
          2                        0x0003
          3                        0x0004

This is the first part of the /tmp/remote created by irrecord
-d /dev/lirc0 /tmp/remote:

begin remote

  name  /tmp/remote
  flags RAW_CODES|CONST_LENGTH
  eps            30
  aeps          100

  gap          123512

      begin raw_codes

          name KEY_POWER
             9250    4500     500     500     750     500
              500    1750     500     500     750     500
              500     500     750     500     500     500
              750    1500     750    1500     750     500
              500    1750     750     250     750    1500
              750    1500     750    1500     750    1500
              750     500     750     250     750     500
              750     500     500     500     750     500
              500     500     750     250     750    1750
              500    1750     500    1750     500    1750
              500    1750     500    1750     500    1750
              500

          name KEY_1
             9000    4500     500     500     750     500
              750    1500     750     500     500     500
              750     500     500     500     750     500
              500    1750     500    1750     500     500
              750    1500     750     500     500    1750
              500    1750     500    1750     500     500
              750    1500     750     500     500     500
              750     500     500     500     750     500
              500     500     750    1500     750     500
              500    1750     500    1750     500    1750
              750    1500     750    1500     750    1500
              750

          name KEY_2
             9000    4500     750     250     750     500
              750    1500     750     500     500     500
              750     250     750     500     750     500
              500    1750     500    1750     500     500
              750    1500     750     500     500    1750
              500    1750     500    1750     500    1750
              500    1750     500     500     750     500
              500     500     750     500     500     500
              750     500     500     500     750     500
              500    1750     500    1750     500    1750
              750    1500     750    1500     500    1750
              750

          name KEY_3
             9250    4250     750     500     750     500
              500    1750     500     500     750     500
              500     500     750     500     500     500
              750    1500     750    1500     750     500
              500    1750     500     500     750    1500
              750    1500     750    1500     750     500
              500     500     750    1500     750     500
              500     500     750     500     500     500
              750     500     500    1750     750    1500
              750     250     750    1500     750    1500
              750    1500     750    1500     750    1750
              500

And in /proc/bus/input/devices there's this line:
H: Handlers=kbd event3

I don't know if this is the reason, but is it possible that my remote
control is treated as a keyboard while it should be treated as event3?

Does anybody know what's going wrong and how this issue could be fixed?
Or is it a bug maybe in the cx88 or lirc related kernel modules?

I tried everything I found by searching various forums, wikis and the
web, but nothing helped. I also asked on the lirc mailing list, but as
a result was asked to ask here again.

And I don't seem to be the only one who has this issue with a cx88
device.

See also:
https://bugs.archlinux.org/task/23894

Heiko
