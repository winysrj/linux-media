Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26831 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2CKTtc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 15:49:32 -0400
Message-ID: <4F5D01C5.4090101@codeaurora.org>
Date: Mon, 12 Mar 2012 01:19:25 +0530
From: Trilok Soni <tsoni@codeaurora.org>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ravi Kumar V <kumarrav@codeaurora.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: Re: [patch] [media] gpio-ir-recv: a couple signedness bugs
References: <20120310085818.GC4647@elgon.mountain>
In-Reply-To: <20120310085818.GC4647@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On 3/10/2012 2:28 PM, Dan Carpenter wrote:
> There are couple places where we check unsigned values for negative.  I
> changed ->gpin_nr to signed because in gpio_ir_recv_probe() we do:
>          if (pdata->gpio_nr<  0)
>                  return -EINVAL;
> I also change gval to a signed int in gpio_ir_recv_irq() because that's
> the type that gpio_get_value_cansleep() returns and we test for negative
> returns.
>
> Signed-off-by: Dan Carpenter<dan.carpenter@oracle.com>
>

Thanks.

Reviewed-by: Trilok Soni <tsoni@codeaurora.org>

---Trilok Soni

--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
