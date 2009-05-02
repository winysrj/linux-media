Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:39768 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZEBDSk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2009 23:18:40 -0400
Date: Fri, 1 May 2009 22:18:38 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] media: remove driver_data direct access of struct device
In-Reply-To: <20090430221808.GA18526@kroah.com>
Message-ID: <Pine.LNX.4.64.0905012217170.15541@cnc.isely.net>
References: <20090430221808.GA18526@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Acked-By: Mike Isely <isely@pobox.com>

Note #1: I am just acking the pvrusb2 part of this.

Note #2: I am immediately pulling the pvrusb2 part of these changes into 
that driver.

  -Mike


On Thu, 30 Apr 2009, Greg Kroah-Hartman wrote:

> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> In the near future, the driver core is going to not allow direct access
> to the driver_data pointer in struct device.  Instead, the functions
> dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> have been around since the beginning, so are backwards compatible with
> all older kernel versions.
> 
> 
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/media/dvb/firewire/firedtv-1394.c   |    4 ++--
>  drivers/media/dvb/firewire/firedtv-dvb.c    |    2 +-
>  drivers/media/video/pvrusb2/pvrusb2-sysfs.c |   22 +++++++++++-----------
>  3 files changed, 14 insertions(+), 14 deletions(-)
> 
> --- a/drivers/media/dvb/firewire/firedtv-1394.c
> +++ b/drivers/media/dvb/firewire/firedtv-1394.c
> @@ -225,7 +225,7 @@ fail_free:
>  
>  static int node_remove(struct device *dev)
>  {
> -	struct firedtv *fdtv = dev->driver_data;
> +	struct firedtv *fdtv = dev_get_drvdata(dev);
>  
>  	fdtv_dvb_unregister(fdtv);
>  
> @@ -242,7 +242,7 @@ static int node_remove(struct device *de
>  
>  static int node_update(struct unit_directory *ud)
>  {
> -	struct firedtv *fdtv = ud->device.driver_data;
> +	struct firedtv *fdtv = dev_get_drvdata(&ud->device);
>  
>  	if (fdtv->isochannel >= 0)
>  		cmp_establish_pp_connection(fdtv, fdtv->subunit,
> --- a/drivers/media/dvb/firewire/firedtv-dvb.c
> +++ b/drivers/media/dvb/firewire/firedtv-dvb.c
> @@ -268,7 +268,7 @@ struct firedtv *fdtv_alloc(struct device
>  	if (!fdtv)
>  		return NULL;
>  
> -	dev->driver_data	= fdtv;
> +	dev_set_drvdata(dev, fdtv);
>  	fdtv->device		= dev;
>  	fdtv->isochannel	= -1;
>  	fdtv->voltage		= 0xff;
> --- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
> @@ -539,7 +539,7 @@ static void class_dev_destroy(struct pvr
>  					 &sfp->attr_unit_number);
>  	}
>  	pvr2_sysfs_trace("Destroying class_dev id=%p",sfp->class_dev);
> -	sfp->class_dev->driver_data = NULL;
> +	dev_set_drvdata(sfp->class_dev, NULL);
>  	device_unregister(sfp->class_dev);
>  	sfp->class_dev = NULL;
>  }
> @@ -549,7 +549,7 @@ static ssize_t v4l_minor_number_show(str
>  				     struct device_attribute *attr, char *buf)
>  {
>  	struct pvr2_sysfs *sfp;
> -	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
> +	sfp = dev_get_drvdata(class_dev);
>  	if (!sfp) return -EINVAL;
>  	return scnprintf(buf,PAGE_SIZE,"%d\n",
>  			 pvr2_hdw_v4l_get_minor_number(sfp->channel.hdw,
> @@ -561,7 +561,7 @@ static ssize_t bus_info_show(struct devi
>  			     struct device_attribute *attr, char *buf)
>  {
>  	struct pvr2_sysfs *sfp;
> -	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
> +	sfp = dev_get_drvdata(class_dev);
>  	if (!sfp) return -EINVAL;
>  	return scnprintf(buf,PAGE_SIZE,"%s\n",
>  			 pvr2_hdw_get_bus_info(sfp->channel.hdw));
> @@ -572,7 +572,7 @@ static ssize_t hdw_name_show(struct devi
>  			     struct device_attribute *attr, char *buf)
>  {
>  	struct pvr2_sysfs *sfp;
> -	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
> +	sfp = dev_get_drvdata(class_dev);
>  	if (!sfp) return -EINVAL;
>  	return scnprintf(buf,PAGE_SIZE,"%s\n",
>  			 pvr2_hdw_get_type(sfp->channel.hdw));
> @@ -583,7 +583,7 @@ static ssize_t hdw_desc_show(struct devi
>  			     struct device_attribute *attr, char *buf)
>  {
>  	struct pvr2_sysfs *sfp;
> -	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
> +	sfp = dev_get_drvdata(class_dev);
>  	if (!sfp) return -EINVAL;
>  	return scnprintf(buf,PAGE_SIZE,"%s\n",
>  			 pvr2_hdw_get_desc(sfp->channel.hdw));
> @@ -595,7 +595,7 @@ static ssize_t v4l_radio_minor_number_sh
>  					   char *buf)
>  {
>  	struct pvr2_sysfs *sfp;
> -	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
> +	sfp = dev_get_drvdata(class_dev);
>  	if (!sfp) return -EINVAL;
>  	return scnprintf(buf,PAGE_SIZE,"%d\n",
>  			 pvr2_hdw_v4l_get_minor_number(sfp->channel.hdw,
> @@ -607,7 +607,7 @@ static ssize_t unit_number_show(struct d
>  				struct device_attribute *attr, char *buf)
>  {
>  	struct pvr2_sysfs *sfp;
> -	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
> +	sfp = dev_get_drvdata(class_dev);
>  	if (!sfp) return -EINVAL;
>  	return scnprintf(buf,PAGE_SIZE,"%d\n",
>  			 pvr2_hdw_get_unit_number(sfp->channel.hdw));
> @@ -635,7 +635,7 @@ static void class_dev_create(struct pvr2
>  	class_dev->parent = &usb_dev->dev;
>  
>  	sfp->class_dev = class_dev;
> -	class_dev->driver_data = sfp;
> +	dev_set_drvdata(class_dev, sfp);
>  	ret = device_register(class_dev);
>  	if (ret) {
>  		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
> @@ -792,7 +792,7 @@ static ssize_t debuginfo_show(struct dev
>  			      struct device_attribute *attr, char *buf)
>  {
>  	struct pvr2_sysfs *sfp;
> -	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
> +	sfp = dev_get_drvdata(class_dev);
>  	if (!sfp) return -EINVAL;
>  	pvr2_hdw_trigger_module_log(sfp->channel.hdw);
>  	return pvr2_debugifc_print_info(sfp->channel.hdw,buf,PAGE_SIZE);
> @@ -803,7 +803,7 @@ static ssize_t debugcmd_show(struct devi
>  			     struct device_attribute *attr, char *buf)
>  {
>  	struct pvr2_sysfs *sfp;
> -	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
> +	sfp = dev_get_drvdata(class_dev);
>  	if (!sfp) return -EINVAL;
>  	return pvr2_debugifc_print_status(sfp->channel.hdw,buf,PAGE_SIZE);
>  }
> @@ -816,7 +816,7 @@ static ssize_t debugcmd_store(struct dev
>  	struct pvr2_sysfs *sfp;
>  	int ret;
>  
> -	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
> +	sfp = dev_get_drvdata(class_dev);
>  	if (!sfp) return -EINVAL;
>  
>  	ret = pvr2_debugifc_docmd(sfp->channel.hdw,buf,count);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
