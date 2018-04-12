Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57390 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751819AbeDLNnM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 09:43:12 -0400
Date: Thu, 12 Apr 2018 16:43:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com,
        hverkuil@xs4all.nl
Subject: Re: [PATCH v1.1 1/1] videodev2: Mark all user pointers as such
Message-ID: <20180412134309.fcvkxrz3qwxcr36f@valkosipuli.retiisi.org.uk>
References: <20180412130322.24762-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180412130322.24762-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 12, 2018 at 04:03:22PM +0300, Sakari Ailus wrote:
> A number of uAPI structs have pointers but some lack the __user modifier.
> Add this to the pointers that do not have it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Please ignore these patches; the issue is not as trivially solved.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
