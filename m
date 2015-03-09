Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21485 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbbCIQVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 12:21:53 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKY00ANDDN9XY20@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Mar 2015 16:25:57 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sean Young' <sean@mess.org>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de,
	'Hans Verkuil' <hansverk@cisco.com>
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
 <1421942679-23609-4-git-send-email-k.debski@samsung.com>
 <20150123110747.GA3084@gofer.mess.org>
 <086501d05828$b88bf320$29a3d960$%debski@samsung.com>
 <20150308104441.GA3764@gofer.mess.org>
In-reply-to: <20150308104441.GA3764@gofer.mess.org>
Subject: RE: [RFC v2 3/7] cec: add new framework for cec support.
Date: Mon, 09 Mar 2015 17:21:49 +0100
Message-id: <000701d05a85$26592130$730b6390$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

From: Sean Young [mailto:sean@mess.org]
Sent: Sunday, March 08, 2015 11:45 AM
> 
> Hi Kamil,
> 
> On Fri, Mar 06, 2015 at 05:14:50PM +0100, Kamil Debski wrote:
> > 3) As you suggested - load an empty keymap whenever the pass through
> > mode is enabled.
> > I am not that familiar with the RC core. Is there a simple way to
> > switch to an empty map from the kernel? There is the ir_setkeytable
> > function, but it is static in rc-main.c, so it cannot be used in
> other
> > kernel modules. Any hints, Sean?
> 
> Why is it problematic if keypresses are passed to the input layer?

I gave this a thought over the weekend and I think I agree that this
shouldn't be much of a problem. I had doubts that there could be an
application that could use both the input device and at the same time
parse the raw messages to get keycodes. In reality this should not
happen, as someone using the "raw"/"promiscuous" mode would be aware
of how it works - that the keycodes are still passed to the input device.

> 
> You can only set the default keymap for an rc-device from kernel space;
> from user space you can clear the table using input ioctl, see:
> 
> http://git.linuxtv.org/cgit.cgi/v4l-
> utils.git/tree/utils/keytable/keytable.c#n1277
> 
> You can select MAP_EMPTY as the default keymap if that is appropriate;
> using
> ir-setkeytable(1) a different keymap can be selected.
> 
> 
> Sean

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


