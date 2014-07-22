Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:54175 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbaGVPw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 11:52:29 -0400
Received: by mail-oa0-f44.google.com with SMTP id eb12so9943803oac.17
        for <linux-media@vger.kernel.org>; Tue, 22 Jul 2014 08:52:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7urbO6C-a6UMB+1JKN2z7F0CDmqh0184cCzXHbW1ADfXA@mail.gmail.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<CA+2YH7uDVL+s9aY-erktyKeUbmd2=49r=nDZXPRCZ8dcSjmCoA@mail.gmail.com>
	<CA+2YH7urbO6C-a6UMB+1JKN2z7F0CDmqh0184cCzXHbW1ADfXA@mail.gmail.com>
Date: Tue, 22 Jul 2014 17:52:27 +0200
Message-ID: <CA+2YH7t0rzko=Ssg7Qe8oC_qXUTr=uFzDqBqmPtAAbQ2dAntNA@mail.gmail.com>
Subject: Re: [PATCH 00/11] OMAP3 ISP BT.656 support
From: Enrico <ebutera@users.sourceforge.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Enric Balletbo Serra <eballetbo@gmail.com>,
	stefan@herbrechtsmeier.net
Content-Type: multipart/mixed; boundary=001a11c20c4cf6419a04feca3590
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001a11c20c4cf6419a04feca3590
Content-Type: text/plain; charset=UTF-8

On Tue, Jun 24, 2014 at 5:19 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Tue, May 27, 2014 at 10:38 AM, Enrico <ebutera@users.berlios.de> wrote:
>> On Mon, May 26, 2014 at 9:50 PM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>>> Hello,
>>>
>>> This patch sets implements support for BT.656 and interlaced formats in the
>>> OMAP3 ISP driver. Better late than never I suppose, although given how long
>>> this has been on my to-do list there's probably no valid excuse.
>>
>> Thanks Laurent!
>>
>> I hope to have time soon to test it :)
>
> Hi Laurent,
>
> i wanted to try your patches but i'm having a problem (probably not
> caused by your patches).
>
> I merged media_tree master and omap3isp branches, applied your patches
> and added camera platform data in pdata-quirks, but when loading the
> omap3-isp driver i have:
>
> omap3isp: clk_set_rate for cam_mclk failed
>
> The returned value from clk_set_rate is -22 (EINVAL), but i can't see
> any other debug message to track it down. Any ides?
> I'm testing it on an igep proton (omap3530 version).

I found out that my previous email was not working anymore, so i
didn't read about Stefan patch (ti,set-rate-parent).

With that patch i can setup my pipeline (attached), but i can't make
yavta capture:

root@igep00x0:~/field# ./yavta -f UYVY -n4 -s 720x624 -c100 /dev/video2
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video output (without
mplanes) device.
Video format set: UYVY (59565955) 720x624 (stride 1440) field none
buffer size 898560
Video format: UYVY (59565955) 720x624 (stride 1440) field none buffer
size 898560
4 buffers requested.
length: 898560 offset: 0 timestamp type/source: mono/EoF
Buffer 0/0 mapped at address 0xb6ce4000.
length: 898560 offset: 901120 timestamp type/source: mono/EoF
Buffer 1/0 mapped at address 0xb6c08000.
length: 898560 offset: 1802240 timestamp type/source: mono/EoF
Buffer 2/0 mapped at address 0xb6b2c000.
length: 898560 offset: 2703360 timestamp type/source: mono/EoF
Buffer 3/0 mapped at address 0xb6a50000.
Unable to start streaming: Invalid argument (22).
4 buffers released.

strace:

ioctl(3, VIDIOC_STREAMON, 0xbef9c75c)   = -1 EINVAL (Invalid argument)

any ideas?

Thanks,

Enrico

--001a11c20c4cf6419a04feca3590
Content-Type: text/plain; charset=US-ASCII; name="mediactl.txt"
Content-Disposition: attachment; filename="mediactl.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hxxefoe50

