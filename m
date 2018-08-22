Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f182.google.com ([209.85.208.182]:32794 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbeHVG7S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 02:59:18 -0400
Received: by mail-lj1-f182.google.com with SMTP id s12-v6so389512ljj.0
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 20:36:21 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id h73-v6sm89429lfb.58.2018.08.21.20.36.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Aug 2018 20:36:20 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id c7-v6so388159lfe.0
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 20:36:20 -0700 (PDT)
MIME-Version: 1.0
From: Helen Koike <helen@koikeco.de>
Date: Wed, 22 Aug 2018 00:35:59 -0300
Message-ID: <CAPW4XYY0k_rjbhTNVOjUcm6cpOXRyoDYk81HV0honCgFF+Crig@mail.gmail.com>
Subject: Question regarding optimizing pipeline in Vimc
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Guilherme Alcarde Gallo <gagallo7@gmail.com>,
        =?UTF-8?Q?Lucas_Magalh=C3=A3es?= <lucmaga@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

One of the discussions we had when developing Vimc, was regarding
optimizing image generation.
The ideia was to generate the images directly in the capture instead
of propagating through the pipeline (to make things faster).
But my question is: if this optimization is on, and if there is a
greyscaler filter in the middle of the pipeline, do you expect to see
a grey image with this optimization? Or if we just generate a dummy
image (with the right size format) at the end of the pipeline, would
it be ok? (I am asking because it doesn't sound that simple to
propagate the image transformation made by each entity in the pipe)
Or do you have any other thing in mind?

Thanks
Helen
