Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab0ESPtg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 11:49:36 -0400
Message-ID: <4BF40889.4090809@redhat.com>
Date: Wed, 19 May 2010 12:49:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 video image
References: <4BF40649.5090900@arcor.de>
In-Reply-To: <4BF40649.5090900@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:
> Hi Mauro,
> 
> I have found what wrong is with video image. 

Great!

> You generate video buffer
> in function tm6000_isoc_copy, but that is not right. I move that in
> function copy_multiplexed and copy_streams. And that works without this
> http://www.stefan.ringel.de/pub/tm6000_image_10_05_2010.jpg (The lines
> with little left shift) . 

Didn't work:

404: Not Found - www.stefan.ringel.de

> Now, I generate a patch.

Ok. It would be great to have this issue finally fixed.

Cheers,
Mauro
