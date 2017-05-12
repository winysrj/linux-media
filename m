Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932283AbdELJK7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 05:10:59 -0400
Date: Fri, 12 May 2017 11:10:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Remco <remco@dutchcoders.io>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: fix one code style problem
Message-ID: <20170512091048.GB29610@kroah.com>
References: <20170505201824.39399-1-remco@dutchcoders.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170505201824.39399-1-remco@dutchcoders.io>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 05, 2017 at 01:18:24PM -0700, Remco wrote:
> From: Remco Verhoef <remco@dutchcoders.io>
> 
> this patch will fix one code style problem (ctx:WxE), space
> prohibited before that

Your subject needs work :)

And why just one issue, is that the only place this type of problem is
needed in this file?

thanks,

greg k-h
