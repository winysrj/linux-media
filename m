Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f196.google.com ([209.85.217.196]:57546 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3LYA0c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 19:26:32 -0500
Received: by mail-lb0-f196.google.com with SMTP id l4so956205lbv.3
        for <linux-media@vger.kernel.org>; Tue, 24 Dec 2013 16:26:30 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 25 Dec 2013 02:26:30 +0200
Message-ID: <CADBDwkdUWD8ixPMxVHb4Oho6BcfnhX72JOUk_N1io2uMTgcYBA@mail.gmail.com>
Subject: DS3000/TS2020 diseqc problem
From: Olcay Korkmaz <olcay.mz@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a geniatech hdstar device with ubuntu gnome 13.10x64 kernel 3.11
My setup is two sats on disecq switch
turksat s42e : lnb1
hellassat s39e : lnb2

I can't scan channels with scan-s2,dvbscan,w_scan,dvbv5-scan
sometimes device can lock on transporder but can't get channel information

only kaffeine can scan both satellites and can tune channels

if I try to scan with scaning tools after that device will be
unavailable for tuning
need to re-connect

I tried three different firmware and tried lastest linux-media source
but no lock

here is some debug log

working log

[  741.740143] ds3000_readreg: read reg 0xd1, value 0x0f
[  741.740361] ds3000_read_status: status = 0x0f
[  714.654175] ds3000_writereg: write reg 0xc4, value 0x05
[  714.654606] ds3000_writereg: write reg 0xc7, value 0x24

not working log

[ 1460.754905] ds3000_readreg: read reg 0xd1, value 0x00
[ 1460.755156] ds3000_read_status: status = 0x00
[ 1460.905801] ds3000_readreg: read reg 0xd1, value 0x00
[ 1460.906047] ds3000_read_status: status = 0x00
[ 1460.954073] ds3000_readreg: read reg 0xd1, value 0x00
[ 1460.954287] ds3000_read_status: status = 0x00

[ 1484.681581] ds3000_writereg: write reg 0x03, value 0x12
[ 1484.682452] ds3000_writereg: write reg 0x03, value 0x02
[ 1484.682658] ds3000_writereg: write reg 0x03, value 0x12
[ 1484.683563] ds3000_writereg: write reg 0x03, value 0x02


[ 1802.083839] ds3000_readreg: read reg 0xa2, value 0x86
[ 1802.083839] ds3000_writereg: write reg 0xa2, value 0x84
[ 1802.099360] ds3000_send_diseqc_msg(0xe0, 0x10, 0x38,
0xf2ds3000_readreg: read reg 0xa2, value 0x84
[ 1802.099937] ds3000_writereg: write reg 0xa2, value 0x04
[ 1802.100375] ds3000_writereg: write reg 0xa3, value 0xe0


thanks
-- 
Olcay K.
