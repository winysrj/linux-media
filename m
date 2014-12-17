Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:62319 "EHLO
	rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaLQIRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 03:17:40 -0500
From: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [RFC PATCH] fixp-arith: replace sin/cos table by a better
 precision one
Date: Wed, 17 Dec 2014 08:17:38 +0000
Message-ID: <D0B737F7.270AE%prladdha@cisco.com>
In-Reply-To: <f437103f284c4ed964bd6577ff0c7793e8299d52.1418743646.git.mchehab@osg.samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9FCEB9962CD0C44D90DB8D471AD06F43@emea.cisco.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the patch, Mauro.  Just a correction below.

> 
>+/* cos(x) = sin(x + pi radians) */
>+
This should pi / 2. Correcting for the same below.
>+#define fixp_cos32_rad(rad, twopi)	\
>+	fixp_sin32_rad(rad + twopi/2, twopi)
          fixp_sin32_rad(rad + twopi/4, twopi)


>+

I think this patch will serve the need. I will test it for vivid sir tone
generation. I will rework my patches to use sin/cos functions from
fixp-arith.h.
>

