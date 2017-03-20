Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43256 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754296AbdCTLQZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 07:16:25 -0400
Date: Mon, 20 Mar 2017 14:14:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com, singhalsimran0@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] staging: atomisp: remove useless condition in
 if-statements
Message-ID: <20170320111451.GC4343@mwanda>
References: <20170320110006.GA17811@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170320110006.GA17811@SEL-JYOUN-D1>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 20, 2017 at 08:00:06PM +0900, Daeseok Youn wrote:
> The css_pipe_id was checked with 'CSS_PIPE_ID_COPY' in previous if-
> statement. In this case, if the css_pipe_id equals to 'CSS_PIPE_ID_COPY',
> it could not enter the next if-statement. But the "next" if-statement
> has the condition to check whether the css_pipe_id equals to
> 'CSS_PIPE_ID_COPY' or not. It should be removed.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

The patch is correct but the changelog is not.

s/CSS_PIPE_ID_COPY/CSS_PIPE_ID_YUVPP/

regards,
dan carpenter
