Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B32C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 17:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE039217F9
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 17:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="uSXLg3ZN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390209AbfBRR7C (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 12:59:02 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:48625 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389053AbfBRR7B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 12:59:01 -0500
X-Sender-Id: dreamhost|x-authsender|brad@b-rad.cc
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id B41DF50364F;
        Mon, 18 Feb 2019 17:58:57 +0000 (UTC)
Received: from pdx1-sub0-mail-a66.g.dreamhost.com (unknown [100.96.19.78])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 57DBA5033AB;
        Mon, 18 Feb 2019 17:58:57 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@b-rad.cc
Received: from pdx1-sub0-mail-a66.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Mon, 18 Feb 2019 17:58:57 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@b-rad.cc
X-MailChannels-Auth-Id: dreamhost
X-Arch-Language: 66f8a9057a89cda1_1550512737592_3854605261
X-MC-Loop-Signature: 1550512737591:185941123
X-MC-Ingress-Time: 1550512737591
Received: from pdx1-sub0-mail-a66.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a66.g.dreamhost.com (Postfix) with ESMTP id EDB7E7F0B8;
        Mon, 18 Feb 2019 09:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=
        subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=
        nextdimension.cc; bh=eBUetx3UOW9C4QO3wpsUt1XHA7I=; b=uSXLg3ZNnoP
        aO3kci/iQ2JymFORB2HebSdv+e3Dy7nYAvNP1JUQWC5QYWgnsICyfUWuZxJnlA7Y
        JrQfwFc05NyhI1z+la+UUquWi1INAG/D/wYSzqXi6LpSFHuwikdQDr71HiHLG6Nw
        +HsMD3uX8svK3H+gG/ENlsB1WpskKqho=
Received: from [192.168.0.21] (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@b-rad.cc)
        by pdx1-sub0-mail-a66.g.dreamhost.com (Postfix) with ESMTPSA id 56A497F0AB;
        Mon, 18 Feb 2019 09:58:55 -0800 (PST)
Subject: Re: [PATCH 0/2] Media Controller "taint" fixes
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@kernel.org
References: <1547515448-15258-1-git-send-email-brad@nextdimension.cc>
 <5e18a556-17fa-de72-a915-45a5f1bea018@xs4all.nl>
X-DH-BACKEND: pdx1-sub0-mail-a66
From:   Brad Love <brad@nextdimension.cc>
Openpgp: preference=signencrypt
Autocrypt: addr=brad@nextdimension.cc; prefer-encrypt=mutual; keydata=
 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
Message-ID: <78e221d5-01b1-33a6-6ea1-6d3e0eb8b248@nextdimension.cc>
Date:   Mon, 18 Feb 2019 11:58:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <5e18a556-17fa-de72-a915-45a5f1bea018@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -85
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrtddugdejiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculdduhedmnecujfgurhepuffvfhfhkffffgggjggtgfesthhqredttdefjeenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeeiiedrledtrddukeelrdduieeinecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopegludelvddrudeikedrtddrvddungdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohephhhvvghrkhhuihhlseigshegrghllhdrnhhlnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,


