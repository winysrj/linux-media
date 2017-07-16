Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0074.hostedemail.com ([216.40.44.74]:35510 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751124AbdGPX5Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 19:57:24 -0400
Message-ID: <1500249440.4457.95.camel@perches.com>
Subject: Re: [PATCH 2/2] [media] staging/atomisp: fixed trivial coding style
 issue
From: Joe Perches <joe@perches.com>
To: Shy More <smklearn@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <trivial@kernel.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 16 Jul 2017 16:57:20 -0700
In-Reply-To: <1500248306-15155-1-git-send-email-smklearn@gmail.com>
References: <20170713151249.GA1451@kroah.com>
         <1500248306-15155-1-git-send-email-smklearn@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2017-07-16 at 16:38 -0700, Shy More wrote:
> Below was the trival error flagged by checkpatch.pl:
> ERROR: space prohibited after that open parenthesis '('
[]
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
[]
> @@ -131,7 +131,7 @@ void ia_css_isys_ibuf_rmgr_release(
>  	for (i = 0; i < ibuf_rsrc.num_allocated; i++) {
>  		handle = getHandle(i);
>  		if ((handle->start_addr == *start_addr)
> -		    && ( true == handle->active)) {
> +		    && (true == handle->active)) {
>  			handle->active = false;
>  			ibuf_rsrc.num_active--;
>  			break;

Better would have been to remove the comparison to true

		if (handle->start_addr == *start_addr && handle->active)

but this would probably read better and perhaps be
marginally faster on some processors if written like:

		if (handle->active && handle->start_addr == *start_addr)
