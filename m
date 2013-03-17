Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58201 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751572Ab3CQKQi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Mar 2013 06:16:38 -0400
Message-ID: <514598FA.7080400@iki.fi>
Date: Sun, 17 Mar 2013 12:20:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>, mchehab@redhat.com,
	gregkh@linuxfoundation.org, prabhakar.lad@ti.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com
CC: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH -next] [media] davinci: vpfe: fix return value check in
 vpfe_enable_clock()
References: <CAPgLHd80DXpcUmY69Vcc72ALGh3LrSGPakm0iBeXNUqLY-+Nxg@mail.gmail.com>
In-Reply-To: <CAPgLHd80DXpcUmY69Vcc72ALGh3LrSGPakm0iBeXNUqLY-+Nxg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function clk_get() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value
> check should be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Reviewed-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
