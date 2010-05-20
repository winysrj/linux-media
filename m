Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:60684 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0ETRvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 May 2010 13:51:13 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id o4KHpDTW023501
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 20 May 2010 12:51:13 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id o4KHpCaW015332
	for <linux-media@vger.kernel.org>; Thu, 20 May 2010 12:51:12 -0500 (CDT)
Received: from dlee75.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o4KHpCEr012222
	for <linux-media@vger.kernel.org>; Thu, 20 May 2010 12:51:12 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Bhardwaj, Asheesh" <asheeshb@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 20 May 2010 12:51:11 -0500
Subject: RE: 
Message-ID: <A69FA2915331DC488A831521EAE36FE4016AFDE3A6@dlee06.ent.ti.com>
References: <1274287478-14661-1-git-send-email-asheeshb@ti.com>
In-Reply-To: <1274287478-14661-1-git-send-email-asheeshb@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Asheesh,

Please re-send this patch with following:-

1) A detailed description of what you are trying to fix in each of this patch. You need to also run the checkpatch.pl script to make sure there are no errors.
2) Please make this patch based on the http://git.linuxtv.org/v4l-dvb.git master branch. I am assuming you have based it upon the Arago tree.
3) add the Signed-off-by field.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Bhardwaj, Asheesh
>Sent: Wednesday, May 19, 2010 12:45 PM
>To: linux-media@vger.kernel.org
>Subject:
>
>The patches will be applied to the davinci tree
>the ../drivers/media/video/davinci and will affect the both the capture and
>display drivers. Apply these patches to the git kernel.
>From asheeshb@ti.com # This line is ignored.
>GIT:
>From: asheeshb@ti.com
>Subject:
>In-Reply-To:
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
