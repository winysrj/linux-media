Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35506 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2ACTo0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 14:44:26 -0500
Received: by ggdk6 with SMTP id k6so9976464ggd.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 11:44:25 -0800 (PST)
MIME-Version: 1.0
From: Mario Ceresa <mrceresa@gmail.com>
Date: Tue, 3 Jan 2012 20:44:04 +0100
Message-ID: <CAHVY3e=Q8yRdXhgsoPBX-dvCHY=uF7adCievYoOTg15cOF6xGw@mail.gmail.com>
Subject: sveon stv40 usb stick
To: V4L Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=14dae93406e32dbbf904b5a4eda4
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--14dae93406e32dbbf904b5a4eda4
Content-Type: text/plain; charset=ISO-8859-1

Hello everybody!
I recently bougth a Sveon STV40 usb stick to capture analogic video
(http://www.sveon.com/fichaSTV40.html)
I can use it in windows but my linux box (Fedora 16 -
3.1.6-1.fc16.x86_64 - gcc 4.6.2) can't recognize it.
Is there any way I can fix this?

These are the results of my investigation so far:

1) It is identified by lsusb as an Afatech board (1b80:e309) with an
Empia 2861 chip (from dmesg and windows driver inf file)
2) I experimented with em28xx  because the chipset was empia and with
af9015 because I found that the stv22 was supported
(http://linuxtv.org/wiki/index.php/Afatech_AF9015). In both cases
after I manually added the vendor:id to /sys/bus/usb/drivers/ driver
started but in the end I was not able to succeed. With em28xx I could
go as far as having a /dev/video0 device but with no signal and the
dmesg log said to ask here for help :) . With the af9015 I had an
early stop.
3) Both the logs are attached.
4) I used the driver shipped with the fedora stock kernel because I
can't compile the ones that I get from
git://linuxtv.org/media_build.git. I have an error at:

CC [M]  media_build/v4l/as3645a.o
media_build/v4l/as3645a.c: In function 'as3645a_probe':
media_build/v4l/as3645a.c:815:2: error: implicit declaration of
function 'kzalloc' [-Werror=implicit-function-declaration]
media_build/v4l/as3645a.c:815:8: warning: assignment makes pointer
from integer without a cast [enabled by default]
cc1: some warnings being treated as errors

Thank you in advance for any help you might provide on this issue!

,Best regards

Mario

--14dae93406e32dbbf904b5a4eda4
Content-Type: text/plain; charset=US-ASCII; name="stv40_dmesg.txt"
Content-Disposition: attachment; filename="stv40_dmesg.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gwzajj580

