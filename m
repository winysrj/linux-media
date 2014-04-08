Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53851 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756121AbaDHNFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Apr 2014 09:05:40 -0400
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id E273920F12
	for <linux-media@vger.kernel.org>; Tue,  8 Apr 2014 09:05:39 -0400 (EDT)
Message-ID: <5343F421.8040006@williammanley.net>
Date: Tue, 08 Apr 2014 14:05:37 +0100
From: William Manley <will@williammanley.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] uvcvideo: Work around buggy Logitech C920 firmware
References: <1394647711-25291-1-git-send-email-will@williammanley.net> <1394714328-29969-1-git-send-email-will@williammanley.net> <533209A1.5090806@williammanley.net> <3163919.oZbdpQdqrg@avalon>
In-Reply-To: <3163919.oZbdpQdqrg@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/03/14 23:03, Laurent Pinchart wrote:
> Hi William,
> 
> On Tuesday 25 March 2014 22:56:33 William Manley wrote:
>> On 13/03/14 12:38, William Manley wrote:
>>> The uvcvideo webcam driver exposes the v4l2 control "Exposure (Absolute)"
>>> which allows the user to control the exposure time of the webcam,
>>> essentially controlling the brightness of the received image.  By default
>>> the webcam automatically adjusts the exposure time automatically but the
>>> if you set the control "Exposure, Auto"="Manual Mode" the user can fix
>>> the exposure time.
>>>
>>> Unfortunately it seems that the Logitech C920 has a firmware bug where
>>> it will forget that it's in manual mode temporarily during initialisation.
>>> This means that the camera doesn't respect the exposure time that the user
>>> requested if they request it before starting to stream video.  They end up
>>> with a video stream which is either too bright or too dark and must reset
>>> the controls after video starts streaming.
>>>
>>> This patch introduces the quirk UVC_QUIRK_RESTORE_CTRLS_ON_INIT which
>>> causes the cached controls to be re-uploaded to the camera immediately
>>> after initialising the camera.  This quirk is applied to the C920 to work
>>> around this camera bug.
>>>
>>> Changes since patch v1:
>>>  * Introduce quirk so workaround is only applied to the C920.
>>>
>>> Signed-off-by: William Manley <will@williammanley.net>
>>
>> Bump?
> 
> Sorry, I haven't had the time to handle your patch yet. I'll try to do so on 
> Thursday or Friday.

Apologies for the nagging: What's the current status?

Thanks

Will

