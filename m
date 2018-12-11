Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D637BC07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 13:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 829E32082F
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 13:34:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="MCBW1IpG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 829E32082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbeLKNeM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 08:34:12 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:42246 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbeLKNeM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 08:34:12 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2BDDB55A;
        Tue, 11 Dec 2018 14:34:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544535249;
        bh=hbVBcFySU0Gifn5T12gbC9SSiCclUCACcPjexlaOYwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCBW1IpGaimnWrfY4RyYzQhTJaDTdUKq2gBOaV2w6lgKmkphCg6AvS0YGjJ5whz2B
         ezY1X/ZRBNjGO7vbpqJtpl78eWUru34D3gsJebCafZPlTQWcoO1yyU1Xp2d7KSzOew
         Lka361nAF0uTcglbM0Uf/jJOX/QJZO+sqZ4pxsjQ=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc:     Tomasz Figa <tfiga@chromium.org>, "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Date:   Tue, 11 Dec 2018 15:34:49 +0200
Message-ID: <3146272.WpjUUU4VRE@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A5999E8D648@fmsmsx124.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <3857756.QIBhGo4FK8@avalon> <6F87890CF0F5204F892DEA1EF0D77A5999E8D648@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1595739.sg6NzSJU8E"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1595739.sg6NzSJU8E
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Rajmohan,

On Wednesday, 5 December 2018 02:30:46 EET Mani, Rajmohan wrote:

[snip]

> I can see a couple of steps missing in the script below.
> (https://lists.libcamera.org/pipermail/libcamera-devel/2018-November/000040.
> html)
> 
> From patch 02 of this v7 series "doc-rst: Add Intel IPU3 documentation",
> under section "Configuring ImgU V4L2 subdev for image processing"...
> 
> 1. The pipe mode needs to be configured for the V4L2 subdev.
> 
> Also the pipe mode of the corresponding V4L2 subdev should be set as
> desired (e.g 0 for video mode or 1 for still mode) through the control
> id 0x009819a1 as below.
> 
> e.g v4l2n -d /dev/v4l-subdev7 --ctrl=0x009819A1=1

I assume the control takes a valid default value ? It's better to set it 
explicitly anyway, so I'll do so.

> 2. ImgU pipeline needs to be configured for image processing as below.
> 
> RAW bayer frames go through the following ISP pipeline HW blocks to
> have the processed image output to the DDR memory.
> 
> RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) ->
> Geometric Distortion Correction (GDC) -> DDR
> 
> The ImgU V4L2 subdev has to be configured with the supported
> resolutions in all the above HW blocks, for a given input resolution.
> 
> For a given supported resolution for an input frame, the Input Feeder,
> Bayer Down Scaling and GDC blocks should be configured with the
> supported resolutions. This information can be obtained by looking at
> the following IPU3 ISP configuration table for ov5670 sensor.
> 
> https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/maste
> r /baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/files/gcss
> /graph_settings_ov5670.xml
> 
> For the ov5670 example, for an input frame with a resolution of
> 2592x1944 (which is input to the ImgU subdev pad 0), the corresponding
> resolutions for input feeder, BDS and GDC are 2592x1944, 2592x1944 and
> 2560x1920 respectively.

How is the GDC output resolution computed from the input resolution ? Does the 
GDC always consume 32 columns and 22 lines ?

> The following steps prepare the ImgU ISP pipeline for the image processing.
> 
> 1. The ImgU V4L2 subdev data format should be set by using the
> VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height obtained above.

If I understand things correctly, the GDC resolution is the pipeline output 
resolution. Why is it configured on pad 0 ?

> 2. The ImgU V4L2 subdev cropping should be set by using the
> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_CROP as the
> target, using the input feeder height and width.
> 
> 3. The ImgU V4L2 subdev composing should be set by using the
> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_COMPOSE as the
> target, using the BDS height and width.
> 
> Once these 2 steps are done, the raw bayer frames can be input to the
> ImgU V4L2 subdev for processing.

Do I need to capture from both the output and viewfinder nodes ? How are they 
related to the IF -> BDS -> GDC pipeline, are they both fed from the GDC 
output ? If so, how does the viewfinder scaler fit in that picture ?