WzEyODgyLjQ4MzQ3MV0gTGludXggbWVkaWEgaW50ZXJmYWNlOiB2MC4xMApbMTI4ODIuNDg0OTgw
XSBMaW51eCB2aWRlbyBjYXB0dXJlIGludGVyZmFjZTogdjIuMDAKWzEyODgyLjQ4NjE4N10gdXNi
Y29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBlbTI4eHgKWzEyODgyLjQ4NjE4
OV0gZW0yOHh4IGRyaXZlciBsb2FkZWQKWzEzMDAyLjE2OTQ1MV0gdXNiIDEtNS4zOiBuZXcgaGln
aCBzcGVlZCBVU0IgZGV2aWNlIG51bWJlciAxMSB1c2luZyBlaGNpX2hjZApbMTMwMDIuMjU5Nzk1
XSB1c2IgMS01LjM6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0xYjgwLCBpZFByb2R1
Y3Q9ZTMwOQpbMTMwMDIuMjU5Nzk5XSB1c2IgMS01LjM6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6
IE1mcj0wLCBQcm9kdWN0PTEsIFNlcmlhbE51bWJlcj0wClsxMzAwMi4yNTk4MDNdIHVzYiAxLTUu
MzogUHJvZHVjdDogVVNCIDI4NjEgRGV2aWNlIChTVkVPTiBTVFY0MCkKWzEzMDAyLjI2MDcwMl0g
ZW0yOHh4OiBOZXcgZGV2aWNlIFVTQiAyODYxIERldmljZSAoU1ZFT04gU1RWNDApIEAgNDgwIE1i
cHMgKDFiODA6ZTMwOSwgaW50ZXJmYWNlIDAsIGNsYXNzIDApClsxMzAwMi4yNjA3ODddIGVtMjh4
eCAjMDogY2hpcCBJRCBpcyBlbTI4NjAKWzEzMDAyLjM1OTI3NV0gZW0yOHh4ICMwOiBib2FyZCBo
YXMgbm8gZWVwcm9tClsxMzAwMi40MzEyODFdIGVtMjh4eCAjMDogcHJlcGFyaW5nIHJlYWQgYXQg
aTJjIGFkZHJlc3MgMHg2MCBmYWlsZWQgKGVycm9yPS0xOSkKWzEzMDA3LjA3MzY4Ml0gZW0yOHh4
ICMwOiBZb3VyIGJvYXJkIGhhcyBubyB1bmlxdWUgVVNCIElEIGFuZCB0aHVzIG5lZWQgYSBoaW50
IHRvIGJlIGRldGVjdGVkLgpbMTMwMDcuMDczNjg2XSBlbTI4eHggIzA6IFlvdSBtYXkgdHJ5IHRv
IHVzZSBjYXJkPTxuPiBpbnNtb2Qgb3B0aW9uIHRvIHdvcmthcm91bmQgdGhhdC4KWzEzMDA3LjA3
MzY4N10gZW0yOHh4ICMwOiBQbGVhc2Ugc2VuZCBhbiBlbWFpbCB3aXRoIHRoaXMgbG9nIHRvOgpb
MTMwMDcuMDczNjg4XSBlbTI4eHggIzA6ICAgICAgIFY0TCBNYWlsaW5nIExpc3QgPGxpbnV4LW1l
ZGlhQHZnZXIua2VybmVsLm9yZz4KWzEzMDA3LjA3MzY5MF0gZW0yOHh4ICMwOiBCb2FyZCBlZXBy
b20gaGFzaCBpcyAweDAwMDAwMDAwClsxMzAwNy4wNzM2OTFdIGVtMjh4eCAjMDogQm9hcmQgaTJj
IGRldmljZWxpc3QgaGFzaCBpcyAweDFiODAwMDgwClsxMzAwNy4wNzM2OTJdIGVtMjh4eCAjMDog
SGVyZSBpcyBhIGxpc3Qgb2YgdmFsaWQgY2hvaWNlcyBmb3IgdGhlIGNhcmQ9PG4+IGluc21vZCBv
cHRpb246ClsxMzAwNy4wNzM2OTRdIGVtMjh4eCAjMDogICAgIGNhcmQ9MCAtPiBVbmtub3duIEVN
MjgwMCB2aWRlbyBncmFiYmVyClsxMzAwNy4wNzM2OTZdIGVtMjh4eCAjMDogICAgIGNhcmQ9MSAt
PiBVbmtub3duIEVNMjc1MC8yOHh4IHZpZGVvIGdyYWJiZXIKWzEzMDA3LjA3MzY5N10gZW0yOHh4
ICMwOiAgICAgY2FyZD0yIC0+IFRlcnJhdGVjIENpbmVyZ3kgMjUwIFVTQgpbMTMwMDcuMDczNjk5
XSBlbTI4eHggIzA6ICAgICBjYXJkPTMgLT4gUGlubmFjbGUgUENUViBVU0IgMgpbMTMwMDcuMDcz
NzAwXSBlbTI4eHggIzA6ICAgICBjYXJkPTQgLT4gSGF1cHBhdWdlIFdpblRWIFVTQiAyClsxMzAw
Ny4wNzM3MDFdIGVtMjh4eCAjMDogICAgIGNhcmQ9NSAtPiBNU0kgVk9YIFVTQiAyLjAKWzEzMDA3
LjA3MzcwMl0gZW0yOHh4ICMwOiAgICAgY2FyZD02IC0+IFRlcnJhdGVjIENpbmVyZ3kgMjAwIFVT
QgpbMTMwMDcuMDczNzAzXSBlbTI4eHggIzA6ICAgICBjYXJkPTcgLT4gTGVhZHRlayBXaW5mYXN0
IFVTQiBJSQpbMTMwMDcuMDczNzA1XSBlbTI4eHggIzA6ICAgICBjYXJkPTggLT4gS3dvcmxkIFVT
QjI4MDAKWzEzMDA3LjA3MzcwNl0gZW0yOHh4ICMwOiAgICAgY2FyZD05IC0+IFBpbm5hY2xlIERh
enpsZSBEVkMgOTAvMTAwLzEwMS8xMDcgLyBLYWlzZXIgQmFhcyBWaWRlbyB0byBEVkQgbWFrZXIg
LyBLd29ybGQgRFZEIE1ha2VyIDIKWzEzMDA3LjA3MzcwOF0gZW0yOHh4ICMwOiAgICAgY2FyZD0x
MCAtPiBIYXVwcGF1Z2UgV2luVFYgSFZSIDkwMApbMTMwMDcuMDczNzA5XSBlbTI4eHggIzA6ICAg
ICBjYXJkPTExIC0+IFRlcnJhdGVjIEh5YnJpZCBYUwpbMTMwMDcuMDczNzEwXSBlbTI4eHggIzA6
ICAgICBjYXJkPTEyIC0+IEt3b3JsZCBQVlIgVFYgMjgwMCBSRgpbMTMwMDcuMDczNzEyXSBlbTI4
eHggIzA6ICAgICBjYXJkPTEzIC0+IFRlcnJhdGVjIFByb2RpZ3kgWFMKWzEzMDA3LjA3MzcxM10g
ZW0yOHh4ICMwOiAgICAgY2FyZD0xNCAtPiBTSUlHIEFWVHVuZXItUFZSIC8gUGl4ZWx2aWV3IFBy
b2xpbmsgUGxheVRWIFVTQiAyLjAKWzEzMDA3LjA3MzcxNF0gZW0yOHh4ICMwOiAgICAgY2FyZD0x
NSAtPiBWLUdlYXIgUG9ja2V0VFYKWzEzMDA3LjA3MzcxNl0gZW0yOHh4ICMwOiAgICAgY2FyZD0x
NiAtPiBIYXVwcGF1Z2UgV2luVFYgSFZSIDk1MApbMTMwMDcuMDczNzE3XSBlbTI4eHggIzA6ICAg
ICBjYXJkPTE3IC0+IFBpbm5hY2xlIFBDVFYgSEQgUHJvIFN0aWNrClsxMzAwNy4wNzM3MThdIGVt
Mjh4eCAjMDogICAgIGNhcmQ9MTggLT4gSGF1cHBhdWdlIFdpblRWIEhWUiA5MDAgKFIyKQpbMTMw
MDcuMDczNzIwXSBlbTI4eHggIzA6ICAgICBjYXJkPTE5IC0+IEVNMjg2MC9TQUE3MTFYIFJlZmVy
ZW5jZSBEZXNpZ24KWzEzMDA3LjA3MzcyMV0gZW0yOHh4ICMwOiAgICAgY2FyZD0yMCAtPiBBTUQg
QVRJIFRWIFdvbmRlciBIRCA2MDAKWzEzMDA3LjA3MzcyMl0gZW0yOHh4ICMwOiAgICAgY2FyZD0y
MSAtPiBlTVBJQSBUZWNobm9sb2d5LCBJbmMuIEdyYWJCZWVYKyBWaWRlbyBFbmNvZGVyClsxMzAw
Ny4wNzM3MjRdIGVtMjh4eCAjMDogICAgIGNhcmQ9MjIgLT4gRU0yNzEwL0VNMjc1MC9FTTI3NTEg
d2ViY2FtIGdyYWJiZXIKWzEzMDA3LjA3MzcyNV0gZW0yOHh4ICMwOiAgICAgY2FyZD0yMyAtPiBI
dWFxaSBETENXLTEzMApbMTMwMDcuMDczNzI2XSBlbTI4eHggIzA6ICAgICBjYXJkPTI0IC0+IEQt
TGluayBEVUItVDIxMCBUViBUdW5lcgpbMTMwMDcuMDczNzI3XSBlbTI4eHggIzA6ICAgICBjYXJk
PTI1IC0+IEdhZG1laSBVVFYzMTAKWzEzMDA3LjA3MzcyOV0gZW0yOHh4ICMwOiAgICAgY2FyZD0y
NiAtPiBIZXJjdWxlcyBTbWFydCBUViBVU0IgMi4wClsxMzAwNy4wNzM3MzBdIGVtMjh4eCAjMDog
ICAgIGNhcmQ9MjcgLT4gUGlubmFjbGUgUENUViBVU0IgMiAoUGhpbGlwcyBGTTEyMTZNRSkKWzEz
MDA3LjA3MzczMV0gZW0yOHh4ICMwOiAgICAgY2FyZD0yOCAtPiBMZWFkdGVrIFdpbmZhc3QgVVNC
IElJIERlbHV4ZQpbMTMwMDcuMDczNzMzXSBlbTI4eHggIzA6ICAgICBjYXJkPTI5IC0+IEVNMjg2
MC9UVlA1MTUwIFJlZmVyZW5jZSBEZXNpZ24KWzEzMDA3LjA3MzczNF0gZW0yOHh4ICMwOiAgICAg
Y2FyZD0zMCAtPiBWaWRlb2xvZ3kgMjBLMTRYVVNCIFVTQjIuMApbMTMwMDcuMDczNzM1XSBlbTI4
eHggIzA6ICAgICBjYXJkPTMxIC0+IFVzYmdlYXIgVkQyMDR2OQpbMTMwMDcuMDczNzM2XSBlbTI4
eHggIzA6ICAgICBjYXJkPTMyIC0+IFN1cGVyY29tcCBVU0IgMi4wIFRWClsxMzAwNy4wNzM3Mzdd
IGVtMjh4eCAjMDogICAgIGNhcmQ9MzMgLT4gRWxnYXRvIFZpZGVvIENhcHR1cmUKWzEzMDA3LjA3
MzczOV0gZW0yOHh4ICMwOiAgICAgY2FyZD0zNCAtPiBUZXJyYXRlYyBDaW5lcmd5IEEgSHlicmlk
IFhTClsxMzAwNy4wNzM3NDBdIGVtMjh4eCAjMDogICAgIGNhcmQ9MzUgLT4gVHlwaG9vbiBEVkQg
TWFrZXIKWzEzMDA3LjA3Mzc0MV0gZW0yOHh4ICMwOiAgICAgY2FyZD0zNiAtPiBOZXRHTUJIIENh
bQpbMTMwMDcuMDczNzQyXSBlbTI4eHggIzA6ICAgICBjYXJkPTM3IC0+IEdhZG1laSBVVFYzMzAK
WzEzMDA3LjA3Mzc0M10gZW0yOHh4ICMwOiAgICAgY2FyZD0zOCAtPiBZYWt1bW8gTW92aWVNaXhl
cgpbMTMwMDcuMDczNzQ1XSBlbTI4eHggIzA6ICAgICBjYXJkPTM5IC0+IEtXb3JsZCBQVlJUViAz
MDBVClsxMzAwNy4wNzM3NDZdIGVtMjh4eCAjMDogICAgIGNhcmQ9NDAgLT4gUGxleHRvciBDb252
ZXJ0WCBQWC1UVjEwMFUKWzEzMDA3LjA3Mzc0N10gZW0yOHh4ICMwOiAgICAgY2FyZD00MSAtPiBL
d29ybGQgMzUwIFUgRFZCLVQKWzEzMDA3LjA3Mzc0OF0gZW0yOHh4ICMwOiAgICAgY2FyZD00MiAt
PiBLd29ybGQgMzU1IFUgRFZCLVQKWzEzMDA3LjA3Mzc0OV0gZW0yOHh4ICMwOiAgICAgY2FyZD00
MyAtPiBUZXJyYXRlYyBDaW5lcmd5IFQgWFMKWzEzMDA3LjA3Mzc1MV0gZW0yOHh4ICMwOiAgICAg
Y2FyZD00NCAtPiBUZXJyYXRlYyBDaW5lcmd5IFQgWFMgKE1UMjA2MCkKWzEzMDA3LjA3Mzc1Ml0g
ZW0yOHh4ICMwOiAgICAgY2FyZD00NSAtPiBQaW5uYWNsZSBQQ1RWIERWQi1UClsxMzAwNy4wNzM3
NTNdIGVtMjh4eCAjMDogICAgIGNhcmQ9NDYgLT4gQ29tcHJvLCBWaWRlb01hdGUgVTMKWzEzMDA3
LjA3Mzc1NF0gZW0yOHh4ICMwOiAgICAgY2FyZD00NyAtPiBLV29ybGQgRFZCLVQgMzA1VQpbMTMw
MDcuMDczNzU2XSBlbTI4eHggIzA6ICAgICBjYXJkPTQ4IC0+IEtXb3JsZCBEVkItVCAzMTBVClsx
MzAwNy4wNzM3NTddIGVtMjh4eCAjMDogICAgIGNhcmQ9NDkgLT4gTVNJIERpZ2lWb3ggQS9EClsx
MzAwNy4wNzM3NThdIGVtMjh4eCAjMDogICAgIGNhcmQ9NTAgLT4gTVNJIERpZ2lWb3ggQS9EIElJ
ClsxMzAwNy4wNzM3NTldIGVtMjh4eCAjMDogICAgIGNhcmQ9NTEgLT4gVGVycmF0ZWMgSHlicmlk
IFhTIFNlY2FtClsxMzAwNy4wNzM3NjBdIGVtMjh4eCAjMDogICAgIGNhcmQ9NTIgLT4gRE5UIERB
MiBIeWJyaWQKWzEzMDA3LjA3Mzc2Ml0gZW0yOHh4ICMwOiAgICAgY2FyZD01MyAtPiBQaW5uYWNs
ZSBIeWJyaWQgUHJvClsxMzAwNy4wNzM3NjNdIGVtMjh4eCAjMDogICAgIGNhcmQ9NTQgLT4gS3dv
cmxkIFZTLURWQi1UIDMyM1VSClsxMzAwNy4wNzM3NjRdIGVtMjh4eCAjMDogICAgIGNhcmQ9NTUg
LT4gVGVycmF0ZWMgQ2lubmVyZ3kgSHlicmlkIFQgVVNCIFhTIChlbTI4ODIpClsxMzAwNy4wNzM3
NjVdIGVtMjh4eCAjMDogICAgIGNhcmQ9NTYgLT4gUGlubmFjbGUgSHlicmlkIFBybyAoMzMwZSkK
WzEzMDA3LjA3Mzc2N10gZW0yOHh4ICMwOiAgICAgY2FyZD01NyAtPiBLd29ybGQgUGx1c1RWIEhE
IEh5YnJpZCAzMzAKWzEzMDA3LjA3Mzc2OF0gZW0yOHh4ICMwOiAgICAgY2FyZD01OCAtPiBDb21w
cm8gVmlkZW9NYXRlIEZvcllvdS9TdGVyZW8KWzEzMDA3LjA3Mzc2OV0gZW0yOHh4ICMwOiAgICAg
Y2FyZD01OSAtPiAobnVsbCkKWzEzMDA3LjA3Mzc3MF0gZW0yOHh4ICMwOiAgICAgY2FyZD02MCAt
PiBIYXVwcGF1Z2UgV2luVFYgSFZSIDg1MApbMTMwMDcuMDczNzcyXSBlbTI4eHggIzA6ICAgICBj
YXJkPTYxIC0+IFBpeGVsdmlldyBQbGF5VFYgQm94IDQgVVNCIDIuMApbMTMwMDcuMDczNzczXSBl
bTI4eHggIzA6ICAgICBjYXJkPTYyIC0+IEdhZG1laSBUVlIyMDAKWzEzMDA3LjA3Mzc4MF0gZW0y
OHh4ICMwOiAgICAgY2FyZD02MyAtPiBLYWlvbXkgVFZuUEMgVTIKWzEzMDA3LjA3Mzc4MV0gZW0y
OHh4ICMwOiAgICAgY2FyZD02NCAtPiBFYXN5IENhcCBDYXB0dXJlIERDLTYwClsxMzAwNy4wNzM3
ODJdIGVtMjh4eCAjMDogICAgIGNhcmQ9NjUgLT4gSU8tREFUQSBHVi1NVlAvU1oKWzEzMDA3LjA3
Mzc4NF0gZW0yOHh4ICMwOiAgICAgY2FyZD02NiAtPiBFbXBpcmUgZHVhbCBUVgpbMTMwMDcuMDcz
Nzg1XSBlbTI4eHggIzA6ICAgICBjYXJkPTY3IC0+IFRlcnJhdGVjIEdyYWJieQpbMTMwMDcuMDcz
Nzg2XSBlbTI4eHggIzA6ICAgICBjYXJkPTY4IC0+IFRlcnJhdGVjIEFWMzUwClsxMzAwNy4wNzM3
ODddIGVtMjh4eCAjMDogICAgIGNhcmQ9NjkgLT4gS1dvcmxkIEFUU0MgMzE1VSBIRFRWIFRWIEJv
eApbMTMwMDcuMDczNzg4XSBlbTI4eHggIzA6ICAgICBjYXJkPTcwIC0+IEV2Z2EgaW5EdHViZQpb
MTMwMDcuMDczNzg5XSBlbTI4eHggIzA6ICAgICBjYXJkPTcxIC0+IFNpbHZlcmNyZXN0IFdlYmNh
bSAxLjNtcGl4ClsxMzAwNy4wNzM3OTFdIGVtMjh4eCAjMDogICAgIGNhcmQ9NzIgLT4gR2FkbWVp
IFVUVjMzMCsKWzEzMDA3LjA3Mzc5Ml0gZW0yOHh4ICMwOiAgICAgY2FyZD03MyAtPiBSZWRkbyBE
VkItQyBVU0IgVFYgQm94ClsxMzAwNy4wNzM3OTNdIGVtMjh4eCAjMDogICAgIGNhcmQ9NzQgLT4g
QWN0aW9ubWFzdGVyL0xpblhjZWwvRGlnaXR1cyBWQzIxMUEKWzEzMDA3LjA3Mzc5NF0gZW0yOHh4
ICMwOiAgICAgY2FyZD03NSAtPiBEaWtvbSBESzMwMApbMTMwMDcuMDczNzk2XSBlbTI4eHggIzA6
ICAgICBjYXJkPTc2IC0+IEtXb3JsZCBQbHVzVFYgMzQwVSBvciBVQjQzNS1RIChBVFNDKQpbMTMw
MDcuMDczNzk3XSBlbTI4eHggIzA6ICAgICBjYXJkPTc3IC0+IEVNMjg3NCBMZWFkZXJzaGlwIElT
REJUClsxMzAwNy4wNzM3OThdIGVtMjh4eCAjMDogICAgIGNhcmQ9NzggLT4gUENUViBuYW5vU3Rp
Y2sgVDIgMjkwZQpbMTMwMDcuMDczNzk5XSBlbTI4eHggIzA6ICAgICBjYXJkPTc5IC0+IFRlcnJh
dGVjIENpbmVyZ3kgSDUKWzEzMDA3LjA3MzgwMV0gZW0yOHh4ICMwOiBCb2FyZCBub3QgZGlzY292
ZXJlZApbMTMwMDcuMDczODAyXSBlbTI4eHggIzA6IElkZW50aWZpZWQgYXMgVW5rbm93biBFTTI4
MDAgdmlkZW8gZ3JhYmJlciAoY2FyZD0wKQpbMTMwMDcuMDczODA0XSBlbTI4eHggIzA6IFlvdXIg
Ym9hcmQgaGFzIG5vIHVuaXF1ZSBVU0IgSUQgYW5kIHRodXMgbmVlZCBhIGhpbnQgdG8gYmUgZGV0
ZWN0ZWQuClsxMzAwNy4wNzM4MDVdIGVtMjh4eCAjMDogWW91IG1heSB0cnkgdG8gdXNlIGNhcmQ9
PG4+IGluc21vZCBvcHRpb24gdG8gd29ya2Fyb3VuZCB0aGF0LgpbMTMwMDcuMDczODA2XSBlbTI4
eHggIzA6IFBsZWFzZSBzZW5kIGFuIGVtYWlsIHdpdGggdGhpcyBsb2cgdG86ClsxMzAwNy4wNzM4
MDddIGVtMjh4eCAjMDogICAgICAgVjRMIE1haWxpbmcgTGlzdCA8bGludXgtbWVkaWFAdmdlci5r
ZXJuZWwub3JnPgpbMTMwMDcuMDczODA4XSBlbTI4eHggIzA6IEJvYXJkIGVlcHJvbSBoYXNoIGlz
IDB4MDAwMDAwMDAKWzEzMDA3LjA3MzgwOV0gZW0yOHh4ICMwOiBCb2FyZCBpMmMgZGV2aWNlbGlz
dCBoYXNoIGlzIDB4MWI4MDAwODAKWzEzMDA3LjA3MzgxMV0gZW0yOHh4ICMwOiBIZXJlIGlzIGEg
bGlzdCBvZiB2YWxpZCBjaG9pY2VzIGZvciB0aGUgY2FyZD08bj4gaW5zbW9kIG9wdGlvbjoKWzEz
MDA3LjA3MzgxMl0gZW0yOHh4ICMwOiAgICAgY2FyZD0wIC0+IFVua25vd24gRU0yODAwIHZpZGVv
IGdyYWJiZXIKWzEzMDA3LjA3MzgxM10gZW0yOHh4ICMwOiAgICAgY2FyZD0xIC0+IFVua25vd24g
RU0yNzUwLzI4eHggdmlkZW8gZ3JhYmJlcgpbMTMwMDcuMDczODE1XSBlbTI4eHggIzA6ICAgICBj
YXJkPTIgLT4gVGVycmF0ZWMgQ2luZXJneSAyNTAgVVNCClsxMzAwNy4wNzM4MTZdIGVtMjh4eCAj
MDogICAgIGNhcmQ9MyAtPiBQaW5uYWNsZSBQQ1RWIFVTQiAyClsxMzAwNy4wNzM4MTddIGVtMjh4
eCAjMDogICAgIGNhcmQ9NCAtPiBIYXVwcGF1Z2UgV2luVFYgVVNCIDIKWzEzMDA3LjA3MzgxOF0g
ZW0yOHh4ICMwOiAgICAgY2FyZD01IC0+IE1TSSBWT1ggVVNCIDIuMApbMTMwMDcuMDczODE5XSBl
bTI4eHggIzA6ICAgICBjYXJkPTYgLT4gVGVycmF0ZWMgQ2luZXJneSAyMDAgVVNCClsxMzAwNy4w
NzM4MjFdIGVtMjh4eCAjMDogICAgIGNhcmQ9NyAtPiBMZWFkdGVrIFdpbmZhc3QgVVNCIElJClsx
MzAwNy4wNzM4MjJdIGVtMjh4eCAjMDogICAgIGNhcmQ9OCAtPiBLd29ybGQgVVNCMjgwMApbMTMw
MDcuMDczODIzXSBlbTI4eHggIzA6ICAgICBjYXJkPTkgLT4gUGlubmFjbGUgRGF6emxlIERWQyA5
MC8xMDAvMTAxLzEwNyAvIEthaXNlciBCYWFzIFZpZGVvIHRvIERWRCBtYWtlciAvIEt3b3JsZCBE
VkQgTWFrZXIgMgpbMTMwMDcuMDczODI1XSBlbTI4eHggIzA6ICAgICBjYXJkPTEwIC0+IEhhdXBw
YXVnZSBXaW5UViBIVlIgOTAwClsxMzAwNy4wNzM4MjZdIGVtMjh4eCAjMDogICAgIGNhcmQ9MTEg
LT4gVGVycmF0ZWMgSHlicmlkIFhTClsxMzAwNy4wNzM4MjddIGVtMjh4eCAjMDogICAgIGNhcmQ9
MTIgLT4gS3dvcmxkIFBWUiBUViAyODAwIFJGClsxMzAwNy4wNzM4MjldIGVtMjh4eCAjMDogICAg
IGNhcmQ9MTMgLT4gVGVycmF0ZWMgUHJvZGlneSBYUwpbMTMwMDcuMDczODMwXSBlbTI4eHggIzA6
ICAgICBjYXJkPTE0IC0+IFNJSUcgQVZUdW5lci1QVlIgLyBQaXhlbHZpZXcgUHJvbGluayBQbGF5
VFYgVVNCIDIuMApbMTMwMDcuMDczODMxXSBlbTI4eHggIzA6ICAgICBjYXJkPTE1IC0+IFYtR2Vh
ciBQb2NrZXRUVgpbMTMwMDcuMDczODMyXSBlbTI4eHggIzA6ICAgICBjYXJkPTE2IC0+IEhhdXBw
YXVnZSBXaW5UViBIVlIgOTUwClsxMzAwNy4wNzM4MzRdIGVtMjh4eCAjMDogICAgIGNhcmQ9MTcg
LT4gUGlubmFjbGUgUENUViBIRCBQcm8gU3RpY2sKWzEzMDA3LjA3MzgzNV0gZW0yOHh4ICMwOiAg
ICAgY2FyZD0xOCAtPiBIYXVwcGF1Z2UgV2luVFYgSFZSIDkwMCAoUjIpClsxMzAwNy4wNzM4MzZd
IGVtMjh4eCAjMDogICAgIGNhcmQ9MTkgLT4gRU0yODYwL1NBQTcxMVggUmVmZXJlbmNlIERlc2ln
bgpbMTMwMDcuMDczODM4XSBlbTI4eHggIzA6ICAgICBjYXJkPTIwIC0+IEFNRCBBVEkgVFYgV29u
ZGVyIEhEIDYwMApbMTMwMDcuMDczODM5XSBlbTI4eHggIzA6ICAgICBjYXJkPTIxIC0+IGVNUElB
IFRlY2hub2xvZ3ksIEluYy4gR3JhYkJlZVgrIFZpZGVvIEVuY29kZXIKWzEzMDA3LjA3Mzg0MF0g
ZW0yOHh4ICMwOiAgICAgY2FyZD0yMiAtPiBFTTI3MTAvRU0yNzUwL0VNMjc1MSB3ZWJjYW0gZ3Jh
YmJlcgpbMTMwMDcuMDczODQyXSBlbTI4eHggIzA6ICAgICBjYXJkPTIzIC0+IEh1YXFpIERMQ1ct
MTMwClsxMzAwNy4wNzM4NDNdIGVtMjh4eCAjMDogICAgIGNhcmQ9MjQgLT4gRC1MaW5rIERVQi1U
MjEwIFRWIFR1bmVyClsxMzAwNy4wNzM4NDRdIGVtMjh4eCAjMDogICAgIGNhcmQ9MjUgLT4gR2Fk
bWVpIFVUVjMxMApbMTMwMDcuMDczODQ1XSBlbTI4eHggIzA6ICAgICBjYXJkPTI2IC0+IEhlcmN1
bGVzIFNtYXJ0IFRWIFVTQiAyLjAKWzEzMDA3LjA3Mzg0Nl0gZW0yOHh4ICMwOiAgICAgY2FyZD0y
NyAtPiBQaW5uYWNsZSBQQ1RWIFVTQiAyIChQaGlsaXBzIEZNMTIxNk1FKQpbMTMwMDcuMDczODQ4
XSBlbTI4eHggIzA6ICAgICBjYXJkPTI4IC0+IExlYWR0ZWsgV2luZmFzdCBVU0IgSUkgRGVsdXhl
ClsxMzAwNy4wNzM4NDldIGVtMjh4eCAjMDogICAgIGNhcmQ9MjkgLT4gRU0yODYwL1RWUDUxNTAg
UmVmZXJlbmNlIERlc2lnbgpbMTMwMDcuMDczODUwXSBlbTI4eHggIzA6ICAgICBjYXJkPTMwIC0+
IFZpZGVvbG9neSAyMEsxNFhVU0IgVVNCMi4wClsxMzAwNy4wNzM4NTJdIGVtMjh4eCAjMDogICAg
IGNhcmQ9MzEgLT4gVXNiZ2VhciBWRDIwNHY5ClsxMzAwNy4wNzM4NTNdIGVtMjh4eCAjMDogICAg
IGNhcmQ9MzIgLT4gU3VwZXJjb21wIFVTQiAyLjAgVFYKWzEzMDA3LjA3Mzg1NF0gZW0yOHh4ICMw
OiAgICAgY2FyZD0zMyAtPiBFbGdhdG8gVmlkZW8gQ2FwdHVyZQpbMTMwMDcuMDczODU1XSBlbTI4
eHggIzA6ICAgICBjYXJkPTM0IC0+IFRlcnJhdGVjIENpbmVyZ3kgQSBIeWJyaWQgWFMKWzEzMDA3
LjA3Mzg1Nl0gZW0yOHh4ICMwOiAgICAgY2FyZD0zNSAtPiBUeXBob29uIERWRCBNYWtlcgpbMTMw
MDcuMDczODU4XSBlbTI4eHggIzA6ICAgICBjYXJkPTM2IC0+IE5ldEdNQkggQ2FtClsxMzAwNy4w
NzM4NTldIGVtMjh4eCAjMDogICAgIGNhcmQ9MzcgLT4gR2FkbWVpIFVUVjMzMApbMTMwMDcuMDcz
ODYwXSBlbTI4eHggIzA6ICAgICBjYXJkPTM4IC0+IFlha3VtbyBNb3ZpZU1peGVyClsxMzAwNy4w
NzM4NjFdIGVtMjh4eCAjMDogICAgIGNhcmQ9MzkgLT4gS1dvcmxkIFBWUlRWIDMwMFUKWzEzMDA3
LjA3Mzg2Ml0gZW0yOHh4ICMwOiAgICAgY2FyZD00MCAtPiBQbGV4dG9yIENvbnZlcnRYIFBYLVRW
MTAwVQpbMTMwMDcuMDczODYzXSBlbTI4eHggIzA6ICAgICBjYXJkPTQxIC0+IEt3b3JsZCAzNTAg
VSBEVkItVApbMTMwMDcuMDczODY1XSBlbTI4eHggIzA6ICAgICBjYXJkPTQyIC0+IEt3b3JsZCAz
NTUgVSBEVkItVApbMTMwMDcuMDczODY2XSBlbTI4eHggIzA6ICAgICBjYXJkPTQzIC0+IFRlcnJh
dGVjIENpbmVyZ3kgVCBYUwpbMTMwMDcuMDczODY3XSBlbTI4eHggIzA6ICAgICBjYXJkPTQ0IC0+
IFRlcnJhdGVjIENpbmVyZ3kgVCBYUyAoTVQyMDYwKQpbMTMwMDcuMDczODY4XSBlbTI4eHggIzA6
ICAgICBjYXJkPTQ1IC0+IFBpbm5hY2xlIFBDVFYgRFZCLVQKWzEzMDA3LjA3Mzg3MF0gZW0yOHh4
ICMwOiAgICAgY2FyZD00NiAtPiBDb21wcm8sIFZpZGVvTWF0ZSBVMwpbMTMwMDcuMDczODcxXSBl
bTI4eHggIzA6ICAgICBjYXJkPTQ3IC0+IEtXb3JsZCBEVkItVCAzMDVVClsxMzAwNy4wNzM4NzJd
IGVtMjh4eCAjMDogICAgIGNhcmQ9NDggLT4gS1dvcmxkIERWQi1UIDMxMFUKWzEzMDA3LjA3Mzg3
M10gZW0yOHh4ICMwOiAgICAgY2FyZD00OSAtPiBNU0kgRGlnaVZveCBBL0QKWzEzMDA3LjA3Mzg3
NF0gZW0yOHh4ICMwOiAgICAgY2FyZD01MCAtPiBNU0kgRGlnaVZveCBBL0QgSUkKWzEzMDA3LjA3
Mzg3Nl0gZW0yOHh4ICMwOiAgICAgY2FyZD01MSAtPiBUZXJyYXRlYyBIeWJyaWQgWFMgU2VjYW0K
WzEzMDA3LjA3Mzg3N10gZW0yOHh4ICMwOiAgICAgY2FyZD01MiAtPiBETlQgREEyIEh5YnJpZApb
MTMwMDcuMDczODc4XSBlbTI4eHggIzA6ICAgICBjYXJkPTUzIC0+IFBpbm5hY2xlIEh5YnJpZCBQ
cm8KWzEzMDA3LjA3Mzg3OV0gZW0yOHh4ICMwOiAgICAgY2FyZD01NCAtPiBLd29ybGQgVlMtRFZC
LVQgMzIzVVIKWzEzMDA3LjA3Mzg4MF0gZW0yOHh4ICMwOiAgICAgY2FyZD01NSAtPiBUZXJyYXRl
YyBDaW5uZXJneSBIeWJyaWQgVCBVU0IgWFMgKGVtMjg4MikKWzEzMDA3LjA3Mzg4Ml0gZW0yOHh4
ICMwOiAgICAgY2FyZD01NiAtPiBQaW5uYWNsZSBIeWJyaWQgUHJvICgzMzBlKQpbMTMwMDcuMDcz
ODgzXSBlbTI4eHggIzA6ICAgICBjYXJkPTU3IC0+IEt3b3JsZCBQbHVzVFYgSEQgSHlicmlkIDMz
MApbMTMwMDcuMDczODg0XSBlbTI4eHggIzA6ICAgICBjYXJkPTU4IC0+IENvbXBybyBWaWRlb01h
dGUgRm9yWW91L1N0ZXJlbwpbMTMwMDcuMDczODg2XSBlbTI4eHggIzA6ICAgICBjYXJkPTU5IC0+
IChudWxsKQpbMTMwMDcuMDczODg3XSBlbTI4eHggIzA6ICAgICBjYXJkPTYwIC0+IEhhdXBwYXVn
ZSBXaW5UViBIVlIgODUwClsxMzAwNy4wNzM4ODhdIGVtMjh4eCAjMDogICAgIGNhcmQ9NjEgLT4g
UGl4ZWx2aWV3IFBsYXlUViBCb3ggNCBVU0IgMi4wClsxMzAwNy4wNzM4ODldIGVtMjh4eCAjMDog
ICAgIGNhcmQ9NjIgLT4gR2FkbWVpIFRWUjIwMApbMTMwMDcuMDczODkwXSBlbTI4eHggIzA6ICAg
ICBjYXJkPTYzIC0+IEthaW9teSBUVm5QQyBVMgpbMTMwMDcuMDczODkyXSBlbTI4eHggIzA6ICAg
ICBjYXJkPTY0IC0+IEVhc3kgQ2FwIENhcHR1cmUgREMtNjAKWzEzMDA3LjA3Mzg5M10gZW0yOHh4
ICMwOiAgICAgY2FyZD02NSAtPiBJTy1EQVRBIEdWLU1WUC9TWgpbMTMwMDcuMDczODk0XSBlbTI4
eHggIzA6ICAgICBjYXJkPTY2IC0+IEVtcGlyZSBkdWFsIFRWClsxMzAwNy4wNzM4OTVdIGVtMjh4
eCAjMDogICAgIGNhcmQ9NjcgLT4gVGVycmF0ZWMgR3JhYmJ5ClsxMzAwNy4wNzM4OTZdIGVtMjh4
eCAjMDogICAgIGNhcmQ9NjggLT4gVGVycmF0ZWMgQVYzNTAKWzEzMDA3LjA3Mzg5N10gZW0yOHh4
ICMwOiAgICAgY2FyZD02OSAtPiBLV29ybGQgQVRTQyAzMTVVIEhEVFYgVFYgQm94ClsxMzAwNy4w
NzM4OTldIGVtMjh4eCAjMDogICAgIGNhcmQ9NzAgLT4gRXZnYSBpbkR0dWJlClsxMzAwNy4wNzM5
MDBdIGVtMjh4eCAjMDogICAgIGNhcmQ9NzEgLT4gU2lsdmVyY3Jlc3QgV2ViY2FtIDEuM21waXgK
WzEzMDA3LjA3MzkwMV0gZW0yOHh4ICMwOiAgICAgY2FyZD03MiAtPiBHYWRtZWkgVVRWMzMwKwpb
MTMwMDcuMDczOTAyXSBlbTI4eHggIzA6ICAgICBjYXJkPTczIC0+IFJlZGRvIERWQi1DIFVTQiBU
ViBCb3gKWzEzMDA3LjA3MzkwNF0gZW0yOHh4ICMwOiAgICAgY2FyZD03NCAtPiBBY3Rpb25tYXN0
ZXIvTGluWGNlbC9EaWdpdHVzIFZDMjExQQpbMTMwMDcuMDczOTA1XSBlbTI4eHggIzA6ICAgICBj
YXJkPTc1IC0+IERpa29tIERLMzAwClsxMzAwNy4wNzM5MDZdIGVtMjh4eCAjMDogICAgIGNhcmQ9
NzYgLT4gS1dvcmxkIFBsdXNUViAzNDBVIG9yIFVCNDM1LVEgKEFUU0MpClsxMzAwNy4wNzM5MDdd
IGVtMjh4eCAjMDogICAgIGNhcmQ9NzcgLT4gRU0yODc0IExlYWRlcnNoaXAgSVNEQlQKWzEzMDA3
LjA3MzkwOV0gZW0yOHh4ICMwOiAgICAgY2FyZD03OCAtPiBQQ1RWIG5hbm9TdGljayBUMiAyOTBl
ClsxMzAwNy4wNzM5MTBdIGVtMjh4eCAjMDogICAgIGNhcmQ9NzkgLT4gVGVycmF0ZWMgQ2luZXJn
eSBINQpbMTMwMDcuMjU4ODU1XSBlbTI4eHggIzA6IENvbmZpZyByZWdpc3RlciByYXcgZGF0YTog
MHg1MApbMTMwMDcuMjcwODQ4XSBlbTI4eHggIzA6IEFDOTcgdmVuZG9yIElEID0gMHg4Mzg0NzY1
MApbMTMwMDcuMjc2ODk5XSBlbTI4eHggIzA6IEFDOTcgZmVhdHVyZXMgPSAweDZhOTAKWzEzMDA3
LjI3NjkwMV0gZW0yOHh4ICMwOiBTaWdtYXRlbCBhdWRpbyBwcm9jZXNzb3IgZGV0ZWN0ZWQoc3Rh
YyA5NzUwKQpbMTMwMDcuNDkxNTg3XSBlbTI4eHggIzA6IHY0bDIgZHJpdmVyIHZlcnNpb24gMC4x
LjMKWzEzMDA3Ljk1Mjk4NV0gZW0yOHh4ICMwOiBWNEwyIHZpZGVvIGRldmljZSByZWdpc3RlcmVk
IGFzIHZpZGVvMApbMTMwMDcuOTUyOTg4XSBlbTI4eHggIzA6IFY0TDIgVkJJIGRldmljZSByZWdp
c3RlcmVkIGFzIHZiaTAKWzEzMDA3Ljk1ODkwNF0gQUxTQSBzb3VuZC91c2IvbWl4ZXIuYzo4NDUg
MjoxOiBjYW5ub3QgZ2V0IG1pbi9tYXggdmFsdWVzIGZvciBjb250cm9sIDIgKGlkIDIpCgo=
--14dae93406e32dbbf904b5a4eda4
Content-Type: text/plain; charset=US-ASCII; name="stv40_dmesg_af9015.txt"
Content-Disposition: attachment; filename="stv40_dmesg_af9015.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gwzb9t6w1

