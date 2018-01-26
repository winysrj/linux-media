Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40080 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753079AbeAZOna (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 09:43:30 -0500
Date: Fri, 26 Jan 2018 16:43:28 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 01/12] vivid: fix module load error when enabling fb and
 no_error_inj=1
Message-ID: <20180126144328.bt5dq33jncrkx6kz@valkosipuli.retiisi.org.uk>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
 <20180126124327.16653-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126124327.16653-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 26, 2018 at 01:43:16PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If the framebuffer is enabled and error injection is disabled, then
> creating the controls for the video output device would fail with an
> error.
> 
> This is because the Clear Framebuffer control uses the 'vivid control
> class' and that control class isn't added if error injection is disabled.
> 
> In addition, this control was added to e.g. vbi devices as well, which
> makes no sense.
> 
> Move this control to its own control handler and handle it correctly.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
