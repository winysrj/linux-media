Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51477 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab0GGOkY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 10:40:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L5600EWGZF9EL40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Jul 2010 15:40:21 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L5600G4QZF8T6@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Jul 2010 15:40:21 +0100 (BST)
Date: Wed, 07 Jul 2010 16:39:10 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RE: [RFC/PATCH 2/6] v4l: subdev: Add device node support
In-reply-to: <A69FA2915331DC488A831521EAE36FE4016B5EDCD7@dlee06.ent.ti.com>
To: "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>
Cc: sakari.ailus@maxwell.research.nokia.com,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Message-id: <000301cb1de2$29683260$7c389720$%nawrocki@samsung.com>
Content-language: en-us
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1278503608-9126-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <A69FA2915331DC488A831521EAE36FE4016B5EDCD7@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Isn't it like there need to be {} for both "if" and "else" when
there is more than one line in either block?

Regards,
--
Sylwester Nawrocki

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Karicheri, Muralidharan
> Sent: Wednesday, July 07, 2010 4:15 PM
> To: Laurent Pinchart; linux-media@vger.kernel.org
> Cc: sakari.ailus@maxwell.research.nokia.com
> Subject: RE: [RFC/PATCH 2/6] v4l: subdev: Add device node support
> 
> 
> 
> >v4l2_device *v4l2_dev,
> > 		if (err && err != -ENOIOCTLCMD) {
> > 			v4l2_device_unregister_subdev(sd);
> > 			sd = NULL;
> >+		} else {
> >+			sd->initialized = 1;
> > 		}
> 
> Wouldn't checkpatch.pl script complain about { } on the else part since
> there is only one statement?
> > 	}
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


