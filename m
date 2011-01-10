Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:60446 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab1AJLz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 06:55:56 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 10 Jan 2011 17:25:33 +0530
Subject: RE: [PATCH v13 5/8] davinci vpbe: platform specific additions
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024829B6B4@dbde02.ent.ti.com>
References: <1294654980-1936-1-git-send-email-manjunath.hadli@ti.com>
 <4D2AED69.3060602@mvista.com>
In-Reply-To: <4D2AED69.3060602@mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jan 10, 2011 at 16:58:41, Sergei Shtylyov wrote:

> > +
> > +#define OSD_REG_SIZE			0x000001ff
> > +#define VENC_REG_SIZE			0x0000017f
> 
>     Well, actually that's not the size but "limit" -- sizes should be 0x200 
> and 0x180 respectively...

In most resource definitions on DaVinci, these are not even #defined. Just
add the limit directly to the base to derive the .end

Thanks,
Sekhar
