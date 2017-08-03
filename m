Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20423 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbdHCPrT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Aug 2017 11:47:19 -0400
Date: Thu, 3 Aug 2017 18:46:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Branislav Radocaj <branislav@radocaj.org>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, nikola.jelic83@gmail.com,
        ran.algawi@gmail.com, linux-kernel@vger.kernel.org, jb@abbadie.fr,
        hans.verkuil@cisco.com, shilpapri@gmail.com, aquannie@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm2048: fix bare use of 'unsigned' in
 radio-bcm2048.c
Message-ID: <20170803154643.w4jwj5uih2sc6kfb@mwanda>
References: <20170803151348.21349-1-branislav@radocaj.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170803151348.21349-1-branislav@radocaj.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This breaks the build.  Always try to compile your patches.

regards,
dan carpenter
