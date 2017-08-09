Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36702 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752238AbdHII3u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 04:29:50 -0400
Date: Wed, 9 Aug 2017 11:29:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: laurent.pinchart+renesas@ideasonboard.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] v4l: vsp1: Add support for the BRS entity
Message-ID: <20170809082923.zcl3kh4fyow4aqtq@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent Pinchart,

This is a semi-automatic email about new static checker warnings.

The patch 6134148f6098: "v4l: vsp1: Add support for the BRS entity"
from May 25, 2017, leads to the following Smatch complaint:

    drivers/media/platform/vsp1/vsp1_wpf.c:456 wpf_configure()
    error: we previously assumed 'pipe->bru' could be null (see line 450)

drivers/media/platform/vsp1/vsp1_wpf.c
   449	
   450			srcrpf |= (!pipe->bru && pipe->num_inputs == 1)
   451				? VI6_WPF_SRCRPF_RPF_ACT_MST(input->entity.index)
   452				: VI6_WPF_SRCRPF_RPF_ACT_SUB(input->entity.index);
   453		}
   454	
   455		if (pipe->bru || pipe->num_inputs > 1)
                    ^^^^^^^^^
Check for NULL.

   456			srcrpf |= pipe->bru->type == VSP1_ENTITY_BRU
                                  ^^^^^^^^^^^
Patch adds new unchecked dereference.

   457				? VI6_WPF_SRCRPF_VIRACT_MST
   458				: VI6_WPF_SRCRPF_VIRACT2_MST;

regards,
dan carpenter
