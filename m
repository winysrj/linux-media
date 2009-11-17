Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52094 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbZKQQ7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 11:59:18 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 17 Nov 2009 10:58:54 -0600
Subject: RE: Help in adding documentation
Message-ID: <A69FA2915331DC488A831521EAE36FE401559C5A38@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401559C59A2@dlee06.ent.ti.com>
 <20091117142820.1e62a362@pedra.chehab.org>
In-Reply-To: <20091117142820.1e62a362@pedra.chehab.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Thanks for your reply. I made progress after my email. My new file
is being processed by Makefile now. I have some issues with some
tags.

>
>This probably means that videodev2.h has it defined, while you didn't have

Do you mean videodev2.h.xml? I see there videodev2.h under linux/include. Do I need to copy my latest videodev2.h to that directory?

>the
>link id created at the xml file you've created.
>
>You probably need a tag like:
>
><table pgwide="1" frame="none" id="v4l2-dv-enum-presets">
><!-- your enum table -->
></table>
>
>
>Cheers,
>Mauro
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

