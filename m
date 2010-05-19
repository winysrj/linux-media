Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:54394 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab0ESPlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 11:41:35 -0400
Message-ID: <4BF40649.5090900@arcor.de>
Date: Wed, 19 May 2010 17:39:53 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: tm6000 video image
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I have found what wrong is with video image. You generate video buffer
in function tm6000_isoc_copy, but that is not right. I move that in
function copy_multiplexed and copy_streams. And that works without this
http://www.stefan.ringel.de/pub/tm6000_image_10_05_2010.jpg (The lines
with little left shift) . Now, I generate a patch.


Stefan Ringel
