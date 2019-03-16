Return-Path: <SRS0=HTTW=RT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4C0C43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 21:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7C0B218A1
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 21:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfCPVt2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Mar 2019 17:49:28 -0400
Received: from retiisi.org.uk ([95.216.213.190]:44320 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbfCPVt2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Mar 2019 17:49:28 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id DC859634C84;
        Sat, 16 Mar 2019 23:47:41 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1h5H9a-00042I-KK; Sat, 16 Mar 2019 23:47:42 +0200
Date:   Sat, 16 Mar 2019 23:47:42 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Mickael Guene <mickael.guene@st.com>
Cc:     linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/3] media: MAINTAINERS: add entry for
 STMicroelectronics MIPID02 media driver
Message-ID: <20190316214742.64wxxracq6giv3kk@valkosipuli.retiisi.org.uk>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1552373045-134493-4-git-send-email-mickael.guene@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552373045-134493-4-git-send-email-mickael.guene@st.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 12, 2019 at 07:44:05AM +0100, Mickael Guene wrote:
> Add maintainer entry for the STMicroelectronics MIPID02 CSI-2 to PARALLEL
> bridge driver and dt-bindings.
> 
> Signed-off-by: Mickael Guene <mickael.guene@st.com>
> ---
> 
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1c6ecae..4bd36b1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14424,6 +14424,14 @@ S:	Maintained
>  F:	drivers/iio/imu/st_lsm6dsx/
>  F:	Documentation/devicetree/bindings/iio/imu/st_lsm6dsx.txt
>  
> +ST MIPID02 CSI-2 TO PARALLEL BRIDGE DRIVER
> +M:	Mickael Guene <mickael.guene@st.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/i2c/st-mipid02.c
> +F:	Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt

Could you squash this to the first patch, so that there are no files added
without them being listed here?

-- 
Sakari Ailus
