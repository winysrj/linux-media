Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:56199 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751826AbdCMRwk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 13:52:40 -0400
Message-ID: <1489427556.24765.8.camel@linux.intel.com>
Subject: Re: [PATCH] staging: atomisp: potential underflow in
 atomisp_get_metadata_by_type()
From: Alan Cox <alan@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org
Date: Mon, 13 Mar 2017 17:52:36 +0000
In-Reply-To: <20170313123414.GB9287@mwanda>
References: <20170313123414.GB9287@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-03-13 at 15:34 +0300, Dan Carpenter wrote:
> md_type is an enum.  On my tests, GCC treats it as unsigned but
> according to the C standard it's an implementation dependant thing so
> we
> should check for negatives.

Can do but the kernel assumes GNU C everywhere else.

Acked-by: Alan Cox <alan@linux.intel.com>

Alan
