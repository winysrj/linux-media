Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37363 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755009AbdDGNss (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 09:48:48 -0400
Message-ID: <1491572923.3704.84.camel@linux.intel.com>
Subject: Re: [PATCH 1/3] staging: atomisp: remove enable_isp_irq function
 and add disable_isp_irq
From: Alan Cox <alan@linux.intel.com>
To: Daeseok Youn <daeseok.youn@gmail.com>, mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Fri, 07 Apr 2017 14:48:43 +0100
In-Reply-To: <20170407055604.GA32049@SEL-JYOUN-D1>
References: <20170407055604.GA32049@SEL-JYOUN-D1>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-04-07 at 14:56 +0900, Daeseok Youn wrote:
> Enable/Disable ISP irq is switched with "enable" parameter of
> enable_isp_irq(). It would be better splited to two such as
> enable_isp_irq()/disable_isp_irq().
> 
> But the enable_isp_irq() is no use in atomisp_cmd.c file.
> So remove the enable_isp_irq() function and add
> disable_isp_irq function only.

All 3 added to my tree - thanks

Alan
