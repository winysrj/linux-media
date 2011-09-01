Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <harald.overas@gmail.com>) id 1Qz4Ee-0006CJ-Bk
	for linux-dvb@linuxtv.org; Thu, 01 Sep 2011 12:11:24 +0200
Received: from mail-ww0-f48.google.com ([74.125.82.48])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1Qz4Ee-0002QP-9w; Thu, 01 Sep 2011 12:11:00 +0200
Received: by wwj26 with SMTP id 26so1152629wwj.5
	for <linux-dvb@linuxtv.org>; Thu, 01 Sep 2011 03:10:59 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 Sep 2011 12:10:58 +0200
Message-ID: <CAMDtrVK2mMc3tpyUkLg7ZfA-rnA91r=KUNNhEv-fkTgP1VWcPw@mail.gmail.com>
From: Harald Overas <harald.overas@gmail.com>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary=0016e6d77cfe15037104abde760d
Subject: [linux-dvb] Updated DVB-S file Thor-1.0W
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--0016e6d77cfe15037104abde760d
Content-Type: text/plain; charset=UTF-8

Hi

I have attached a patch for Thor-1.0W. Most of the mux updates are for
the new Thor 6 satellite.
http://www.telenorsbc.com/templates/Page.aspx?id=783

I have also taking the liberty to update one of the existing muxes.
http://www.telenorsbc.com/templates/Page.aspx?id=674

I have tested the patch with tvheadend and it works without any problems.

Best regards,
Harald

--0016e6d77cfe15037104abde760d
Content-Type: application/octet-stream; name="Thor-1.0W.patch"
Content-Disposition: attachment; filename="Thor-1.0W.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gs1kqjgj0

ZGlmZiAtcnVwTiBkdmItYXBwcy0zNmEwODRhYWNlNDctb3JnLy91dGlsL3NjYW4vZHZiLXMvVGhv
ci0xLjBXIGR2Yi1hcHBzLTM2YTA4NGFhY2U0Ny91dGlsL3NjYW4vZHZiLXMvVGhvci0xLjBXCi0t
LSBkdmItYXBwcy0zNmEwODRhYWNlNDctb3JnLy91dGlsL3NjYW4vZHZiLXMvVGhvci0xLjBXCTIw
MTEtMDktMDEgMTA6MjA6MTYuMDAwMDAwMDAwICswMjAwCisrKyBkdmItYXBwcy0zNmEwODRhYWNl
NDcvdXRpbC9zY2FuL2R2Yi1zL1Rob3ItMS4wVwkyMDExLTA5LTAxIDEwOjE1OjQ5LjAwMDAwMDAw
MCArMDIwMApAQCAtMSw1ICsxLDE4IEBACiAjIFRob3IgMS4wVwogIyBmcmVxIHBvbCBzciBmZWMK
K1MgMTA3NDcwMDAgSCAyNTAwMDAwMCAzLzQKK1MgMTA3NzgwMDAgViAyNTAwMDAwMCAzLzQKK1Mg
MTA3NzgwMDAgSCAyNDUwMDAwMCA3LzgKK1MgMTA4MDkwMDAgViAyNDUwMDAwMCA3LzgKK1MgMTA4
MDkwMDAgSCAyNDUwMDAwMCA3LzgKK1MgMTA4NDEwMDAgViAyNDUwMDAwMCA3LzgKK1MgMTA4NDEw
MDAgSCAyNDUwMDAwMCA3LzgKK1MgMTA4NzIwMDAgViAyNDUwMDAwMCA3LzgKK1MgMTA4NzIwMDAg
SCAyNDUwMDAwMCA3LzgKK1MgMTA5MDMwMDAgViAyNTAwMDAwMCAzLzQKK1MgMTA5MDMwMDAgSCAy
NTAwMDAwMCAzLzQKK1MgMTA5MzQwMDAgViAyNDUwMDAwMCA3LzgKK1MgMTA5MzQwMDAgSCAyNTAw
MDAwMCAzLzQJCiBTIDExMjE2MDAwIFYgMjQ1MDAwMDAgNy84CiBTIDExMjI5MDAwIEggMjQ1MDAw
MDAgNy84CiBTIDExMjQ3MDAwIFYgMjQ1MDAwMDAgNy84CkBAIC0xNywxMSArMzAsMjUgQEAgUyAx
MTM4OTAwMCBIIDI0NTAwMDAwIDcvOAogUyAxMTQwMzAwMCBWIDI0NTAwMDAwIDcvOAogUyAxMTQy
MTAwMCBIIDI0NTAwMDAwIDcvOAogUyAxMTQzNDAwMCBWIDI0NTAwMDAwIDcvOAorUyAxMTcyNzAw
MCBWIDI4MDAwMDAwIDcvOAogUyAxMTc0NzAwMCBIIDI4MDAwMDAwIDUvNgotUyAxMTc4NTAwMCBI
IDI4MDAwMDAwIDUvNgorUyAxMTc2NjAwMCBWIDI4MDAwMDAwIDcvOAorUyAxMTc4NTAwMCBIIDMw
MDAwMDAwIDMvNAorUyAxMTgwNDAwMCBWIDI4MDAwMDAwIDcvOAogUyAxMTgyMzAwMCBIIDI4MDAw
MDAwIDcvOAorUyAxMTg0MzAwMCBWIDMwMDAwMDAwIDMvNAorUyAxMTg2MjAwMCBIIDI4MDAwMDAw
IDcvOAorUyAxMTg4MTAwMCBWIDI4MDAwMDAwIDUvNgorUyAxMTkwMDAwMCBIIDI4MDAwMDAwIDUv
NgorUyAxMTkxOTAwMCBWIDI4MDAwMDAwIDcvOAogUyAxMTkzODAwMCBIIDI1MDAwMDAwIDMvNAor
UyAxMTk1ODAwMCBWIDI4MDAwMDAwIDcvOAorUyAxMTk3NzAwMCBIIDI4MDAwMDAwIDcvOAorUyAx
MTk5NjAwMCBWIDI4MDAwMDAwIDcvOAogUyAxMjAxNTAwMCBIIDMwMDAwMDAwIDMvNAorUyAxMjAz
NDAwMCBWIDI4MDAwMDAwIDcvOAorUyAxMjA3MzAwMCBWIDI4MDAwMDAwIDcvOAorUyAxMjA5MjAw
MCBIIDMwMDAwMDAwIDMvNAogUyAxMjEzMDAwMCBIIDMwMDAwMDAwIDMvNAogUyAxMjE0OTAwMCBW
IDI4MDAwMDAwIDUvNgogUyAxMjE2OTAwMCBIIDI4MDAwMDAwIDcvOApAQCAtMzAsNiArNTcsOCBA
QCBTIDEyMjI2MDAwIFYgMjgwMDAwMDAgMy80CiBTIDEyMjQ1MDAwIEggMjgwMDAwMDAgNS82CiBT
IDEyMzAzMDAwIFYgMjgwMDAwMDAgNS82CiBTIDEyMzIyMDAwIEggMjc4MDAwMDAgMy80CitTIDEy
MzQxMDAwIFYgMjgwMDAwMDAgNy84CitTIDEyMzgwMDAwIFYgMjgwMDAwMDAgNS82CiBTIDEyMzk5
MDAwIEggMjgwMDAwMDAgNy84CiBTIDEyNDE4MDAwIFYgMjgwMDAwMDAgNy84CiBTIDEyNDU2MDAw
IFYgMjgwMDAwMDAgMy80Cg==
--0016e6d77cfe15037104abde760d
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--0016e6d77cfe15037104abde760d--
