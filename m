Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:34979 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIXXFs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 19:05:48 -0400
Received: by mail-la0-f53.google.com with SMTP id ge10so11725201lab.12
        for <linux-media@vger.kernel.org>; Wed, 24 Sep 2014 16:05:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5824d4d8b177c3778cea8ef5e345d126e6c46767.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
	<5824d4d8b177c3778cea8ef5e345d126e6c46767.1411597610.git.mchehab@osg.samsung.com>
Date: Wed, 24 Sep 2014 20:05:46 -0300
Message-ID: <CAOMZO5BeuqG77tax==sRAWv00YYRcS5x7zKF61uk1Gg15CCPZA@mail.gmail.com>
Subject: Re: [PATCH 13/18] [media] s5p_mfc_opr_v5: Fix lots of warnings on x86_64
From: Fabio Estevam <festevam@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 24, 2014 at 7:27 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:

> -       mfc_debug(2, "buf_size1: %d, buf_size2: %d\n", buf_size1, buf_size2);
> +       mfc_debug(2, "buf_size1: %zd, buf_size2: %zd\n", buf_size1, buf_size2);


This should be %zu. Same for other %zd ocurrences.
