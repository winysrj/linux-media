Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54827 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1AWNvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 08:51:55 -0500
Received: by eye27 with SMTP id 27so1538458eye.19
        for <linux-media@vger.kernel.org>; Sun, 23 Jan 2011 05:51:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101231119320.26778@sbhezbfg.of5.nffheflf.cev>
References: <alpine.LFD.2.00.1101231119320.26778@sbhezbfg.of5.nffheflf.cev>
Date: Sun, 23 Jan 2011 08:51:52 -0500
Message-ID: <AANLkTimtKKJkA35tn=wv+sONgWaUxjFcAQWfLfYzSOLW@mail.gmail.com>
Subject: Re: Hauppauge Nova-T-500; losing one tuner. Regression?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Alex Butcher <linuxtv@assursys.co.uk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Alex,

> As a refresher, the drivers in the 2.6.26.6-49 kernel didn't yet include
> support for the new I2C functions only supported by dib0700 firmware
> revisions >= 1.20.  I don't think this is relevant to the Nova-T-500,
> though, as only s5h1411_frontend_attach() and lgdt3305_frontend_attach() set
> fw_use_new_i2c_api to 1.

There were general fixes to the i2c in the 1.20 firmware which you get
the benefits of regardless of using the new API.  The new API is
required though for devices that perform i2c writes without a
corresponding read (e.g. the s5h1411 and lgdt3305).  In fact, most
Nova-T 500 users noted a significant improvement in the general
reliability of the mt2060 i2c after upgrading to 1.20 (with the
exception of the "warm boot problem").

> My old MythTV system worked perfectly for months at a time (i.e. between AC
> power failures!) and once I got a stable configuration for the Nova-T-500
> card, I never had failed recordings due to losing a tuner.  However, despite
> recreating the same config on the new hardware, I seem to be experiencing
> the old problems with one of the tuners on the Nova-T-500 ceasing to respond
> randomly many hours after boot, resulting in failed MythTV recordings.  Both
> the tuners work immediately after the system is booted, however.  When one
> Nova-T-500 tuner has stopped responding the other is able to record
> perfectly, suggesting that there isn't a signal strength or cabling problem.
>
> Tweaks I used on my old MythTV box, that I've carried forward to the
> upgraded system:
>
> 1) Boot kernel with usbcore.autosuspend=-1 to disable suspending of USB
> devices (i.e.  the two USB tuners behind the VIA USB/PCI bridge on the
> Nova-T-500 PCI card)

This shouldn't have any effect, but was a good idea to test.

> 2) Load the dvb_usb kernel module with disable_rc_polling=1 to disable the
> IR port on the Nova-T-500. I only use the IR port on the Nova-T, so I can
> live with this.

The RC polling issue was initially a problem after I introduced the
1.20 firmware support, but was fixed in a later version of the driver
(over a year ago).  Therefore, setting "disable_rc_polling" is no
longer required.

> 3) Load the dvb-usb-dib0700 module with force_lna_activation=1 to have the
> LNA permanently enabled.

People have mixed results with the LNA, largely dependent on their
signal quality in general, as would be expected.  I believe most
people who have had to force it's activation have general signal
quality issues which have nothing to do with the mt2060 i2c issue.

> 5) Use the 1.20 firmware (MD5: f42f86e2971fd994003186a055813237) file and
> ensure it's being properly loaded.

That is the correct firmware,  It's bundled by default in Ubuntu now,
and I thought Fedora was too (since I submitted it to the
linux-firmware package).

> I've also tried the 1.10 firmware (MD5:
> 5878ebfcba2d8deb90b9120eb89b02da) with no apparent improvement.

Well, *this* is very strange.  It suggests your problem has nothing to
do with the new firmware at all.  Have you tried blowing the dust out
the PCI slots and making sure the PCI connectors are clean?

> 6) Ensure that the machine is cold-booted (thereby forcing a firmware load
> onto the Nova-T-500) every time due to reports of warm boots being
> problematic.

Correct:  This is the one known issue with the 1.20 firmware,
specifically on the Nova-T 500.  It has to do with the power routing
on that board compared to all other dib0700 based designs.

> 7) Disable EIT scanning by MythTV on both of the two Nova-T-500 tuners. Only
> leave it enabled on the Nova-T card.

This is a good idea.  I've heard mixed results from users where this
has an effect, although I've never seen it personally.

> 8) MythTV is configured to open all the tuner devices when mythbackend
> starts and keep them open until mythbackend terminates (i.e.
> dvb_on_demand=0), rather than repeated opening and closing of the tuner
> devices which has also been reported as problematic for some.
>
> 9) MythTV signal_timeout=500, channel_timeout=3000, dvb_tuning_delay=0
> (defaults), but I've tried increasing those to 3000, 4000 and 400
> respectively, as per <http://www.knoppmythwiki.org/index.php?page=NovaT500>
> with no apparent improvement.
>
> 10) MythTV multirec enabled, configured with 2 virtual tuners per physical
> tuner.
>
> 11) I briefly experimented with setting buggy_sfn_workaround=1 when loading
> the dib3000mc and dib7000p modules with no apparent improvement.  As far as
> I can see, though, UK DVB-T broadcasting isn't a single frequency network,
> so a) this is not relevant here and b) it will impair performace.  As a
> result, I'm NOT using the buggy_sfn_workaround.
>
> I've got debug=1 set for the mt2060, dib3000mc and dib7000p modules,
> debug=127 for dvb_usb and debug=7 for dvb-usb-dib0700, but I'm not seeing
> anything obviously bad in my kernel syslog. I've got mythbackend running
> with "-v important,record" but all that seems to report is no progress on
> failed recordings after "TVRec(_): Successfully set up DVB table
> monitoring." (where _ is the cardid of the failed tuner).

All this other stuff is unlikely to have any bearing on the issue.

> Can anyone offer any tips for regaining reliability? Failing that, is there
> any further logging I can enable, and entries to look out for?

Exactly what errors are you seeing?  I2c write errors in dmesg?
Perhaps you should post some actual log output showing the failure
rather than the vague characterization of "one of the tuners on the
Nova-T-500 ceasing to respond randomly many hours after boot"

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
