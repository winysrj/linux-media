Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:59921 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751540AbcJNFrE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 01:47:04 -0400
Subject: Re: [media] RedRat3: Use kcalloc() in two functions?
To: Joe Perches <joe@perches.com>, linux-media@vger.kernel.org
References: <566ABCD9.1060404@users.sourceforge.net>
 <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
 <21c57b39-25ac-2df1-030d-11c243a11ebc@users.sourceforge.net>
 <1476376177.2164.10.camel@perches.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <e98cbba5-8254-af1e-5405-428f61c8433e@users.sourceforge.net>
Date: Fri, 14 Oct 2016 07:45:17 +0200
MIME-Version: 1.0
In-Reply-To: <1476376177.2164.10.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Markus, please stop being _so_ mechanical and use your
> brain a little too.  By definition, sizeof(char) == 1.
> 
> This _really_ should be kzalloc(RR3_FW_VERSION_LEN + 1,...)

Do you expect that function call examples like the following will be equivalent?

	zbuffer = kzalloc(123, …);
	cbuffer = kcalloc(123, 1, …);

Regards,
Markus
