Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:48480 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab1BJML2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Feb 2011 07:11:28 -0500
Subject: Re: [alsa-devel] WL1273 FM Radio driver...
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "ext Bensaid, Selma" <selma.bensaid@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@redhat.com>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
In-Reply-To: <20110210110205.GA28336@opensource.wolfsonmicro.com>
References: <4D4FF821.4010701@redhat.com>
	 <20110207135225.GJ10564@opensource.wolfsonmicro.com>
	 <1297088242.15320.62.camel@masi.mnp.nokia.com>
	 <4D501704.6060504@redhat.com> <4D5109B3.60504@nokia.com>
	 <2A84145621092446B6659B8A0F28E26F47010C29F1@irsmsx501.ger.corp.intel.com>
	 <4D5122CF.3010403@nokia.com> <1297236165.15320.70.camel@masi.mnp.nokia.com>
	 <2A84145621092446B6659B8A0F28E26F4703CC3968@irsmsx501.ger.corp.intel.com>
	 <1297332223.15320.95.camel@masi.mnp.nokia.com>
	 <20110210110205.GA28336@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 14:10:40 +0200
Message-ID: <1297339840.15320.101.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2011-02-10 at 11:02 +0000, ext Mark Brown wrote:
> On Thu, Feb 10, 2011 at 12:03:43PM +0200, Matti J. Aaltonen wrote:
> 
> > We know these messages, they are mentioned in the documentation and we
> > use them already, but we send them from the user space. The problem is
> > how to send the messages from the driver within the kernel.
> 
> Set up a line discipline - it's not in principle that much different to
> what something like PPP is doing.

I'll look into it. 

But I got the following quick comment from a local BT expert: "No you
cannot change line discipline if bt is already in use. And it's not uart
interface but hci interface. uart can be replaced with sdio for example
and you still have the same hci interface."

Thanks,
Matti



