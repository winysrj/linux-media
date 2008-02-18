Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JRDC4-0000RW-CW
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 22:06:32 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1426841fge.25
	for <linux-dvb@linuxtv.org>; Mon, 18 Feb 2008 13:06:17 -0800 (PST)
Message-ID: <ea4209750802181306tcc8c98clff330d4289523d96@mail.gmail.com>
Date: Mon, 18 Feb 2008 22:06:17 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47B9D533.7050504@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----=_Part_378_2959486.1203368777714"
References: <ea4209750801161224p6b75d7fanbdcd29e7d367802d@mail.gmail.com>
	<47B9D533.7050504@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Yuan EC372S (STK7700D based device)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_378_2959486.1203368777714
Content-Type: multipart/alternative;
	boundary="----=_Part_379_33176584.1203368777714"

------=_Part_379_33176584.1203368777714
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hey people, we already solved this problems. I submitted a patch a few days
ago, but I think it's not on the current sources. I send again the patch.
Basically it must use the same frontend description as asus cards.

Albert

2008/2/18, Antti Palosaari <crope@iki.fi>:
>
> moikka
> I have also this device (express card). I haven't looked inside yet, but
> I think there is DibCOM STK7700D (in my understanding dual demod chip)
> and only *one* MT2266 tuner. I tried various GPIO settings but no luck
> yet.
> GPIO6 is for MT2266.
> GPIO9 and GPIO10 are for frontend.
>
> Looks like tuner goes to correct frequency because I got always
> PID-filter timeouts when tuning to correct freq. I will now try to take
> some usb-sniffs to see configuration used. Any help is welcome.
>
> regards
> Antti
>
> Albert Comerma wrote:
> > Hi!, with Michel (mm-sl@ibelgique.com <mailto:mm-sl@ibelgique.com>) who
>
> > is a owner of this Yuan card we added the device to dib0700_devices, and
> > we got it recognized without problems. The only problem is that no
> > channel is detected on scan on kaffeine or other software... I post some
> > dmesg. We don't know where it may be the problem... or how to detect
> it...
> >
> > usb 4-2: new high speed USB device using ehci_hcd and address 6
> > usb 4-2: new device found, idVendor=1164, idProduct=1edc
> > usb 4-2: new device strings: Mfr=1, Product=2, SerialNumber=3
> > usb 4-2: Product: STK7700D
> > usb 4-2: Manufacturer: YUANRD
> > usb 4-2: SerialNumber: 0000000001
> > usb 4-2: configuration #1 chosen from 1 choice
> > dvb-usb: found a 'Yuan EC372S' in cold state, will try to load a
> firmware
> > dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
> > dib0700: firmware started successfully.
> > dvb-usb: found a 'Yuan EC372S' in warm state.
> > dvb-usb: will pass the complete MPEG2 transport stream to the software
> > demuxer.
> > DVB: registering new adapter (Yuan EC372S)
> > dvb-usb: no frontend was attached by 'Yuan EC372S'
> > dvb-usb: will pass the complete MPEG2 transport stream to the software
> > demuxer.
> > DVB: registering new adapter (Yuan EC372S)
> > DVB: registering frontend 1 (DiBcom 7000PC)...
> > MT2266: successfully identified
> > input: IR-receiver inside an USB DVB receiver as /class/input/input10
> > dvb-usb: schedule remote query interval to 150 msecs.
> > dvb-usb: Yuan EC372S successfully initialized and connected.
> >
> >
>
> > ------------------------------------------------------------------------
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
>
> --
> http://palosaari.fi/
>

