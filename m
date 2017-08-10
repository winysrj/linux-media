Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58462 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751456AbdHJNE4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 09:04:56 -0400
Date: Thu, 10 Aug 2017 16:04:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Harold Gomez <haroldgmz11@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Subject:staging:media:atomisp:ap1302: fix comments style
Message-ID: <20170810130453.ahoabwyttsj5tfqp@valkosipuli.retiisi.org.uk>
References: <20170810122735.GA2481@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170810122735.GA2481@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 10, 2017 at 05:57:35PM +0530, Harold Gomez wrote:
> fix comment style Warning in ap1302.c
> fix WARNING on Block comments use * on subsequent lines
> 
> Signed-off-by: Harold Gomez <haroldgmz11@gmail.com>

If you're making a number of trivial cleanups to a single driver, please
submit them as a single patch instead. And do continue paying attention to
commit message subject and body.

Thanks.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
