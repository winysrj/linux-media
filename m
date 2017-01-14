Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:36065 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750721AbdANXcy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Jan 2017 18:32:54 -0500
Received: by mail-qk0-f173.google.com with SMTP id 11so88136930qkl.3
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2017 15:32:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbzfgb0VYBuh47mLjZGq+5OP=yhAYgS-mD3PQ0RZ104mMA@mail.gmail.com>
References: <CAEm3SNCszAdpYYHjv3chxYNH2qDJtKoRdQzNO=konoGcZsou-g@mail.gmail.com>
 <CAOcJUbzfgb0VYBuh47mLjZGq+5OP=yhAYgS-mD3PQ0RZ104mMA@mail.gmail.com>
From: Justin Husted <valentinej@gmail.com>
Date: Sat, 14 Jan 2017 15:32:53 -0800
Message-ID: <CAEm3SNAumcu_zihHw2sw-Lavh1fcD1TxN43z96C13e2FZRXbYQ@mail.gmail.com>
Subject: Re: Problem with Hauppauge WinTV-HVR-1250
To: Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11482b54990bb50546165e41
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001a11482b54990bb50546165e41
Content-Type: text/plain; charset=UTF-8

On Sat, Jan 14, 2017 at 8:01 AM, Michael Ira Krufky <mkrufky@linuxtv.org> wrote:
>
> On Fri, Jan 13, 2017 at 11:56 PM, Justin Husted <valentinej@gmail.com> wrote:
> > Hi!
> >
> > I recently got one of these cards on ebay to do some analog video capturing,
> > and I'm having a few problems with it on the 4.4.0 kernel.
> >
> > I wasn't really sure who the maintainer is for this stuff, but I saw your
> > name in the Linux MAINTAINERS file for the tda18271, which seems to be one
> > of the relevant drivers. :-)
> >
> > Are you the person to talk to, or do you know who is?
>
> Justin,
>
> Better to email the linux-media mailing list on kernel.org with this
> type of question (cc added)

Ok, thanks!

> What is the problem that you're having in the 4.4.0 kernel?

There are two fundamental problems. Note that I'm just attempting to
use this card as an analog video capture card, using the RCA plug.

== Sleep / Reference Leak ==

The first problem is less important, but is clearly annoying: the card
does not work after sleep/resume, and I can't try the typical approach
of adding a special module unload/reload rule because it appears to
have a reference leak.

