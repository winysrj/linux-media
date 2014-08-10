Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:57747 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaHJUpq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 16:45:46 -0400
Received: by mail-yk0-f178.google.com with SMTP id 142so5381745ykq.37
        for <linux-media@vger.kernel.org>; Sun, 10 Aug 2014 13:45:46 -0700 (PDT)
Received: from mythbox.lightfoot.us ([64.184.112.106])
        by mx.google.com with ESMTPSA id c61sm4105789yhk.25.2014.08.10.13.45.42
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 10 Aug 2014 13:45:45 -0700 (PDT)
Message-ID: <53E7D9F5.1030600@gmail.com>
Date: Sun, 10 Aug 2014 16:45:41 -0400
From: Bob Lightfoot <boblfoot@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: CX23885 error during boot
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dear Media Community:
    Since switching to CentOS7 and the 3.10.0-123 kernel as listed below:
> Linux mythbox.lightfoot.us 3.10.0-123.6.3.el7.x86_64 #1 SMP Wed Aug
> 6 21:12:36 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

	I keep getting the following in dmesg related to my Hauppage Video
Card at bootup.  The error seems to have no affect on operation, but I
am curious if there is something to be done to resolve it?

> [root@mythbox ~]# dmesg | grep -A 1 -B 1 23885 [    9.885221]
> cx18-0: cx23418 revision 01010000 (B) [    9.886966] cx23885 driver
> version 0.0.3 loaded [    9.887305] CORE cx23885[0]: subsystem:
> 0070:7801, board: Hauppauge WinTV-HVR1800 [card=2,autodetected] [
> 9.900353] iTCO_vendor_support: vendor-support=0 -- [   10.276671]
> tveeprom 3-0050: has radio [   10.276673] cx23885[0]: hauppauge
> eeprom: model=78521 [   10.283170] cx18-alsa: module loading... [
> 10.287519] cx25840 5-0044: cx23887 A/V decoder found @ 0x88
> (cx23885[0]) [   10.599619] ieee80211 phy0: rt2x00_set_chip: Info -
> Chipset detected - rt: 2573, rf: 0002, rev: 000a -- [   10.897596]
> cx18-0: FW version: 0.0.74.0 (Release 2007/03/12) [   11.610505]
> cx25840 5-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382
> bytes) [   11.633747] tuner 4-0042: Tuner -1 found with type(s)
> Radio TV. -- [   12.246302] cx18-0 843: verified load of
> v4l-cx23418-dig.fw firmware (16382 bytes) [   12.903492]
> cx23885[0]: registered device video1 [v4l2] [   12.903583]
> cx23885[0]: registered device vbi1 [   12.903780] cx23885[0]:
> registered ALSA audio device [   13.782171] cx23885[0]: registered
> device video2 [mpeg] [   13.782192] Firmware and/or mailbox pointer
> not initialized or corrupted, signature = 0xffffffff, cmd =
> PING_FW -- [   14.113710] ERROR: Firmware size mismatch (have
> 16382, expected 376836) [   14.113755] cx23885_initialize_codec()
> f/w load failed [   14.113793] cx23885_dvb_register() allocating 1
> frontend(s) [   14.113796] cx23885[0]: cx23885 based dvb card [
> 14.145153] MT2131: successfully identified at address 0x61 [
> 14.146825] DVB: registering new adapter (cx23885[0]) [   14.146833]
> cx23885 0000:02:00.0: DVB: registering adapter 1 frontend 0
> (Samsung S5H1409 QAM/8VSB Frontend)... [   14.147622]
> cx23885_dev_checkrevision() Hardware revision = 0xb1 [   14.147630]
> cx23885[0]/0: found at 0000:02:00.0, rev: 15, irq: 17, latency: 0,
> mmio: 0xf9e00000 [   14.963310] EXT4-fs (sda2): mounted filesystem
> with ordered data mode. Opts: (null) [root@mythbox ~]#

Sincerely,
Bob Lightfoot
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJT59n1AAoJEKqgpLIhfz3Xnw4H/RKVTFbjop2Qf00vdxDy1zQ1
AdJx2mxS+LC0AMHu6tXwLw5QuaqczHIx2arkB2ry1OskLwvKqZXUsDXkRQVgrPob
TG4dCkQtdK3u4aMPXJ10RGMfXA8HZ3z//dfV2Adp98EvUBcw9XrK8EEL729I7fFH
+kLQV5592XoBhIBPAJN7/SsuK+45glkt3yuQva/nkaNV0JP77IgtozeYVQyVd99Y
rZcK/WaQmy0+6ErrQc3zKLqKnfk/frnj5UmgZVKnMEstXYU1u2/1kZsQtXvxnBRT
R9kssWp2cxU7bR6oek3bCX34zP2x1K872TH8TmHdqDD54TVd65cPD9gPjMjITWE=
=PcpQ
-----END PGP SIGNATURE-----
