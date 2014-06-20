Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:15578 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaFTUoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 16:44:21 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N7H00ACRIXWXI20@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 Jun 2014 16:44:20 -0400 (EDT)
Date: Fri, 20 Jun 2014 17:44:13 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Time for v4l-utils 1.2 release?
Message-id: <20140620174413.1571e4b1.m.chehab@samsung.com>
In-reply-to: <53A49A11.2010502@googlemail.com>
References: <53A49A11.2010502@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 20 Jun 2014 22:31:13 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> It's been 11 months since the 1.0.0 release. What do you think about
> releasing HEAD? Do you have any pending commits?
> 
> Mauro, you tried to re-license the DVB library. What's the status there?

Hi Gregor,

I was missing one formal ack on that. However, the previous demand of
re-licinsing it as LGPL has gone, as gstreamer developers decided to
implement DVBv5 there directly.

So, I decided to keep it as-is for now, as there's no gain currently on
changing the license.

>From my side, please go ahead and release 1.2 ;)

Regards,
Mauro

