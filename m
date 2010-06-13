Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f204.google.com ([209.85.211.204]:52027 "EHLO
	mail-yw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab0FMTqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 15:46:55 -0400
Received: by ywh42 with SMTP id 42so2864310ywh.15
        for <linux-media@vger.kernel.org>; Sun, 13 Jun 2010 12:46:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100613150938.GA5483@localhost.localdomain>
References: <20100317145900.GA7875@localhost.localdomain>
	<829197381003170843u73743ccand32e7d0d2e6d3ca6@mail.gmail.com>
	<20100613150938.GA5483@localhost.localdomain>
Date: Sun, 13 Jun 2010 15:46:54 -0400
Message-ID: <AANLkTimgmQzy5sAh_lU_RHYj-ZD9XZavvLmgs7tSNNdZ@mail.gmail.com>
Subject: Re: Problem with em28xx card, PAL and teletext
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Eugeniy Meshcheryakov <eugen@debian.org>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636283b1c5980380488eea221
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001636283b1c5980380488eea221
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 13, 2010 at 11:09 AM, Eugeniy Meshcheryakov
<eugen@debian.org> wrote:
> Hi,
>
> I was waiting with reply to look at improvements you made in the driver.
> But the problem did not go away. Actually it became worser. In recent
> kernels the picture is not only shifted, but amount of shift changes
> with the time. Every second or so picture is shifted 1-2 pixels right
> or left. This problem is introduced with this patch:
>
> =A0 V4L/DVB: em28xx: rework buffer pointer tracking for offset to start o=
f video
> =A0 5fee334039550bdd5efed9e69af7860a66a9de37
>
> After reverting this patch the picture does not move anymore. Also there
> is still green line on the bottom, and still some pixels that should be
> on the right edge are on the left edge.
>
> I'm using mplayer to watch tv. If it helps, it is cable tv in Germany.
> Some maplyer parameters related to tv:
> norm=3Dpal-bg:device=3D/dev/video1:tdevice=3D/dev/vbi0:width=3D640:height=
=3D480:alsa=3Dyes:adevice=3Dhw.2,0:amode=3D1:immediatemode=3D0:audiorate=3D=
48000
>
> Regards,
> Eugeniy Meshcheryakov

Hello Eugeniy,

I finally found a couple of hours to debug this issue.  Please try the
attached patch and report back whether it addresses the problem you
were seeing with the fields shifting left/right.

Regarding the green lines at the bottom, this is an artifact of the
VBI changes, resulting from the fact that there is some important VBI
content inside of the Active Video area (line 23 WSS in particular),
and the chip cannot handle providing it both in YUYV format for the
video area as well as in 8 bit greyscale for the VBI.  As a result, we
had to drop the lines from the video area.

What probably needs to happen is I will need to change the driver to
inject black lines into each field to make up for the two lines per
field we're not sending in the video area.  In the meantime though,
you can work around the issue by cropping out the lines with the
following command:

/usr/bin/mplayer -vo xv,x11 tv:// -tv
driver=3Dv4l2:device=3D/dev/video0:norm=3DPAL:width=3D720:height=3D576:inpu=
t=3D1
-vf crop=3D720:572:0:0

(in particular, look at the "-vf crop=3D720:572:0:0" portion)

Devin

--=20
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--001636283b1c5980380488eea221
Content-Type: text/x-patch; charset=US-ASCII; name="isocfix.patch"
Content-Disposition: attachment; filename="isocfix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gaeacjh91

Rml4IGNhc2Ugd2hlcmUgZmllbGRzIHdlcmUgbm90IGF0IHRoZSBjb3JyZWN0IHN0YXJ0IGxvY2F0
aW9uLgoKRnJvbTogRGV2aW4gSGVpdG11ZWxsZXIgPGRoZWl0bXVlbGxlckBrZXJuZWxsYWJzLmNv
bT4KClRoaXMgcGF0Y2ggYWRkcmVzcyBhbiBhcml0aG1ldGljIGVycm9yIGZvciB0aGUgY2FzZSB3
aGVyZSB0aGUgb25seSByZW1haW5pbmcKY29udGVudCBpbiB0aGUgVVNCIHBhY2tldCB3YXMgdGhl
ICIyMjVBeHh4eCIgc3RhcnQgb2YgYWN0aXZlIHZpZGVvLiAgSW4gY2FzZXMKd2hlcmUgdGhhdCBo
YXBwZW5lZCB0byBiZSBhdCB0aGUgZW5kIG9mIHRoZSBmcmFtZSwgd2Ugd291bGQgaW5qZWN0IGl0
IGludG8gdGhlCnZpZGVvYnVmICh3aGljaCBpcyBpbmNvcnJlY3QpLiAgVGhpcyBjYXVzZWQgZmll
bGRzIHRvIGJlIGludGVybWl0dGVudGx5CnJlbmRlcmVkIG9mZiBieSB0d28gcGl4ZWxzLgoKVGhh
bmtzIHRvIEV1Z2VuaXkgTWVzaGNoZXJ5YWtvdiBmb3IgYnJpbmdpbmcgdGhpcyBpc3N1ZSB0byBt
eSBhdHRlbnRpb24KClByaW9yaXR5OiBoaWdoCgpTaWduZWQtb2ZmLWJ5OiBEZXZpbiBIZWl0bXVl
bGxlciA8ZGhlaXRtdWVsbGVyQGtlcm5lbGxhYnMuY29tPgpDYzogRXVnZW5peSBNZXNoY2hlcnlh
a292IDxldWdlbkBkZWJpYW4ub3JnPgoKZGlmZiAtciBiNTk0MDI5ZDc2MmYgbGludXgvZHJpdmVy
cy9tZWRpYS92aWRlby9lbTI4eHgvZW0yOHh4LXZpZGVvLmMKLS0tIGEvbGludXgvZHJpdmVycy9t
ZWRpYS92aWRlby9lbTI4eHgvZW0yOHh4LXZpZGVvLmMJVGh1IE1heSAxMyAxNjo1OToxNSAyMDEw
IC0wMzAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZW0yOHh4L2VtMjh4eC12aWRl
by5jCVN1biBKdW4gMTMgMTU6NDI6MjcgMjAxMCAtMDQwMApAQCAtNjg0LDEyICs2ODQsMTIgQEAK
IAkJfQogCiAJCWlmIChidWYgIT0gTlVMTCAmJiBkZXYtPmNhcHR1cmVfdHlwZSA9PSAyKSB7Ci0J
CQlpZiAobGVuID4gNCAmJiBwWzBdID09IDB4ODggJiYgcFsxXSA9PSAweDg4ICYmCisJCQlpZiAo
bGVuID49IDQgJiYgcFswXSA9PSAweDg4ICYmIHBbMV0gPT0gMHg4OCAmJgogCQkJICAgIHBbMl0g
PT0gMHg4OCAmJiBwWzNdID09IDB4ODgpIHsKIAkJCQlwICs9IDQ7CiAJCQkJbGVuIC09IDQ7CiAJ
CQl9Ci0JCQlpZiAobGVuID4gNCAmJiBwWzBdID09IDB4MjIgJiYgcFsxXSA9PSAweDVhKSB7CisJ
CQlpZiAobGVuID49IDQgJiYgcFswXSA9PSAweDIyICYmIHBbMV0gPT0gMHg1YSkgewogCQkJCWVt
Mjh4eF9pc29jZGJnKCJWaWRlbyBmcmFtZSAlZCwgbGVuPSVpLCAlc1xuIiwKIAkJCQkJICAgICAg
IHBbMl0sIGxlbiwgKHBbMl0gJiAxKSA/CiAJCQkJCSAgICAgICAib2RkIiA6ICJldmVuIik7Cg==
--001636283b1c5980380488eea221--
