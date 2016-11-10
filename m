Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:41339
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932341AbcKJVvZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 16:51:25 -0500
Date: Thu, 10 Nov 2016 22:51:21 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: question about hva_hw_probe
Message-ID: <alpine.DEB.2.20.1611102242470.1970@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function hva_hw_probe in the file
drivers/media/platform/sti/hva/hva-hw.c contains the following code:

        /* get memory for esram */
        esram = platform_get_resource(pdev, IORESOURCE_MEM, 1);
        if (IS_ERR_OR_NULL(esram)) {
                dev_err(dev, "%s     failed to get esram\n", HVA_PREFIX);
                return PTR_ERR(esram);
        }
        hva->esram_addr = esram->start;
        hva->esram_size = resource_size(esram);

platform_get_resource only returns NULL on failure, so the test of
IS_ERR_OR_NULL doesn't look appropriate.  Nor does the return value of
PTR_ERR(esram), which will be 0 on a NULL result.  But I wondered if it
was intended to have a call to devm_ioremap_resource between the
platform_get_resource and the IS_ERR_OR_NULL test (which should be just
IS_ERR; likewise for the call just above)?

thanks,
julia
