Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:42746 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933492AbZEAA1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 20:27:34 -0400
Date: Thu, 30 Apr 2009 19:27:32 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>, Mike Isely <isely@isely.net>
Subject: Re: [PATCH] pvrusb2: Don't use the internal i2c client list
In-Reply-To: <20090430173554.4cb2f585@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904301924520.15541@cnc.isely.net>
References: <20090430173554.4cb2f585@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Apr 2009, Jean Delvare wrote:

> The i2c core used to maintain a list of client for each adapter. This
> is a duplication of what the driver core already does, so this list
> will be removed as part of a future cleanup. Anyone using this list
> must stop doing so.
> 
> For pvrusb2, I propose the following change, which should lead to an
> equally informative output. The only difference is that i2c clients
> which are not a v4l2 subdev won't show up, but I guess this case is
> not supposed to happen anyway.

It will happen for anything i2c used by v4l which itself is not really a 
part of v4l.  That would include, uh, lirc.

I will review and test this first chance I get which should be tomorrow.

  -Mike


> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Mike Isely <isely@pobox.com>
> ---
> Mike, can you please review and test this patch? Thanks.
> 
>  linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c |   56 +++++------------------
>  1 file changed, 13 insertions(+), 43 deletions(-)
> 
> --- v4l-dvb.orig/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	2009-04-30 16:52:32.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	2009-04-30 17:20:37.000000000 +0200
> @@ -4920,65 +4920,35 @@ static unsigned int pvr2_hdw_report_clie
>  	unsigned int tcnt = 0;
>  	unsigned int ccnt;
>  	struct i2c_client *client;
> -	struct list_head *item;
> -	void *cd;
>  	const char *p;
>  	unsigned int id;
>  
> -	ccnt = scnprintf(buf, acnt, "Associated v4l2-subdev drivers:");
> +	ccnt = scnprintf(buf, acnt, "Associated v4l2-subdev drivers and I2C clients:\n");
>  	tcnt += ccnt;
>  	v4l2_device_for_each_subdev(sd, &hdw->v4l2_dev) {
>  		id = sd->grp_id;
>  		p = NULL;
>  		if (id < ARRAY_SIZE(module_names)) p = module_names[id];
>  		if (p) {
> -			ccnt = scnprintf(buf + tcnt, acnt - tcnt, " %s", p);
> +			ccnt = scnprintf(buf + tcnt, acnt - tcnt, "  %s:", p);
>  			tcnt += ccnt;
>  		} else {
>  			ccnt = scnprintf(buf + tcnt, acnt - tcnt,
> -					 " (unknown id=%u)", id);
> +					 "  (unknown id=%u):", id);
>  			tcnt += ccnt;
>  		}
> -	}
> -	ccnt = scnprintf(buf + tcnt, acnt - tcnt, "\n");
> -	tcnt += ccnt;
> -
> -	ccnt = scnprintf(buf + tcnt, acnt - tcnt, "I2C clients:\n");
> -	tcnt += ccnt;
> -
> -	mutex_lock(&hdw->i2c_adap.clist_lock);
> -	list_for_each(item, &hdw->i2c_adap.clients) {
> -		client = list_entry(item, struct i2c_client, list);
> -		ccnt = scnprintf(buf + tcnt, acnt - tcnt,
> -				 "  %s: i2c=%02x", client->name, client->addr);
> -		tcnt += ccnt;
> -		cd = i2c_get_clientdata(client);
> -		v4l2_device_for_each_subdev(sd, &hdw->v4l2_dev) {
> -			if (cd == sd) {
> -				id = sd->grp_id;
> -				p = NULL;
> -				if (id < ARRAY_SIZE(module_names)) {
> -					p = module_names[id];
> -				}
> -				if (p) {
> -					ccnt = scnprintf(buf + tcnt,
> -							 acnt - tcnt,
> -							 " subdev=%s", p);
> -					tcnt += ccnt;
> -				} else {
> -					ccnt = scnprintf(buf + tcnt,
> -							 acnt - tcnt,
> -							 " subdev= id %u)",
> -							 id);
> -					tcnt += ccnt;
> -				}
> -				break;
> -			}
> +		client = v4l2_get_subdevdata(sd);
> +		if (client) {
> +			ccnt = scnprintf(buf + tcnt, acnt - tcnt,
> +					 " %s @ %02x\n", client->name,
> +					 client->addr);
> +			tcnt += ccnt;
> +		} else {
> +			ccnt = scnprintf(buf + tcnt, acnt - tcnt,
> +					 " no i2c client\n");
> +			tcnt += ccnt;
>  		}
> -		ccnt = scnprintf(buf + tcnt, acnt - tcnt, "\n");
> -		tcnt += ccnt;
>  	}
> -	mutex_unlock(&hdw->i2c_adap.clist_lock);
>  	return tcnt;
>  }
>  
> 
> 
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
