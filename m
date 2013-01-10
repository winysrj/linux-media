Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:42547 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3AJQCA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 11:02:00 -0500
Received: from morden (ip-5-146-176-139.unitymediagroup.de [5.146.176.139])
	by smtp.strato.de (josoe mo42) (RZmta 31.12 DYNA|AUTH)
	with (DHE-RSA-AES128-SHA encrypted) ESMTPA id J07d8bp0AFZhtI
	for <linux-media@vger.kernel.org>;
	Thu, 10 Jan 2013 17:01:57 +0100 (CET)
Received: from rjkm by morden with local (Exim 4.80)
	(envelope-from <rjkm@morden.metzler>)
	id 1TtKZp-00032I-Ia
	for linux-media@vger.kernel.org; Thu, 10 Jan 2013 17:01:57 +0100
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20718.58869.396398.764373@morden.metzler>
Date: Thu, 10 Jan 2013 17:01:57 +0100
To: <linux-media@vger.kernel.org>
Subject: Re: [dvb] Question on dvb-core re-structure
In-Reply-To: <20130110121304.1a24d5d3@redhat.com>
References: <000801cdef1f$70667580$51336080$@codeaurora.org>
	<50EEA240.4060803@iki.fi>
	<000901cdef28$9ba87050$d2f950f0$@codeaurora.org>
	<20130110121304.1a24d5d3@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab writes:
 > Em Thu, 10 Jan 2013 13:49:52 +0200
 > "Hamad Kadmany" <hkadmany@codeaurora.org> escreveu:
 > 
 > > On 01/10/2013 1:13 PM, Antti Palosaari wrote:
 > > > I could guess that even for the SoCs there is some bus used internally. 
 > > > If it is not one of those already existing, then create new directly just
 > > like one of those existing and put it there.
 > > 
 > > Thanks for the answer. I just wanted to clarify - it's integrated into the
 > > chip and accessed via memory mapped registers, so I'm not sure which
 > > category to give the new directory (parallel to pci/mms/usb). Should I just
 > > put the adapter's sources directory directly under media directory?
 > 
 > That's the case of all other drivers under drivers/media/platform: they're
 > IP blocks inside the SoC chip. I think that all arch-dependent drivers are
 > there.
 > 
 > The menu needs to be renamed to "Media platform drivers" when the first DVB
 > driver arrives there (it currently says V4L, as there's no DVB driver there
 > yet). Feel free to add such patch on your patch series at the time you
 > submit your driver, if nobody else submit any DVB platform driver earlier
 > than yours.


What about DVB cores which can be used via different busses?
E.g. ddbridge initially only used PCIe. Now we also use the same function blocks
(I2C, DVB input, etc.) connected to a SoC via an EBI (extension bus interface) 
and register it as a platform device. Because a lot of code can be
shared I do not want to split it over several directories. 

Regards,
Ralph
