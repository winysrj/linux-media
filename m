Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0AJMLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 07:11:37 -0500
Message-ID: <4B49C3E6.2040206@infradead.org>
Date: Sun, 10 Jan 2010 10:11:18 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] gspca pac7302: add support for camera button
References: <4B095EEF.9070205@freemail.hu>
In-Reply-To: <4B095EEF.9070205@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Add support for snapshot button found on Labtec Webcam 2200
> (USB ID 093a:2626

This patch breaks compilation against current -tip:

/home/v4l/master/v4l/pac7302.c:74:19: error: input.h: No such file or directory
/home/v4l/master/v4l/pac7302.c: In function 'sd_int_pkt_scan':
/home/v4l/master/v4l/pac7302.c:1255: error: 'struct gspca_dev' has no member named 'input_dev'
/home/v4l/master/v4l/pac7302.c:1256: error: 'struct gspca_dev' has no member named 'input_dev'
/home/v4l/master/v4l/pac7302.c:1257: error: 'struct gspca_dev' has no member named 'input_dev'
/home/v4l/master/v4l/pac7302.c:1258: error: 'struct gspca_dev' has no member named 'input_dev'
/home/v4l/master/v4l/pac7302.c: At top level:
/home/v4l/master/v4l/pac7302.c:1284: error: unknown field 'int_pkt_scan' specified in initializer
/home/v4l/master/v4l/pac7302.c:1284: warning: excess elements in struct initializer
/home/v4l/master/v4l/pac7302.c:1284: warning: (near initialization for 'sd_desc')
make[3]: *** [/home/v4l/master/v4l/pac7302.o] Error 1

Cheers,
Mauro
