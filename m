Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19995 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752435AbdEENDS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 09:03:18 -0400
Date: Fri, 5 May 2017 16:03:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Surender Polsani <surenderpolsani@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [V1] staging : media : fixed macro expansion error
Message-ID: <20170505130305.kcpftkj3qu5lgjoo@mwanda>
References: <1493988646-3813-1-git-send-email-surenderpolsani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493988646-3813-1-git-send-email-surenderpolsani@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



>  #define DEFINE_SYSFS_PROPERTY(prop, signal, size, mask, check)		\
> -property_write(prop, signal size, mask, check)				\
> -property_read(prop, size, mask)
> +(property_write(prop, signal size, mask, check)				\
> +property_read(prop, size, mask))

breaks the build.

regards,
dan carpenter
