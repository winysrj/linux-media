Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55721 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZA2Gyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 01:54:44 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: David Brownell <david-b@pacbell.net>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"Hadli, Manjunath" <mrh@ti.com>, "R, Sivaraj" <sivaraj@ti.com>
Date: Thu, 29 Jan 2009 12:24:10 +0530
Subject: RE: [REVIEW PATCH 2/2] Added OMAP3EVM Multi-Media Daughter Card
 Support
Message-ID: <19F8576C6E063C45BE387C64729E739403FA78FFC5@dbde02.ent.ti.com>
In-Reply-To: <200901111554.10469.david-b@pacbell.net>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: David Brownell [mailto:david-b@pacbell.net]
> Sent: Monday, January 12, 2009 5:24 AM
> To: Hiremath, Vaibhav
> Cc: linux-omap@vger.kernel.org; linux-media@vger.kernel.org;
> video4linux-list@redhat.com; Jadav, Brijesh R; Shah, Hardik; Hadli,
> Manjunath; R, Sivaraj
> Subject: Re: [REVIEW PATCH 2/2] Added OMAP3EVM Multi-Media Daughter
> Card Support
> 
> On Tuesday 06 January 2009, hvaibhav@ti.com wrote:
> > +config MACH_OMAP3EVM_DC
> > +       bool "OMAP 3530 EVM daughter card board"
> > +       depends on ARCH_OMAP3 && ARCH_OMAP34XX && MACH_OMAP3EVM
> 
> There can be other daughtercards, so the Kconfig text should
> say which specific card is being configured.  And it should
> probably use the "zero or one of these choices" syntax, so
> it's easier to include other options..
> 
[Hiremath, Vaibhav] I do agree with this point, but as of now I believe there is only one Daughter card which is available with us. And I would prefer to have menu option for the future when any new daughter card available and gets added to tree.

Any other opinions would be helpful?

> - Dave
> 
> 

