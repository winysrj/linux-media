Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46373
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbcGLPDm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 11:03:42 -0400
Subject: Re: [PATCH] media: s5p-mfc Fix misspelled error message and
 checkpatch errors
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
	k.debski@samsung.com, jtp.park@samsung.com, mchehab@kernel.org
References: <1468276740-1591-1-git-send-email-shuahkh@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-ID: <8dd68d9b-9455-d593-dc0f-c269c778b961@osg.samsung.com>
Date: Tue, 12 Jul 2016 11:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <1468276740-1591-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Shuah,

On 07/11/2016 06:39 PM, Shuah Khan wrote:
> Fix misspelled error message and existing checkpatch errors in the
> error message conditional.
> 
> WARNING: suspect code indent for conditional statements (8, 24)
>  	if (ctx->state != MFCINST_HEAD_PARSED &&
> [...]
> +               mfc_err("Can not get crop information\n");
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---

Patch looks good to me. Maybe is better to split the message and checkpatch
changes in two different patches. But I don't have a strong opinion on this:

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
