Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45289 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbcAMPbn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 10:31:43 -0500
Subject: Re: PCI multimedia driver
To: Joao Pinto <Joao.Pinto@synopsys.com>, linux-media@vger.kernel.org
References: <56966984.9030807@synopsys.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
	Filipe.Goncalves@synopsys.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56966EB3.3040204@xs4all.nl>
Date: Wed, 13 Jan 2016 16:35:15 +0100
MIME-Version: 1.0
In-Reply-To: <56966984.9030807@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/13/16 16:13, Joao Pinto wrote:
> Hi guys,
> 
> We are developing a PCI endpoint with HDMI video out and sound out capabilities
> and we will need to develop a linux driver to control it (host side). Could you
> please point us some existing driver example?

Assuming that you plan to use V4L2 as the API instead of DRM/KMS, then the best
reference driver is drivers/media/pci/cobalt.

The PCIe cobalt card has four HDMI input and (via a daughterboard) an optional
fifth input or an HDMI output.

You can ignore all the code for the input part and just look at the code for the
HDMI output (it uses the adv7511 as the i2c HDMI transmitter).

The driver supports audio too.

I assume the primary use is to stream video (V4L2) and not as a desktop/GUI output
(DRM/KMS)? If you want to use it for the latter, then this is the wrong mailinglist.

Regards,

	Hans
