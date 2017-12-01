Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:53144 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751921AbdLARl7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 12:41:59 -0500
Date: Fri, 1 Dec 2017 17:41:50 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 2/3] media: atomisp: delete zero-valued struct
 members.
Message-ID: <20171201174150.57f12e5f@alans-desktop>
In-Reply-To: <20171201171939.3432-3-jeremy@azazel.net>
References: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
        <20171201171939.3432-1-jeremy@azazel.net>
        <20171201171939.3432-3-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
> @@ -152,14 +152,6 @@ struct ia_css_pipe_config {
>  };
>  


Thani you that's a really good cleanup.

Alan
