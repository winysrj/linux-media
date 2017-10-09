Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58820 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751184AbdJILQe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:16:34 -0400
Date: Mon, 9 Oct 2017 14:16:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 03/24] media: v4l2-mediabus: use BIT() macro for flags
Message-ID: <20171009111632.7zhwdb5tf24l4own@valkosipuli.retiisi.org.uk>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <6a5f7e450dbb613e47bef21af9119bf09ef35762.1507544011.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a5f7e450dbb613e47bef21af9119bf09ef35762.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 09, 2017 at 07:19:09AM -0300, Mauro Carvalho Chehab wrote:
> Instead of using (1 << n) for bits, use the BIT() macro,
> as it makes them better documented.

I wouldn't say this makes a difference from documentation point of view.

Anyway,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
