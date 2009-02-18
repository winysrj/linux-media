Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32108.mail.mud.yahoo.com ([68.142.207.122]:36156 "HELO
	web32108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753321AbZBRVcW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 16:32:22 -0500
Date: Wed, 18 Feb 2009 13:32:21 -0800 (PST)
From: Agustin <gatoguan-os@yahoo.com>
Reply-To: gatoguan-os@yahoo.com
Subject: Re: [PATCH/RFC 1/4] ipu_idmac: code clean-up and robustness improvements
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>,
	Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <20090218200739.GC11757@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <342407.54641.qm@web32108.mail.mud.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On 18/2/09, Russell King -wrote:
> On Wed, Feb 18, 2009 at 07:09:55AM -0800, Agustin wrote:
> > $ patch -p1 --dry-run < p1
> > patching file drivers/dma/ipu/ipu_idmac.c
> > patch: **** malformed patch at line 29: /*
> > 
> > Looks like your patches lost their format while on their way,
> > specially every single line with a starting space has had it
> > removed. Or is it my e-mail reader? I am trying to fix it
> > manually, no luck.
> 
> I think it's your mail reader - the version I have here is fine.
> What you could do is look up the message in the mailing list
> archive on lists.arm.linux.org.uk, and use the '(text/plain)'
> link to download an unmangled copy of it.

Thanks, that worked fine.
