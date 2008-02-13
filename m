Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JPNy8-0004GT-Vj
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 21:12:37 +0100
Received: by fg-out-1718.google.com with SMTP id 22so78064fge.25
	for <linux-dvb@linuxtv.org>; Wed, 13 Feb 2008 12:12:34 -0800 (PST)
Message-ID: <ea4209750802131212p5fb2f10bt142c6880faa8e7b2@mail.gmail.com>
Date: Wed, 13 Feb 2008 21:12:34 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: hfvogt@gmx.net, "Patrick Boettcher" <patrick.boettcher@desy.de>
In-Reply-To: <200802131940.55526.hfvogt@gmx.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_8299_24614360.1202933554378"
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802121454v385d58edt162445379daddca4@mail.gmail.com>
	<200802131940.55526.hfvogt@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_8299_24614360.1202933554378
Content-Type: multipart/alternative;
	boundary="----=_Part_8300_7780400.1202933554379"

------=_Part_8300_7780400.1202933554379
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Hans, thanks for your answer, I say what I tryed;

your dmesg output looks quite good. In fact, the only line that irritates me
is the line with

>
> xc2028 4-0061: Error on line 1063: -5
>
> This line indicates an i2c-communication problem with the tuner.
> As it happens BEFORE the XC3028  firmware is loaded, it cannot have
> anything to do with the xc3028 firmware.
> Therefore, I suspect something either with the general setup of the
> Expresscard or a DiB firmware that does not
> 100% support your device. Have you tried a later firmware?


I was trying latest firmware (I think): dvb-usb-dib0700-03-pre1.fw
I also tryed the previous; dvb-usb-dib0700-1.10.fw
And an other one; dvb-usb-dib0700-01.fw

This last one doesn't give any error, but I also can not see anything on
scanning. I send you the dmesg.

Feb 13 19:14:50: xc2028 7-0061: Loading firmware for type=D2620 DTV8 (208),
> id 0000000000000000.
> Feb 13 19:14:50: xc2028 7-0061: Device is Xceive 3028 version 1.0,
> firmware version 2.7
> Feb 13 19:14:50: dib0700: stk7700ph_xc3028_callback: XC2028_RESET_CLK 1


This last lines are a little bit different from the ones I have... Perhaps
something about the firmware modification.

I did not change the extract_firmware.pl file (in fact, it is not useable
> for the Mod7700.sys driver, but expects the driver
> file hcw85bda.sys), but just used a hex editor to replace the ID
> 0x64000200 by 0x60000200.


I tryed to do the same but I can't find 0x64000200 on the hex... Could you
send me your firmware just to try?

certainly a good idea to use an amplified antenna. Have you got another
> DVB-t device that works with a passive
> antenna in the same area where you use your new device?


I use the same device on XP and it detects some channels. When I try to scan
with kaffeine I don't see any SNR or anything so I guess the comunication
with xc3028 is failing.

Thanks again for your answer. I also send this mail to pattrick who probably
knows better the dibcom firmware stuff.

------=_Part_8300_7780400.1202933554379
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Hans, thanks for your answer, I say what I tryed;<br><br><div><span class="gmail_quote"></span>your dmesg output looks quite good. In fact, the only line that irritates me is the line with<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
 <br>xc2028 4-0061: Error on line 1063: -5<br> <br>This line indicates an i2c-communication problem with the tuner.<br> As it happens BEFORE the XC3028&nbsp;&nbsp;firmware is loaded, it cannot have anything to do with the xc3028 firmware.<br>
 Therefore, I suspect something either with the general setup of the Expresscard or a DiB firmware that does not<br> 100% support your device. Have you tried a later firmware?</blockquote><div><br>I was trying latest firmware (I think): dvb-usb-dib0700-03-pre1.fw<br>
I also tryed the previous; dvb-usb-dib0700-1.10.fw<br>And an other one; dvb-usb-dib0700-01.fw<br>&nbsp;<br>This last one doesn&#39;t give any error, but I also can not see anything on scanning. I send you the dmesg.<br></div><br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Feb 13 19:14:50: xc2028 7-0061: Loading firmware for type=D2620 DTV8 (208), id 0000000000000000.<br>
 Feb 13 19:14:50: xc2028 7-0061: Device is Xceive 3028 version 1.0, firmware version 2.7<br> Feb 13 19:14:50: dib0700: stk7700ph_xc3028_callback: XC2028_RESET_CLK 1</blockquote><div><br>This last lines are a little bit different from the ones I have... Perhaps something about the firmware modification.<br>
