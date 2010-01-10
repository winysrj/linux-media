Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0AJMhu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 07:37:50 -0500
Message-ID: <4B49CA0F.3040502@infradead.org>
Date: Sun, 10 Jan 2010 10:37:35 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] gspca pac7302: add support for camera button
References: <4B095EEF.9070205@freemail.hu> <4B49C3E6.2040206@infradead.org> <4B49C70E.90109@freemail.hu>
In-Reply-To: <4B49C70E.90109@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Németh Márton wrote:
> Mauro Carvalho Chehab worte:
>> Németh Márton wrote:
>>> From: Márton Németh <nm127@freemail.hu>
>>>
>>> Add support for snapshot button found on Labtec Webcam 2200
>>> (USB ID 093a:2626
>> This patch breaks compilation against current -tip:
> 
> There was several versions of adding support to pac7302. The last version
> still have some problems which I haven't addressed, yet. So the camera
> button support for pac7302 is not yet ready for inclusion.

Ok. While you don't have a final version, please add an "RFC" at the patch, for
me to know, when dealing with patchwork queue, that the patch is not ok
yet.


> 
> Regards,
> 
> 	Márton Németh
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

