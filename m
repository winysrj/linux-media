Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56033 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbZLAWrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 17:47:12 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 1 Dec 2009 16:47:12 -0600
Subject: RE: linux-media documentation fails to build
Message-ID: <A69FA2915331DC488A831521EAE36FE40155B76C37@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40155B76C14@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155B76C14@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some body removed media-spec target from v4l/Makefile.

I got it working with make spec.

Why to change target name like this? 

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Karicheri, Muralidharan
>Sent: Tuesday, December 01, 2009 5:28 PM
>To: linux-media@vger.kernel.org
>Cc: Mauro Carvalho Chehab; Hans Verkuil
>Subject: linux-media documentation fails to build
>
>Hi,
>
>I had downloaded the v4l2-dvb tree few days back to create my video timings
>API documentation and it had compiled fine when I did,
>
>make media-spec
>
>I still can build using the old tar ball. But today, I downloaded v4l-dvb-
>e0cd9a337600.tar.gz, it fails immediately after running the
>make_myconfig.pl script with the error
>
>"No rule to make target 'media-spec'. Stop
>
>Has something changed last few days that broke the build?
>
>I need to make updates to video timing API documentation based on Han's
>review comments and I am stuck at this issue now :(
>
>Murali Karicheri
>Software Design Engineer
>Texas Instruments Inc.
>Germantown, MD 20874
>phone: 301-407-9583
>email: m-karicheri2@ti.com
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
