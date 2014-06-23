Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:50607 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754239AbaFWVFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 17:05:20 -0400
Message-ID: <53A89688.6080103@codethink.co.uk>
Date: Mon, 23 Jun 2014 22:05:12 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@lists.codethink.co.uk, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org, robert.jarzmik@free.fr,
	magnus.damm@opensource.se, horms@verge.net.au,
	ian.molton@codethink.co.uk, william.towle@codethink.co.uk
Subject: Re: [PATCH 7/9] soc_camera: add support for dt binding soc_camera
 drivers
References: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk> <1402862194-17743-8-git-send-email-ben.dooks@codethink.co.uk> <Pine.LNX.4.64.1406190927110.22703@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1406190927110.22703@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/06/14 08:28, Guennadi Liakhovetski wrote:
> Hi Ben,
> 
> Thanks for an update.
> 
> On Sun, 15 Jun 2014, Ben Dooks wrote:
> 
>> Add initial support for OF based soc-camera devices that may be used
>> by any of the soc-camera drivers. The driver itself will need converting
>> to use OF.
>>
>> These changes allow the soc-camera driver to do the connecting of any
>> async capable v4l2 device to the soc-camera driver. This has currently
>> been tested on the Renesas Lager board.
>>
>> It currently only supports one input device per driver as this seems
>> to be the standard connection for these devices.
> 
> You ignored most of my comments to the previous version of this your 
> patch. Please, revisit.

Sorry, will go and have a look over this tomorrow.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