</div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">I did not change the extract_firmware.pl file (in fact, it is not useable for the Mod7700.sys driver, but expects the driver<br>
 file hcw85bda.sys), but just used a hex editor to replace the ID 0x64000200 by 0x60000200.</blockquote><div><br>I tryed to do the same but I can&#39;t find 0x64000200 on the hex... Could you send me your firmware just to try?<br>
</div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">certainly a good idea to use an amplified antenna. Have you got another DVB-t device that works with a passive<br>
 antenna in the same area where you use your new device?</blockquote><div><br>I use the same device on XP and it detects some channels. When I try to scan with kaffeine I don&#39;t see any SNR or anything so I guess the comunication with xc3028 is failing.<br>
</div><br>Thanks again for your answer. I also send this mail to pattrick who probably knows better the dibcom firmware stuff.<br></div>

------=_Part_8300_7780400.1202933554379--

------=_Part_8299_24614360.1202933554378
Content-Type: text/plain; name=dmesg.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcmbkm1t
Content-Disposition: attachment; filename=dmesg.txt

WyA0MTA3LjE5NjAwMF0gdXNiIDEtMTogbmV3IGhpZ2ggc3BlZWQgVVNCIGRldmljZSB1c2luZyBl
aGNpX2hjZCBhbmQgYWRkcmVzcyA5ClsgNDEwNy4zMjgwMDBdIHVzYiAxLTE6IGNvbmZpZ3VyYXRp
b24gIzEgY2hvc2VuIGZyb20gMSBjaG9pY2UKWyA0MTA3LjMyODAwMF0gZHZiLXVzYjogZm91bmQg
YSAnUGlubmFjbGUgRXhwcmVzc2NhcmQgMzIwY3gnIGluIGNvbGQgc3RhdGUsIHdpbGwgdHJ5IHRv
IGxvYWQgYSBmaXJtd2FyZQpbIDQxMDcuMzMyMDAwXSBkdmItdXNiOiBkb3dubG9hZGluZyBmaXJt
d2FyZSBmcm9tIGZpbGUgJ2R2Yi11c2ItZGliMDcwMC0xLjEwLmZ3JwpbIDQxMDcuNTE2MDAwXSBk
aWIwNzAwOiBmaXJtd2FyZSBzdGFydGVkIHN1Y2Nlc3NmdWxseS4KWyA0MTA4LjAyMDAwMF0gZHZi
LXVzYjogZm91bmQgYSAnUGlubmFjbGUgRXhwcmVzc2NhcmQgMzIwY3gnIGluIHdhcm0gc3RhdGUu
ClsgNDEwOC4wMjAwMDBdIGR2Yi11c2I6IHdpbGwgcGFzcyB0aGUgY29tcGxldGUgTVBFRzIgdHJh
bnNwb3J0IHN0cmVhbSB0byB0aGUgc29mdHdhcmUgZGVtdXhlci4KWyA0MTA4LjAyMDAwMF0gRFZC
OiByZWdpc3RlcmluZyBuZXcgYWRhcHRlciAoUGlubmFjbGUgRXhwcmVzc2NhcmQgMzIwY3gpClsg
NDEwOC4zMDAwMDBdIERWQjogcmVnaXN0ZXJpbmcgZnJvbnRlbmQgMCAoRGlCY29tIDcwMDBQQyku
Li4KWyA0MTA4LjMwMDAwMF0geGMyMDI4IDQtMDA2MTogdHlwZSBzZXQgdG8gWENlaXZlIHhjMjAy
OC94YzMwMjggdHVuZXIKWyA0MTA4LjMwMDAwMF0gaW5wdXQ6IElSLXJlY2VpdmVyIGluc2lkZSBh
biBVU0IgRFZCIHJlY2VpdmVyIGFzIC9jbGFzcy9pbnB1dC9pbnB1dDEzClsgNDEwOC4zMDAwMDBd
IGR2Yi11c2I6IHNjaGVkdWxlIHJlbW90ZSBxdWVyeSBpbnRlcnZhbCB0byAxNTAgbXNlY3MuClsg
NDEwOC4zMDAwMDBdIGR2Yi11c2I6IFBpbm5hY2xlIEV4cHJlc3NjYXJkIDMyMGN4IHN1Y2Nlc3Nm
dWxseSBpbml0aWFsaXplZCBhbmQgY29ubmVjdGVkLgpbIDQxMzYuMjUyMDAwXSB4YzIwMjggNC0w
MDYxOiBMb2FkaW5nIDgwIGZpcm13YXJlIGltYWdlcyBmcm9tIHhjMzAyOC12MjcuZncsIHR5cGU6
IHhjMjAyOCBmaXJtd2FyZSwgdmVyIDIuNwpbIDQxMzYuMjU2MDAwXSBkaWIwNzAwOiBzdGs3NzAw
cGhfeGMzMDI4X2NhbGxiYWNrOiBYQzIwMjhfVFVORVJfUkVTRVQgMApbIDQxMzYuMjU2MDAwXSAK
WyA0MTM2LjI3MjAwMF0geGMyMDI4IDQtMDA2MTogTG9hZGluZyBmaXJtd2FyZSBmb3IgdHlwZT1C
QVNFIEY4TUhaICgzKSwgaWQgMDAwMDAwMDAwMDAwMDAwMC4KWyA0MTM2LjI3MjAwMF0gZGliMDcw
MDogc3RrNzcwMHBoX3hjMzAyOF9jYWxsYmFjazogWEMyMDI4X1RVTkVSX1JFU0VUIDAKWyA0MTM2
LjI3MjAwMF0gClsgNDEzOS4yNzIwMDBdIHhjMjAyOCA0LTAwNjE6IExvYWRpbmcgZmlybXdhcmUg
Zm9yIHR5cGU9RDI2MjAgRFRWOCAoMjA4KSwgaWQgMDAwMDAwMDAwMDAwMDAwMC4KWyA0MTM5LjMy
NDAwMF0geGMyMDI4IDQtMDA2MTogTG9hZGluZyBTQ09ERSBmb3IgdHlwZT1EVFY4IFNDT0RFIEhB
U19JRl81NDAwICg2MDAwMDIwMCksIGlkIDAwMDAwMDAwMDAwMDAwMDAuClsgNDEzOS4zNjgwMDBd
IHhjMjAyOCA0LTAwNjE6IERldmljZSBpcyBYY2VpdmUgMzAyOCB2ZXJzaW9uIDEuMCwgZmlybXdh
cmUgdmVyc2lvbiAyLjcKWyA0MTM5LjM4NDAwMF0gZGliMDcwMDogc3RrNzcwMHBoX3hjMzAyOF9j
YWxsYmFjazogWEMyMDI4X1JFU0VUX0NMSyAxClsgNDEzOS4zODQwMDBdIApbIDQxNDEuMDA0MDAw
XSB4YzIwMjggNC0wMDYxOiBEZXZpY2UgaXMgWGNlaXZlIDMwMjggdmVyc2lvbiAxLjAsIGZpcm13
YXJlIHZlcnNpb24gMi43ClsgNDE0MS4wMjAwMDBdIGRpYjA3MDA6IHN0azc3MDBwaF94YzMwMjhf
Y2FsbGJhY2s6IFhDMjAyOF9SRVNFVF9DTEsgMQpbIDQxNDEuMDIwMDAwXSAKWyA0MTQyLjUzMjAw
MF0geGMyMDI4IDQtMDA2MTogRGV2aWNlIGlzIFhjZWl2ZSAzMDI4IHZlcnNpb24gMS4wLCBmaXJt
d2FyZSB2ZXJzaW9uIDIuNwpbIDQxNDIuNTQ4MDAwXSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4
X2NhbGxiYWNrOiBYQzIwMjhfUkVTRVRfQ0xLIDEKWyA0MTQyLjU0ODAwMF0gClsgNDE0NC4xNjAw
MDBdIHhjMjAyOCA0LTAwNjE6IERldmljZSBpcyBYY2VpdmUgMzAyOCB2ZXJzaW9uIDEuMCwgZmly
bXdhcmUgdmVyc2lvbiAyLjcKWyA0MTQ0LjE3NjAwMF0gZGliMDcwMDogc3RrNzcwMHBoX3hjMzAy
OF9jYWxsYmFjazogWEMyMDI4X1JFU0VUX0NMSyAxClsgNDE0NC4xNzYwMDBdIApbIDQxNDUuNjk2
MDAwXSB4YzIwMjggNC0wMDYxOiBEZXZpY2UgaXMgWGNlaXZlIDMwMjggdmVyc2lvbiAxLjAsIGZp
cm13YXJlIHZlcnNpb24gMi43ClsgNDE0NS43MTIwMDBdIGRpYjA3MDA6IHN0azc3MDBwaF94YzMw
MjhfY2FsbGJhY2s6IFhDMjAyOF9SRVNFVF9DTEsgMQpbIDQxNDUuNzEyMDAwXSAKWyA0MTQ3LjMy
NDAwMF0geGMyMDI4IDQtMDA2MTogRGV2aWNlIGlzIFhjZWl2ZSAzMDI4IHZlcnNpb24gMS4wLCBm
aXJtd2FyZSB2ZXJzaW9uIDIuNwpbIDQxNDcuMzQwMDAwXSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMz
MDI4X2NhbGxiYWNrOiBYQzIwMjhfUkVTRVRfQ0xLIDEKWyA0MTQ3LjM0MDAwMF0gClsgNDE0OC44
NTIwMDBdIHhjMjAyOCA0LTAwNjE6IERldmljZSBpcyBYY2VpdmUgMzAyOCB2ZXJzaW9uIDEuMCwg
ZmlybXdhcmUgdmVyc2lvbiAyLjcKWyA0MTQ4Ljg2ODAwMF0gZGliMDcwMDogc3RrNzcwMHBoX3hj
MzAyOF9jYWxsYmFjazogWEMyMDI4X1JFU0VUX0NMSyAxClsgNDE0OC44NjgwMDBdIApbIDQxNTAu
NDg0MDAwXSB4YzIwMjggNC0wMDYxOiBEZXZpY2UgaXMgWGNlaXZlIDMwMjggdmVyc2lvbiAxLjAs
IGZpcm13YXJlIHZlcnNpb24gMi43ClsgNDE1MC41MDAwMDBdIGRpYjA3MDA6IHN0azc3MDBwaF94
YzMwMjhfY2FsbGJhY2s6IFhDMjAyOF9SRVNFVF9DTEsgMQpbIDQxNTAuNTAwMDAwXSAKWyA0MTUy
LjAxNjAwMF0geGMyMDI4IDQtMDA2MTogRGV2aWNlIGlzIFhjZWl2ZSAzMDI4IHZlcnNpb24gMS4w
LCBmaXJtd2FyZSB2ZXJzaW9uIDIuNwpbIDQxNTIuMDMyMDAwXSBkaWIwNzAwOiBzdGs3NzAwcGhf
eGMzMDI4X2NhbGxiYWNrOiBYQzIwMjhfUkVTRVRfQ0xLIDEKWyA0MTUyLjAzMjAwMF0gClsgNDE1
My42NDQwMDBdIHhjMjAyOCA0LTAwNjE6IERldmljZSBpcyBYY2VpdmUgMzAyOCB2ZXJzaW9uIDEu
MCwgZmlybXdhcmUgdmVyc2lvbiAyLjcKWyA0MTUzLjY2MDAwMF0gZGliMDcwMDogc3RrNzcwMHBo
X3hjMzAyOF9jYWxsYmFjazogWEMyMDI4X1JFU0VUX0NMSyAxClsgNDE1My42NjAwMDBdIApbIDQx
NTUuMTg0MDAwXSB4YzIwMjggNC0wMDYxOiBEZXZpY2UgaXMgWGNlaXZlIDMwMjggdmVyc2lvbiAx
LjAsIGZpcm13YXJlIHZlcnNpb24gMi43ClsgNDE1NS4yMDQwMDBdIGRpYjA3MDA6IHN0azc3MDBw
aF94YzMwMjhfY2FsbGJhY2s6IFhDMjAyOF9SRVNFVF9DTEsgMQpbIDQxNTUuMjA0MDAwXSAKWyA0
MTU2LjgxNjAwMF0geGMyMDI4IDQtMDA2MTogRGV2aWNlIGlzIFhjZWl2ZSAzMDI4IHZlcnNpb24g
MS4wLCBmaXJtd2FyZSB2ZXJzaW9uIDIuNwpbIDQxNTYuODMyMDAwXSBkaWIwNzAwOiBzdGs3NzAw
cGhfeGMzMDI4X2NhbGxiYWNrOiBYQzIwMjhfUkVTRVRfQ0xLIDEKWyA0MTU2LjgzMjAwMF0gCg==

------=_Part_8299_24614360.1202933554378
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_8299_24614360.1202933554378--
