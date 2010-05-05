Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab0EEN61 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 May 2010 09:58:27 -0400
Message-ID: <4BE17979.6040005@redhat.com>
Date: Wed, 05 May 2010 10:58:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Bee Hock Goh <beehock@gmail.com>, linux-media@vger.kernel.org,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: Re: tm6000
References: <20100505145027.1571f12c@glory.loctelecom.ru>	<u2y6e8e83e21005042244g2ba765c9ga1822df8093baae@mail.gmail.com> <20100505172759.6da65251@glory.loctelecom.ru>
In-Reply-To: <20100505172759.6da65251@glory.loctelecom.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitri Belimov wrote:
> On Wed, 5 May 2010 13:44:38 +0800
> Bee Hock Goh <beehock@gmail.com> wrote:
> 
>> Did you comment off the code in the get_next_buff that clear the
>> previous frame data?
> 
> No. 
> 
> Git tree + my last patch.
> 

A "green" tree can happen due to lots of conditions, like:
	1) it is not receiving data from xc3028 (or xc5000);
	2) wrong gpio setup;
	3) data sent too fast to tm6000;
	4) need to add some new workarounds to another tm6000 firmware/hardware bug;
	5) the device stopped answer and got disconnected from USB buffer;
	6) signal were too weak after changing to some channel (it seems that the tm6000 
	   chip stops reception with weak signals - I remember I had to add a code that 
	   re-enables xc3028 every time a channel is changed due to this bug, since,
	   after disabled, even if the signal become strong, it keeps showing a green
	   screen);
	7) you hit yet another bug on this device ;)

-- 

Cheers,
Mauro
