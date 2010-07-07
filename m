Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60118 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149Ab0GGOOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 10:14:38 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Wed, 7 Jul 2010 09:14:33 -0500
Subject: RE: [RFC/PATCH 2/6] v4l: subdev: Add device node support
Message-ID: <A69FA2915331DC488A831521EAE36FE4016B5EDCD7@dlee06.ent.ti.com>
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1278503608-9126-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278503608-9126-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



>v4l2_device *v4l2_dev,
> 		if (err && err != -ENOIOCTLCMD) {
> 			v4l2_device_unregister_subdev(sd);
> 			sd = NULL;
>+		} else {
>+			sd->initialized = 1;
> 		}

Wouldn't checkpatch.pl script complain about { } on the else part since
there is only one statement?  
> 	}
>


