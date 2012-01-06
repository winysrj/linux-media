Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:54775 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758808Ab2AFRtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 12:49:07 -0500
Received: by obcwo16 with SMTP id wo16so2144285obc.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 09:49:07 -0800 (PST)
MIME-Version: 1.0
From: Mario Ceresa <mrceresa@gmail.com>
Date: Fri, 6 Jan 2012 18:48:46 +0100
Message-ID: <CAHVY3enRbcw-xKthuog5LXGMc_2tUAa0+owqbDm+C00mdWhV7w@mail.gmail.com>
Subject: em28xx: no sound on board 1b80:e309 (sveon stv40)
To: V4L Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=14dae934042d58313f04b5dfaa00
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--14dae934042d58313f04b5dfaa00
Content-Type: text/plain; charset=ISO-8859-1

Hello again!

I managed to obtain a nice video input from my sveon usb stick using
last em28xx v4l drivers from git and giving the module the hint
card=19.

But I have no audio.The card works flawlessy in windows.

The internal chipsets in the card are:
- USB interface: em2860
- Audio ADC: emp202
- Video ADC: saa7118h (philips)

Attached is the relevant dmseg output.

The usb audio card card correctly shows in pulseaudio volume control
and is recognized as hw.2 by alsa:
$ arecord -l
**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: AD198x Analog [AD198x Analog]
  Subdevices: 3/3
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
  Subdevice #2: subdevice #2
card 2: STV40 [USB 2861 Device (SVEON STV40)], device 0: USB Audio [USB Audio]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

However, I'm not able to record any sound from it and mplayer says "no audio":
$ mplayer -tv device=/dev/video0:input=1:norm=PAL:alsa:immediatemode=0:audiorate=48000:amode=1:adevice=hw.2
tv://
MPlayer SVN-r33996-4.6.1 (C) 2000-2011 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: EM2860/SAA711X Reference Design
 Capabilities:  video capture  VBI capture device  audio  read/write  streaming
 supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR;
4 = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK;
10 = PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 =
SECAM-B; 16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20 =
SECAM-Lc;
 inputs: 0 = S-Video; 1 = Composite1;
 Current input: 1
 Current format: YUYV
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
Selected input hasn't got a tuner!
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
Movie-Aspect is undefined - no prescaling applied.
VO: [vdpau] 640x480 => 640x480 Packed YUY2
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
==========================================================================
Audio: no sound
Starting playback...
V:   2.0  52/ 52  0%  5%  0.0% 0 0
v4l2: 59 frames successfully processed, 0 frames dropped.

Maybe has something to do with the last line in dmesg:

[  403.359333] ALSA sound/usb/mixer.c:845 2:1: cannot get min/max
values for control 2 (id 2)

Any ideas?

Mario

--14dae934042d58313f04b5dfaa00
Content-Type: text/plain; charset=US-ASCII; name="em28xx_v4l_noaudio.txt"
Content-Disposition: attachment; filename="em28xx_v4l_noaudio.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx3hbhhe0

