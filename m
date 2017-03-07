Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57762 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751258AbdCGId1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Mar 2017 03:33:27 -0500
Date: Tue, 7 Mar 2017 10:30:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-media@vger.kernel.org, devel@linuxdriverproject.org,
        linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, peterz@infradead.org,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Subject: Re: [PATCH 12/29] drivers, media: convert s2255_dev.num_channels
 from atomic_t to refcount_t
Message-ID: <20170307083016.GG3220@valkosipuli.retiisi.org.uk>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-13-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488810076-3754-13-git-send-email-elena.reshetova@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Elena,

On Mon, Mar 06, 2017 at 04:20:59PM +0200, Elena Reshetova wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
...
> @@ -1688,7 +1689,7 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
>  				"failed to register video device!\n");
>  			break;
>  		}
> -		atomic_inc(&dev->num_channels);
> +		refcount_set(&dev->num_channels, 1);

That's not right. The loop runs four iterations and the value after the
loop should be indeed the number of channels.

atomic_t isn't really used for reference counting here, but storing out how
many "channels" there are per hardware device, with maximum number of four
(4). I'd leave this driver using atomic_t.

>  		v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
>  			  video_device_node_name(&vc->vdev));
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
