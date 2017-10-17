Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39076 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753378AbdJQMBX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 08:01:23 -0400
Date: Tue, 17 Oct 2017 15:01:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Aishwarya Pant <aishpant@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [PATCH v2 0/2] staging: atomisp: memory allocation cleanups
Message-ID: <20171017120120.fjztitbo6jcoki6j@valkosipuli.retiisi.org.uk>
References: <cover.1507989087.git.aishpant@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1507989087.git.aishpant@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Aishwarya,

On Sat, Oct 14, 2017 at 07:24:00PM +0530, Aishwarya Pant wrote:
> Patch series performs minor code cleanups using coccinelle to simplify memory
> allocation tests and remove redundant OOM log messages.
> 
> Changes in v2:
> Rebase and re-send patches
> 
> Aishwarya Pant (2):
>   staging: atomisp2: cleanup null check on memory allocation
>   staging: atomisp: cleanup out of memory messages

Thank you for the update, but the patches still don't apply.

Some patches have been merged since I last reviewed these and I've already
sent a pull request for the branch.

Could you rebase your patches on this branch, please?

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=atomisp-next>

Normally it'll be "atomisp".

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
