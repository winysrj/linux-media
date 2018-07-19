Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59290 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730663AbeGSOAR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 10:00:17 -0400
Date: Thu, 19 Jul 2018 16:17:01 +0300
From: sakari.ailus@iki.fi
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Tom aan de Wiel <tom.aandewiel@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH 2/5] videodev.h: add PIX_FMT_FWHT for use with vicodec
Message-ID: <20180719131701.b22czfv5zqyqnewa@lanttu.localdomain>
References: <20180719121353.20021-1-hverkuil@xs4all.nl>
 <20180719121353.20021-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719121353.20021-3-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 19, 2018 at 02:13:50PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hansverk@cisco.com>
> 
> Add a new pixelformat for the vicodec software codec using the
> Fast Walsh Hadamard Transform.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>

Apart from the docs:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