------=_Part_379_33176584.1203368777714
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hey people, we already solved this problems. I submitted a patch a few days ago, but I think it&#39;s not on the current sources. I send again the patch. Basically it must use the same frontend description as asus cards.<br>
<br>Albert<br><br><div><span class="gmail_quote">2008/2/18, Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
moikka<br> I have also this device (express card). I haven&#39;t looked inside yet, but<br> I think there is DibCOM STK7700D (in my understanding dual demod chip)<br> and only *one* MT2266 tuner. I tried various GPIO settings but no luck yet.<br>
 GPIO6 is for MT2266.<br> GPIO9 and GPIO10 are for frontend.<br> <br> Looks like tuner goes to correct frequency because I got always<br> PID-filter timeouts when tuning to correct freq. I will now try to take<br> some usb-sniffs to see configuration used. Any help is welcome.<br>
 <br> regards<br> Antti<br> <br> Albert Comerma wrote:<br> &gt; Hi!, with Michel (<a href="mailto:mm-sl@ibelgique.com">mm-sl@ibelgique.com</a> &lt;mailto:<a href="mailto:mm-sl@ibelgique.com">mm-sl@ibelgique.com</a>&gt;) who<br>
 <br>&gt; is a owner of this Yuan card we added the device to dib0700_devices, and<br> &gt; we got it recognized without problems. The only problem is that no<br> &gt; channel is detected on scan on kaffeine or other software... I post some<br>
 &gt; dmesg. We don&#39;t know where it may be the problem... or how to detect it...<br> &gt;<br> &gt; usb 4-2: new high speed USB device using ehci_hcd and address 6<br> &gt; usb 4-2: new device found, idVendor=1164, idProduct=1edc<br>
 &gt; usb 4-2: new device strings: Mfr=1, Product=2, SerialNumber=3<br> &gt; usb 4-2: Product: STK7700D<br> &gt; usb 4-2: Manufacturer: YUANRD<br> &gt; usb 4-2: SerialNumber: 0000000001<br> &gt; usb 4-2: configuration #1 chosen from 1 choice<br>
 &gt; dvb-usb: found a &#39;Yuan EC372S&#39; in cold state, will try to load a firmware<br> &gt; dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700-1.10.fw&#39;<br> &gt; dib0700: firmware started successfully.<br>
 &gt; dvb-usb: found a &#39;Yuan EC372S&#39; in warm state.<br> &gt; dvb-usb: will pass the complete MPEG2 transport stream to the software<br> &gt; demuxer.<br> &gt; DVB: registering new adapter (Yuan EC372S)<br> &gt; dvb-usb: no frontend was attached by &#39;Yuan EC372S&#39;<br>
 &gt; dvb-usb: will pass the complete MPEG2 transport stream to the software<br> &gt; demuxer.<br> &gt; DVB: registering new adapter (Yuan EC372S)<br> &gt; DVB: registering frontend 1 (DiBcom 7000PC)...<br> &gt; MT2266: successfully identified<br>
 &gt; input: IR-receiver inside an USB DVB receiver as /class/input/input10<br> &gt; dvb-usb: schedule remote query interval to 150 msecs.<br> &gt; dvb-usb: Yuan EC372S successfully initialized and connected.<br> &gt;<br>
 &gt;<br> <br>&gt; ------------------------------------------------------------------------<br> &gt;<br> &gt; _______________________________________________<br> &gt; linux-dvb mailing list<br> &gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
 &gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br> <br><br> <br> --<br> <a href="http://palosaari.fi/">http://palosaari.fi/</a><br> </blockquote>
</div><br>

------=_Part_379_33176584.1203368777714--

------=_Part_378_2959486.1203368777714
Content-Type: text/x-patch; name=YuanEC372.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fctin5x2
Content-Disposition: attachment; filename=YuanEC372.patch

