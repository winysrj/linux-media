Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41852 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752874AbeEGVpm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 17:45:42 -0400
Date: Tue, 8 May 2018 00:45:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] media: media-device: fix ioctl function types
Message-ID: <20180507214540.55d5k7xk2ytdqjij@valkosipuli.retiisi.org.uk>
References: <20180507104509.lq4ep22fm6h53gra@valkosipuli.retiisi.org.uk>
 <20180507180946.104340-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507180946.104340-1-samitolvanen@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 07, 2018 at 11:09:46AM -0700, Sami Tolvanen wrote:
> This change fixes function types for media device ioctls to avoid
> indirect call mismatches with Control-Flow Integrity checking.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Kiitos!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
