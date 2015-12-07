Return-path: <linux-media-owner@vger.kernel.org>
Received: from 216.75.116.100.bus.sta.allophone.biz ([216.75.116.100]:33511
	"EHLO server1.n0sq.us" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932542AbbLGUMW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2015 15:12:22 -0500
Received: from localhost (localhost [127.0.0.1])
	by server1.n0sq.us (Postfix) with ESMTP id 009BF3164
	for <linux-media@vger.kernel.org>; Mon,  7 Dec 2015 13:05:49 -0700 (MST)
Received: from server1.n0sq.us ([127.0.0.1])
	by localhost (server1.n0sq.us [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gvJFIgndRpQY for <linux-media@vger.kernel.org>;
	Mon,  7 Dec 2015 13:05:48 -0700 (MST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by server1.n0sq.us (Postfix) with ESMTP id D5C6E1808
	for <linux-media@vger.kernel.org>; Mon,  7 Dec 2015 13:05:48 -0700 (MST)
To: linux-media@vger.kernel.org
From: Lee <temp5@n0sq.us>
Subject: dvbv5 questions
Message-ID: <5665E69C.70302@n0sq.us>
Date: Mon, 7 Dec 2015 13:05:48 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I suppose the following are bugs? Ubuntu 14.04.3 64 bit.

When I run dvbv5-scan, I get a lock but then it times out with a
Segmentation fault. So far I haven't found a solution for this.

user@server2:~$ dvbv5-scan AMC21-125W0.dvbv5scan -l UNIVERSAL -F -o CHANNEL
Using LNBf UNIVERSAL
    Europe
    10800 to 11800 MHz and 11600 to 12700 MHz
    Dual LO, IF = lowband 9750 MHz, highband 10600 MHz
ERROR    command MODULATION (4) not found during store
INFO     Scanning frequency #1 11106000
Lock   (0x1f) Signal= 70.50% C/N= 100.00% UCB= 65535 postBER= 67108864
Segmentation fault (core dumped)

Referring to the above output, I don't know what is causing the
Modulation error. Furthermore, I'm unable to use 8PSK for modulation
even though the docs on the spec says it's a valid modulation option.
The following test file was used for the above: (and I had to modify the
FREQUENCY because dvbv5-scan -l? doesn't give a  LNBF with a 10750 LO freq)

ki7rw@server2:~$ cat AMC21-125W0.dvbv5scan
[MONTANA_PBS]
    DELIVERY_SYSTEM = DVBS2
    FREQUENCY = 11106000
    POLARIZATION = VERTICAL
    SYMBOL_RATE = 2398000
    INNER_FEC = AUTO
    MODULATION = QPSK
    INVERSION = OFF
