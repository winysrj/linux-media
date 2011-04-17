Return-path: <mchehab@pedra>
Received: from mail-px0-f179.google.com ([209.85.212.179]:62874 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab1DQMCj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Apr 2011 08:02:39 -0400
Received: by pxi2 with SMTP id 2so2633829pxi.10
        for <linux-media@vger.kernel.org>; Sun, 17 Apr 2011 05:02:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTiksB-XiGyDwkH+ikFto18w+T2J-3g@mail.gmail.com>
References: <BANLkTimaDxKQno=pjW0rpxYKG82M4jU1xg@mail.gmail.com>
	<BANLkTiksB-XiGyDwkH+ikFto18w+T2J-3g@mail.gmail.com>
Date: Sun, 17 Apr 2011 09:02:38 -0300
Message-ID: <BANLkTimm3E9cLRAiSK5b08p58easCmxffQ@mail.gmail.com>
Subject: Possibly Bug
From: Eder Santiago carneiro <eder.carneiro@ig.com.br>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd3284221872c04a11c0de4
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--000e0cd3284221872c04a11c0de4
Content-Type: text/plain; charset=ISO-8859-1

Well, at first I'm sorry to not know how to use yours dvb list. But
since I'm not planning to be a active developer, just let me send some
problem I got with 'scan' utility.
First of all, I Live in South America, got a Skystar HD2 wich runs
perfectly on my other OS..
I'm planning to get it working on opensuse 11.4 x86_64, kernel version
2.6.38.2, using mantis driver. I used, as input for scan, the file I'm
sending attached to this mail. It's from Star One C2 satellite
(formerly Brasilsat B4) which operates on C band. Unfortunately, when
I run scan, got error messages like this for every transponder:

__tune_to_transponder:1912: ERROR: Setting frontend parameters failed:
22 Invalid argument
ERROR: initial tuning failed

tail -f /var/log/messages said:

Apr 17 08:51:13 linux-7gu4 kernel: [ 2446.768781] DVB: adapter 0
frontend 0 frequency 5137920 out of range (950000..2150000)
Apr 17 08:51:13 linux-7gu4 kernel: [ 2446.768797] DVB: adapter 0
frontend 0 frequency 5137920 out of range (950000..2150000)
Apr 17 08:51:13 linux-7gu4 kernel: [ 2446.768813] DVB: adapter 0
frontend 0 frequency 5137880 out of range (950000..2150000)
Apr 17 08:51:13 linux-7gu4 kernel: [ 2446.768829] DVB: adapter 0
frontend 0 frequency 5137880 out of range (950000..2150000)
Apr 17 08:51:13 linux-7gu4 kernel: [ 2446.768846] DVB: adapter 0
frontend 0 frequency 5137835 out of range (950000..2150000)
Apr 17 08:51:13 linux-7gu4 kernel: [ 2446.768862] DVB: adapter 0
frontend 0 frequency 5137835 out of range (950000..2150000)


Which makes me guess that there are some problem which values or
conversion here. So please let me know whether It's a known bug, and
how to fix it.

--000e0cd3284221872c04a11c0de4
Content-Type: text/plain; charset=US-ASCII; name="2900.1.txt"
Content-Disposition: attachment; filename="2900.1.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmlwv84x0

UyAzNjI4IEggMzAwMDAwMCAzLzQgQVVUTyBRUFNLClMgMzYzMiBIIDQ2ODgwMDAgMy80IEFVVE8g
UVBTSwpTIDM2MzcgSCAyNjAwMDAwIDMvNCBBVVRPICA4UFNLClMgMzY0MiBIIDY1MTYwMDAgMy80
IEFVVE8gUVBTSwpTIDM2NDQgViAzMjE0MDAwIDMvNCBBVVRPIFFQU0sKUyAzNjQ4IFYgMjE3MDAw
MCAzLzQgQVVUTyBRUFNLClMgMzY1MCBIIDQyODUwMDAgMy80IEFVVE8gUVBTSwpTIDM2NTIgViAy
NzgwMDAwIDMvNCBBVVRPIFFQU0sKUyAzNjU2IEggMzM5MzAwMCAzLzQgQVVUTyBRUFNLClMgMzY1
NyBWIDM5MzEwMDAgMy80IEFVVE8gUVBTSwpTIDM2NjIgSCAzMzMzMDAwIDMvNCBBVVRPIFFQU0sK
UyAzNjYzIFYgNDI4NTAwMCA1LzYgQVVUTyBRUFNLClMgMzY2OCBIIDc1MDAwMDAgMi8zIEFVVE8g
OFBTSwpTIDM2NjggViAyMjIyMDAwIDMvNCBBVVRPIFFQU0sKUyAzNjcyIEggNDgwMDAwMCA1LzYg
QVVUTyBRUFNLClMgMzY3NCBWIDY2NjcwMDAgMy80IEFVVE8gUVBTSwpTIDM2ODAgSCA2MDAwMDAw
IDMvNCBBVVRPIFFQU0sKUyAzNjg1IFYgNTAwMDAwMCAzLzQgQVVUTyA4UFNLClMgMzY4OCBIIDc1
MDAwMDAgMi8zIEFVVE8gUVBTSwpTIDM2OTAgViAyMjIwMDAwIDMvNCBBVVRPIFFQU0sKUyAzNjk1
IEggMzU5ODAwMCAzLzQgQVVUTyBRUFNLClMgMzcwMCBWIDE1MDAwMDAwIDUvNiBBVVRPIDhQU0sK
UyAzNzA0IEggMzc1MDAwMCAzLzQgQVVUTyA4UFNLClMgMzcxNCBWIDQ0MDAwMDAgMy80IEFVVE8g
UVBTSwpTIDM3NTQgViA2MjIwMDAwIDMvNCBBVVRPIFFQU0sKUyAzODA4IFYgODE1MDAwMCAyLzMg
QVVUTyA4UFNLClMgMzgyMiBWIDEwMDAwMDAwIDUvNiBBVVRPIDhQU0sKUyAzODMwIFYgMjUwMDAw
MCAyLzMgQVVUTyA4UFNLClMgMzgzMyBWIDczNTAwMDAgNS82IEFVVE8gUVBTSwpTIDM4NzQgViA1
OTI2MDAwIDMvNCBBVVRPIFFQU0sKUyAzODg4IFYgODE1MDAwMCAyLzMgQVVUTyA4UFNLClMgMzg5
OCBWIDc1MDAwMDAgMi8zIEFVVE8gUVBTSwpTIDM5MDQgViAzMjE0MDAwIDMvNCBBVVRPIFFQU0sK
UyAzOTA5IFYgNDAwMDAwMCA1LzYgQVVUTyBRUFNLClMgMzkxNiBWIDUwMDAwMDAgMi8zIEFVVE8g
OFBTSwpTIDM5NDAgViAzMDAwMDAwMCAyLzMgQVVUTyA4UFNLClMgMzk0NSBIIDcyMDAwMDAgMi8z
IEFVVE8gUVBTSwpTIDM5NTUgSCA0NDAwMDAwIDMvNCBBVVRPIFFQU0sKUyAzOTY0IEggMTg3NTAw
MCAzLzQgQVVUTyBRUFNLClMgMzk2NSBWIDI5MzAwMDAgMi8zIEFVVE8gUVBTSwpTIDM5NjkgViAx
ODUzMDAwIDUvNiBBVVRPIFFQU0sKUyAzOTczIFYgMzcwMzAwMCAzLzQgQVVUTyBRUFNLClMgMzk3
OCBWIDM2MTcwMDAgNy84IEFVVE8gUVBTSwpTIDM5ODMgViAzOTI4MDAwIDMvNCBBVVRPIFFQU0sK
UyAzOTg1IEggMjE3MDAwMCAzLzQgQVVUTyBRUFNLClMgMzk5MCBWIDc0MDAwMDAgMy80IEFVVE8g
OFBTSwpTIDM5OTYgViAyMzAwMDAwIDMvNCBBVVRPIFFQU0sKUyA0MDAwIEggMjQwMDAwMCAyLzMg
QVVUTyBRUFNLClMgNDA0NyBWIDcxNDMwMDAgMy80IEFVVE8gUVBTSwpTIDQwNzAgSCAxMzAyMTAw
MCAzLzQgQVVUTyBRUFNLClMgMTA5NzQgSCAyOTkwMDAwMCAzLzQgQVVUTyBRUFNLClMgMTEwMTQg
SCAyOTkwMDAwMCAzLzQgQVVUTyBRUFNLClMgMTExMzAgViAyOTkwMDAwMCAzLzQgQVVUTyBRUFNL
ClMgMTExNzAgViAyOTkwMDAwMCAzLzQgQVVUTyBRUFNLClMgMTE3ODAgSCAyOTkwMDAwMCAzLzQg
QVVUTyBRUFNLClMgMTE4MjAgSCAyOTkwMDAwMCAzLzQgQVVUTyBRUFNLClMgMTE5NDAgSCAyOTkw
MDAwMCAzLzQgQVVUTyBRUFNLClMgMTE5NjAgViAyOTkwMDAwMCAzLzQgQVVUTyBRUFNLClMgMTIw
MjAgViA0MTUwMDAwMCA0LzUgQVVUTyBRUFNLClMgMTIwODAgViAyOTkwMDAwMCAzLzUgQVVUTyA4
UFNLClMgMTIxMjAgViAyOTkwMDAwMCAzLzQgQVVUTyBRUFNLClMgMTIxNjUgViAyOTkwMDAwMCAz
LzUgQVVUTyA4UFNLCg==
--000e0cd3284221872c04a11c0de4--
