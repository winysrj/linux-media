Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35686 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751617AbdJMWmr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 18:42:47 -0400
Date: Sat, 14 Oct 2017 01:42:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Aishwarya Pant <aishpant@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [PATCH 0/2] staginng: atomisp: memory allocation cleanups
Message-ID: <20171013224243.xven2blughzfxlq3@valkosipuli.retiisi.org.uk>
References: <cover.1507454423.git.aishpant@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1507454423.git.aishpant@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Aishwarya,

On Sun, Oct 08, 2017 at 02:53:20PM +0530, Aishwarya Pant wrote:
> Patch series performs minor code cleanups using coccinelle to simplify memory
> allocation tests and remove redundant OOM log messages.
> 
> Aishwarya Pant (2):
>   staging: atomisp2: cleanup null check on memory allocation
>   staging: atomisp: cleanup out of memory messages

Thanks for the patchset.

Unfortunately neither applies anymore after other patches have been merged.

Could you rebase yours on top of this tree, please?

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=atomisp>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