On 18/02/2019 10.08, Hans Verkuil wrote:
> Hi Brad,
>
> On 1/15/19 2:24 AM, Brad Love wrote:
>> Hauppauge USBLive2 was reported broken. A change in media controller
>> logic appears to be the culprit.
>>
>> Fixes: 9d6d20e652 ("v4l2-mc: switch it to use the new approach to setu=
p pipelines")
>>
>> Without "taint" set for signal type, devices
>> with analog capture fail during probe:
>>
>> [    5.821715] cx231xx 3-2:1.1: v4l2 driver version 0.0.3
>> [    5.955721] cx231xx 3-2:1.1: Registered video device video0 [v4l2]
>> [    5.955797] cx231xx 3-2:1.1: Registered VBI device vbi0
>> [    5.955802] cx231xx 3-2:1.1: video EndPoint Addr 0x84, Alternate se=
ttings: 5
>> [    5.955805] cx231xx 3-2:1.1: VBI EndPoint Addr 0x85, Alternate sett=
ings: 2
>> [    5.955807] cx231xx 3-2:1.1: sliced CC EndPoint Addr 0x86, Alternat=
e settings: 2
>> [    5.955834] cx231xx 3-2:1.1: V4L2 device vbi0 deregistered
>> [    5.955889] cx231xx 3-2:1.1: V4L2 device video0 deregistered
>> [    5.959131] cx231xx: probe of 3-2:1.1 failed with error -22
>> [    5.959190] usbcore: registered new interface driver cx231xx
>>
>>
>> This series sets the taint as follows:
>> - source pads from the bridge to PAD_SIGNAL_ANALOG
>> - sink pads on the decoder to PAD_SIGNAL_ANALOG
>> - source pads on the decoder to PAD_SIGNAL_DV
> Mauro asked me to look at this, but it is still failing for me:
>
> [ 2046.476092] usb usb3: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0002, bcdDevice=3D 5.00
> [ 2046.476098] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
> [ 2046.476102] usb usb3: Product: xHCI Host Controller
> [ 2046.476107] usb usb3: Manufacturer: Linux 5.0.0-rc1-zen xhci-hcd
> [ 2046.476111] usb usb3: SerialNumber: 0000:39:00.0
> [ 2046.476677] hub 3-0:1.0: USB hub found
> [ 2046.476898] hub 3-0:1.0: 2 ports detected
> [ 2046.478160] xhci_hcd 0000:39:00.0: xHCI Host Controller
> [ 2046.478677] xhci_hcd 0000:39:00.0: new USB bus registered, assigned =
bus number 4
> [ 2046.478690] xhci_hcd 0000:39:00.0: Host supports USB 3.1 Enhanced Su=
perSpeed
> [ 2046.478838] usb usb4: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0003, bcdDevice=3D 5.00
> [ 2046.478843] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
> [ 2046.478847] usb usb4: Product: xHCI Host Controller
> [ 2046.478851] usb usb4: Manufacturer: Linux 5.0.0-rc1-zen xhci-hcd
> [ 2046.478855] usb usb4: SerialNumber: 0000:39:00.0
> [ 2046.479180] hub 4-0:1.0: USB hub found
> [ 2046.479206] hub 4-0:1.0: 2 ports detected
> [ 2046.802013] usb 3-2: new high-speed USB device number 2 using xhci_h=
cd
> [ 2046.934170] usb 3-2: New USB device found, idVendor=3D2040, idProduc=
t=3Dc200, bcdDevice=3D40.01
> [ 2046.934188] usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
> [ 2046.934197] usb 3-2: Product: Hauppauge Device
> [ 2046.934206] usb 3-2: Manufacturer: Hauppauge
> [ 2046.934214] usb 3-2: SerialNumber: 0013567005
> [ 2046.942224] cx231xx 3-2:1.1: New device Hauppauge Hauppauge Device @=
 480 Mbps (2040:c200) with 6 interfaces
> [ 2046.942626] cx231xx 3-2:1.1: can't change interface 3 alt no. to 3: =
Max. Pkt size =3D 0
> [ 2046.942631] cx231xx 3-2:1.1: Identified as Hauppauge USB Live 2 (car=
d=3D9)
> [ 2046.944251] i2c i2c-10: Added multiplexed i2c bus 12
> [ 2046.944382] i2c i2c-10: Added multiplexed i2c bus 13
> [ 2047.054566] cx25840 9-0044: cx23102 A/V decoder found @ 0x88 (cx231x=
x #0-0)
> [ 2049.997665] cx25840 9-0044: loaded v4l-cx231xx-avcore-01.fw firmware=
 (16382 bytes)
> [ 2050.091897] cx231xx 3-2:1.1: v4l2 driver version 0.0.3
> [ 2050.307929] cx231xx 3-2:1.1: Registered video device video0 [v4l2]
> [ 2050.308349] cx231xx 3-2:1.1: Registered VBI device vbi0
> [ 2050.314083] cx231xx 3-2:1.1: audio EndPoint Addr 0x83, Alternate set=
tings: 3
> [ 2050.314131] cx231xx 3-2:1.1: video EndPoint Addr 0x84, Alternate set=
tings: 5
> [ 2050.314135] cx231xx 3-2:1.1: VBI EndPoint Addr 0x85, Alternate setti=
ngs: 2
> [ 2050.314138] cx231xx 3-2:1.1: sliced CC EndPoint Addr 0x86, Alternate=
 settings: 2
> [ 2050.314148] usb 3-2: couldn't get decoder output pad for V4L I/O
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> [ 2050.314151] cx231xx 3-2:1.1: V4L2 device vbi0 deregistered
> [ 2050.314449] cx231xx 3-2:1.1: V4L2 device video0 deregistered
> [ 2050.316448] cx231xx: probe of 3-2:1.1 failed with error -22
>
> Can you take another look?
>
> See also:
>
> https://lore.kernel.org/linux-media/1550027010.2460608.1656864112.3A25F=
771@webmail.messagingengine.com/
>
> And also:
>
> https://patchwork.kernel.org/patch/10763655/
>
> I'm really confused what the status is and what has and hasn't been tes=
ted/reviewed.
>
> Regards,
>
> 	Hans


I fetched tip and rebased with both patches from this series applied.
When A usblive2 is connected everything works.

Note, patch 1/2 just explicitly sets sig_type, but is not required, as
found out later during testing. Patch 2/2 by itself fixes this issue
entirely. The message from 1/2 should have been in 2/2, since that is
the fix. Patch 1/2 does not have any adverse affects in operation.



[=C2=A0=C2=A0 10.432033] usb 3-2: new high-speed USB device number 3 usin=
g xhci_hcd
[=C2=A0=C2=A0 10.582784] usb 3-2: New USB device found, idVendor=3D2040,
idProduct=3Dc200, bcdDevice=3D40.01
[=C2=A0=C2=A0 10.582787] usb 3-2: New USB device strings: Mfr=3D1, Produc=
t=3D2,
SerialNumber=3D3
[=C2=A0=C2=A0 10.582788] usb 3-2: Product: Hauppauge Device
[=C2=A0=C2=A0 10.582789] usb 3-2: Manufacturer: Hauppauge
[=C2=A0=C2=A0 10.582790] usb 3-2: SerialNumber: 0013871590
[=C2=A0=C2=A0 10.710747] media: Linux media interface: v0.10
[=C2=A0=C2=A0 10.715890] videodev: Linux video capture interface: v2.00
[=C2=A0=C2=A0 10.731810] cx231xx 3-2:1.1: New device Hauppauge Hauppauge =
Device @
480 Mbps (2040:c200) with 6 interfaces
[=C2=A0=C2=A0 10.731902] cx231xx 3-2:1.1: can't change interface 3 alt no=
=2E to 3:
Max. Pkt size =3D 0
[=C2=A0=C2=A0 10.731904] cx231xx 3-2:1.1: Identified as Hauppauge USB Liv=
e 2 (card=3D9)
[=C2=A0=C2=A0 10.733128] i2c i2c-17: Added multiplexed i2c bus 19
[=C2=A0=C2=A0 10.733221] i2c i2c-17: Added multiplexed i2c bus 20
[=C2=A0=C2=A0 10.870542] cx25840 16-0044: cx23102 A/V decoder found @ 0x8=
8
(cx231xx #0-0)
[=C2=A0=C2=A0 12.995801] cx25840 16-0044: loaded v4l-cx231xx-avcore-01.fw=
 firmware
(16382 bytes)
[=C2=A0=C2=A0 13.027555] cx231xx 3-2:1.1: v4l2 driver version 0.0.3
[=C2=A0=C2=A0 13.125674] cx231xx 3-2:1.1: Registered video device video0 =
[v4l2]
[=C2=A0=C2=A0 13.125736] cx231xx 3-2:1.1: Registered VBI device vbi0
[=C2=A0=C2=A0 13.125741] cx231xx 3-2:1.1: video EndPoint Addr 0x84, Alter=
nate
settings: 5
[=C2=A0=C2=A0 13.125744] cx231xx 3-2:1.1: VBI EndPoint Addr 0x85, Alterna=
te
settings: 2
[=C2=A0=C2=A0 13.125747] cx231xx 3-2:1.1: sliced CC EndPoint Addr 0x86, A=
lternate
settings: 2
[=C2=A0=C2=A0 13.125920] usbcore: registered new interface driver cx231xx=

[=C2=A0=C2=A0 13.136241] cx231xx 3-2:1.1: audio EndPoint Addr 0x83, Alter=
nate
settings: 3
[=C2=A0=C2=A0 13.136245] cx231xx 3-2:1.1: Cx231xx Audio Extension initial=
ized




>>
>>
>> Brad Love (2):
>>   cx231xx-video: Set media controller taint for analog outputs
>>   cx25840-core: Set media controller taint for pads
>>
>>  drivers/media/i2c/cx25840/cx25840-core.c  | 6 ++++++
>>  drivers/media/usb/cx231xx/cx231xx-video.c | 1 +
>>  2 files changed, 7 insertions(+)
>>

