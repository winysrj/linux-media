Return-path: <linux-media-owner@vger.kernel.org>
Received: from asmtp.unoeuro.com ([195.41.131.37]:35891 "EHLO
	asmtp.unoeuro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab2AaW0v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 17:26:51 -0500
Received: from mail-bk0-f46.google.com (mail-bk0-f46.google.com [209.85.214.46])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by asmtp.unoeuro.com (Postfix) with ESMTP id B56F7623BAC
	for <linux-media@vger.kernel.org>; Tue, 31 Jan 2012 23:26:50 +0100 (CET)
Received: by bkcjm19 with SMTP id jm19so445908bkc.19
        for <linux-media@vger.kernel.org>; Tue, 31 Jan 2012 14:26:50 -0800 (PST)
MIME-Version: 1.0
From: Kenni Lund <kenni@kelu.dk>
Date: Tue, 31 Jan 2012 23:26:30 +0100
Message-ID: <CAAd_vpSGPJiFxGBdj9cy0QTK=aVM=XTO68etWXhRKOefUdWEPQ@mail.gmail.com>
Subject: TechnoTrend CT-3650 Viaccess CAM never initializes correctly
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi list

I'm unable to get the CI working on a TT CT-3650 with a Viaccess CAM.
Every time the CAM is inserted, I get a "dvb_ca adapter 0: Invalid PC
card inserted :(" error message.

I've tested with both an Arch Linux 3.2.1 kernel (CI-support included)
and with a Ubuntu 2.6.32 kernel with latest media_build git compiled
against it - both results in the same error.

To rule out any hardware issues, I've tested the tuner with the
Viaccess CAM under Windows, and it works without any issues here.

>From my very limited understanding of the code, it appears that the
CAM never returns any initialization string to the driver - or times
out too early - and therefore never is initialized ("TUPLE type:0x0
length:0").

Log:
------
[  756.167732] usb 2-1.1: new high speed USB device using ehci_hcd and address 5
[  756.748184] usb 2-1.1: configuration #1 chosen from 1 choice
[  756.765394] WARNING: You are using an experimental version of the
media stack.
[  756.765397]     As the driver is backported to an older kernel, it
doesn't offer
[  756.765399]     enough quality for its usage in production.
[  756.765401]     Use it with care.
[  756.765402] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[  756.765404]     59b30294e14fa6a370fdd2bc2921cca1f977ef16 Merge
branch 'v4l_for_linus' into staging/for_v3.4
[  756.765406]     72565224609a23a60d10fcdf42f87a2fa8f7b16d [media]
cxd2820r: sleep on DVB-T/T2 delivery system switch
[  756.765408]     46de20a78ae4b122b79fc02633e9a6c3d539ecad [media]
anysee: fix CI init
[  756.772765] check for cold 2304 20f
[  756.772766] check for cold 2304 222
[  756.772768] check for cold b48 3006
[  756.772769] check for warm b48 300d
[  756.772770] dvb-usb: found a 'Technotrend TT-connect CT-3650' in warm state.
[  756.772776] power control: 1
[  756.773291] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[  756.773295] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[  756.773626] DVB: registering new adapter (Technotrend TT-connect CT-3650)
[  756.790636] ttusb2: tt3650_ci_init
[  756.790641] dvb_ca_en50221_init
[  756.790766] ttusb2: CI initialized.
[  756.790770] dvb_ca_en50221_thread
[  756.790774] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
[  756.815920] DVB: registering adapter 0 frontend 1 (NXP TDA10048HN DVB-T)...
[  756.816407] Registered IR keymap rc-tt-1500
[  756.816520] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/rc/rc3/input13
[  756.816596] rc3: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/rc/rc3
[  756.816604] dvb-usb: schedule remote query interval to 150 msecs.
[  756.816610] power control: 0
[  756.817273] dvb-usb: Technotrend TT-connect CT-3650 successfully
initialized and connected.
[  756.817326] usbcore: registered new interface driver dvb_usb_ttusb2
[  761.777164] ttusb2: tt3650_ci_slot_reset 0
[  764.006950] ttusb2: tt3650_ci_read_attribute_mem 0000 -> 0 0x00
[  764.007322] ttusb2: tt3650_ci_read_attribute_mem 0002 -> 0 0x00
[  764.007327] TUPLE type:0x0 length:0
[  764.007508] dvb_ca adapter 0: Invalid PC card inserted :(


Does anyone have any ideas of what the issue could be or things that I
could test? Thank you in advance...

Best regards
Kenni