I'm seeing that there is (usually) one reference to cx25840 and
cx23885 at all times, plus extra references if a capture is actually
going on. However, it is also somewhat unreliable, so occasionally
there isn't a reference to the driver and I'm able to unload/reload it
(but it still doesn't work).

== Interlaced Video Capture ==

The second problem is the more important one: It seems like the
interlaced video capture I'm receiving via various tools has something
wrong with it. I'm not sure precisely how to characterize this.

Basically, what I first noticed was that after deinterlacing, it
looked as if each pair of lines in the output was reversed, leading to
an extremely vertically pixelated result. I attempted to investigate,
and basically what I'm seeing is that the interlaced video frames
(720x480 @ 29.97 fps) appear as if they're in an inverted pattern in
the output, like 214365....

Ok! I think, maybe they're in bff rather than tff format. I then
attempted to change my capture settings (I've been using vlc, ffmpeg,
mplayer, and cheese to try to debug), and found that occasionally this
seemed to help, but it would invariably not work reliably.

I then attempted capturing with a variety of different deinterlacing
schemes. I found with a bob deinterlacer that it seemed like the video
would switch modes, jumping every few seconds up and down a little.

The next thing I tried was to extract the interlaced fields and
produce a 59.94 hz stream, so I could frame by frame it. What was most
notable about this was that it seemed like in high-motion scenes, the
motion would actually jump backwards in time by a few frames, instead
of the fields each showing an A-B-C-D-E-F or B-A-D-C-F-E pattern like
I expected.

So, basically, it seemed to me almost like this driver is mis-managing
its video buffers. I don't know how the internal hardware interface
works (I mean seriously, I wasn't even sure which driver programs the
analog video chip...), so I wasn't sure if it was plausible that
perhaps the driver is reading the video stream one field at a time and
then composing them in the wrong order or something crazy like that.

Regardless, the card doesn't really seem to be usable for NTSC video
capture with this driver.

> Which is the most recent kernel that works for you correctly?

I just picked up this card recently (I need to transfer old video
tape), and haven't tried it with any other kernel series. I did check
the kernel changelog to see if there had been commits recently to the
cx23885 or cx25840 drivers, and didn't see anything relevant.

> Do you have logs that illustrate your problem?

I've attached the result of lsmod, showing the refcounts. I'm not
really sure what the most useful data regarding the actual video
capture problem is.

Alternatively, do you know a good reliable PCIe or USB analog video
capture card that produces good results? It's seemed quite difficult
to find something these days given that it's basically a dead
technology... (and for the low end USB cards, we seem to be in
counterfeit hell).

Thanks,
Justin

--001a11482b54990bb50546165e41
Content-Type: application/octet-stream; name=hauppage_lsmod_pre2
Content-Disposition: attachment; filename=hauppage_lsmod_pre2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ixxuzpui0

TW9kdWxlICAgICAgICAgICAgICAgICAgU2l6ZSAgVXNlZCBieQpuZnN2MyAgICAgICAgICAgICAg
ICAgIDQwOTYwICAxCm5mc19hY2wgICAgICAgICAgICAgICAgMTYzODQgIDEgbmZzdjMKbmZzICAg
ICAgICAgICAgICAgICAgIDI1Mzk1MiAgMiBuZnN2Mwpsb2NrZCAgICAgICAgICAgICAgICAgIDk0
MjA4ICAyIG5mcyxuZnN2MwpncmFjZSAgICAgICAgICAgICAgICAgIDE2Mzg0ICAxIGxvY2tkCmZz
Y2FjaGUgICAgICAgICAgICAgICAgNjE0NDAgIDEgbmZzCnBjaV9zdHViICAgICAgICAgICAgICAg
MTYzODQgIDEKdmJveHBjaSAgICAgICAgICAgICAgICAyNDU3NiAgMAp2Ym94bmV0YWRwICAgICAg
ICAgICAgIDI4NjcyICAwCnZib3huZXRmbHQgICAgICAgICAgICAgMjg2NzIgIDAKdmJveGRydiAg
ICAgICAgICAgICAgIDQ1NDY1NiAgMyB2Ym94bmV0YWRwLHZib3huZXRmbHQsdmJveHBjaQpiaW5m
bXRfbWlzYyAgICAgICAgICAgIDIwNDgwICAxCm10MjEzMSAgICAgICAgICAgICAgICAgMTYzODQg
IDEKczVoMTQwOSAgICAgICAgICAgICAgICAyMDQ4MCAgMQp0dW5lciAgICAgICAgICAgICAgICAg
IDI4NjcyICAwCm52aWRpYV91dm0gICAgICAgICAgICA3NDU0NzIgIDAKc25kX2hkYV9jb2RlY19o
ZG1pICAgICA1MzI0OCAgMQpjeDI1ODQwICAgICAgICAgICAgICAgMTQzMzYwICAxCm52aWRpYV9k
cm0gICAgICAgICAgICAgNDUwNTYgIDEKbnZpZGlhX21vZGVzZXQgICAgICAgIDc2NTk1MiAgNiBu
dmlkaWFfZHJtCmRybV9rbXNfaGVscGVyICAgICAgICAxNTU2NDggIDEgbnZpZGlhX2RybQpkcm0g
ICAgICAgICAgICAgICAgICAgMzY0NTQ0ICA0IGRybV9rbXNfaGVscGVyLG52aWRpYV9kcm0KZmJf
c3lzX2ZvcHMgICAgICAgICAgICAxNjM4NCAgMSBkcm1fa21zX2hlbHBlcgpzeXNjb3B5YXJlYSAg
ICAgICAgICAgIDE2Mzg0ICAxIGRybV9rbXNfaGVscGVyCnN5c2ZpbGxyZWN0ICAgICAgICAgICAg
MTYzODQgIDEgZHJtX2ttc19oZWxwZXIKc3lzaW1nYmx0ICAgICAgICAgICAgICAxNjM4NCAgMSBk
cm1fa21zX2hlbHBlcgpjeDIzODg1ICAgICAgICAgICAgICAgMTc2MTI4ICAxCnNuZF91c2JfYXVk
aW8gICAgICAgICAxNzYxMjggIDEKYWx0ZXJhX2NpICAgICAgICAgICAgICAyMDQ4MCAgMSBjeDIz
ODg1CnNuZF91c2JtaWRpX2xpYiAgICAgICAgMzY4NjQgIDEgc25kX3VzYl9hdWRpbwp0ZGExODI3
MSAgICAgICAgICAgICAgIDQ5MTUyICAxIGN4MjM4ODUKbnZpZGlhICAgICAgICAgICAgICAxMTQ4
OTI4MCAgMTAwIG52aWRpYV9tb2Rlc2V0LG52aWRpYV91dm0KaW50ZWxfcmFwbCAgICAgICAgICAg
ICAyMDQ4MCAgMAp4ODZfcGtnX3RlbXBfdGhlcm1hbCAgICAxNjM4NCAgMAphbHRlcmFfc3RhcGwg
ICAgICAgICAgIDM2ODY0ICAxIGN4MjM4ODUKaW50ZWxfcG93ZXJjbGFtcCAgICAgICAxNjM4NCAg
MAptODhkczMxMDMgICAgICAgICAgICAgIDI4NjcyICAxIGN4MjM4ODUKdHZlZXByb20gICAgICAg
ICAgICAgICAyNDU3NiAgMSBjeDIzODg1CmNvcmV0ZW1wICAgICAgICAgICAgICAgMTYzODQgIDAK
Y3gyMzQxeCAgICAgICAgICAgICAgICAyNDU3NiAgMSBjeDIzODg1CnZpZGVvYnVmMl9kdmIgICAg
ICAgICAgMTYzODQgIDEgY3gyMzg4NQp1dmN2aWRlbyAgICAgICAgICAgICAgIDkwMTEyICAwCmt2
bV9pbnRlbCAgICAgICAgICAgICAxNzIwMzIgIDAKZHZiX2NvcmUgICAgICAgICAgICAgIDEyMjg4
MCAgNCBjeDIzODg1LGFsdGVyYV9jaSxtODhkczMxMDMsdmlkZW9idWYyX2R2YgppbnB1dF9sZWRz
ICAgICAgICAgICAgIDE2Mzg0ICAwCmkyY19tdXggICAgICAgICAgICAgICAgMTYzODQgIDEgbTg4
ZHMzMTAzCnZpZGVvYnVmMl92bWFsbG9jICAgICAgMTYzODQgIDEgdXZjdmlkZW8Ka3ZtICAgICAg
ICAgICAgICAgICAgIDU0MDY3MiAgMSBrdm1faW50ZWwKc25kX2hkYV9jb2RlY19yZWFsdGVrICAg
IDg2MDE2ICAxCnNuZF9oZGFfY29kZWNfZ2VuZXJpYyAgICA3NzgyNCAgMSBzbmRfaGRhX2NvZGVj
X3JlYWx0ZWsKc25kX3NlcV9taWRpICAgICAgICAgICAxNjM4NCAgMApzbmRfc2VxX21pZGlfZXZl
bnQgICAgIDE2Mzg0ICAxIHNuZF9zZXFfbWlkaQppcnFieXBhc3MgICAgICAgICAgICAgIDE2Mzg0
ICAxIGt2bQp2aWRlb2J1ZjJfZG1hX3NnICAgICAgIDIwNDgwICAxIGN4MjM4ODUKdmlkZW9idWYy
X21lbW9wcyAgICAgICAxNjM4NCAgMiB2aWRlb2J1ZjJfdm1hbGxvYyx2aWRlb2J1ZjJfZG1hX3Nn
CnZpZGVvYnVmMl92NGwyICAgICAgICAgMjg2NzIgIDMgY3gyMzg4NSx1dmN2aWRlbyx2aWRlb2J1
ZjJfZHZiCnNuZF9yYXdtaWRpICAgICAgICAgICAgMzI3NjggIDIgc25kX3VzYm1pZGlfbGliLHNu
ZF9zZXFfbWlkaQp2aWRlb2J1ZjJfY29yZSAgICAgICAgIDM2ODY0ICA0IGN4MjM4ODUsdXZjdmlk
ZW8sdmlkZW9idWYyX3Y0bDIsdmlkZW9idWYyX2R2YgpzbmRfaGRhX2ludGVsICAgICAgICAgIDQw
OTYwICA1CnNuZF9oZGFfY29kZWMgICAgICAgICAxMzUxNjggIDQgc25kX2hkYV9jb2RlY19yZWFs
dGVrLHNuZF9oZGFfY29kZWNfaGRtaSxzbmRfaGRhX2NvZGVjX2dlbmVyaWMsc25kX2hkYV9pbnRl
bAp2NGwyX2NvbW1vbiAgICAgICAgICAgIDE2Mzg0ICA1IGN4MjM0MXgsY3gyMzg4NSxjeDI1ODQw
LHR1bmVyLHZpZGVvYnVmMl92NGwyCnNuZF9oZGFfY29yZSAgICAgICAgICAgNzM3MjggIDUgc25k
X2hkYV9jb2RlY19yZWFsdGVrLHNuZF9oZGFfY29kZWNfaGRtaSxzbmRfaGRhX2NvZGVjX2dlbmVy
aWMsc25kX2hkYV9jb2RlYyxzbmRfaGRhX2ludGVsCnZpZGVvZGV2ICAgICAgICAgICAgICAxNzYx
MjggIDggY3gyMzQxeCxjeDIzODg1LGN4MjU4NDAsdHVuZXIsdXZjdmlkZW8sdjRsMl9jb21tb24s
dmlkZW9idWYyX2NvcmUsdmlkZW9idWYyX3Y0bDIKc25kX2h3ZGVwICAgICAgICAgICAgICAxNjM4
NCAgMiBzbmRfdXNiX2F1ZGlvLHNuZF9oZGFfY29kZWMKc2VyaW9fcmF3ICAgICAgICAgICAgICAx
NjM4NCAgMApzbmRfc2VxICAgICAgICAgICAgICAgIDY5NjMyICAyIHNuZF9zZXFfbWlkaV9ldmVu
dCxzbmRfc2VxX21pZGkKbWVkaWEgICAgICAgICAgICAgICAgICAyNDU3NiAgNCBjeDI1ODQwLHR1
bmVyLHV2Y3ZpZGVvLHZpZGVvZGV2CnNuZF9wY20gICAgICAgICAgICAgICAxMDY0OTYgIDYgY3gy
Mzg4NSxzbmRfdXNiX2F1ZGlvLHNuZF9oZGFfY29kZWNfaGRtaSxzbmRfaGRhX2NvZGVjLHNuZF9o
ZGFfaW50ZWwsc25kX2hkYV9jb3JlCnNuZF9zZXFfZGV2aWNlICAgICAgICAgMTYzODQgIDMgc25k
X3NlcSxzbmRfcmF3bWlkaSxzbmRfc2VxX21pZGkKc25kX3RpbWVyICAgICAgICAgICAgICAzMjc2
OCAgMiBzbmRfcGNtLHNuZF9zZXEKc25kICAgICAgICAgICAgICAgICAgICA4MTkyMCAgMjggc25k
X2hkYV9jb2RlY19yZWFsdGVrLGN4MjM4ODUsc25kX3VzYl9hdWRpbyxzbmRfaHdkZXAsc25kX3Rp
bWVyLHNuZF9oZGFfY29kZWNfaGRtaSxzbmRfcGNtLHNuZF9zZXEsc25kX3Jhd21pZGksc25kX2hk
YV9jb2RlY19nZW5lcmljLHNuZF91c2JtaWRpX2xpYixzbmRfaGRhX2NvZGVjLHNuZF9oZGFfaW50
ZWwsc25kX3NlcV9kZXZpY2UKbWVpX21lICAgICAgICAgICAgICAgICAzNjg2NCAgMAptZWkgICAg
ICAgICAgICAgICAgICAgIDk4MzA0ICAxIG1laV9tZQpzb3VuZGNvcmUgICAgICAgICAgICAgIDE2
Mzg0ICAxIHNuZApzaHBjaHAgICAgICAgICAgICAgICAgIDM2ODY0ICAwCmxwY19pY2ggICAgICAg
ICAgICAgICAgMjQ1NzYgIDAKODI1MF9maW50ZWsgICAgICAgICAgICAxNjM4NCAgMAppdGVfY2ly
ICAgICAgICAgICAgICAgIDI4NjcyICAwCnJjX2NvcmUgICAgICAgICAgICAgICAgMjg2NzIgIDIg
Y3gyMzg4NSxpdGVfY2lyCm1hY19oaWQgICAgICAgICAgICAgICAgMTYzODQgIDAKc3VucnBjICAg
ICAgICAgICAgICAgIDMzNTg3MiAgMTggbmZzLGxvY2tkLG5mc3YzLG5mc19hY2wKcGFycG9ydF9w
YyAgICAgICAgICAgICAzMjc2OCAgMApwcGRldiAgICAgICAgICAgICAgICAgIDIwNDgwICAwCmxw
ICAgICAgICAgICAgICAgICAgICAgMjA0ODAgIDAKcGFycG9ydCAgICAgICAgICAgICAgICA0OTE1
MiAgMyBscCxwcGRldixwYXJwb3J0X3BjCmF1dG9mczQgICAgICAgICAgICAgICAgNDA5NjAgIDIK
YnRyZnMgICAgICAgICAgICAgICAgIDk4NzEzNiAgMQp4b3IgICAgICAgICAgICAgICAgICAgIDI0
NTc2ICAxIGJ0cmZzCnJhaWQ2X3BxICAgICAgICAgICAgICAxMDI0MDAgIDEgYnRyZnMKZHJiZyAg
ICAgICAgICAgICAgICAgICAzMjc2OCAgMQphbnNpX2Nwcm5nICAgICAgICAgICAgIDE2Mzg0ICAw
CmFsZ2lmX3NrY2lwaGVyICAgICAgICAgMjA0ODAgIDAKYWZfYWxnICAgICAgICAgICAgICAgICAx
NjM4NCAgMSBhbGdpZl9za2NpcGhlcgpzZXMgICAgICAgICAgICAgICAgICAgIDIwNDgwICAwCmVu
Y2xvc3VyZSAgICAgICAgICAgICAgMTYzODQgIDEgc2VzCmRtX2NyeXB0ICAgICAgICAgICAgICAg
Mjg2NzIgIDIKZG1fbWlycm9yICAgICAgICAgICAgICAyNDU3NiAgMApkbV9yZWdpb25faGFzaCAg
ICAgICAgIDI0NTc2ICAxIGRtX21pcnJvcgpkbV9sb2cgICAgICAgICAgICAgICAgIDIwNDgwICAy
IGRtX3JlZ2lvbl9oYXNoLGRtX21pcnJvcgp1YXMgICAgICAgICAgICAgICAgICAgIDI0NTc2ICAw
CnVzYl9zdG9yYWdlICAgICAgICAgICAgNjk2MzIgIDEgdWFzCmhpZF9nZW5lcmljICAgICAgICAg
ICAgMTYzODQgIDAKdXNiaGlkICAgICAgICAgICAgICAgICA0OTE1MiAgMApoaWQgICAgICAgICAg
ICAgICAgICAgMTE4Nzg0ICAyIGhpZF9nZW5lcmljLHVzYmhpZApjcmN0MTBkaWZfcGNsbXVsICAg
ICAgIDE2Mzg0ICAwCmNyYzMyX3BjbG11bCAgICAgICAgICAgMTYzODQgIDAKZ2hhc2hfY2xtdWxu
aV9pbnRlbCAgICAxNjM4NCAgMAphZXNuaV9pbnRlbCAgICAgICAgICAgMTY3OTM2ICA1CmFlc194
ODZfNjQgICAgICAgICAgICAgMjA0ODAgIDEgYWVzbmlfaW50ZWwKbHJ3ICAgICAgICAgICAgICAg
ICAgICAxNjM4NCAgMSBhZXNuaV9pbnRlbApnZjEyOG11bCAgICAgICAgICAgICAgIDE2Mzg0ICAx
IGxydwpnbHVlX2hlbHBlciAgICAgICAgICAgIDE2Mzg0ICAxIGFlc25pX2ludGVsCmFibGtfaGVs
cGVyICAgICAgICAgICAgMTYzODQgIDEgYWVzbmlfaW50ZWwKY3J5cHRkICAgICAgICAgICAgICAg
ICAyMDQ4MCAgNSBnaGFzaF9jbG11bG5pX2ludGVsLGFlc25pX2ludGVsLGFibGtfaGVscGVyCnBz
bW91c2UgICAgICAgICAgICAgICAxMzEwNzIgIDAKYWhjaSAgICAgICAgICAgICAgICAgICAzNjg2
NCAgMwpyODE2OSAgICAgICAgICAgICAgICAgIDgxOTIwICAwCmxpYmFoY2kgICAgICAgICAgICAg
ICAgMzI3NjggIDEgYWhjaQptaWkgICAgICAgICAgICAgICAgICAgIDE2Mzg0ICAxIHI4MTY5CnZp
ZGVvICAgICAgICAgICAgICAgICAgNDA5NjAgIDAKZmplcyAgICAgICAgICAgICAgICAgICAyODY3
MiAgMAo=
--001a11482b54990bb50546165e41--
