Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0196.hostedemail.com ([216.40.44.196]:47127 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756959AbcJMQbF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:31:05 -0400
Message-ID: <1476376177.2164.10.camel@perches.com>
Subject: Re: [PATCH 01/18] [media] RedRat3: Use kcalloc() in two functions
From: Joe Perches <joe@perches.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Thu, 13 Oct 2016 09:29:37 -0700
In-Reply-To: <21c57b39-25ac-2df1-030d-11c243a11ebc@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
         <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
         <21c57b39-25ac-2df1-030d-11c243a11ebc@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2016-10-13 at 18:18 +0200, SF Markus Elfring wrote:
> diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
[]
> @@ -549,7 +549,7 @@ static void redrat3_get_firmware_rev(struct redrat3_dev *rr3)
>  	int rc = 0;
>  	char *buffer;
>  
> -	buffer = kzalloc(sizeof(char) * (RR3_FW_VERSION_LEN + 1), GFP_KERNEL);
> +	buffer = kcalloc(RR3_FW_VERSION_LEN + 1, sizeof(*buffer), GFP_KERNEL);
>  	if (!buffer) {
>  		dev_err(rr3->dev, "Memory allocation failure\n");
>  		return;,

Markus, please stop being _so_ mechanical and use your
brain a little too.  By definition, sizeof(char) == 1.

This _really_ should be kzalloc(RR3_FW_VERSION_LEN + 1,...)