I have tried the above configuration with the IPU3 v8 driver, and while the 
kernel doesn't crash, no images get processed. The userspace processes wait 
forever for buffers to be ready. I then configured pad 2 to 2560x1920 and pad 
3 to 1920x1080, and managed to capture images \o/

There's one problem though: during capture, or very soon after it, the machine 
locks up completely. I suspect a memory corruption, as when it doesn't log 
immediately commands such as dmesg will not produce any output and just block, 
until the system freezes soon after (especially when moving the mouse).

I would still call this an improvement to some extent, but there's definitely 
room for more improvements :-)

To reproduce the issue, you can run the ipu3-process.sh script (attached to 
this e-mail) with the following arguments:

$ ipu3-process.sh --out 2560x1920 frame-2592x1944.cio2

frame-2592x1944.cio2 is a binary file containing a 2592x1944 images in the 
IPU3-specific Bayer format (for a total of 6469632 bytes).

-- 
Regards,

Laurent Pinchart

--nextPart1595739.sg6NzSJU8E
Content-Disposition: attachment; filename="ipu3-process.sh"
Content-Transfer-Encoding: base64
Content-Type: application/x-shellscript; name="ipu3-process.sh"

IyEvYmluL2Jhc2gKIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcgoj
IENvcHlyaWdodCAoQykgMjAxOCwgR29vZ2xlIEluYy4KIwojIEF1dGhvcjogTGF1cmVudCBQaW5j
aGFydCA8bGF1cmVudC5waW5jaGFydEBpZGVhc29uYm9hcmQuY29tPgojCiMgaXB1My1wcm9jZXNz
LnNoIC0gUHJvY2VzcyByYXcgZnJhbWVzIHdpdGggdGhlIEludGVsIElQVTMKIwojIFRoZSBzY3Jp
cHRzIG1ha2VzIHVzZSBvZiB0aGUgZm9sbG93aW5nIHRvb2xzLCB3aGljaCBhcmUgZXhwZWN0ZWQg
dG8gYmUKIyBmb3VuZCBpbiAkUEFUSDoKIwojIC0gbWVkaWEtY3RsIChmcm9tIHY0bC11dGlscyBn
aXQ6Ly9saW51eHR2Lm9yZy92NGwtdXRpbHMuZ2l0KQojIC0gcmF3MnBubSAoZnJvbSBudnQgaHR0
cHM6Ly9naXRodWIuY29tL2ludGVsL252dC5naXQpCiMgLSB5YXZ0YSAoZnJvbSBnaXQ6Ly9naXQu
aWRlYXNvbmJvYXJkLm9yZy95YXZ0YS5naXQpCgppbWd1X2VudGl0eT0iaXB1My1pbWd1IDAiCgoj
IExvY2F0ZSB0aGUgbWVkaWEgZGV2aWNlCmZpbmRfbWVkaWFfZGV2aWNlKCkgewoJbG9jYWwgbWRl
dgoKCWZvciBtZGV2IGluIC9kZXYvbWVkaWEqIDsgZG8KCQltZWRpYS1jdGwgLWQgJG1kZXYgLXAg
fCBncmVwIC1xICJeZHJpdmVyWyBcdF0qaXB1My1pbWd1JCIgJiYgYnJlYWsKCQltZGV2PQoJZG9u
ZQoKCWlmIFtbIC16ICRtZGV2IF1dIDsgdGhlbgoJCWVjaG8gIklQVTMgbWVkaWEgZGV2aWNlIG5v
dCBmb3VuZC4iID4mMgoJCWV4aXQgMQoJZmkKCgllY2hvICRtZGV2Cn0KCiMgQ29uZmlndXJlIHRo
ZSBwaXBlbGluZQpjb25maWd1cmVfcGlwZWxpbmUoKSB7Cglsb2NhbCBlbmFibGVfM2E9MQoJbG9j
YWwgZW5hYmxlX291dD0xCglsb2NhbCBlbmFibGVfdmY9MQoJbG9jYWwgbW9kZT0wCgoJIyBDb25m
aWd1cmUgdGhlIGxpbmtzCgkkbWVkaWFjdGwgLXIKCSRtZWRpYWN0bCAtbCAiXCIkaW1ndV9lbnRp
dHkgaW5wdXRcIjowIC0+IFwiJGltZ3VfZW50aXR5XCI6MFsxXSIKCSRtZWRpYWN0bCAtbCAiXCIk
aW1ndV9lbnRpdHlcIjoyIC0+IFwiJGltZ3VfZW50aXR5IG91dHB1dFwiOjBbJGVuYWJsZV9vdXRd
IgoJJG1lZGlhY3RsIC1sICJcIiRpbWd1X2VudGl0eVwiOjMgLT4gXCIkaW1ndV9lbnRpdHkgdmll
d2ZpbmRlclwiOjBbJGVuYWJsZV92Zl0iCgkkbWVkaWFjdGwgLWwgIlwiJGltZ3VfZW50aXR5XCI6
NCAtPiBcIiRpbWd1X2VudGl0eSAzYSBzdGF0XCI6MFskZW5hYmxlXzNhXSIKCgkjIFNlbGVjdCBw
cm9jZXNzaW5nIG1vZGUgKDAgZm9yIHZpZGVvLCAxIGZvciBzdGlsbCBpbWFnZSkKCXlhdnRhIC0t
bm8tcXVlcnkgLXcgIjB4MDA5ODE5YzEgJG1vZGUiICQoJG1lZGlhY3RsIC1lICIkaW1ndV9lbnRp
dHkiKQoKCSMgU2V0IGZvcm1hdHMKCSRtZWRpYWN0bCAtViAiXCIkaW1ndV9lbnRpdHlcIjowIFtm
bXQ6U0JHR1IxMF8xWDEwLyRvdXRfc2l6ZSBjcm9wOigwLDApLyRpbl9zaXplIGNvbXBvc2U6KDAs
MCkvJGluX3NpemVdIgoJJG1lZGlhY3RsIC1WICJcIiRpbWd1X2VudGl0eVwiOjIgW2ZtdDpTQkdH
UjEwXzFYMTAvJG91dF9zaXplXSIKCSRtZWRpYWN0bCAtViAiXCIkaW1ndV9lbnRpdHlcIjozIFtm
bXQ6U0JHR1IxMF8xWDEwLyRvdXRfc2l6ZV0iCgkkbWVkaWFjdGwgLVYgIlwiJGltZ3VfZW50aXR5
XCI6NCBbZm10OlNCR0dSMTBfMVgxMC8kb3V0X3NpemVdIgp9CgojIFBlcmZvcm0gZnJhbWUgcHJv
Y2Vzc2luZyB0aHJvdWdoIHRoZSBJTUdVCnByb2Nlc3NfZnJhbWVzKCkgewoJY29uZmlndXJlX3Bp
cGVsaW5lCgoJbG9jYWwgeWF2dGE9InlhdnRhIC1uICRuYnVmcyAtYyRmcmFtZV9jb3VudCIKCgkj
IFNhdmUgdGhlIG1haW4gYW5kIHZpZXdmaW5kZXIgb3V0cHV0cyB0byBkaXNrLCBjYXB0dXJlIGFu
ZCBkcm9wIDNBCgkjIHN0YXRpc3RpY3MuIFNsZWVwIDUwMG1zIGJldHdlZW4gZWFjaCBleGVjdXRp
b24gb2YgeWF2dGEgdG8ga2VlcCB0aGUKCSMgc3Rkb3V0IG1lc3NhZ2VzIHJlYWRhYmxlLgoJJHlh
dnRhIC1mICRJTUdVX09VVF9QSVhFTEZPUk1BVCAtcyAkb3V0X3NpemUgIi1GJG91dHB1dF9kaXIv
ZnJhbWUtb3V0LSMuYmluIiBcCgkJJCgkbWVkaWFjdGwgLWUgIiRpbWd1X2VudGl0eSBvdXRwdXQi
KSAmCglzbGVlcCAwLjUKCSR5YXZ0YSAtZiAkSU1HVV9WRl9QSVhFTEZPUk1BVCAtcyAkdmZfc2l6
ZSAiLUYkb3V0cHV0X2Rpci9mcmFtZS12Zi0jLmJpbiIgXAoJCSQoJG1lZGlhY3RsIC1lICIkaW1n
dV9lbnRpdHkgdmlld2ZpbmRlciIpICYKCXNsZWVwIDAuNQoJJHlhdnRhICQoJG1lZGlhY3RsIC1l
ICIkaW1ndV9lbnRpdHkgM2Egc3RhdCIpICYKCXNsZWVwIDAuNQoKCSMgRmVlZCB0aGUgSU1HVSBp
bnB1dC4KCSR5YXZ0YSAtZiAkSU1HVV9JTl9QSVhFTEZPUk1BVCAtcyAkaW5fc2l6ZSAiLUYkaW5f
ZmlsZSIgXAoJCSQoJG1lZGlhY3RsIC1lICIkaW1ndV9lbnRpdHkgaW5wdXQiKQp9CgojIENvbnZl
cnQgY2FwdHVyZWQgZmlsZXMgdG8gcHBtCmNvbnZlcnRfZmlsZXMoKSB7Cglsb2NhbCBpbmRleD0k
MQoJbG9jYWwgdHlwZT0kMgoJbG9jYWwgc2l6ZT0kMwoJbG9jYWwgZm9ybWF0PSQ0CgoJbG9jYWwg
d2lkdGg9JChlY2hvICRzaXplIHwgYXdrIC1GICd4JyAne3ByaW50ICQxfScpCglsb2NhbCBoZWln
aHQ9JChlY2hvICRzaXplIHwgYXdrIC1GICd4JyAne3ByaW50ICQyfScpCglsb2NhbCBwYWRkZWRf
d2lkdGg9JChleHByICQoZXhwciAkd2lkdGggKyA2MykgLyA2NCBcKiA2NCkKCglyYXcycG5tIC14
JHBhZGRlZF93aWR0aCAteSRoZWlnaHQgLWYkZm9ybWF0IFwKCQkkb3V0cHV0X2Rpci9mcmFtZS0k
dHlwZS0kaW5kZXguYmluIFwKCQkkb3V0cHV0X2Rpci9mcmFtZS0kdHlwZS0kaW5kZXgucHBtCn0K
CnJ1bl90ZXN0KCkgewoJSU1HVV9JTl9QSVhFTEZPUk1BVD1JUFUzX1NHUkJHMTAKCUlNR1VfT1VU
X1BJWEVMRk9STUFUPU5WMTIKCUlNR1VfVkZfUElYRUxGT1JNQVQ9TlYxMgoKCWVjaG8gIj09PT0g
VGVzdCA9PT09IgoJZWNobyAiaW5wdXQ6ICAkaW5fZmlsZSIKCWVjaG8gIm91dHB1dDogJElNR1Vf
T1VUX1BJWEVMRk9STUFULyRvdXRfc2l6ZSIKCWVjaG8gInZmOiAgICAgJElNR1VfVkZfUElYRUxG
T1JNQVQvJHZmX3NpemUiCgoJcHJvY2Vzc19mcmFtZXMKCglmb3IgaSBpbiBgc2VxIC1mICclMDYu
MGYnIDAgJCgoJGZyYW1lX2NvdW50IC0gMSkpYDsgZG8KCQljb252ZXJ0X2ZpbGVzICRpIG91dCAk
b3V0X3NpemUgJElNR1VfT1VUX1BJWEVMRk9STUFUCgkJY29udmVydF9maWxlcyAkaSB2ZiAkdmZf
c2l6ZSAkSU1HVV9WRl9QSVhFTEZPUk1BVAoJZG9uZQp9Cgp2YWxpZGF0ZV9zaXplKCkgewoJbG9j
YWwgc2l6ZT0kMQoJbG9jYWwgd2lkdGg9JChlY2hvICRzaXplIHwgYXdrIC1GICd4JyAne3ByaW50
ICQxfScpCglsb2NhbCBoZWlnaHQ9JChlY2hvICRzaXplIHwgYXdrIC1GICd4JyAne3ByaW50ICQy
fScpCgoJW1sgIngke3NpemV9IiA9PSAieCR7d2lkdGh9eCR7aGVpZ2h0fSIgXV0KfQoKIyBQcmlu
dCB1c2FnZSBtZXNzYWdlCnVzYWdlKCkgewoJZWNobyAiVXNhZ2U6ICQoYmFzZW5hbWUgJDEpIFtv
cHRpb25zXSA8aW5wdXQtZmlsZT4iCgllY2hvICJTdXBwb3J0ZWQgb3B0aW9uczoiCgllY2hvICIt
LW91dCBzaXplICAgICAgICBvdXRwdXQgZnJhbWUgc2l6ZSAoZGVmYXVsdHMgdG8gaW5wdXQgc2l6
ZSkiCgllY2hvICItLXZmIHNpemUgICAgICAgICB2aWV3ZmluZGVyIGZyYW1lIHNpemUgKGRlZmF1
bHRzIHRvIGlucHV0IHNpemUpIgoJZWNobyAiIgoJZWNobyAiV2hlcmUgdGhlIGlucHV0IGZpbGUg
bmFtZSBhbmQgc2l6ZSBhcmUiCgllY2hvICIiCgllY2hvICJpbnB1dC1maWxlID0gcHJlZml4ICct
JyB3aWR0aCAneCcgaGVpZ2h0ICcuJyBleHRlbnNpb24iCgllY2hvICJzaXplID0gd2lkdGggJ3gn
IGhlaWdodCIKfQoKIyBQYXJzZSBjb21tYW5kIGxpbmUgYXJndW1lbnRzCndoaWxlICgoICIkIyIg
KSkgOyBkbwoJY2FzZSAkMSBpbgoJLS1vdXQpCgkJb3V0X3NpemU9JDIKCQlpZiAhIHZhbGlkYXRl
X3NpemUgJG91dF9zaXplIDsgdGhlbgoJCQllY2hvICJJbnZhbGlkIHNpemUgJyRvdXRfc2l6ZSci
CgkJCXVzYWdlICQwCgkJCWV4aXQgMQoJCWZpCgkJc2hpZnQgMgoJCTs7CgktLXZmKQoJCXZmX3Np
emU9JDIKCQlpZiAhIHZhbGlkYXRlX3NpemUgJHZmX3NpemUgOyB0aGVuCgkJCWVjaG8gIkludmFs
aWQgc2l6ZSAnJHZmX3NpemUnIgoJCQl1c2FnZSAkMAoJCQlleGl0IDEKCQlmaQoJCXNoaWZ0IDIK
CQk7OwoJLSopCgkJZWNobyAiVW5zdXBwb3J0ZWQgb3B0aW9uICQxIiA+JjIKCQl1c2FnZSAkMAoJ
CWV4aXQgMQoJCTs7CgkqKQoJCWJyZWFrCgkJOzsKCWVzYWMKZG9uZQoKaWYgWyAkIyAhPSAxIF0g
OyB0aGVuCgl1c2FnZSAkMAoJZXhpdCAxCmZpCgppbl9maWxlPSQxCgojIFBhcnNlIHRoZSBzaXpl
IGZyb20gdGhlIGlucHV0IGZpbGUgbmFtZSBhbmQgcGVyZm9ybSBtaW5pbWFsIHNhbml0eQojIGNo
ZWNrcy4KaW5fc2l6ZT0kKGVjaG8gJGluX2ZpbGUgfCBzZWQgJ3MvLiotXChbMC05XSpcKXhcKFsw
LTldKlwpXC5bYS16MC05XSokL1wxeFwyLycpCnZhbGlkYXRlX3NpemUgJGluX3NpemUKaWYgW1sg
JD8gIT0gMCBdXSA7IHRoZW4KCWVjaG8gIkludmFsaWQgaW5wdXQgZmlsZSBuYW1lICRpbl9maWxl
IiA+JjIKCXVzYWdlICQwCglleGl0IDEKZmkKCm91dF9zaXplPSR7b3V0X3NpemU6LSRpbl9zaXpl
fQp2Zl9zaXplPSR7dmZfc2l6ZTotJGluX3NpemV9CgptZGV2PSQoZmluZF9tZWRpYV9kZXZpY2Up
IHx8IGV4aXQKbWVkaWFjdGw9Im1lZGlhLWN0bCAtZCAkbWRldiIKZWNobyAiVXNpbmcgZGV2aWNl
ICRtZGV2IgoKb3V0cHV0X2Rpcj0iL3RtcCIKZnJhbWVfY291bnQ9NQpuYnVmcz03CnJ1bl90ZXN0
Cg==


--nextPart1595739.sg6NzSJU8E--



