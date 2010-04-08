Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933780Ab0DHXMa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Apr 2010 19:12:30 -0400
Message-ID: <4BBE62B7.9010807@redhat.com>
Date: Thu, 08 Apr 2010 20:11:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] Fix the drivers/media/dvb/ttpci/budget-ci.c conversion
 to	ir-core
References: <20100408230246.14453.97377.stgit@localhost.localdomain> <20100408230425.14453.62639.stgit@localhost.localdomain>
In-Reply-To: <20100408230425.14453.62639.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

David Härdeman wrote:
> When I converted drivers/media/dvb/ttpci/budget-ci.c to use ir-core
> I missed one line. This patch fixes that mistake.

I did this already (I merged with your commit, at v4l-dvb.git), to avoid 
breaking git bisect. I'll backport it to the ir.git tree after finishing
to process my loooong patchwork queue. (I'll probably just create a new
branch there from v4l-dvb.git - since I've merged all ir-related patches
there already).


Cheers,
Mauro

PS.: As you can see, stgit did the right thing with inline ;)
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/dvb/ttpci/budget-ci.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
> index 8950df1..4617143 100644
> --- a/drivers/media/dvb/ttpci/budget-ci.c
> +++ b/drivers/media/dvb/ttpci/budget-ci.c
> @@ -225,8 +225,6 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
>  		break;
>  	}
>  
> -	ir_input_init(input_dev, &budget_ci->ir.state, IR_TYPE_RC5);
> -
>  	error = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
>  	if (error) {
>  		printk(KERN_ERR "budget_ci: could not init driver for IR device (code %d)\n", error);
> 


-- 

Cheers,
Mauro
