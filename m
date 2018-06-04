Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:53020 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751842AbeFDHGe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 03:06:34 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
References: <m37eobudmo.fsf@t19.piap.pl>
        <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
        <m3tvresqfw.fsf@t19.piap.pl>
        <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
        <m3fu2oswjh.fsf@t19.piap.pl> <m3603hsa4o.fsf@t19.piap.pl>
        <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
        <m3h8mxqc7t.fsf@t19.piap.pl>
        <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
        <1527229949.4938.1.camel@pengutronix.de> <m3y3g8p5j3.fsf@t19.piap.pl>
        <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com>
        <m3lgc2q5vl.fsf@t19.piap.pl>
        <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com>
        <m38t81plry.fsf@t19.piap.pl>
        <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com>
        <m336y9ouc4.fsf@t19.piap.pl>
        <6923fcd4-317e-d6a6-7975-47a8c712f8f9@gmail.com>
        <m3sh66omdk.fsf@t19.piap.pl> <1527858788.5913.2.camel@pengutronix.de>
Date: Mon, 04 Jun 2018 09:06:32 +0200
In-Reply-To: <1527858788.5913.2.camel@pengutronix.de> (Philipp Zabel's message
        of "Fri, 01 Jun 2018 15:13:08 +0200")
Message-ID: <m38t7vni87.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Philipp Zabel <p.zabel@pengutronix.de> writes:

> My understanding is that the CCIR codes for height == 480 (NTSC)
> currently capture the second field (top) first, assuming that for NTSC
> the EAV/SAV codes are bottom-field-first.

2a38014: 010D07DF 00040596

        SA  EA         SB  EB  SB  EB
D07DF: 001 101 (0000) 011 111 011 111 (field 0)
40596: 000 100 (0000) 010 110 010 110 (field 1)

The codes apparently are 1=EAV (0=SAV), field#, 1=blanking.
Now BT.656 doesn't say a word about top and bottom fields. There are
just fields 1 and 2. So yes, the CCIR_CODE* registers currently seem to
swap the fields. It also depends on the ADV7180 sending correct codes
based on the even/odd analog fields. Interesting.

> So the CSI captures SEQ_TB for both PAL and NTSC: The three-bit values
> in CCIR_CODE_2/3 are in H,V,F order, and the NTSC case has F=1 for the
> field that is captured first, where F=1 is the field that is marked as
> second field on the wire, so top. Which means that the captured frame
> has two fields captured across frame boundaries, which might be
> problematic if the source data was originally progressive.

Exactly.
Especially if the complete frame is then passed straight to the display,
with the user treating it as progressive (which it isn't anymore).

>>  My guess is the CSI is skipping
>> the first incomplete line (half-line - the first visible line has full
>> length) and BT becomes TB.
>
> That wouldn't make BT TB though, if we'd still capture the bottom field
> (minus its first half line) first?

Well, the entire frame would shift up a line, the bottom "field" would
become top and vice versa. This would effectively make BT->TB and TB->BT.

>> It seems writing to the CCIR_CODE_[12] registers does the trick, though
>> (the captured frames aren't correct and have the lines swapped in pairs
>> because t/b field pointers aren't correctly set).
>
> What are you writing exactly? 0x01040596 to CCIR_CODE_1 and 0x000d07df
> to CCIR_CODE_2?

Yes.

> That is what I would expect to capture SEQ_BT for NTSC
> data, and the IPU could interweave this into INTERLACED_BT, correctly if
> we fix ipu_cpmem_interlaced_scan to allow negative offsets.

Exactly.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
