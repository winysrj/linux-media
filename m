Return-path: <mchehab@pedra>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18287 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab1FABMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 21:12:30 -0400
From: Andrew Chew <AChew@nvidia.com>
To: 'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
	"olof@lixom.net" <olof@lixom.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 31 May 2011 18:12:20 -0700
Subject: RE: [PATCH 3/5 v2] [media] ov9740: Fixed some settings
Message-ID: <643E69AA4436674C8F39DCC2C05F76382A75BF37C2@HQMAIL03.nvidia.com>
References: <1306368272-28279-1-git-send-email-achew@nvidia.com>
 <1306368272-28279-3-git-send-email-achew@nvidia.com>
 <Pine.LNX.4.64.1105291218250.18788@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105291218250.18788@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> > +	{ OV9740_MIPI_CTRL00,		0x64 }, /* 0x44 for 
> continuous clock */
> 
> I think, the choice between continuous and discontinuous CSI-2 clock 
> should become configurable. You can only use discontinuous clock with 
> hosts, that support it, right? Whereas all hosts must support 
> continuous 
> clock. So, I'm not sure we should unconditionally switch to 
> discontinuous 
> clock here... Maybe it's better to keep it continuous until 
> we make it 
> configurable?

Yes, that's right.  The camera host needs to support discontinuous clocks.  I'll change it back to continuous clock by default, and change the comment to "0x64 for discontinuous clock", so we remember for when this becomes configurable.