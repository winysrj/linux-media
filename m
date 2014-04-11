Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbaDKOIE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 10:08:04 -0400
Date: Fri, 11 Apr 2014 07:10:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] Prefer gspca_sonixb over sn9c102 for all devices
Message-ID: <20140411141050.GC2276@kroah.com>
References: <20140411091532.2a1bcce2@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411091532.2a1bcce2@endymion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 11, 2014 at 09:15:32AM +0200, Jean Delvare wrote:
> The sn9c102 driver is deprecated. It was moved to staging in
> anticipation of its removal in a future kernel version. However, USB
> devices 0C45:6024 and 0C45:6025 are still handled by sn9c102 when
> both sn9c102 and gspca_sonixb are enabled.
> 
> We must migrate all the users of these devices to the gspca_sonixb
> driver now, so that it gets sufficient testing before the sn9c102
> driver is finally phased out.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: Luca Risolia <luca.risolia@studio.unibo.it>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> I consider this a bug fix, I believe it should go upstream ASAP.
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
