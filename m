Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37304 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2GRKXK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 06:23:10 -0400
Received: by vcbfk26 with SMTP id fk26so967005vcb.19
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2012 03:23:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOLE0zPeaRXNJY9yVwVG0n5tsbgYoqw1pQs7_+2fQoA-K0uS3Q@mail.gmail.com>
References: <CAOLE0zPeaRXNJY9yVwVG0n5tsbgYoqw1pQs7_+2fQoA-K0uS3Q@mail.gmail.com>
Date: Wed, 18 Jul 2012 11:23:09 +0100
Message-ID: <CAOLE0zMrNpNAa9pvVxXhnN6r_NdAYSHJ7wsGCMACOGCmmgBJRA@mail.gmail.com>
Subject: Problems with Asus My Cinema-U3000Hybrid tuner
From: "H. Cristiano Alves Machado" <heberto.machado@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf3079b8aeb10e7804c5180c8d
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--20cf3079b8aeb10e7804c5180c8d
Content-Type: text/plain; charset=ISO-8859-1

Hello.

I have an Asus My Cinema-U3000Hybrid tuner connected in

Bus 002 Device 003: ID 0b05:1736 ASUSTek Computer, Inc.


The modules associated with this device in the current linux kernel are:
Module Used by
rc_dib0700_rc5 12508 0
tuner_xc2028 31235 1
dvb_usb_dib0700 149125 0
dib0090 39179 1 dvb_usb_dib0700
dib7000p 43270 2 dvb_usb_dib0700
dib7000m 23489 1 dvb_usb_dib0700
dib0070 18511 1 dvb_usb_dib0700
dvb_usb 24540 1 dvb_usb_dib0700
dib8000 53374 1 dvb_usb_dib0700
dvb_core 111077 3 dib7000p,dvb_usb,dib8000
dib3000mc 23378 1 dvb_usb_dib0700
rc_core 26422 4 rc_dib0700_rc5,dvb_usb_dib0700,dvb_usb
dibx000_common 18810 5 dvb_usb_dib0700,dib7000p,dib7000m,dib8000,dib3000mc

issuing:

$ uname -a

I get

Linux crisr-Satellite-A300 3.5.0-4-generic #4-Ubuntu SMP Tue Jul 10
04:58:52 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

everytime I try to play dvb-t the image gets distortions and
pixelizations as well as the sound and image lag more than acceptable.


Attached  are readings from dmesg (at connection time first, and then
while using the device)

The second part of the file asus.log refers to the process of checking
the tuning quality parameters at that moment with dvb_apps utility
tzap.

