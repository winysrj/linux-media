Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54C6C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 18:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC62720661
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 18:26:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ce7/VZ+s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfCGS0Z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 13:26:25 -0500
Received: from mail-ed1-f42.google.com ([209.85.208.42]:36683 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfCGS0Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 13:26:25 -0500
Received: by mail-ed1-f42.google.com with SMTP id g9so14310331eds.3
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2019 10:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jNaX/VrxJMLXH7Ds064jA6nG9NyVJIwDczO/mu6ELdI=;
        b=Ce7/VZ+sIxTZde0r48H1d0ayNp2bS9tnIkEAKyjDYe9Dko+UPJdVFoueutcglAt3I1
         Z9wqipYOFLpVi6sTruAMIyxnNWsE5OQrdnOVkfnVJrAGQs3/CWinFbYVnMbpkmdZifDR
         GWS1f3ylnI4us6xlGAVPgAQt2osnbaqjguYMVgPzt0ScmMR7Lwf5d4iCPQMYDhYu4Nas
         s6byMl5zZBMjHkilbcI8faMc1Zs88uCfmIAEf4pOyUDP0rT0Q5bf7cA/mwdtUQFlwlcf
         lZIUkjUnHxjs7b3h1wQDCHiPbzLnnCAuAuqz4EXTQo+pwVnMJ/MJ5VF9fGL2OLbrwfpx
         zDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jNaX/VrxJMLXH7Ds064jA6nG9NyVJIwDczO/mu6ELdI=;
        b=Fj7cUEjCx3jU3ii58fEGDWAivDO6rlVNHpTVlspCs/Epsyh0YonR48dJl3GPUExbQn
         tGL0cJ3yVLPTRxanYFcAugu1d+HZG1GpVWI6Pxufc5LtDFmlYY8lqAWV8T1THWTofSyg
         +Pyqk2i+p5yZtTFJqghKbhSx6VoSjHWlr0yPvC6yIiV6b7GHpyNm5AnENZeQuErIhfBT
         JgSD5fYrH7Ec70qx8c4ZTyr1YdBM4Ln6RBNJ4TZshKuLP28mOWWCyldrpGnmXcZqygo/
         /PWho7qGxsaITCKsJu7zQTQYOIx4WZCW/gF51CuyFVjqWHQTZEnw0Hh2yDMjQ8ytoJiI
         64EA==
X-Gm-Message-State: APjAAAUF5dn2ZK9NWaJB/wOXe6lx8eNQPAnpHYAcLEhq+pOj7wQWJhRV
        JaaGM5JjK+T+d0YBzOA887/xrlCwFsuVyotZi8ypVR/R
X-Google-Smtp-Source: APXvYqzh48jqry48Tzuch2JcgQCo5OLjXIar6ijpK5PjceuxksEehIkvXFjyOvnHToeTWg8Sx0RehUZEDtIDkZZlles=
X-Received: by 2002:a50:9156:: with SMTP id f22mr29825119eda.131.1551983182731;
 Thu, 07 Mar 2019 10:26:22 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?Q?Salvador_Fern=C3=A1ndez?= <moltitronico@gmail.com>
Date:   Thu, 7 Mar 2019 19:26:23 +0100
Message-ID: <CAD4B5T9UggLZgxvmaCLSxgB8=MLtXLszmGcoY_H7rhFat1irBg@mail.gmail.com>
Subject: Suppor for a new usb webcam for the uvcdriver
To:     linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi developers,

In the past( https://www.spinics.net/lists/linux-media/msg147477.html
) I reported how to add support to a new HP USB webcam for the
uvcdriver driver. It was only a matter of adding de vendorId y
productId to the driver and the webcam worked perfectly. I believe
that change will not be included in future kernels.
Do I need to send a PATCH so that the change is accepted?

Thanks in advance for your support.

Un saludo,

Salvador Fern=C3=A1ndez
