Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:44609 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbZDDPvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 11:51:06 -0400
Date: Sat, 4 Apr 2009 10:51:01 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>, Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
In-Reply-To: <20090404142837.3e12824c@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
 <20090404142837.3e12824c@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Nacked-by: Mike Isely <isely@pobox.com>

This will interfere with the alternative use of LIRC drivers (which work 
in more cases that ir-kbd).  It will thus break some peoples' use of the 
driver.  Also we have better information on what i2c addresses needed to 
be probed based on the model of the device - and some devices supported 
by this device are not from Hauppauge so you are making a too-strong 
assumption that IR should be probed this way in all cases.  Also, unless 
ir-kbd has suddenly improved, this will not work at all for HVR-1950 
class devices nor MCE type PVR-24xxx devices (different incompatible IR 
receiver).

This is why the pvrusb2 driver has never directly attempted to load 
ir-kbd.

  -Mike


On Sat, 4 Apr 2009, Jean Delvare wrote:

> --- v4l-dvb.orig/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-04-04 10:53:08.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-04-04 10:58:36.000000000 +0200
> @@ -649,6 +649,27 @@ static void do_i2c_scan(struct pvr2_hdw
>  	printk(KERN_INFO "%s: i2c scan done.\n", hdw->name);
>  }
>  
> +static void pvr2_i2c_register_ir(struct i2c_adapter *i2c_adap)
> +{
> +	struct i2c_board_info info;
> +	/* The external IR receiver is at i2c address 0x34 (0x35 for
> +	   reads).  Future Hauppauge cards will have an internal
> +	   receiver at 0x30 (0x31 for reads).  In theory, both can be
> +	   fitted, and Hauppauge suggest an external overrides an
> +	   internal.
> +
> +	   That's why we probe 0x1a (~0x34) first. CB
> +	*/
> +	const unsigned short addr_list[] = {
> +		0x1a, 0x18, 0x4b, 0x64, 0x30,
> +		I2C_CLIENT_END
> +	};
> +
> +	memset(&info, 0, sizeof(struct i2c_board_info));
> +	strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
> +	i2c_new_probed_device(i2c_adap, &info, addr_list);
> +}
> +
>  void pvr2_i2c_core_init(struct pvr2_hdw *hdw)
>  {
>  	unsigned int idx;
> @@ -696,6 +717,9 @@ void pvr2_i2c_core_init(struct pvr2_hdw
>  		}
>  	}
>  	if (i2c_scan) do_i2c_scan(hdw);
> +
> +	/* Instantiate the IR receiver device, if present */
> +	pvr2_i2c_register_ir(&hdw->i2c_adap);
>  }
>  
>  void pvr2_i2c_core_done(struct pvr2_hdw *hdw)

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
