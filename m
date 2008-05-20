Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1JyGls-0007qW-TS
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 03:36:10 +0200
Received: by wa-out-1112.google.com with SMTP id n7so1935495wag.13
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 18:36:03 -0700 (PDT)
Message-ID: <bb72339d0805191836l26aa826fl3b6dd3aafa20712@mail.gmail.com>
Date: Tue, 20 May 2008 11:36:03 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Kworld 399U Dual DVB-T USB tuner
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

Hey,
  I have had some trouble trying to get a new KWorld 399U dual dvb-t
USB dongle working with my debian etch 64-bit (+mythtv) box [1].
  Physically dissasembling the dongle reveals the four chips on board
are labeled AF9013-N1, FA9015-N1 and 2x MXL5003S.
  I have found and followed instructions on linuxtv.org for building
the latest v4l drivers[2] with some modifications[3]. I have also
found that the 399U has recently had support added[4]. Building and
installing from the latest source[5], restarting and trying `modprobe
dvb-usb-af9005` tells me I need firmware.
  Adding an image to /lib/firmware[6] solves this issue. I then reboot
and this now detects as /dev/dvb/adapter0 and works well with mythtv
though the channel changes are a little slow.
  Only one of the two tuners is working for now, I am guessing this
could be because of the firmware image I chose to use. I have the
windows driver disk that came with the tuner and have read suggestions
that the firmware image can be extracted from it. I tried using
AF15BDA.sys file from the x64 driver dir as
/lib/firmware/dvb-usb/ad9015.fw without success. dmesg shows the
driver continually trying to load the firmware.

  A second issue is that the computer already has a working KWorld pci
tuner which uses the cx88 drivers which are not compiled when building
the af9015 checkout. The files seem available, but the modules are not
being build. My existing kernel modules are not compatible (I backed
up then rm -rf /lib/modules/`uname -r`/kernel/drivers/media/* before
doing `make install`, restoring my backed up video/cx88 dir and
contents throws unknown symbol errors when trying `modprobe
cx88-dvb`).
  I tried `make all cx88-ivtv` in case that was relevant, but this
doesn't seem to help (possibly because the link is dead
v4l/cx88-ivtv.c -> ../v4l_experimental/cx88-ivtv.c but this doesn't
exist).

So two questions:
  What can I do to enable the second tuner on the dongle?
  How can I compile the cx88 drivers along with the rest in the af9015 checkout?

If there's any other output or info that may help, please let me know.

cheers,
Owen.

Footnotes:
--
[1] Linux kushiel 2.6.18-6-amd64 #1 SMP Thu May 8 06:49:39 UTC 2008
x86_64 GNU/Linux
[2] http://linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers
[3] http://www.gossamer-threads.com/lists/ivtv/devel/37175
[4] http://linuxtv.org/hg/~anttip/af9015/rev/22fc34924b9e
[5] hg clone http://linuxtv.org/hg/~anttip/af9015; cd af9005; ( Make
recommended mods for 2.6.18 ); sudo mv
/lib/modules/2.6.18-6-amd-64/kernel/drivers/media/* ~/mod.bak; sudo
make install;
[6] Firmware from:
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