Its readings (tzap's) go below too:


~$ tzap "RTP 1"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/crisr/.tzap/channels.conf'
tuning to 754000000 Hz
video pid 0x0100, audio pid 0x0101
status 1f | signal a92a | snr 00bd | ber 001fffff | unc 00000014 | FE_HAS_LOCK
status 1f | signal a83a | snr 00b6 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a872 | snr 00b0 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a876 | snr 00b1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a8a6 | snr 00b6 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a8bd | snr 00b2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a8d0 | snr 00b5 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a8e9 | snr 00b3 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a903 | snr 00b7 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a916 | snr 00b5 | ber 00000020 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a90f | snr 00b3 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a927 | snr 00b2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a937 | snr 00b6 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a93f | snr 00b6 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a940 | snr 00af | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a95d | snr 00b7 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a971 | snr 00b3 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a977 | snr 00b9 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a984 | snr 00af | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a980 | snr 00b7 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a991 | snr 00b2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a998 | snr 00b0 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a9ad | snr 00b1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a9c2 | snr 00b2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a9b8 | snr 00b8 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a9de | snr 00b2 | ber 00000000 | unc 00000022 | FE_HAS_LOCK
status 1f | signal a9cb | snr 00b4 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a9d5 | snr 00b5 | ber 00000000 | unc 00000015 | FE_HAS_LOCK
status 1f | signal a9b4 | snr 00b3 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a9e2 | snr 00b1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a9d7 | snr 00b2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a9cc | snr 00b1 | ber 00001450 | unc 0000004b | FE_HAS_LOCK
status 1f | signal a9ec | snr 00b3 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal a9e2 | snr 00b4 | ber 00001a80 | unc 0000001d | FE_HAS_LOCK
status 1f | signal aa0d | snr 00b3 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal a9fc | snr 00b2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal aa05 | snr 00b4 | ber 00001650 | unc 00000000 | FE_HAS_LOCK
status 1f | signal aa13 | snr 00b0 | ber 00000ca0 | unc 00000020 | FE_HAS_LOCK
status 1f | signal aa19 | snr 00b5 | ber 00000250 | unc 00000033 | FE_HAS_LOCK
status 1f | signal aa38 | snr 00b2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
^C
~$

Hope there can be any solution to these problems.

Finally I would like to say that with the same set up, in windows
there are no such problems.

I am trying a long time now to set this system up here in linux and I
have strong reasons to do so:

Besides becoming more and more fond of linux, I could also get to the
point of its ability to use dvblast from vlc and therefore stream
dvb-t channels in the local area network.

Can anybody help?

Best regards!

--
Heberto Cristiano Machado

heberto.machado@gmail.com



--
Heberto Cristiano Machado

heberto.machado@gmail.com

--20cf3079b8aeb10e7804c5180c8d
Content-Type: application/octet-stream; name="asus cortado.log"
Content-Disposition: attachment; filename="asus cortado.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h4s9bv1r0

WyAyNDExLjcxMjMxMV0gdXNiIDItMzogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIg
MyB1c2luZyBlaGNpX2hjZApbIDI0MTIuMTMwMTQyXSBkdmItdXNiOiBmb3VuZCBhICdBc3VzIE15
IENpbmVtYS1VMzAwMEh5YnJpZCcgaW4gY29sZCBzdGF0ZSwgd2lsbCB0cnkgdG8gbG9hZCBhIGZp
cm13YXJlClsgMjQxMi4yMDc2MDRdIGR2Yi11c2I6IGRvd25sb2FkaW5nIGZpcm13YXJlIGZyb20g
ZmlsZSAnZHZiLXVzYi1kaWIwNzAwLTEuMjAuZncnClsgMjQxMi40MTMzOTFdIGRpYjA3MDA6IGZp
cm13YXJlIHN0YXJ0ZWQgc3VjY2Vzc2Z1bGx5LgpbIDI0MTIuOTE2MzY5XSBkdmItdXNiOiBmb3Vu
ZCBhICdBc3VzIE15IENpbmVtYS1VMzAwMEh5YnJpZCcgaW4gd2FybSBzdGF0ZS4KWyAyNDEyLjkx
NzU2Nl0gZHZiLXVzYjogd2lsbCBwYXNzIHRoZSBjb21wbGV0ZSBNUEVHMiB0cmFuc3BvcnQgc3Ry
ZWFtIHRvIHRoZSBzb2Z0d2FyZSBkZW11eGVyLgpbIDI0MTIuOTE3NjkxXSBEVkI6IHJlZ2lzdGVy
aW5nIG5ldyBhZGFwdGVyIChBc3VzIE15IENpbmVtYS1VMzAwMEh5YnJpZCkKWyAyNDEzLjE4OTYy
Ml0gRFZCOiByZWdpc3RlcmluZyBhZGFwdGVyIDAgZnJvbnRlbmQgMCAoRGlCY29tIDcwMDBQQyku
Li4KWyAyNDEzLjIyMzQyOV0geGMyMDI4IDYtMDA2MTogY3JlYXRpbmcgbmV3IGluc3RhbmNlClsg
MjQxMy4yMjM0MzldIHhjMjAyOCA2LTAwNjE6IHR5cGUgc2V0IHRvIFhDZWl2ZSB4YzIwMjgveGMz
MDI4IHR1bmVyClsgMjQxMy4yNzIwODJdIFJlZ2lzdGVyZWQgSVIga2V5bWFwIHJjLWRpYjA3MDAt
cmM1ClsgMjQxMy4yNzI3NTldIGlucHV0OiBJUi1yZWNlaXZlciBpbnNpZGUgYW4gVVNCIERWQiBy
ZWNlaXZlciBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MWQuNy91c2IyLzItMy9yYy9y
YzAvaW5wdXQxMQpbIDI0MTMuMjcyOTg2XSByYzA6IElSLXJlY2VpdmVyIGluc2lkZSBhbiBVU0Ig
RFZCIHJlY2VpdmVyIGFzIC9kZXZpY2VzL3BjaTAwMDA6MDAvMDAwMDowMDoxZC43L3VzYjIvMi0z
L3JjL3JjMApbIDI0MTMuMjczMjE3XSBkdmItdXNiOiBzY2hlZHVsZSByZW1vdGUgcXVlcnkgaW50
ZXJ2YWwgdG8gNTAgbXNlY3MuClsgMjQxMy4yNzMyMjVdIGR2Yi11c2I6IEFzdXMgTXkgQ2luZW1h
LVUzMDAwSHlicmlkIHN1Y2Nlc3NmdWxseSBpbml0aWFsaXplZCBhbmQgY29ubmVjdGVkLgpbIDI0
MTMuMjc1NTUwXSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91
c2JfZGliMDcwMAoKCgoKCgoKCgoKCgoKClsgMzU5NC4xMDUyMzZdIHhjMjAyOCA2LTAwNjE6IExv
YWRpbmcgODAgZmlybXdhcmUgaW1hZ2VzIGZyb20geGMzMDI4LXYyNy5mdywgdHlwZTogeGMyMDI4
IGZpcm13YXJlLCB2ZXIgMi43ClsgMzU5NC4xMjk5OTddIHhjMjAyOCA2LTAwNjE6IExvYWRpbmcg
ZmlybXdhcmUgZm9yIHR5cGU9QkFTRSBGOE1IWiAoMyksIGlkIDAwMDAwMDAwMDAwMDAwMDAuClsg
MzU5NS41MjE2MTZdIGRpYjA3MDA6IHN0azc3MDBwaF94YzMwMjhfY2FsbGJhY2s6IHVua25vd24g
Y29tbWFuZCAyLCBhcmcgMApbIDM1OTUuNTIxNjE2XSAKWyAzNTk1LjUyNTc4OV0gZGliMDcwMDog
c3RrNzcwMHBoX3hjMzAyOF9jYWxsYmFjazogdW5rbm93biBjb21tYW5kIDIsIGFyZyAwClsgMzU5
NS41MjU3ODldIApbIDM1OTUuNTI5OTE3XSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxi
YWNrOiB1bmtub3duIGNvbW1hbmQgMiwgYXJnIDAKWyAzNTk1LjUyOTkxN10gClsgMzU5NS41MzQw
MzRdIGRpYjA3MDA6IHN0azc3MDBwaF94YzMwMjhfY2FsbGJhY2s6IHVua25vd24gY29tbWFuZCAy
LCBhcmcgMApbIDM1OTUuNTM0MDM0XSAKWyAzNTk1LjUzODkwOV0gZGliMDcwMDogc3RrNzcwMHBo
X3hjMzAyOF9jYWxsYmFjazogdW5rbm93biBjb21tYW5kIDIsIGFyZyAwClsgMzU5NS41Mzg5MDld
IApbIDM1OTUuNjQ1NDk4XSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxiYWNrOiB1bmtu
b3duIGNvbW1hbmQgMiwgYXJnIDAKWyAzNTk1LjY0NTQ5OF0gClsgMzU5NS42NTA0MTNdIGRpYjA3
MDA6IHN0azc3MDBwaF94YzMwMjhfY2FsbGJhY2s6IHVua25vd24gY29tbWFuZCAyLCBhcmcgMApb
IDM1OTUuNjUwNDEzXSAKWyAzNTk1LjY1NTI4MV0gZGliMDcwMDogc3RrNzcwMHBoX3hjMzAyOF9j
YWxsYmFjazogdW5rbm93biBjb21tYW5kIDIsIGFyZyAwClsgMzU5NS42NTUyODFdIApbIDM1OTUu
NjYwMzc2XSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxiYWNrOiB1bmtub3duIGNvbW1h
bmQgMiwgYXJnIDAKWyAzNTk1LjY2MDM3Nl0gClsgMzU5NS42NjU1NDRdIGRpYjA3MDA6IHN0azc3
MDBwaF94YzMwMjhfY2FsbGJhY2s6IHVua25vd24gY29tbWFuZCAyLCBhcmcgMApbIDM1OTUuNjY1
NTQ0XSAKWyAzNTk1LjY3MDQxOF0gZGliMDcwMDogc3RrNzcwMHBoX3hjMzAyOF9jYWxsYmFjazog
dW5rbm93biBjb21tYW5kIDIsIGFyZyAwClsgMzU5NS42NzA0MThdIApbIDM1OTUuNjc1MjkxXSBk
aWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxiYWNrOiB1bmtub3duIGNvbW1hbmQgMiwgYXJn
IDAKWyAzNTk1LjY3NTI5MV0gClsgMzU5NS42ODAxNjddIGRpYjA3MDA6IHN0azc3MDBwaF94YzMw
MjhfY2FsbGJhY2s6IHVua25vd24gY29tbWFuZCAyLCBhcmcgMApbIDM1OTUuNjgwMTY3XSAKCgoK
CgoKWyAzNjAwLjM1OTUxOV0gClsgMzYwMC4zNjM2NDRdIGRpYjA3MDA6IHN0azc3MDBwaF94YzMw
MjhfY2FsbGJhY2s6IHVua25vd24gY29tbWFuZCAyLCBhcmcgMApbIDM2MDAuMzYzNjQ0XSAKWyAz
NjAwLjM2MzY1Nl0geGMyMDI4IDYtMDA2MTogTG9hZGluZyBmaXJtd2FyZSBmb3IgdHlwZT1EMjYy
MCBEVFY4ICgyMDgpLCBpZCAwMDAwMDAwMDAwMDAwMDAwLgpbIDM2MDAuMzY4NTM5XSBkaWIwNzAw
OiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxiYWNrOiB1bmtub3duIGNvbW1hbmQgMiwgYXJnIDAKWyAz
NjAwLjM2ODUzOV0gClsgMzYwMC4zNzM2NzhdIGRpYjA3MDA6IHN0azc3MDBwaF94YzMwMjhfY2Fs
bGJhY2s6IHVua25vd24gY29tbWFuZCAyLCBhcmcgMApbIDM2MDAuMzczNjc4XSAKWyAzNjAwLjM3
Nzc4Nl0gZGliMDcwMDogc3RrNzcwMHBoX3hjMzAyOF9jYWxsYmFjazogdW5rbm93biBjb21tYW5k
IDIsIGFyZyAwClsgMzYwMC4zNzc3ODZdIApbIDM2MDAuMzg1OTk3XSBkaWIwNzAwOiBzdGs3NzAw
cGhfeGMzMDI4X2NhbGxiYWNrOiB1bmtub3duIGNvbW1hbmQgMiwgYXJnIDAKWyAzNjAwLjM4NTk5
N10gClsgMzYwMC4zOTQyOThdIGRpYjA3MDA6IHN0azc3MDBwaF94YzMwMjhfY2FsbGJhY2s6IHVu
a25vd24gY29tbWFuZCAyLCBhcmcgMApbIDM2MDAuMzk0Mjk4XSAKWyAzNjAwLjQwMzM3MV0gZGli
MDcwMDogc3RrNzcwMHBoX3hjMzAyOF9jYWxsYmFjazogdW5rbm93biBjb21tYW5kIDIsIGFyZyAw
ClsgMzYwMC40MDMzNzFdIApbIDM2MDAuNDA3NTIxXSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4
X2NhbGxiYWNrOiB1bmtub3duIGNvbW1hbmQgMiwgYXJnIDAKWyAzNjAwLjQwNzUyMV0gClsgMzYw
MC40MTE2NDVdIGRpYjA3MDA6IHN0azc3MDBwaF94YzMwMjhfY2FsbGJhY2s6IHVua25vd24gY29t
bWFuZCAyLCBhcmcgMApbIDM2MDAuNDExNjQ1XSAKWyAzNjAwLjQxOTY2MV0gZGliMDcwMDogc3Rr
NzcwMHBoX3hjMzAyOF9jYWxsYmFjazogdW5rbm93biBjb21tYW5kIDIsIGFyZyAwClsgMzYwMC40
MTk2NjFdIApbIDM2MDAuNDIzNzYzXSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxiYWNr
OiB1bmtub3duIGNvbW1hbmQgMiwgYXJnIDAKWyAzNjAwLjQyMzc2M10gClsgMzYwMC40Mjk5MTBd
IGRpYjA3MDA6IHN0azc3MDBwaF94YzMwMjhfY2FsbGJhY2s6IHVua25vd24gY29tbWFuZCAyLCBh
cmcgMApbIDM2MDAuNDI5OTEwXSAKWyAzNjAwLjQzNDAzOF0gZGliMDcwMDogc3RrNzcwMHBoX3hj
MzAyOF9jYWxsYmFjazogdW5rbm93biBjb21tYW5kIDIsIGFyZyAwClsgMzYwMC40MzQwMzhdIApb
IDM2MDAuNDQyMDQyXSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxiYWNrOiB1bmtub3du
IGNvbW1hbmQgMiwgYXJnIDAKWyAzNjAwLjQ0MjA0Ml0gClsgMzYwMC40NDYxNDVdIGRpYjA3MDA6
IHN0azc3MDBwaF94YzMwMjhfY2FsbGJhY2s6IHVua25vd24gY29tbWFuZCAyLCBhcmcgMApbIDM2
MDAuNDQ2MTQ1XSAKWyAzNjAwLjQ1MDI2OV0gZGliMDcwMDogc3RrNzcwMHBoX3hjMzAyOF9jYWxs
YmFjazogdW5rbm93biBjb21tYW5kIDIsIGFyZyAwClsgMzYwMC40NTAyNjldIApbIDM2MDAuNDU3
MTY0XSBkaWIwNzAwOiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxiYWNrOiB1bmtub3duIGNvbW1hbmQg
MiwgYXJnIDAKWyAzNjAwLjQ1NzE2NF0gClsgMzYwMC40NjE1MzldIGRpYjA3MDA6IHN0azc3MDBw
aF94YzMwMjhfY2FsbGJhY2s6IHVua25vd24gY29tbWFuZCAyLCBhcmcgMApbIDM2MDAuNDYxNTM5
XSAKWyAzNjAwLjQ2NTY0M10gZGliMDcwMDogc3RrNzcwMHBoX3hjMzAyOF9jYWxsYmFjazogdW5r
bm93biBjb21tYW5kIDIsIGFyZyAwClsgMzYwMC40NjU2NDNdIApbIDM2MDAuNDY5NzY5XSBkaWIw
NzAwOiBzdGs3NzAwcGhfeGMzMDI4X2NhbGxiYWNrOiB1bmtub3duIGNvbW1hbmQgMiwgYXJnIDAK
WyAzNjAwLjQ2OTc2OV0gClsgMzYwMC40NzQ2NDVdIGRpYjA3MDA6IHN0azc3MDBwaF94YzMwMjhf
Y2FsbGJhY2s6IHVua25vd24gY29tbWFuZCAyLCBhcmcgMApbIDM2MDAuNDc0NjQ1XSAKWyAzNjAw
LjQ3NDY1NF0geGMyMDI4IDYtMDA2MTogTG9hZGluZyBTQ09ERSBmb3IgdHlwZT1EVFY3IERUVjc4
IERUVjggRElCQ09NNTIgQ0hJTkEgU0NPREUgSEFTX0lGXzU0MDAgKDY1MDAwMzgwKSwgaWQgMDAw
MDAwMDAwMDAwMDAwMC4KWyAzNjQxLjUzMDIzOV0gZGliMDcwMDogY291bGQgbm90IGFjcXVpcmUg
bG9jawpbIDM2NDEuNTMwMjUwXSBkdmItdXNiOiBlcnJvciB3aGlsZSBzdG9wcGluZyBzdHJlYW0u
Cgo=
--20cf3079b8aeb10e7804c5180c8d--