WzE0MDMzLjc1Nzc5MF0gdXNiIDEtNS4zOiBuZXcgaGlnaCBzcGVlZCBVU0IgZGV2aWNlIG51bWJl
ciAxMyB1c2luZyBlaGNpX2hjZApbMTQwMzMuODQ5MzUwXSB1c2IgMS01LjM6IE5ldyBVU0IgZGV2
aWNlIGZvdW5kLCBpZFZlbmRvcj0xYjgwLCBpZFByb2R1Y3Q9ZTMwOQpbMTQwMzMuODQ5MzU1XSB1
c2IgMS01LjM6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0wLCBQcm9kdWN0PTEsIFNlcmlh
bE51bWJlcj0wClsxNDAzMy44NDkzNThdIHVzYiAxLTUuMzogUHJvZHVjdDogVVNCIDI4NjEgRGV2
aWNlIChTVkVPTiBTVFY0MCkKWzE0MDMzLjg0OTg4Ml0gYWY5MDE1OiBidWxrIG1lc3NhZ2UgZmFp
bGVkOi0yMiAoOC8tMzA3MTgpClsxNDAzMy44NDk4ODVdIGFmOTAxNTogYnVsayBtZXNzYWdlIGZh
aWxlZDotMjIgKDgvLTMwNzE4KQpbMTQwMzMuODQ5ODg3XSBhZjkwMTU6IGJ1bGsgbWVzc2FnZSBm
YWlsZWQ6LTIyICg4Ly0zMDcxOCkKWzE0MDMzLjg0OTg4OV0gYWY5MDE1OiBidWxrIG1lc3NhZ2Ug
ZmFpbGVkOi0yMiAoOC8tMzA3MTgpClsxNDAzMy44NDk4OTBdIGFmOTAxNTogZWVwcm9tIHJlYWQg
ZmFpbGVkOi0yMgpbMTQwMzMuODQ5ODk0XSBkdmJfdXNiX2FmOTAxNTogcHJvYmUgb2YgMS01LjM6
MS4wIGZhaWxlZCB3aXRoIGVycm9yIC0yMgpbMTQwMzMuODU1Njk4XSBBTFNBIHNvdW5kL3VzYi9t
aXhlci5jOjg0NSAyOjE6IGNhbm5vdCBnZXQgbWluL21heCB2YWx1ZXMgZm9yIGNvbnRyb2wgMiAo
aWQgMikK
--14dae93406e32dbbf904b5a4eda4--
