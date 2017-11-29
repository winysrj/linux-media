Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33058 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932065AbdK2Ik1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 03:40:27 -0500
Date: Wed, 29 Nov 2017 10:40:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Riccardo Schirone <sirmy15@gmail.com>
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2 0/4] fix some checkpatch style issues in atomisp driver
Message-ID: <20171129084024.5jhrj5poxzeq4gyj@valkosipuli.retiisi.org.uk>
References: <20171127214413.10749-1-sirmy15@gmail.com>
 <20171128204004.9345-1-sirmy15@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128204004.9345-1-sirmy15@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 28, 2017 at 09:40:00PM +0100, Riccardo Schirone wrote:
> This patch series fixes some coding style issues in atomisp driver
> reported by checkpatch, like: missing blank lines after declarations,
> comments style, comparisons and indentation.
> 
> It is based on next-20171128.
> 
> Changes since v1:
>  - Add commit message to first patch as reported by Jacopo Mondi
>    <jacopo@jmondi.org>
> 
> Riccardo Schirone (4):
>   staging: add missing blank line after declarations in atomisp-ov5693
>   staging: improve comments usage in atomisp-ov5693
>   staging: improves comparisons readability in atomisp-ov5693
>   staging: fix indentation in atomisp-ov5693

Applied, thanks!

Please use staging: atomisp: prefix in the future.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
