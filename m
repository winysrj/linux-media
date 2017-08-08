Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58430 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751921AbdHHKxk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 06:53:40 -0400
Date: Tue, 8 Aug 2017 13:53:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, bhumirks@gmail.com,
        kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] [media] atomisp: constify videobuf_queue_ops
 structures
Message-ID: <20170808105337.onxwiuq2ufm5k4cg@valkosipuli.retiisi.org.uk>
References: <1501848588-22628-1-git-send-email-Julia.Lawall@lip6.fr>
 <1501848588-22628-3-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1501848588-22628-3-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 04, 2017 at 02:09:45PM +0200, Julia Lawall wrote:
> These videobuf_queue_ops structures are only passed as the second
> argument to videobuf_queue_vmalloc_init, which is declared as const.
> Thus the videobuf_queue_ops structures themselves can be const.
> 
> Done with the help of Coccinelle.

Thanks. I'm picking this one up (for atomisp).

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
