Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:38995 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750981AbaFOT7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 15:59:43 -0400
Message-ID: <539DFB28.8050505@codethink.co.uk>
Date: Sun, 15 Jun 2014 20:59:36 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: soc_camera and device-tree
References: <87ppibtes8.fsf@free.fr> <Pine.LNX.4.64.1406142256010.23099@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1406142256010.23099@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/06/14 21:58, Guennadi Liakhovetski wrote:
> Hi Robert,
> 
> On Sat, 14 Jun 2014, Robert Jarzmik wrote:
> 
>> Hi Guennadi,
>>
>> I'm slowly converting all of my drivers to device-tree.
>> In the process, I met ... soc_camera.
>>
>> I converted mt9m111.c and pxa_camera.c, but now I need the linking
>> soc_camera. And I don't have a clear idea on how it should be done.

New series is on the list. Let me know if there are any issues.

I am pushing the series up to git.codethink.co.uk.

	http://git.codethink.co.uk/linux.git bjdooks/v315/vin-of

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
