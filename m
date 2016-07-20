Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:53877 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551AbcGTKhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 06:37:37 -0400
Subject: Re: [PATCH 0/6] radio: Utilize the module_isa_driver macro
To: William Breathitt Gray <vilhelm.gray@gmail.com>,
	mchehab@osg.samsung.com
References: <cover.1468852798.git.vilhelm.gray@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6e689553-b3bc-c5d1-1246-ff109d2bba17@xs4all.nl>
Date: Wed, 20 Jul 2016 12:37:31 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1468852798.git.vilhelm.gray@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2016 04:45 PM, William Breathitt Gray wrote:
> The module_isa_driver macro is a helper macro for ISA drivers which do
> not do anything special in module init/exit. This patchset eliminates a
> lot of ISA driver registration boilerplate code by utilizing
> module_isa_driver, which replaces module_init and module_exit.
> 
> William Breathitt Gray (6):
>   radio: terratec: Utilize the module_isa_driver macro
>   radio: rtrack2: Utilize the module_isa_driver macro
>   radio: trust: Utilize the module_isa_driver macro
>   radio: zoltrix: Utilize the module_isa_driver macro
>   radio: aztech: Utilize the module_isa_driver macro
>   radio: aimslab: Utilize the module_isa_driver macro

Good idea, but it doesn't compile:

module_isa_driver(terratec_driver.driver, 1);

expands to:

static int __init terratec_driver.driver_init(void)
{
        return isa_register_driver(&(terratec_driver.driver), 1);
}

So now the function name contains a '.' and it won't compile.

Regards,

	Hans
