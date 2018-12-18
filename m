Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF52C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 06:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D742221841
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 06:44:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=spam.dobel.click header.i=@spam.dobel.click header.b="IPDOQcxU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbeLRGom (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 01:44:42 -0500
Received: from mo4-p05-ob.smtp.rzone.de ([85.215.255.131]:27638 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbeLRGom (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 01:44:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1545115480;
        s=strato-dkim-0002; d=spam.dobel.click;
        h=Message-ID:From:CC:To:Subject:References:In-Reply-To:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=hytjffTwMgOexxg8Bjcz30SICgRdjgUzSC+p7dHCLoA=;
        b=IPDOQcxUOagNOla/+i/bOxmCzXaRv+XBCyNINuhGMK6bRUjI5L43ZMX+XP8xntly0k
        qflD77EoH/Ic7zWMtTkd29hvNpRWxUN3GDqWniVK5KHuPJ0tnRCL7hodtAkNitRni328
        L3+yy/bmwblappzBkhnfFUGlDdWVbSjpofxOaj1gioXyVW6k2U5fApTuSv4ZtIoPCV0l
        n3Gx9Om5B9iysPaiGVAj9tjFrzb4SYr9n9uo8JiHu2+J8IEVaKDfTARNtuzvLQbLqFeu
        xyjHnBmGOHLIxbYNf7zeUZg5dB6TeCvOt8iUPS8JRl2I0lp1Ljs7uYMajT+Ex/d0/obx
        oP/Q==
X-RZG-AUTH: ":O2kGeEG7b/pS1F6pSnL9jeN+13y5RJmU4P3fJr/G5t0ui5Acx8X0cDNeCSxopc53VF6bgGbyVolcMoOkh9bmg4rtFcrFUReGxan5UJOhBzM="
X-RZG-CLASS-ID: mo05
Received: from [IPv6:2003:e3:5710:3b00:4468:88c9:a13:24d3]
        by smtp.strato.de (RZmta 44.8 AUTH)
        with ESMTPSA id n06405uBI6WeFlU
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp384r1 with 384 ECDH bits, eq. 7680 bits RSA))
        (Client did not present a certificate);
        Tue, 18 Dec 2018 07:32:40 +0100 (CET)
Date:   Tue, 18 Dec 2018 07:32:42 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <CADnq5_Ntq7_pXkTE53-PV15G5BUP9WOJ8YQ8+Q+OBzCkWVRCgQ@mail.gmail.com>
References: <3d7393a6287db137a69c4d05785522d5@gmx.de> <20181205090721.43e7f36c@coco.lan> <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc> <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de> <20181206160145.2d23ac0e@coco.lan> <8858694d5934ce78e46ef48d6f90061a@gmx.de> <20181216122315.2539ae80@coco.lan> <CADnq5_Ntq7_pXkTE53-PV15G5BUP9WOJ8YQ8+Q+OBzCkWVRCgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall fixes
To:     Alex Deucher <alexdeucher@gmail.com>, mchehab@kernel.org,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
CC:     Brad Love <brad@nextdimension.cc>,
        linux-media <linux-media@vger.kernel.org>,
        linux-media-owner@vger.kernel.org
From:   Markus Dobel <markus.dobel@gmx.de>
Message-ID: <D95D27BE-8761-4451-9AC7-11677F6D1DAD@gmx.de>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



Am 18=2E Dezember 2018 03:05:11 MEZ schrieb Alex Deucher <alexdeucher@gmai=
l=2Ecom>:

>possibly?  It's still not clear to me that this is specific to ryzen
>chips rather than a problem with the DMA setup on the cx board=2E  Is
>there a downside to enabling the workaround in general? =20

Hi Alex,

yes, there is=2E At least for me, the resetting function breaks the driver=
, making the card unresponsive after a few hours of uptime=2E Without that =
function, the card is perfectly stable=2E

Markus

--=20
Gesendet mit zwei Streichh=C3=B6lzern, einem Gummiband und etwas Draht=2E
