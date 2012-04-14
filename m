Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36154 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab2DNUU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Apr 2012 16:20:28 -0400
Received: by dake40 with SMTP id e40so5247262dak.11
        for <linux-media@vger.kernel.org>; Sat, 14 Apr 2012 13:20:28 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 14 Apr 2012 16:20:28 -0400
Message-ID: <CAJ=kj5xyGhjEUo=nBh8WNB+oRosoAqiyJXPF_oCj4JRXEgtKUA@mail.gmail.com>
Subject: soundgraph imon pad remote controller generate 'unknown keypress'
 when used in Keyboard mode
From: Patrik Dufresne <ikus060@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using my "15c2:ffdc SoundGraph Inc. iMON PAD Remote Controller" with
Linux 3.0.0-17-generic in keyboard mode is generating 'unknown
keypress' in syslog when I use the pad. Looking at the source code,
imon.c line 1398 is setting the key code to KEY_UNKNOWN whenever a
direction is not found. Instead, I suggest to leave the function and
also leave imon_incoming_packet.

e.g.:
Apr 13 11:55:17 ikus060-htpc kernel: [413442.452803] imon 3-6:1.0:
imon_incoming_packet: unknown keypress, code 0x6882c1b7

Here is the full list of keypress :
0x688291b7
0x6882a1b7
0x6882b1b7
0x6882c1b7
0x6892c9b7
0x689a81b7
0x689a91b7
0x689aa1b7
0x68a281b7
0x68a299b7
0x68a2b1b7
0x68a2c9b7
0x68aa91b7
0x68c291b7
0x68c299b7
0x68c2a9b7
0x68c2a9b7
0x68c2b1b7
0x68c2b1b7
0x68c2b9b7
0x68c2c9b7
0x68c2f1b7
0x68d2b9b7
0x68e281b7
0x68e291b7
0x68e2a9b7
0x68e2b9b7
0x68e2c1b7
0x68e2c9b7
0x68faa1b7
0x6902c9b7
0x6902f9b7
0x691291b7
0x692299b7
0x6922a9b7
0x6922c9b7
0x6922e9b7
0x6922f1b7
0x6942b1b7
0x6942b9b7
0x696291b7
0x6962a9b7
0x6962b1b7
0x6962b9b7
0x6962c9b7
0x6962d9b7
0x6962f9b7
0x697af9b7
0x69c299b7
0x6a9a81b7
0x6a9a81b7
0x6aaa81b7
0x6aaaa1b7
0x6aaac1b7
0x6abac1b7
0x6acae1b7
0x6afa81b7
0x6afa81bf
0x6b1ab9b7
0x6b1af9b7
0x78aac1f7
0x78c299b7

Patrik Dufresne
