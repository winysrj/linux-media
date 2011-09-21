Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <gnu.andrew.rocks@gmail.com>) id 1R6QXu-0006w8-8H
	for linux-dvb@linuxtv.org; Wed, 21 Sep 2011 19:25:18 +0200
Received: from mail-qw0-f42.google.com ([209.85.216.42])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1R6QXt-0002LT-J9; Wed, 21 Sep 2011 19:25:18 +0200
Received: by qwm42 with SMTP id 42so3055750qwm.1
	for <linux-dvb@linuxtv.org>; Wed, 21 Sep 2011 10:25:16 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 21 Sep 2011 18:25:14 +0100
Message-ID: <CAFXTvn7otkiKw90aA8Yh4o7z87uarbtj3C8OdNYyKbywdMHdiQ@mail.gmail.com>
From: Andii Hughes <gnu_andrew@member.fsf.org>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary=001485f87b2cf0247004ad76db55
Subject: [linux-dvb] uk-EmleyMoor update
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

--001485f87b2cf0247004ad76db55
Content-Type: text/plain; charset=UTF-8

The Emley Moor transmitter in the UK completed digital switchover
today, making the existing transmitter file:

http://linuxtv.org/hg/dvb-apps/file/tip/util/scan/dvb-t/uk-EmleyMoor

obsolete.  Attached is a patch which I've just successfully used with
dvbscan to obtain a new channels.conf.

Thanks,
-- 
Andii :-)

--001485f87b2cf0247004ad76db55
Content-Type: text/x-patch; charset=US-ASCII; name="emley.patch"
Content-Disposition: attachment; filename="emley.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsul1hc30

LS0tIC91c3Ivc2hhcmUvZHZiL2R2Yi10L3VrLUVtbGV5TW9vcgkyMDEwLTA4LTAyIDE5OjE3OjA0
LjMwMjQxNjQwMiArMDEwMAorKysgL2hvbWUvYW5kcmV3Ly50emFwL3VrLUVtbGV5TW9vcgkyMDEx
LTA5LTIxIDE4OjExOjAyLjkzNjEwNjA5MCArMDEwMApAQCAtMSwxMCArMSw3IEBACiAjIFVLLCBF
bWxleSBNb29yCi0jIEF1dG8tZ2VuZXJhdGVkIGZyb20gaHR0cDovL3d3dy5kdGcub3JnLnVrL3Jl
dGFpbGVyL2R0dF9jaGFubmVscy5odG1sCi0jIGFuZCBodHRwOi8vd3d3Lm9mY29tLm9yZy51ay9z
dGF0aWMvcmVjZXB0aW9uX2FkdmljZS9pbmRleC5hc3AuaHRtbAogIyBUIGZyZXEgYncgZmVjX2hp
IGZlY19sbyBtb2QgdHJhbnNtaXNzaW9uLW1vZGUgZ3VhcmQtaW50ZXJ2YWwgaGllcmFyY2h5Ci1U
IDcyMjE2NzAwMCA4TUh6IDMvNCBOT05FIFFBTTE2IDJrIDEvMzIgTk9ORQotVCA2MjU4MzMwMDAg
OE1IeiAyLzMgTk9ORSBRQU02NCAyayAxLzMyIE5PTkUKLVQgNjQ5ODMzMDAwIDhNSHogMi8zIE5P
TkUgUUFNNjQgMmsgMS8zMiBOT05FCi1UIDY3MzgzMzAwMCA4TUh6IDMvNCBOT05FIFFBTTE2IDJr
IDEvMzIgTk9ORQotVCA3MDU4MzMwMDAgOE1IeiAzLzQgTk9ORSBRQU0xNiAyayAxLzMyIE5PTkUK
LVQgNjk3ODMzMDAwIDhNSHogMy80IE5PTkUgUUFNMTYgMmsgMS8zMiBOT05FCitUIDY4MjAwMDAw
MCA4TUh6IDIvMyAxLzIgUUFNNjQgOGsgMS8zMiBOT05FICMgUFNCMS9CQkNBCitUIDY1ODAwMDAw
MCA4TUh6IDIvMyAxLzIgUUFNNjQgOGsgMS8zMiBOT05FICMgUFNCMi9EMyY0CitUIDcxNDAwMDAw
MCA4TUh6IDIvMyAxLzIgUUFNNjQgOGsgMS8zMiBOT05FICMgQ09NNC9TRE4KK1QgNzIyMDAwMDAw
IDhNSHogMi8zIDEvMiBRQU02NCA4ayAxLzMyIE5PTkUgIyBDT001L0FSUUEKK1QgNjkwMDAwMDAw
IDhNSHogMi8zIDEvMiBRQU02NCA4ayAxLzMyIE5PTkUgIyBDT002L0FSUUIK
--001485f87b2cf0247004ad76db55
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--001485f87b2cf0247004ad76db55--
