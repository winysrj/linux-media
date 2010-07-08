Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32241 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0GHHWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 03:22:14 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L5800KXN9SZBX00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Jul 2010 08:22:11 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L58007O99SZ61@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Jul 2010 08:22:11 +0100 (BST)
Date: Thu, 08 Jul 2010 09:20:58 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [RFC/PATCH 2/6] v4l: subdev: Add device node support
In-reply-to: <A69FA2915331DC488A831521EAE36FE4016B5EDCD7@dlee06.ent.ti.com>
To: "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Message-id: <00a901cb1e6e$1c5d8d40$5518a7c0$%osciak@samsung.com>
Content-language: pl
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1278503608-9126-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <A69FA2915331DC488A831521EAE36FE4016B5EDCD7@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>>v4l2_device *v4l2_dev,
>> 		if (err && err != -ENOIOCTLCMD) {
>> 			v4l2_device_unregister_subdev(sd);
>> 			sd = NULL;
>>+		} else {
>>+			sd->initialized = 1;
>> 		}
>
>Wouldn't checkpatch.pl script complain about { } on the else part since
>there is only one statement?
>> 	}
>>


CodingStyle is 100% clear on this:


Do not unnecessarily use braces where a single statement will do.

if (condition)
        action();

This does not apply if one branch of a conditional statement is a single
statement. Use braces in both branches.

if (condition) {
        do_this();
        do_that();
} else {
        otherwise();
}

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


