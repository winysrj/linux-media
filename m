Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:52075 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754768AbcJNMB7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 08:01:59 -0400
Subject: Re: [media] RedRat3: Move two assignments in redrat3_transmit_ir()?
To: Dan Carpenter <dan.carpenter@oracle.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
 <c5297c05-df30-8296-a767-99791c64b5c6@users.sourceforge.net>
 <20161014081524.GF5687@mwanda>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <c6f74b6e-5270-f8da-41e9-5257b7253442@users.sourceforge.net>
Date: Fri, 14 Oct 2016 14:01:37 +0200
MIME-Version: 1.0
In-Reply-To: <20161014081524.GF5687@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The original code was correct.

Your view can be appropriate for this function implementation to some degree.

I got the impression that it contains the specification of assignments
which will happen a bit too early here.
Is this a weakness for which software developers can care about?

Regards,
Markus
