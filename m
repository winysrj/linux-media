Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:56054 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbcAMPf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 10:35:57 -0500
Subject: Re: PCI multimedia driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Joao Pinto <Joao.Pinto@synopsys.com>,
	<linux-media@vger.kernel.org>
References: <56966984.9030807@synopsys.com> <56966EB3.3040204@xs4all.nl>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
	<Filipe.Goncalves@synopsys.com>
From: Joao Pinto <Joao.Pinto@synopsys.com>
Message-ID: <56966ED8.20200@synopsys.com>
Date: Wed, 13 Jan 2016 15:35:52 +0000
MIME-Version: 1.0
In-Reply-To: <56966EB3.3040204@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thanks for the information!

On 1/13/2016 3:35 PM, Hans Verkuil wrote:
> On 01/13/16 16:13, Joao Pinto wrote:
>> Hi guys,
>>
>> We are developing a PCI endpoint with HDMI video out and sound out capabilities
>> and we will need to develop a linux driver to control it (host side). Could you
>> please point us some existing driver example?
> 
> Assuming that you plan to use V4L2 as the API instead of DRM/KMS, then the best
> reference driver is drivers/media/pci/cobalt.
> 
> The PCIe cobalt card has four HDMI input and (via a daughterboard) an optional
> fifth input or an HDMI output.
> 
> You can ignore all the code for the input part and just look at the code for the
> HDMI output (it uses the adv7511 as the i2c HDMI transmitter).
> 
> The driver supports audio too.
> 
> I assume the primary use is to stream video (V4L2) and not as a desktop/GUI output
> (DRM/KMS)? If you want to use it for the latter, then this is the wrong mailinglist.
> 
> Regards,
> 
> 	Hans
> 

Regards,
Joao
