Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36346 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726602AbeKGW6S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 17:58:18 -0500
Date: Wed, 7 Nov 2018 15:27:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4l-utils] keytable: fix compilation warning
Message-ID: <20181107132754.dbjwbzfzuhrp7ykt@valkosipuli.retiisi.org.uk>
References: <20181107120214.13906-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181107120214.13906-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 07, 2018 at 12:02:14PM +0000, Sean Young wrote:
> keytable.c: In function ‘parse_opt’:
> keytable.c:835:7: warning: ‘param’ may be used uninitialized in this function [-Wuninitialized]
> 
> Signed-off-by: Sean Young <sean@mess.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
