Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43874C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 10:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1000420850
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 10:35:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=eatwithus.eu header.i=@eatwithus.eu header.b="Qs8hHpbz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfCVKfi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 06:35:38 -0400
Received: from mail.eatwithus.eu ([176.107.131.6]:38236 "EHLO eatwithus.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbfCVKfi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 06:35:38 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2019 06:35:37 EDT
Received: by eatwithus.eu (Postfix, from userid 1001)
        id 7B1AD88AFF; Fri, 22 Mar 2019 11:25:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=eatwithus.eu; s=mail;
        t=1553250342; bh=cd5EgeQdknypVv/toasjvJr+1fSRH55Ph4rD02X3yd0=;
        h=Date:From:To:Subject:From;
        b=Qs8hHpbzHbNCddgeB0v5+UFKxVlz9yDn2+efcfOjanIOGWyft5lU+qtW6/sPYIYy+
         7oEJFecOTxBNc9UicjYBUvIYheGOywKOoBNwsf5Lg5HvgVp2rQb9OcQ2AkzkYyBefM
         +ScFLc+qkbo2OsbroEUmsDKq/P8Vpnonsl4pYAI0=
Received: by mail.eatwithus.eu for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 10:25:16 GMT
Message-ID: <20190322112453-0.1.i.9qd.0.r3hxj58op9@eatwithus.eu>
Date:   Fri, 22 Mar 2019 10:25:16 GMT
From:   "Radoslav Dobrev" <radoslav.dobrev@eatwithus.eu>
To:     <linux-media@vger.kernel.org>
Subject: =?UTF-8?Q?=D0=9C=D0=BE=D1=82=D0=B8=D0=B2=D0=B8=D1=80=D0=B0=D0=BD_=D0=BF=D0=B5=D1=80=D1=81=D0=BE=D0=BD=D0=B0=D0=BB?=
X-Mailer: mail.eatwithus.eu
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

=D0=97=D0=B4=D1=80=D0=B0=D0=B2=D0=B5=D0=B9=D1=82=D0=B5!

=D0=92=D0=B0=D1=83=D1=87=D0=B5=D1=80=D0=B8=D1=82=D0=B5 =D0=B7=D0=B0 =D1=85=
=D1=80=D0=B0=D0=BD=D0=B0 =D1=81=D0=B5 =D0=BD=D0=B0=D1=80=D0=B5=D0=B6=D0=B4=
=D0=B0=D1=82 =D1=81=D1=80=D0=B5=D0=B4 =D0=BB=D1=8E=D0=B1=D0=B8=D0=BC=D0=B8=
=D1=82=D0=B5 =D1=81=D0=BE=D1=86=D0=B8=D0=B0=D0=BB=D0=BD=D0=B8 =D0=BF=D1=80=
=D0=B8=D0=B4=D0=BE=D0=B1=D0=B8=D0=B2=D0=BA=D0=B8 =D0=BD=D0=B0 =D1=80=D0=B0=
=D0=B1=D0=BE=D1=82=D0=B5=D1=89=D0=B8=D1=82=D0=B5 =D1=85=D0=BE=D1=80=D0=B0=
 =D0=B8 =D1=81=D1=80=D0=B5=D0=B4 =D0=BD=D0=B0=D0=B9-=D0=BF=D1=80=D0=B5=D0=
=B4=D0=BF=D0=BE=D1=87=D0=B8=D1=82=D0=B0=D0=BD=D0=B8=D1=82=D0=B5 =D0=BD=D0=
=B0=D1=87=D0=B8=D0=BD=D0=B8 =D0=B7=D0=B0 =D1=81=D1=82=D0=B8=D0=BC=D1=83=D0=
=BB=D0=B8=D1=80=D0=B0=D0=BD=D0=B5 =D0=BE=D1=82 =D1=80=D0=B0=D0=B1=D0=BE=D1=
=82=D0=BE=D0=B4=D0=B0=D1=82=D0=B5=D0=BB=D0=B8=D1=82=D0=B5. =D0=A2=D0=B5 =D0=
=BF=D0=BE=D0=B4=D0=BE=D0=B1=D1=80=D1=8F=D0=B2=D0=B0=D1=82 =D0=B5=D1=84=D0=
=B5=D0=BA=D1=82=D0=B8=D0=B2=D0=BD=D0=BE=D1=81=D1=82=D1=82=D0=B0 =D0=B8 =D0=
=BF=D1=80=D0=BE=D0=B8=D0=B7=D0=B2=D0=BE=D0=B4=D0=B8=D1=82=D0=B5=D0=BB=D0=BD=
=D0=BE=D1=81=D1=82=D1=82=D0=B0 =D0=BD=D0=B0 =D0=92=D0=B0=D1=88=D0=B8=D1=82=
=D0=B5 =D1=81=D0=BB=D1=83=D0=B6=D0=B8=D1=82=D0=B5=D0=BB=D0=B8.

=D0=91=D0=BB=D0=B0=D0=B3=D0=BE=D0=B4=D0=B0=D1=80=D0=B5=D0=BD=D0=B8=D0=B5 =
=D0=BD=D0=B0 =D0=B2=D0=B0=D1=83=D1=87=D0=B5=D1=80=D0=B8=D1=82=D0=B5 =D0=B7=
=D0=B0 =D1=85=D1=80=D0=B0=D0=BD=D0=B0 =D1=80=D0=B5=D0=B0=D0=BB=D0=B8=D0=B7=
=D0=B8=D1=80=D0=B0=D1=82=D0=B5 =D1=81=D0=BF=D0=B5=D1=81=D1=82=D1=8F=D0=B2=
=D0=B0=D0=BD=D0=B8=D1=8F =E2=80=93 =D1=81=D1=82=D0=BE=D0=B9=D0=BD=D0=BE=D1=
=81=D1=82=D1=82=D0=B0 =D0=BD=D0=B0 =D0=B2=D0=B0=D1=83=D1=87=D0=B5=D1=80=D0=
=B8=D1=82=D0=B5 =D0=BD=D0=B5 =D1=81=D0=B5 =D0=BE=D0=B1=D0=BB=D0=B0=D0=B3=D0=
=B0 =D1=81 =D0=B4=D0=B0=D0=BD=D1=8A=D1=86=D0=B8 =D0=B8 =D0=BE=D1=81=D0=B8=
=D0=B3=D1=83=D1=80=D0=BE=D0=B2=D0=BA=D0=B8 =D0=B4=D0=BE 60=D0=BB=D0=B2 =D0=
=BC=D0=B5=D1=81=D0=B5=D1=87=D0=BD=D0=BE =D0=B7=D0=B0 =D0=B2=D1=81=D0=B5=D0=
=BA=D0=B8 =D1=80=D0=B0=D0=B1=D0=BE=D1=82=D0=BD=D0=B8=D0=BA, =D0=B0 =D0=B2=
 =D1=81=D1=8A=D1=89=D0=BE=D1=82=D0=BE =D0=B2=D1=80=D0=B5=D0=BC=D0=B5 =D0=BC=
=D0=BE=D1=82=D0=B8=D0=B2=D0=B0=D1=86=D0=B8=D1=8F=D1=82=D0=B0 =D0=B8 =D0=BF=
=D0=BE=D0=BA=D1=83=D0=BF=D0=B0=D1=82=D0=B5=D0=BB=D0=BD=D0=B0=D1=82=D0=B0 =
=D1=81=D0=BF=D0=BE=D1=81=D0=BE=D0=B1=D0=BD=D0=BE=D1=81=D1=82 =D0=BD=D0=B0=
 =D1=81=D0=BB=D1=83=D0=B6=D0=B8=D1=82=D0=B5=D0=BB=D0=B8=D1=82=D0=B5 =D0=BD=
=D0=B0=D1=80=D0=B0=D1=81=D1=82=D0=B2=D0=B0.

=D0=90=D0=BA=D0=BE =D0=BF=D1=80=D0=BE=D1=8F=D0=B2=D1=8F=D0=B2=D0=B0=D1=82=
=D0=B5 =D0=B8=D0=BD=D1=82=D0=B5=D1=80=D0=B5=D1=81 =D0=BA=D1=8A=D0=BC =D0=B2=
=D1=8A=D0=B7=D0=BC=D0=BE=D0=B6=D0=BD=D0=BE=D1=81=D1=82=D0=B8=D1=82=D0=B5 =
=D0=B7=D0=B0 =D0=B2=D1=8A=D0=B2=D0=B5=D0=B6=D0=B4=D0=B0=D0=BD=D0=B5 =D0=BD=
=D0=B0 =D0=B2=D0=B0=D1=83=D1=87=D0=B5=D1=80=D0=B8 =D0=B7=D0=B0 =D1=85=D1=80=
=D0=B0=D0=BD=D0=B0 =D0=B2=D1=8A=D0=B2 =D0=92=D0=B0=D1=88=D0=B0=D1=82=D0=B0=
 =D1=84=D0=B8=D1=80=D0=BC=D0=B0 =D0=B8 =D0=B6=D0=B5=D0=BB=D0=B0=D0=B5=D1=82=
=D0=B5 =D0=BF=D0=BE-=D0=BF=D0=BE=D0=B4=D1=80=D0=BE=D0=B1=D0=BD=D0=B0 =D0=B8=
=D0=BD=D1=84=D0=BE=D1=80=D0=BC=D0=B0=D1=86=D0=B8=D1=8F, =D0=B8=D0=B7=D0=BF=
=D1=80=D0=B0=D1=82=D0=B5=D1=82=D0=B5 =D0=BC=D0=B8 =D1=81=D1=8A=D0=BE=D0=B1=
=D1=89=D0=B5=D0=BD=D0=B8=D0=B5.


=D0=A0=D0=B0=D0=B4=D0=BE=D1=81=D0=BB=D0=B0=D0=B2 =D0=94=D0=BE=D0=B1=D1=80=
=D0=B5=D0=B2
Head of HR Benefit Team
www.eatwithus.eu  
