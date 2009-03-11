Return-path: <linux-media-owner@vger.kernel.org>
Received: from rotring.dds.nl ([85.17.178.138]:57194 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbZCKMDf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 08:03:35 -0400
Subject: Re: Improve DKMS build of v4l-dvb?
From: Alain Kalker <miki@dds.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <alpine.LRH.2.00.0903110842570.1207@pedra.chehab.org>
References: <1236612894.5982.72.camel@miki-desktop>
	 <20090309204308.10c9afc6@pedra.chehab.org>
	 <1236771396.5991.24.camel@miki-desktop>
	 <alpine.LRH.2.00.0903110842570.1207@pedra.chehab.org>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 13:03:27 +0100
Message-Id: <1236773007.5991.36.camel@miki-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op woensdag 11-03-2009 om 08:47 uur [tijdzone -0300], schreef Mauro
Carvalho Chehab:
> IMO, a perl script searching for PCI and USB tables at the driver
> would do 
> a faster job than doing a module build. You don't need to do a test build 
> to know what modules compile, since v4l/versions.txt already contains the 
> minimum supported version for each module. If the module is not there, 
> then it will build since kernel 2.6.16.

Good point, but for now I'm staying away from parsing the source files
(tough job to get it right with all the substitutions and the like), so
I can finish up packaging the source for DKMS and building the right
modules for a driver.

Kind regards,

Alain

