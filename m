Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:37154 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751288AbeCWVqC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 17:46:02 -0400
Date: Fri, 23 Mar 2018 23:45:57 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 06/30] media: ov5670: get rid of a series of __be warnings
Message-ID: <20180323214557.yx7svz3xm7y5zclm@kekkonen.localdomain>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
 <baa6f19b37cc1aebf6e84ed4c451f1078693bb4b.1521806166.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <baa6f19b37cc1aebf6e84ed4c451f1078693bb4b.1521806166.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 23, 2018 at 07:56:52AM -0400, Mauro Carvalho Chehab wrote:
> There are some troubles on this driver with respect to the usage
> of __be16 and __b32 macros:
> 
> 	drivers/media/i2c/ov5670.c:1857:27: warning: incorrect type in initializer (different base types)
> 	drivers/media/i2c/ov5670.c:1857:27:    expected unsigned short [unsigned] [usertype] reg_addr_be
> 	drivers/media/i2c/ov5670.c:1857:27:    got restricted __be16 [usertype] <noident>
> 	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
> 	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
> 	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
> 	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
> 	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
> 	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
> 	drivers/media/i2c/ov5670.c:1901:13: warning: incorrect type in assignment (different base types)
> 	drivers/media/i2c/ov5670.c:1901:13:    expected unsigned int [unsigned] [usertype] val
> 	drivers/media/i2c/ov5670.c:1901:13:    got restricted __be32 [usertype] <noident>
> 
> Fix them.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
