Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47162 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752755AbeDKKcb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 06:32:31 -0400
Date: Wed, 11 Apr 2018 13:32:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: asadpt iqroot <asadptiqroot@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: sensor driver - v4l2 - MEDIA_BUS_FMT
Message-ID: <20180411103228.oic7hq2be2atfl6l@valkosipuli.retiisi.org.uk>
References: <CA+gCWtKWYE4+F8gHEYYjvNrkCV7G0VNjGq11SC2MRSqP9N8Yog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+gCWtKWYE4+F8gHEYYjvNrkCV7G0VNjGq11SC2MRSqP9N8Yog@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 11, 2018 at 03:33:50PM +0530, asadpt iqroot wrote:
> Hi All,
> 
> We are trying develop a sensor driver code for hdmi2csi adapter.
> Reguired data format is RGB888. But in media format header file, we
> could see three macros related to RGB888. Hardware connection is mipi
> csi2.
> 
> #define MEDIA_BUS_FMT_RGB888_1X24 0x100a
> #define MEDIA_BUS_FMT_RGB888_2X12_BE 0x100b
> #define MEDIA_BUS_FMT_RGB888_2X12_LE 0x100c
> 
> How to decide whether we go for RGB888_1X24 or RGB888_2X12 macros.

Originally when support was added for serial busses, we did not create new
formats for these busses but instead re-used the ones intended for parallel
busses. Please use the single-sample variant of the format.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