WyAgMzg5LjQ5MTQ4OF0gTGludXggdmlkZW8gY2FwdHVyZSBpbnRlcmZhY2U6IHYyLjAwClsgIDM4
OS40OTE0OTBdIFdBUk5JTkc6IFlvdSBhcmUgdXNpbmcgYW4gZXhwZXJpbWVudGFsIHZlcnNpb24g
b2YgdGhlIG1lZGlhIHN0YWNrLgpbICAzODkuNDkxNDkxXSAgQXMgdGhlIGRyaXZlciBpcyBiYWNr
cG9ydGVkIHRvIGFuIG9sZGVyIGtlcm5lbCwgaXQgZG9lc24ndCBvZmZlcgpbICAzODkuNDkxNDkx
XSAgZW5vdWdoIHF1YWxpdHkgZm9yIGl0cyB1c2FnZSBpbiBwcm9kdWN0aW9uLgpbICAzODkuNDkx
NDkyXSAgVXNlIGl0IHdpdGggY2FyZS4KWyAgMzg5LjQ5MTQ5Ml0gTGF0ZXN0IGdpdCBwYXRjaGVz
IChuZWVkZWQgaWYgeW91IHJlcG9ydCBhIGJ1ZyB0byBsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5v
cmcpOgpbICAzODkuNDkxNDkzXSAgMWU3M2ZhNWQ1NjMzMzIzMDg1NGFlOTQ2MDU3OWViMmZjZWU4
YWYwMiBbbWVkaWFdIHN0YjYxMDA6IFByb3Blcmx5IHJldHJpZXZlIHN5bWJvbCByYXRlClsgIDM4
OS40OTE0OTRdICBlOTdhNWQ4OTNmZGY0NWMyMDc5OWI3MmExYzExZGNhM2IyODJjODljIFttZWRp
YV0gZnMvY29tcGF0X2lvY3RsOiBpdCBuZWVkcyB0byBzZWUgdGhlIERWQnYzIGNvbXBhdCBzdHVm
ZgpbICAzODkuNDkxNDk1XSAgNTNjOTEzNzNiZGQ3NGY3ZTExZDI3MjYwNDZhOTBiOTg2YzFlZDY1
MCBbbWVkaWFdIGR2YjogcmVtb3ZlIHRoZSBleHRyYSBwYXJhbWV0ZXIgb24gZ2V0X2Zyb250ZW5k
ClsgIDM4OS41MTgyMTNdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIg
ZW0yOHh4ClsgIDM4OS41MTgyMTVdIGVtMjh4eCBkcml2ZXIgbG9hZGVkClsgIDQwMS43NTQwNzZd
IHVzYiAxLTUuMzogbmV3IGhpZ2ggc3BlZWQgVVNCIGRldmljZSBudW1iZXIgNCB1c2luZyBlaGNp
X2hjZApbICA0MDEuODQ0NjU1XSB1c2IgMS01LjM6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZl
bmRvcj0xYjgwLCBpZFByb2R1Y3Q9ZTMwOQpbICA0MDEuODQ0NjU4XSB1c2IgMS01LjM6IE5ldyBV
U0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0wLCBQcm9kdWN0PTEsIFNlcmlhbE51bWJlcj0wClsgIDQw
MS44NDQ2NjBdIHVzYiAxLTUuMzogUHJvZHVjdDogVVNCIDI4NjEgRGV2aWNlIChTVkVPTiBTVFY0
MCkKWyAgNDAxLjg0NTY5NF0gZW0yOHh4OiBOZXcgZGV2aWNlIFVTQiAyODYxIERldmljZSAoU1ZF
T04gU1RWNDApIEAgNDgwIE1icHMgKDFiODA6ZTMwOSwgaW50ZXJmYWNlIDAsIGNsYXNzIDApClsg
IDQwMS44NDU4MjhdIGVtMjh4eCAjMDogY2hpcCBJRCBpcyBlbTI4NjAKWyAgNDAxLjk0Nzk5M10g
ZW0yOHh4ICMwOiBpMmMgZWVwcm9tIDAwOiAxYSBlYiA2NyA5NSA4MCAxYiAwOSBlMyA1MCAwMCAy
MCAwMyA2YSAzYyAwMCAwMApbICA0MDEuOTQ4MDAwXSBlbTI4eHggIzA6IGkyYyBlZXByb20gMTA6
IDAwIDAwIDA0IDU3IDA2IDAyIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwClsgIDQwMS45
NDgwMDVdIGVtMjh4eCAjMDogaTJjIGVlcHJvbSAyMDogMDIgMDAgMDEgMDAgZjAgMDAgMDEgMDAg
MDAgMDAgMDAgMDAgNWIgMDAgMDAgMDAKWyAgNDAxLjk0ODAxMF0gZW0yOHh4ICMwOiBpMmMgZWVw
cm9tIDMwOiAwMCAwMCAyMCA0MCAyMCA4MCAwMiAyMCAwMSAwMSAwMiAwMSAwMCAwMCAwMCAwMApb
ICA0MDEuOTQ4MDE1XSBlbTI4eHggIzA6IGkyYyBlZXByb20gNDA6IDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwClsgIDQwMS45NDgwMjBdIGVtMjh4eCAjMDog
aTJjIGVlcHJvbSA1MDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKWyAgNDAxLjk0ODAyNV0gZW0yOHh4ICMwOiBpMmMgZWVwcm9tIDYwOiAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAzYyAwMyA1NSAwMCA1MyAwMApbICA0MDEuOTQ4MDMwXSBlbTI4
eHggIzA6IGkyYyBlZXByb20gNzA6IDQyIDAwIDIwIDAwIDMyIDAwIDM4IDAwIDM2IDAwIDMxIDAw
IDIwIDAwIDQ0IDAwClsgIDQwMS45NDgwMzVdIGVtMjh4eCAjMDogaTJjIGVlcHJvbSA4MDogNjUg
MDAgNzYgMDAgNjkgMDAgNjMgMDAgNjUgMDAgMjAgMDAgMjggMDAgNTMgMDAKWyAgNDAxLjk0ODA0
MF0gZW0yOHh4ICMwOiBpMmMgZWVwcm9tIDkwOiA1NiAwMCA0NSAwMCA0ZiAwMCA0ZSAwMCAyMCAw
MCA1MyAwMCA1NCAwMCA1NiAwMApbICA0MDEuOTQ4MDQ1XSBlbTI4eHggIzA6IGkyYyBlZXByb20g
YTA6IDM0IDAwIDMwIDAwIDI5IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwClsgIDQw
MS45NDgwNTBdIGVtMjh4eCAjMDogaTJjIGVlcHJvbSBiMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKWyAgNDAxLjk0ODA1NV0gZW0yOHh4ICMwOiBpMmMg
ZWVwcm9tIGMwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MApbICA0MDEuOTQ4MDYwXSBlbTI4eHggIzA6IGkyYyBlZXByb20gZDA6IDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwClsgIDQwMS45NDgwNjVdIGVtMjh4eCAj
MDogaTJjIGVlcHJvbSBlMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAKWyAgNDAxLjk0ODA3MF0gZW0yOHh4ICMwOiBpMmMgZWVwcm9tIGYwOiAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApbICA0MDEuOTQ4MDc2XSBl
bTI4eHggIzA6IEVFUFJPTSBJRD0gMHg5NTY3ZWIxYSwgRUVQUk9NIGhhc2ggPSAweGEzOTYzMDQw
ClsgIDQwMS45NDgwNzddIGVtMjh4eCAjMDogRUVQUk9NIGluZm86ClsgIDQwMS45NDgwNzhdIGVt
Mjh4eCAjMDogICAgICAgQUM5NyBhdWRpbyAoNSBzYW1wbGUgcmF0ZXMpClsgIDQwMS45NDgwNzld
IGVtMjh4eCAjMDogICAgICAgNTAwbUEgbWF4IHBvd2VyClsgIDQwMS45NDgwODFdIGVtMjh4eCAj
MDogICAgICAgVGFibGUgYXQgMHgwNCwgc3RyaW5ncz0weDNjNmEsIDB4MDAwMCwgMHgwMDAwClsg
IDQwMS45NDkzNjVdIGVtMjh4eCAjMDogSWRlbnRpZmllZCBhcyBFTTI4NjAvU0FBNzExWCBSZWZl
cmVuY2UgRGVzaWduIChjYXJkPTE5KQpbICA0MDIuMTYwMzQxXSBzYWE3MTE1IDUtMDAyNTogc2Fh
NzExMyBmb3VuZCAoMWY3MTEzZDBlMTAwMDAwKSBAIDB4NGEgKGVtMjh4eCAjMCkKWyAgNDAyLjU0
NjAzOF0gZW0yOHh4ICMwOiBDb25maWcgcmVnaXN0ZXIgcmF3IGRhdGE6IDB4NTAKWyAgNDAyLjU1
Nzg4OF0gZW0yOHh4ICMwOiBBQzk3IHZlbmRvciBJRCA9IDB4ODM4NDc2NTAKWyAgNDAyLjU2Mzc3
Ml0gZW0yOHh4ICMwOiBBQzk3IGZlYXR1cmVzID0gMHg2YTkwClsgIDQwMi41NjM3NzNdIGVtMjh4
eCAjMDogU2lnbWF0ZWwgYXVkaW8gcHJvY2Vzc29yIGRldGVjdGVkKHN0YWMgOTc1MCkKWyAgNDAy
Ljc5ODY4MV0gZW0yOHh4ICMwOiB2NGwyIGRyaXZlciB2ZXJzaW9uIDAuMS4zClsgIDQwMy4zMTQ3
ODldIGVtMjh4eCAjMDogVjRMMiB2aWRlbyBkZXZpY2UgcmVnaXN0ZXJlZCBhcyB2aWRlbzAKWyAg
NDAzLjMxNDc5MV0gZW0yOHh4ICMwOiBWNEwyIFZCSSBkZXZpY2UgcmVnaXN0ZXJlZCBhcyB2Ymkw
ClsgIDQwMy4zMTQ4MzRdIGVtMjh4eCBhdWRpbyBkZXZpY2UgKDFiODA6ZTMwOSk6IGludGVyZmFj
ZSAxLCBjbGFzcyAxClsgIDQwMy4zMTQ4NjhdIGVtMjh4eCBhdWRpbyBkZXZpY2UgKDFiODA6ZTMw
OSk6IGludGVyZmFjZSAyLCBjbGFzcyAxClsgIDQwMy4zNTkzMzNdIEFMU0Egc291bmQvdXNiL21p
eGVyLmM6ODQ1IDI6MTogY2Fubm90IGdldCBtaW4vbWF4IHZhbHVlcyBmb3IgY29udHJvbCAyIChp
ZCAyKQpbICA0MDMuMzYwMDEzXSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJp
dmVyIHNuZC11c2ItYXVkaW8KCg==
--14dae934042d58313f04b5dfaa00--
