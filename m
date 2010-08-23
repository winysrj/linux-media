Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <tampoco@126.com>) id 1OnMgm-0002GR-Qm
	for linux-dvb@linuxtv.org; Mon, 23 Aug 2010 04:23:09 +0200
Received: from m15-29.126.com ([220.181.15.29])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OnMgk-0006A3-2a; Mon, 23 Aug 2010 04:23:08 +0200
Date: Mon, 23 Aug 2010 10:22:58 +0800 (CST)
From: yb <tampoco@126.com>
To: linux-dvb@linuxtv.org
Message-ID: <4ab97ca2.3883.12a9cc173e7.Coremail.tampoco@126.com>
MIME-Version: 1.0
Subject: [linux-dvb] Driver use reference count becomes -2
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1523814828=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============1523814828==
Content-Type: multipart/alternative;
	boundary="----=_Part_37504_1368525335.1282530178022"

------=_Part_37504_1368525335.1282530178022
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: base64

SGkgYWxsLApJIGZvdW5kIHRoYXQgd2hlbiBJIGxvYWQgdGhlIGRyaXZlciBmb3IgdnA3MDQ1IGFu
ZCB1bnBsdWcgZGV2aWNlIGZyb20gVVNCIHBvcnQsIHRoZSBkcml2ZXIncyB1c2UgcmVmZXJlbmNl
IGNvdW50IHJlYWNoZXMgYSBiaWcgd2VpcmQgbnVtYmVyIChFeDogNDI5NDk2NzI5NCwgaW4gaGV4
IGl0IGlzIEZGRkZGRkZFLCBtZWFucy0yIEkgZ3Vlc3MpLiBUaGlzIGNhbiBiZSBzZWVuIGJ5IGNv
bW1hbmQgImxzbW9kfGdyZXAgdnA3MDQ1Ii4KClRoZSBMaW51eCBrZXJuZWwgdmVyc2lvbiBpcyAy
LjYuMjguIFRoZSBzb3VyY2UgY29kZSBpcyBmZXRjaGVkIGZyb20gaGcgc2VydmVyIG9mIExpbnV4
VFYgbGF0ZWx5LgoKRG9lcyBhbnlvbmUga25vdyB0aGlzIGJ1Zz8gSSBndWVzcyBzb21ld2hlcmUg
bWlzaGFuZGxlZCB0aGUgdXNlIGNvdW50IGJ5IGFjY2lkZW50YWxseSBkZWNyZW1lbnRlZC4KClRo
YW5rIHlvdSEKQm9iCg==
------=_Part_37504_1368525335.1282530178022
Content-Type: text/html; charset=gbk
Content-Transfer-Encoding: base64

SGkgYWxsLDxicj5JIGZvdW5kIHRoYXQgd2hlbiBJIGxvYWQgdGhlIGRyaXZlciBmb3IgdnA3MDQ1
IGFuZCB1bnBsdWcgZGV2aWNlIGZyb20gVVNCIHBvcnQsIHRoZSBkcml2ZXIncyB1c2UgcmVmZXJl
bmNlIGNvdW50IHJlYWNoZXMgYSBiaWcgd2VpcmQgbnVtYmVyIChFeDogNDI5NDk2NzI5NCwgaW4g
aGV4IGl0IGlzIEZGRkZGRkZFLCBtZWFucy0yIEkgZ3Vlc3MpLiBUaGlzIGNhbiBiZSBzZWVuIGJ5
IGNvbW1hbmQgImxzbW9kfGdyZXAgdnA3MDQ1Ii48YnI+PGJyPlRoZSBMaW51eCBrZXJuZWwgdmVy
c2lvbiBpcyAyLjYuMjguIFRoZSBzb3VyY2UgY29kZSBpcyBmZXRjaGVkIGZyb20gaGcgc2VydmVy
IG9mIExpbnV4VFYgbGF0ZWx5Ljxicj48YnI+RG9lcyBhbnlvbmUga25vdyB0aGlzIGJ1Zz8gSSBn
dWVzcyBzb21ld2hlcmUgbWlzaGFuZGxlZCB0aGUgdXNlIGNvdW50IGJ5IGFjY2lkZW50YWxseSBk
ZWNyZW1lbnRlZC48YnI+PGJyPlRoYW5rIHlvdSE8YnI+Qm9iPGJyPjxicj48YnI+PHNwYW4gdGl0
bGU9Im5ldGVhc2Vmb290ZXIiLz48aHIvPgo8YSBocmVmPSJodHRwOi8vcWl5ZS4xNjMuY29tLz8x
NjMiIHRhcmdldD0iX2JsYW5rIj7E+s/r07XT0LrNzfjS18Pit9HTys/k0rvR+ce/tPO1xMjtvP7C
8KO/PC9hPgo8L3NwYW4+
------=_Part_37504_1368525335.1282530178022--



--===============1523814828==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1523814828==--
