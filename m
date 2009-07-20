Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35013 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbZGTGJs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 02:09:48 -0400
From: "chaithrika" <chaithrika@ti.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: <linux-media@vger.kernel.org>, <mchehab@infradead.org>,
	<hverkuil@xs4all.nl>,
	<davinci-linux-open-source@linux.davincidsp.com>,
	"'Brijesh Jadav'" <brijesh.j@ti.com>,
	"'Kevin Hilman'" <khilman@deeprootsystems.com>
References: <1246967577-8573-1-git-send-email-chaithrika@ti.com> <20090719104258.GR12062@n2100.arm.linux.org.uk>
In-Reply-To: <20090719104258.GR12062@n2100.arm.linux.org.uk>
Subject: RE: [PATCH v2] ARM: DaVinci: DM646x Video: Platform and board	specific setup
Date: Mon, 20 Jul 2009 11:38:17 +0530
Message-ID: <007d01ca0900$79b4c320$6d1e4960$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Sunday, July 19, 2009 4:13 PM
> To: Chaithrika U S
> Cc: linux-media@vger.kernel.org; mchehab@infradead.org;
> hverkuil@xs4all.nl; davinci-linux-open-source@linux.davincidsp.com;
> Manjunath Hadli; Brijesh Jadav; Kevin Hilman
> Subject: Re: [PATCH v2] ARM: DaVinci: DM646x Video: Platform and board
> specific setup
> 
> On Tue, Jul 07, 2009 at 07:52:57AM -0400, Chaithrika U S wrote:
> > diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h
> b/arch/arm/mach-davinci/include/mach/dm646x.h
> > index 0585484..1f247fb 100644
> > --- a/arch/arm/mach-davinci/include/mach/dm646x.h
> > +++ b/arch/arm/mach-davinci/include/mach/dm646x.h
> > @@ -26,4 +26,28 @@ void __init dm646x_init(void);
> >  void __init dm646x_init_mcasp0(struct snd_platform_data *pdata);
> >  void __init dm646x_init_mcasp1(struct snd_platform_data *pdata);
> >
> > +void dm646x_video_init(void);
> > +
> > +struct vpif_output {
> > +	u16 id;
> > +	const char *name;
> > +};
> > +
> > +struct subdev_info {
> > +	unsigned short addr;
> > +	const char *name;
> > +};
> 
> 'subdev_info' is far too generic to have in platform header files.
> Please rename this to at least vpif_subdev_info.
> 
> Other than that, patch looks fine.

OK. I will post an updated patch soon.

Regards,
Chaithrika


