Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:38179 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab0BFROY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 12:14:24 -0500
Received: by fxm20 with SMTP id 20so252603fxm.1
        for <linux-media@vger.kernel.org>; Sat, 06 Feb 2010 09:14:22 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 6 Feb 2010 18:14:22 +0100
Message-ID: <7e5e0d9a1002060914l11e6d0baje575675dd8b21404@mail.gmail.com>
Subject: Re: [Bugme-new] [Bug 15087] New: hauppauge nova-t 500 remote
	controller cause usb halt with Via usb controller
From: edm <fuffi.il.fuffo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).

> On Mon, 18 Jan 2010 21:06:57 GMT
> bugzilla-daemon@xxxxxxxxxxxxxxxxxxx wrote:

> > http://bugzilla.kernel.org/show_bug.cgi?id=15087
> >
> >            Summary: hauppauge nova-t 500 remote controller cause usb halt
> >                     with Via usb controller
> >            Product: Drivers
> >            Version: 2.5
> >     Kernel Version: 2.6.32
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: blocking
> >           Priority: P1
> >          Component: USB
> >         AssignedTo: greg@xxxxxxxxx
> >         ReportedBy: fuffi.il.fuffo@xxxxxxxxx
> >         Regression: Yes
> >
> >
> > This is a know problem with this dvb-t card.
> > If the ir receiver is disabled via modprobe option (adding this parameter in
> > modprobe.conf: "#options dvb_usb disable_rc_polling=1") I cannot use it but the
> > card works perfectly, but if I try to activate it (removing that option) and i
> > launch the lircd daemon, I obtain a "usb halt" as described below in this old
> > message in the linux-media ml.
> >
> > klogd: ehci_hcd 0000:04:00.2: force halt; handhake f8018014 00004000
> > 00000000 -> -110
> >
> > Here, the writer find the commit that cause this regression:
> > http://osdir.com/ml/linux-media/2009-08/msg00185.html
> > Here is explained when it was introduced:
> > http://osdir.com/ml/linux-media/2009-08/msg00182.html
> >
> > It seems that this problem is present only with a via usb controller,
> > unfortunately i have this one:
> >
> >  lspci | grep -i via
> > 01:08.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> > Controller (rev 62)
> > 01:08.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> > Controller (rev 62)
> > 01:08.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65)
> >
> > Tell me if you need additional info.
> > I'm using a 2.6.32 kernel on arch linux.
> > Other relevant modprobe options:
> > options dib3000mc buggy_sfn_workaround=1
> > options dib7000p buggy_sfn_workaround=1
> > alias net-pf-10 off
> >
>
> This is a regression.  You have to chase links a bit, but it was
> bisected down to a particular commit in
> http://linuxtv.org/hg/v4l-dvb/rev/561b447ade77.

Hi, using the last version of v4l-dvb driver from hg, solved this
issue. I tested the card in the last days and it seems to work well
now; the IR receiver works, I tested it using irw, all the keys are
recognised.
I can't test the IR receiver with a specific program because the
.lircrc is ignored but I think it's a gnome-related problem :)
Is the option "dvb_usb_dib0700 force_lna_activation=1" still
necessary? Why this option is not activated at default?

Thank you.