T3BlbmluZyBtZWRpYSBkZXZpY2UgL2Rldi9tZWRpYTAKRW51bWVyYXRpbmcgZW50aXRpZXMKRm91
bmQgMTYgZW50aXRpZXMKRW51bWVyYXRpbmcgcGFkcyBhbmQgbGlua3MKTWVkaWEgY29udHJvbGxl
ciBBUEkgdmVyc2lvbiAwLjAuMAoKTWVkaWEgZGV2aWNlIGluZm9ybWF0aW9uCi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQpkcml2ZXIgICAgICAgICAgb21hcDNpc3AKbW9kZWwgICAgICAgICAgIFRJ
IE9NQVAzIElTUApzZXJpYWwgICAgICAgICAgCmJ1cyBpbmZvICAgICAgICAKaHcgcmV2aXNpb24g
ICAgIDB4MjAKZHJpdmVyIHZlcnNpb24gIDAuMC4wCgpEZXZpY2UgdG9wb2xvZ3kKLSBlbnRpdHkg
MTogT01BUDMgSVNQIENDUDIgKDIgcGFkcywgMiBsaW5rcykKICAgICAgICAgICAgdHlwZSBWNEwy
IHN1YmRldiBzdWJ0eXBlIFVua25vd24KICAgICAgICAgICAgZGV2aWNlIG5vZGUgbmFtZSAvZGV2
L3Y0bC1zdWJkZXYwCglwYWQwOiBTaW5rIFtTR1JCRzEwIDQwOTZ4NDA5Nl0KCQk8LSAiT01BUDMg
SVNQIENDUDIgaW5wdXQiOjAgW10KCXBhZDE6IFNvdXJjZSBbU0dSQkcxMCA0MDk2eDQwOTZdCgkJ
LT4gIk9NQVAzIElTUCBDQ0RDIjowIFtdCgotIGVudGl0eSAyOiBPTUFQMyBJU1AgQ0NQMiBpbnB1
dCAoMSBwYWQsIDEgbGluaykKICAgICAgICAgICAgdHlwZSBOb2RlIHN1YnR5cGUgVjRMCiAgICAg
ICAgICAgIGRldmljZSBub2RlIG5hbWUgL2Rldi92aWRlbzAKCXBhZDA6IFNvdXJjZSAKCQktPiAi
T01BUDMgSVNQIENDUDIiOjAgW10KCi0gZW50aXR5IDM6IE9NQVAzIElTUCBDU0kyYSAoMiBwYWRz
LCAyIGxpbmtzKQogICAgICAgICAgICB0eXBlIFY0TDIgc3ViZGV2IHN1YnR5cGUgVW5rbm93bgog
ICAgICAgICAgICBkZXZpY2Ugbm9kZSBuYW1lIC9kZXYvdjRsLXN1YmRldjEKCXBhZDA6IFNpbmsg
W1NHUkJHMTAgNDA5Nng0MDk2XQoJcGFkMTogU291cmNlIFtTR1JCRzEwIDQwOTZ4NDA5Nl0KCQkt
PiAiT01BUDMgSVNQIENTSTJhIG91dHB1dCI6MCBbXQoJCS0+ICJPTUFQMyBJU1AgQ0NEQyI6MCBb
XQoKLSBlbnRpdHkgNDogT01BUDMgSVNQIENTSTJhIG91dHB1dCAoMSBwYWQsIDEgbGluaykKICAg
ICAgICAgICAgdHlwZSBOb2RlIHN1YnR5cGUgVjRMCiAgICAgICAgICAgIGRldmljZSBub2RlIG5h
bWUgL2Rldi92aWRlbzEKCXBhZDA6IFNpbmsgCgkJPC0gIk9NQVAzIElTUCBDU0kyYSI6MSBbXQoK
LSBlbnRpdHkgNTogT01BUDMgSVNQIENDREMgKDMgcGFkcywgOSBsaW5rcykKICAgICAgICAgICAg
dHlwZSBWNEwyIHN1YmRldiBzdWJ0eXBlIFVua25vd24KICAgICAgICAgICAgZGV2aWNlIG5vZGUg
bmFtZSAvZGV2L3Y0bC1zdWJkZXYyCglwYWQwOiBTaW5rIFtVWVZZMlg4IDcyMHg2MjVdCgkJPC0g
Ik9NQVAzIElTUCBDQ1AyIjoxIFtdCgkJPC0gIk9NQVAzIElTUCBDU0kyYSI6MSBbXQoJCTwtICJ0
dnA1MTUwIDEtMDA1YyI6MCBbRU5BQkxFRF0KCXBhZDE6IFNvdXJjZSBbVVlWWSA3MjB4NjI0ICgw
LDApLzcyMHg2MjRdCgkJLT4gIk9NQVAzIElTUCBDQ0RDIG91dHB1dCI6MCBbRU5BQkxFRF0KCQkt
PiAiT01BUDMgSVNQIHJlc2l6ZXIiOjAgW10KCXBhZDI6IFNvdXJjZSBbdW5rbm93biA3MjB4NjI0
XQoJCS0+ICJPTUFQMyBJU1AgcHJldmlldyI6MCBbXQoJCS0+ICJPTUFQMyBJU1AgQUVXQiI6MCBb
RU5BQkxFRCxJTU1VVEFCTEVdCgkJLT4gIk9NQVAzIElTUCBBRiI6MCBbRU5BQkxFRCxJTU1VVEFC
TEVdCgkJLT4gIk9NQVAzIElTUCBoaXN0b2dyYW0iOjAgW0VOQUJMRUQsSU1NVVRBQkxFXQoKLSBl
bnRpdHkgNjogT01BUDMgSVNQIENDREMgb3V0cHV0ICgxIHBhZCwgMSBsaW5rKQogICAgICAgICAg
ICB0eXBlIE5vZGUgc3VidHlwZSBWNEwKICAgICAgICAgICAgZGV2aWNlIG5vZGUgbmFtZSAvZGV2
L3ZpZGVvMgoJcGFkMDogU2luayAKCQk8LSAiT01BUDMgSVNQIENDREMiOjEgW0VOQUJMRURdCgot
IGVudGl0eSA3OiBPTUFQMyBJU1AgcHJldmlldyAoMiBwYWRzLCA0IGxpbmtzKQogICAgICAgICAg
ICB0eXBlIFY0TDIgc3ViZGV2IHN1YnR5cGUgVW5rbm93bgogICAgICAgICAgICBkZXZpY2Ugbm9k
ZSBuYW1lIC9kZXYvdjRsLXN1YmRldjMKCXBhZDA6IFNpbmsgW1NHUkJHMTAgNDA5Nng0MDk2ICg4
LDQpLzQwODJ4NDA4OF0KCQk8LSAiT01BUDMgSVNQIENDREMiOjIgW10KCQk8LSAiT01BUDMgSVNQ
IHByZXZpZXcgaW5wdXQiOjAgW10KCXBhZDE6IFNvdXJjZSBbWVVZViA0MDgyeDQwODhdCgkJLT4g
Ik9NQVAzIElTUCBwcmV2aWV3IG91dHB1dCI6MCBbXQoJCS0+ICJPTUFQMyBJU1AgcmVzaXplciI6
MCBbXQoKLSBlbnRpdHkgODogT01BUDMgSVNQIHByZXZpZXcgaW5wdXQgKDEgcGFkLCAxIGxpbmsp
CiAgICAgICAgICAgIHR5cGUgTm9kZSBzdWJ0eXBlIFY0TAogICAgICAgICAgICBkZXZpY2Ugbm9k
ZSBuYW1lIC9kZXYvdmlkZW8zCglwYWQwOiBTb3VyY2UgCgkJLT4gIk9NQVAzIElTUCBwcmV2aWV3
IjowIFtdCgotIGVudGl0eSA5OiBPTUFQMyBJU1AgcHJldmlldyBvdXRwdXQgKDEgcGFkLCAxIGxp
bmspCiAgICAgICAgICAgIHR5cGUgTm9kZSBzdWJ0eXBlIFY0TAogICAgICAgICAgICBkZXZpY2Ug
bm9kZSBuYW1lIC9kZXYvdmlkZW80CglwYWQwOiBTaW5rIAoJCTwtICJPTUFQMyBJU1AgcHJldmll
dyI6MSBbXQoKLSBlbnRpdHkgMTA6IE9NQVAzIElTUCByZXNpemVyICgyIHBhZHMsIDQgbGlua3Mp
CiAgICAgICAgICAgICB0eXBlIFY0TDIgc3ViZGV2IHN1YnR5cGUgVW5rbm93bgogICAgICAgICAg
ICAgZGV2aWNlIG5vZGUgbmFtZSAvZGV2L3Y0bC1zdWJkZXY0CglwYWQwOiBTaW5rIFtZVVlWIDQw
OTV4NDA5NSAoMCw2KS80MDk0eDQwODJdCgkJPC0gIk9NQVAzIElTUCBDQ0RDIjoxIFtdCgkJPC0g
Ik9NQVAzIElTUCBwcmV2aWV3IjoxIFtdCgkJPC0gIk9NQVAzIElTUCByZXNpemVyIGlucHV0Ijow
IFtdCglwYWQxOiBTb3VyY2UgW1lVWVYgMzMxMng0MDk1XQoJCS0+ICJPTUFQMyBJU1AgcmVzaXpl
ciBvdXRwdXQiOjAgW10KCi0gZW50aXR5IDExOiBPTUFQMyBJU1AgcmVzaXplciBpbnB1dCAoMSBw
YWQsIDEgbGluaykKICAgICAgICAgICAgIHR5cGUgTm9kZSBzdWJ0eXBlIFY0TAogICAgICAgICAg
ICAgZGV2aWNlIG5vZGUgbmFtZSAvZGV2L3ZpZGVvNQoJcGFkMDogU291cmNlIAoJCS0+ICJPTUFQ
MyBJU1AgcmVzaXplciI6MCBbXQoKLSBlbnRpdHkgMTI6IE9NQVAzIElTUCByZXNpemVyIG91dHB1
dCAoMSBwYWQsIDEgbGluaykKICAgICAgICAgICAgIHR5cGUgTm9kZSBzdWJ0eXBlIFY0TAogICAg
ICAgICAgICAgZGV2aWNlIG5vZGUgbmFtZSAvZGV2L3ZpZGVvNgoJcGFkMDogU2luayAKCQk8LSAi
T01BUDMgSVNQIHJlc2l6ZXIiOjEgW10KCi0gZW50aXR5IDEzOiBPTUFQMyBJU1AgQUVXQiAoMSBw
YWQsIDEgbGluaykKICAgICAgICAgICAgIHR5cGUgVjRMMiBzdWJkZXYgc3VidHlwZSBVbmtub3du
CiAgICAgICAgICAgICBkZXZpY2Ugbm9kZSBuYW1lIC9kZXYvdjRsLXN1YmRldjUKCXBhZDA6IFNp
bmsgCgkJPC0gIk9NQVAzIElTUCBDQ0RDIjoyIFtFTkFCTEVELElNTVVUQUJMRV0KCi0gZW50aXR5
IDE0OiBPTUFQMyBJU1AgQUYgKDEgcGFkLCAxIGxpbmspCiAgICAgICAgICAgICB0eXBlIFY0TDIg
c3ViZGV2IHN1YnR5cGUgVW5rbm93bgogICAgICAgICAgICAgZGV2aWNlIG5vZGUgbmFtZSAvZGV2
L3Y0bC1zdWJkZXY2CglwYWQwOiBTaW5rIAoJCTwtICJPTUFQMyBJU1AgQ0NEQyI6MiBbRU5BQkxF
RCxJTU1VVEFCTEVdCgotIGVudGl0eSAxNTogT01BUDMgSVNQIGhpc3RvZ3JhbSAoMSBwYWQsIDEg
bGluaykKICAgICAgICAgICAgIHR5cGUgVjRMMiBzdWJkZXYgc3VidHlwZSBVbmtub3duCiAgICAg
ICAgICAgICBkZXZpY2Ugbm9kZSBuYW1lIC9kZXYvdjRsLXN1YmRldjcKCXBhZDA6IFNpbmsgCgkJ
PC0gIk9NQVAzIElTUCBDQ0RDIjoyIFtFTkFCTEVELElNTVVUQUJMRV0KCi0gZW50aXR5IDE2OiB0
dnA1MTUwIDEtMDA1YyAoMSBwYWQsIDEgbGluaykKICAgICAgICAgICAgIHR5cGUgVjRMMiBzdWJk
ZXYgc3VidHlwZSBVbmtub3duCiAgICAgICAgICAgICBkZXZpY2Ugbm9kZSBuYW1lIC9kZXYvdjRs
LXN1YmRldjgKCXBhZDA6IFNvdXJjZSBbVVlWWTJYOCA3MjB4NjI1XQoJCS0+ICJPTUFQMyBJU1Ag
Q0NEQyI6MCBbRU5BQkxFRF0KCgo=
--001a11c20c4cf6419a04feca3590--
