Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.anw.at ([195.234.102.72]:47584 "EHLO smtp.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752698AbeGEHcq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 03:32:46 -0400
Subject: Re: [PATCH] media: dvb_ca_en50221: off by one in
 dvb_ca_en50221_io_do_ioctl()
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20180704094835.vzfqt44sqaga6aia@kili.mountain>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <6dda6fb1-fdce-df86-b0f9-a6c4bc522a2d@anw.at>
Date: Thu, 5 Jul 2018 09:32:28 +0200
MIME-Version: 1.0
In-Reply-To: <20180704094835.vzfqt44sqaga6aia@kili.mountain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Dan!

I checked this and this is in since ages. Good catch!

I did a quick look to the other places where this is checked also
and they seem all ok.

Acked-by: Jasmin Jessich <jasmin@anw.at>

BR,
   Jasmin
