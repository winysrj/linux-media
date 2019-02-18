Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B291C10F01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 11:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D321A217F4
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 11:12:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fpond.eu header.i=@fpond.eu header.b="m2WsnIjG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbfBRLMV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 06:12:21 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:16965 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729013AbfBRLMV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 06:12:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1550488339;
        s=strato-dkim-0002; d=fpond.eu;
        h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=aBGmTPvVWEFvgbr8TYQPEE+EsuLM56MvYlMQzuIWvXE=;
        b=m2WsnIjGKfvUvIjP9AWVUMl+sxhu1xT85PMtsJIc8Ec1ZbFesnBcUwIa4i6QabYLHS
        YENAmL5Js2wTSObCnV5SowS6zK9WWZxnehxMFuryIaXGsVdyCDe3jDpsvHL+PyRBUzhM
        sycgdC4P4P6rqWBmJh8sWl/8Sejp6//Xh34L384+++CaTy8/IXRrCJQjBjmUoei1yRux
        Hz+ONnBQ3hoc5BNjVVQ2Dsvr6UMof+rcELNV2p51k9ckwS0CXxQlMSNXB8phPmAe0GE2
        wS9zpTUncERhy6t3CQWhowL15I8hakxymE5LMSRj1ZfI+4x0altQnO61EpVNytlJPfuz
        73qA==
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzmt2bYDnKIKaws6YXTsc4="
X-RZG-CLASS-ID: mo00
Received: from oxapp01-03.back.ox.d0m.de
        by smtp-ox.front (RZmta 44.9 AUTH)
        with ESMTPSA id V028b8v1IBCJQEb
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Mon, 18 Feb 2019 12:12:19 +0100 (CET)
Date:   Mon, 18 Feb 2019 12:12:19 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org
Message-ID: <1597578789.516973.1550488339434@webmail.strato.com>
In-Reply-To: <20190218100313.14529-3-niklas.soderlund+renesas@ragnatech.se>
References: <20190218100313.14529-1-niklas.soderlund+renesas@ragnatech.se>
 <20190218100313.14529-3-niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH 2/3] rcar-csi2: Update start procedure for H3 ES2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev50
X-Originating-IP: 188.192.207.28
X-Originating-Client: open-xchange-appsuite
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


> On February 18, 2019 at 11:03 AM Niklas S=C3=B6derlund <niklas.soderlund+=
renesas@ragnatech.se> wrote:
>=20
>=20
> Latest information from hardware engineers reveals that H3 ES2 and ES3
> of behaves differently when working with link speeds bellow 250 Mpbs.
> Add a SoC match for H3 ES2.* and use the correct startup sequence.

It would be helpful to explain how they behave differently. My guess is tha=
t the extra steps "Set the PHTW to H=E2=80=B20139 0105." and "Set the PHTW =
to the appropriate values for the HS reception frequency." from the flowcha=
rt can/must be omitted on ES2+, but I think it would be better if that were=
 stated explicitly somewhere.

With that fixed:

Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>

CU
Uli
