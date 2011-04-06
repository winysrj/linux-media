Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:65180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1DFM2D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2011 08:28:03 -0400
Message-ID: <4D9C5C4D.4040709@redhat.com>
Date: Wed, 06 Apr 2011 09:27:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: wk <handygewinnspiel@gmx.de>
Subject: dvb-apps: charset support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I added some patches to dvb-apps/util/scan.c in order to properly support EN 300 468 charsets.
Before the patch, scan were producing invalid UTF-8 codes here, for ISO-8859-15 charsets, as
scan were simply filling service/provider name with whatever non-control characters that were
there. So, if your computer uses the same character as your service provider, you're lucky.
Otherwise, invalid characters will appear at the scan tables.

After the changes, scan gets the locale environment charset, and use it as the output charset
on the output files. 

The TS info may provide the used charset on the first character of the provider name and service name,
if the first character is < 0x20. If not provided, the spec says that the character table 00 should be
assumed (a modified version of ISO 6937 charset). However, on my tests, local carriers here
don't fill it, but they use ISO-8859-15 charset, instead of ISO-6937. So, a new optional parameter 
allows to change the default charset.

Also, the spec provides 2 tables with control character codes, one for 1-byte character tables,
and another for 2-byte character tables. Before the patch, the 1-byte control character table
were applied for all character sets. Now, the table is applied only for ISO-8859* and ISO-6937,
as they don't seem to make sense for the other character sets. However, the 2-byte control
character table were not implemented yet, due to a few reasons:
	1) I'm not familiar with 2-byte charsets;
	2) I don't have any environment here that would allow me to test it;
	3) The spec is not very clear about what character tables use 2-byte control codes.

The EN 300 428 Annex A says, just before the 2-byte control code table:
	"For two-byte character tables, the codes in the range 0xE080 to 0xE09F 
	 are assigned to control functions as shown in table A.2."

So, it seems that the 2-byte control character table refers to character tables 0x11 to 0x14 
(iso-10646 + Korean Character Set + GB2312 + BIG5).

However, the table A.2 is described as just:
	"Table A.2: DVB codes within private use area of ISO/IEC 10646"

So, one may assume that it refers only to ISO-10646 (character table 0x11), or to this one
plus BIG5 (table 0x14), as BIG5 is a subset of ISO-10646.

The spec is even less clear about what should be done with character table 0x15 (ISO-10646/UTF-8),
as UTF-8 codes have a variable length from 1-byte to 4-bytes.

I _suspect_ that all character tables that are not ISO-8859 or ISO-6937 should be using table
A.2 (that means, character tables 0x11 to 0x15).

The code change to implement 2-byte control codes should be trivial trough. A placeholder for such
code is there at the scancode with a short comment.

It would be great to have some feedback about it. So, comments are welcome.

Thanks,
Mauro.
