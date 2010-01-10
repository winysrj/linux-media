Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:59194 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab0AJMYw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 07:24:52 -0500
Message-ID: <4B49C70E.90109@freemail.hu>
Date: Sun, 10 Jan 2010 13:24:46 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] gspca pac7302: add support for camera button
References: <4B095EEF.9070205@freemail.hu> <4B49C3E6.2040206@infradead.org>
In-Reply-To: <4B49C3E6.2040206@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab worte:
> Németh Márton wrote:
>> From: Márton Németh <nm127@freemail.hu>
>>
>> Add support for snapshot button found on Labtec Webcam 2200
>> (USB ID 093a:2626
> 
> This patch breaks compilation against current -tip:

There was several versions of adding support to pac7302. The last version
still have some problems which I haven't addressed, yet. So the camera
button support for pac7302 is not yet ready for inclusion.

Regards,

	Márton Németh

