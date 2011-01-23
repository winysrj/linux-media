Return-path: <mchehab@pedra>
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:16079 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1AWMIT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 07:08:19 -0500
Received: from localhost (localhost [127.0.0.1])
	by assursys.co.uk (Postfix) with ESMTP id 20D6930034
	for <linux-media@vger.kernel.org>; Sun, 23 Jan 2011 11:58:43 +0000 (GMT)
Date: Sun, 23 Jan 2011 11:58:43 +0000 (GMT)
From: Alex Butcher <linuxtv@assursys.co.uk>
To: linux-media@vger.kernel.org
Subject: Hauppauge Nova-T-500; losing one tuner. Regression?
Message-ID: <alpine.LFD.2.00.1101231119320.26778@sbhezbfg.of5.nffheflf.cev>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi -

I've recently built an upgraded MythTV system. My old system was running
Fedora 8 (with kernel 2.6.26.6-49), MythTV 0.21-fixes, and used a
single-tuner PCI Nova-T and a dual tuner PCI Nova-T-500 for a total of three
physical tuners.  I've re-used the tuner cards in my upgraded system, which
runs Fedora 14 (kernel 2.6.35.10-74) and MythTV 0.24-fixes.

As a refresher, the drivers in the 2.6.26.6-49 kernel didn't yet include
support for the new I2C functions only supported by dib0700 firmware
revisions >= 1.20.  I don't think this is relevant to the Nova-T-500,
though, as only s5h1411_frontend_attach() and lgdt3305_frontend_attach() set
fw_use_new_i2c_api to 1.

My old MythTV system worked perfectly for months at a time (i.e. between AC
power failures!) and once I got a stable configuration for the Nova-T-500
card, I never had failed recordings due to losing a tuner.  However, despite
recreating the same config on the new hardware, I seem to be experiencing
the old problems with one of the tuners on the Nova-T-500 ceasing to respond
randomly many hours after boot, resulting in failed MythTV recordings.  Both
the tuners work immediately after the system is booted, however.  When one
Nova-T-500 tuner has stopped responding the other is able to record
perfectly, suggesting that there isn't a signal strength or cabling problem.

Tweaks I used on my old MythTV box, that I've carried forward to the
upgraded system:

1) Boot kernel with usbcore.autosuspend=-1 to disable suspending of USB
devices (i.e.  the two USB tuners behind the VIA USB/PCI bridge on the
Nova-T-500 PCI card)

2) Load the dvb_usb kernel module with disable_rc_polling=1 to disable the
IR port on the Nova-T-500. I only use the IR port on the Nova-T, so I can
live with this.

3) Load the dvb-usb-dib0700 module with force_lna_activation=1 to have the
LNA permanently enabled.

4) In /etc/rc.d/rc.local:

echo 0 >/sys/module/dvb_core/parameters/dvb_powerdown_on_sleep

and

#for i in `find /sys -name 'level' | grep usb`; do echo "on" >$i; done
# AJB20110120 power/level deprecated in favour of power/control
for i in `find /sys -name 'control' | grep usb`; do echo "on" >$i; done
for i in `find /sys -name 'control' | grep i2c` ; do echo "on" >$i; done

as belt-and-braces to prevent the Nova-T-500 sub-devices being suspended.

5) Use the 1.20 firmware (MD5: f42f86e2971fd994003186a055813237) file and
ensure it's being properly loaded. I've also tried the 1.10 firmware (MD5:
5878ebfcba2d8deb90b9120eb89b02da) with no apparent improvement.

6) Ensure that the machine is cold-booted (thereby forcing a firmware load
onto the Nova-T-500) every time due to reports of warm boots being
problematic.

7) Disable EIT scanning by MythTV on both of the two Nova-T-500 tuners. Only
leave it enabled on the Nova-T card.

8) MythTV is configured to open all the tuner devices when mythbackend
starts and keep them open until mythbackend terminates (i.e. 
dvb_on_demand=0), rather than repeated opening and closing of the tuner
devices which has also been reported as problematic for some.

9) MythTV signal_timeout=500, channel_timeout=3000, dvb_tuning_delay=0
(defaults), but I've tried increasing those to 3000, 4000 and 400
respectively, as per <http://www.knoppmythwiki.org/index.php?page=NovaT500>
with no apparent improvement.

10) MythTV multirec enabled, configured with 2 virtual tuners per physical
tuner.

11) I briefly experimented with setting buggy_sfn_workaround=1 when loading
the dib3000mc and dib7000p modules with no apparent improvement.  As far as
I can see, though, UK DVB-T broadcasting isn't a single frequency network,
so a) this is not relevant here and b) it will impair performace.  As a
result, I'm NOT using the buggy_sfn_workaround.

I've got debug=1 set for the mt2060, dib3000mc and dib7000p modules,
debug=127 for dvb_usb and debug=7 for dvb-usb-dib0700, but I'm not seeing
anything obviously bad in my kernel syslog. I've got mythbackend running
with "-v important,record" but all that seems to report is no progress on
failed recordings after "TVRec(_): Successfully set up DVB table
monitoring." (where _ is the cardid of the failed tuner).

Can anyone offer any tips for regaining reliability? Failing that, is there
any further logging I can enable, and entries to look out for?

Best Regards,
Alex
