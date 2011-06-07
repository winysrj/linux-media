Return-path: <mchehab@pedra>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:34541
	"EHLO CH1EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752484Ab1FGKD7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 06:03:59 -0400
Date: Tue, 7 Jun 2011 11:58:29 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
	"arnd@arndb.de" <arnd@arndb.de>,
	"davidb@codeaurora.org" <davidb@codeaurora.org>,
	Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: Re: [RFC 0/6] iommu: generic api migration and grouping
Message-ID: <20110607095829.GD4407@amd.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
 <20110606100950.GC30762@amd.com>
 <BANLkTi=i2s-Ujiy4qn_XQv+9dMjUC9R66A@mail.gmail.com>
 <20110606153557.GE1953@amd.com>
 <BANLkTinwwVO4TmsxuTfSBf6jqYrEVV3b_A@mail.gmail.com>
 <20110606192030.GA4356@amd.com>
 <BANLkTinx21-E3DRe9D7LRB8e1aeOwv=-9A@mail.gmail.com>
 <20110607075221.GB4407@amd.com>
 <BANLkTimR3KofKA3LSKXdX8k1FGR0XUxu=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTimR3KofKA3LSKXdX8k1FGR0XUxu=Q@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jun 07, 2011 at 05:22:11AM -0400, Ohad Ben-Cohen wrote:
> On Tue, Jun 7, 2011 at 10:52 AM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > Yup. Btw, is there any IOMMU hardware which supports non-natural
> > alignment? In this case we need to expose these requirements somehow.
> 
> Not sure there are. Let's start with natural alignment, and extend it
> only if someone with additional requirements shows up.

Btw, mind to split out your changes which move the iommu-api into
drivers/iommu? I can merge them meanwhile into my iommu tree and start
working on a proposal for the generic large page-size support.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