ZGlmZiAtY3JCIHY0bC1kdmItN2Q4NTU4ZjNmYzY2LW9yaWcvbGludXgvZHJpdmVycy9tZWRpYS9k
dmIvZHZiLXVzYi9kaWIwNzAwX2RldmljZXMuYyB2NGwtZHZiLTdkODU1OGYzZmM2Ni9saW51eC9k
cml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCioqKiB2NGwtZHZiLTdk
ODU1OGYzZmM2Ni1vcmlnL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGliMDcwMF9k
ZXZpY2VzLmMJMjAwOC0wMS0yNyAxNjoyMzo1My4wMDAwMDAwMDAgKzAxMDAKLS0tIHY0bC1kdmIt
N2Q4NTU4ZjNmYzY2L2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGliMDcwMF9kZXZp
Y2VzLmMJMjAwOC0wMS0yNyAxNjozNDoyMC4wMDAwMDAwMDAgKzAxMDAKKioqKioqKioqKioqKioq
CioqKiA5MDUsOTEwICoqKioKLS0tIDkwNSw5MTEgLS0tLQogIAkJeyBVU0JfREVWSUNFKFVTQl9W
SURfQVNVUywgICAgICBVU0JfUElEX0FTVVNfVTMxMDApIH0sCiAgLyogMjUgKi8JeyBVU0JfREVW
SUNFKFVTQl9WSURfSEFVUFBBVUdFLCBVU0JfUElEX0hBVVBQQVVHRV9OT1ZBX1RfU1RJQ0tfMykg
fSwKICAJCXsgVVNCX0RFVklDRShVU0JfVklEX0hBVVBQQVVHRSwgVVNCX1BJRF9IQVVQUEFVR0Vf
TVlUVl9UKSB9LAorIAkJeyBVU0JfREVWSUNFKFVTQl9WSURfWVVBTiwgVVNCX1BJRF9ZVUFOX0VD
MzcyUykgfSwKICAJCXsgMCB9CQkvKiBUZXJtaW5hdGluZyBlbnRyeSAqLwogIH07CiAgTU9EVUxF
X0RFVklDRV9UQUJMRSh1c2IsIGRpYjA3MDBfdXNiX2lkX3RhYmxlKTsKKioqKioqKioqKioqKioq
CioqKiAxMDY5LDEwODAgKioqKgogIAkJCX0sCiAgCQl9LAogIAohIAkJLm51bV9kZXZpY2VfZGVz
Y3MgPSAxLAogIAkJLmRldmljZXMgPSB7CiAgCQkJeyAgICJBU1VTIE15IENpbmVtYSBVMzAwMCBN
aW5pIERWQlQgVHVuZXIiLAogIAkJCQl7ICZkaWIwNzAwX3VzYl9pZF90YWJsZVsyM10sIE5VTEwg
fSwKICAJCQkJeyBOVUxMIH0sCiAgCQkJfSwKICAJCX0KICAJfSwgeyBESUIwNzAwX0RFRkFVTFRf
REVWSUNFX1BST1BFUlRJRVMsCiAgCi0tLSAxMDcwLDEwODUgLS0tLQogIAkJCX0sCiAgCQl9LAog
IAohIAkJLm51bV9kZXZpY2VfZGVzY3MgPSAyLAogIAkJLmRldmljZXMgPSB7CiAgCQkJeyAgICJB
U1VTIE15IENpbmVtYSBVMzAwMCBNaW5pIERWQlQgVHVuZXIiLAogIAkJCQl7ICZkaWIwNzAwX3Vz
Yl9pZF90YWJsZVsyM10sIE5VTEwgfSwKICAJCQkJeyBOVUxMIH0sCiAgCQkJfSwKKyAJCQl7ICAg
Ill1YW4gRUMzNzJTIiwKKyAJCQkJeyAmZGliMDcwMF91c2JfaWRfdGFibGVbMjddLCBOVUxMIH0s
CisgCQkJCXsgTlVMTCB9LAorIAkJCX0KICAJCX0KICAJfSwgeyBESUIwNzAwX0RFRkFVTFRfREVW
SUNFX1BST1BFUlRJRVMsCiAgCmRpZmYgLWNyQiB2NGwtZHZiLTdkODU1OGYzZmM2Ni1vcmlnL2xp
bnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaCB2NGwtZHZiLTdkODU1
OGYzZmM2Ni9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2R2Yi11c2ItaWRzLmgKKioq
IHY0bC1kdmItN2Q4NTU4ZjNmYzY2LW9yaWcvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVz
Yi9kdmItdXNiLWlkcy5oCTIwMDgtMDEtMjcgMTY6MjM6NTMuMDAwMDAwMDAwICswMTAwCi0tLSB2
NGwtZHZiLTdkODU1OGYzZmM2Ni9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2R2Yi11
c2ItaWRzLmgJMjAwOC0wMS0yNyAxNjoyNzoyMC4wMDAwMDAwMDAgKzAxMDAKKioqKioqKioqKioq
KioqCioqKiA0Niw1MyAqKioqCiAgI2RlZmluZSBVU0JfVklEX1VMVElNQV9FTEVDVFJPTklDCQkw
eDA1ZDgKICAjZGVmaW5lIFVTQl9WSURfVU5JV0lMTAkJCQkweDE1ODQKICAjZGVmaW5lIFVTQl9W
SURfV0lERVZJRVcJCQkweDE0YWEKLSAvKiBkb20gOiBwb3VyIGdpZ2FieXRlIHU3MDAwICovCiAg
I2RlZmluZSBVU0JfVklEX0dJR0FCWVRFCQkJMHgxMDQ0CiAgCiAgCiAgLyogUHJvZHVjdCBJRHMg
Ki8KLS0tIDQ2LDUzIC0tLS0KICAjZGVmaW5lIFVTQl9WSURfVUxUSU1BX0VMRUNUUk9OSUMJCTB4
MDVkOAogICNkZWZpbmUgVVNCX1ZJRF9VTklXSUxMCQkJCTB4MTU4NAogICNkZWZpbmUgVVNCX1ZJ
RF9XSURFVklFVwkJCTB4MTRhYQogICNkZWZpbmUgVVNCX1ZJRF9HSUdBQllURQkJCTB4MTA0NAor
ICNkZWZpbmUgVVNCX1ZJRF9ZVUFOCQkJCTB4MTE2NAogIAogIAogIC8qIFByb2R1Y3QgSURzICov
CioqKioqKioqKioqKioqKgoqKiogMTgzLDE5MSAqKioqCiAgI2RlZmluZSBVU0JfUElEX09QRVJB
MV9XQVJNCQkJCTB4MzgyOQogICNkZWZpbmUgVVNCX1BJRF9MSUZFVklFV19UVl9XQUxLRVJfVFdJ
Tl9DT0xECQkweDA1MTQKICAjZGVmaW5lIFVTQl9QSURfTElGRVZJRVdfVFZfV0FMS0VSX1RXSU5f
V0FSTQkJMHgwNTEzCi0gLyogZG9tIHBvdXIgZ2lnYWJ5dGUgdTcwMDAgKi8KICAjZGVmaW5lIFVT
Ql9QSURfR0lHQUJZVEVfVTcwMDAJCQkJMHg3MDAxCiAgI2RlZmluZSBVU0JfUElEX0FTVVNfVTMw
MDAJCQkJMHgxNzFmCiAgI2RlZmluZSBVU0JfUElEX0FTVVNfVTMxMDAJCQkJMHgxNzNmCiAgCiAg
I2VuZGlmCi0tLSAxODMsMTkxIC0tLS0KICAjZGVmaW5lIFVTQl9QSURfT1BFUkExX1dBUk0JCQkJ
MHgzODI5CiAgI2RlZmluZSBVU0JfUElEX0xJRkVWSUVXX1RWX1dBTEtFUl9UV0lOX0NPTEQJCTB4
MDUxNAogICNkZWZpbmUgVVNCX1BJRF9MSUZFVklFV19UVl9XQUxLRVJfVFdJTl9XQVJNCQkweDA1
MTMKICAjZGVmaW5lIFVTQl9QSURfR0lHQUJZVEVfVTcwMDAJCQkJMHg3MDAxCiAgI2RlZmluZSBV
U0JfUElEX0FTVVNfVTMwMDAJCQkJMHgxNzFmCiAgI2RlZmluZSBVU0JfUElEX0FTVVNfVTMxMDAJ
CQkJMHgxNzNmCisgI2RlZmluZSBVU0JfUElEX1lVQU5fRUMzNzJTCQkJCTB4MWVkYwogIAogICNl
bmRpZgo=
------=_Part_378_2959486.1203368777714
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_378_2959486.1203368777714--
