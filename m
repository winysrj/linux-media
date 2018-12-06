Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86707C04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 17:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF392205C9
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 17:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=spam.dobel.click header.i=@spam.dobel.click header.b="Mtruxbld"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF392205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbeLFRa3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 12:30:29 -0500
Received: from mo4-p05-ob.smtp.rzone.de ([85.215.255.136]:21828 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbeLFRa2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 12:30:28 -0500
X-Greylist: delayed 725 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2018 12:30:28 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1544117427;
        s=strato-dkim-0002; d=spam.dobel.click;
        h=Message-ID:From:CC:To:Subject:References:In-Reply-To:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=44fYicFtSfZpauqcTAmBLcm0q0jYLFKIANWIZL7++0M=;
        b=MtruxbldAdT3r1F94RNs6DDfI3KawSLKayIFMz7T6tTFYZt3raJjXGRAVOgPSyurAE
        /8W71Qp4JGN5ILURj7ksTbhkY3nojlaX1T6BDmNB/iWYcYxmVR0VqCGjPLPTg2W0jJKU
        U1Uytx7Ca3s5mLDJtWYn1mpQkG0XQadGk/TOOPvGFs+yJPbhQb/Z8cYOF+45td3qVbM0
        2iKBgInZ/qmGZl3d5sWrSOthMSIuwQ3sj+BH0RRQht3ItrFvpCASMK4FQqn+3Trn8nRQ
        4p1RdR3fqC0Lga88njDJcbuI1LwW8aCwCvLzarUHHPs5c518ac6v3hWVqhPo/evhzgR5
        1r9w==
X-RZG-AUTH: ":O2kGeEG7b/pS1F6pSnL9jeN+13y5RJmU4P3fJr/G5t0ui5Acx8X0cDNeCSw5pcx31iY1id9s7xzrepg/3uTgT0uKNQ+j5xvRznGdf31LbPCw3Q=="
X-RZG-CLASS-ID: mo05
Received: from [IPv6:2a01:598:9087:6ad0:a531:3a67:d902:7b83]
        by smtp.strato.de (RZmta 44.6 AUTH)
        with ESMTPSA id t0084buB6HIJrTg
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp384r1 with 384 ECDH bits, eq. 7680 bits RSA))
        (Client did not present a certificate);
        Thu, 6 Dec 2018 18:18:19 +0100 (CET)
Date:   Thu, 06 Dec 2018 18:18:23 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc>
References: <3d7393a6287db137a69c4d05785522d5@gmx.de> <20181205090721.43e7f36c@coco.lan> <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall fixes
To:     Brad Love <brad@nextdimension.cc>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC:     linux-media@vger.kernel.org
From:   Markus Dobel <markus.dobel@gmx.de>
Message-ID: <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi everyone,

I will try if the hack mentioned fixes the issue for me on the weekend (bu=
t I assume, as if effectively removes the function)=2E

Just in case this is of interest, I neither have Ryzen nor Intel, but an H=
P Microserver G7 with an AMD Turion II Neo  N54L, so the machine is more on=
 the slow side=2E=20

Regards, Markus
--=20
Gesendet mit zwei Streichh=C3=B6lzern, einem Gummiband und etwas Draht=2E
