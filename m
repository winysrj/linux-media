Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:55619 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab1AJMv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 07:51:58 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>,
	Sergei Shtylyov <sshtylyov@mvista.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 10 Jan 2011 18:21:34 +0530
Subject: RE: [PATCH v13 5/8] davinci vpbe: platform specific additions
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930247F9A821@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024829B6B4@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jan 10, 2011 at 17:25:33, Nori, Sekhar wrote:
> On Mon, Jan 10, 2011 at 16:58:41, Sergei Shtylyov wrote:
> 
> > > +
> > > +#define OSD_REG_SIZE			0x000001ff
> > > +#define VENC_REG_SIZE			0x0000017f
> > 
> >     Well, actually that's not the size but "limit" -- sizes should be 
> > 0x200 and 0x180 respectively...
> 
> In most resource definitions on DaVinci, these are not even #defined. Just add the limit directly to the base to derive the .end
> 
> Thanks,
> Sekhar
> 
Ok. I shall keep the numbers as is.

Thanks,
-Manju

