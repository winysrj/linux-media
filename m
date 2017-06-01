Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42482 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdFBADA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Jun 2017 20:03:00 -0400
Date: Fri, 2 Jun 2017 08:48:36 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 24/27] usb: gadget: u_uac1: Kill set_fs() usage
Message-ID: <20170601234836.GA21844@kroah.com>
References: <20170601205850.24993-1-tiwai@suse.de>
 <20170601205850.24993-25-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170601205850.24993-25-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 01, 2017 at 10:58:47PM +0200, Takashi Iwai wrote:
> With the new API to perform the in-kernel buffer copy, we can get rid
> of set_fs() usage in this driver, finally.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
