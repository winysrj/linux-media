Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:33124 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932665AbaFRH1o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jun 2014 03:27:44 -0400
Message-ID: <53A13F69.2020809@codethink.co.uk>
Date: Wed, 18 Jun 2014 08:27:37 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	linux-kernel@lists.codethink.co.uk, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org
CC: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	magnus.damm@opensource.se, horms@verge.net.au,
	ian.molton@codethink.co.uk, william.towle@codethink.co.uk
Subject: Re: [PATCH 2/9] ARM: lager: add i2c1, i2c2 pins
References: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk> <1402862194-17743-3-git-send-email-ben.dooks@codethink.co.uk> <539EE41D.3050206@cogentembedded.com>
In-Reply-To: <539EE41D.3050206@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/06/14 13:33, Sergei Shtylyov wrote:
> Hello.
> 
> On 06/15/2014 11:56 PM, Ben Dooks wrote:
> 
>> Add pinctrl definitions for i2c1 and i2c2 busses on the Lager board
>> to ensure these are setup correctly at initialisation time. The i2c0
>> and i2c3 busses are connected to single function pins.
> 
>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> 
>    Likewise, this as been already merged by Simon.

Ah, they had not been merged when I took the branch for this around
-rc8 time. I will look at changing the necessary bits for the vin
in the DT and re-sub them as a new series for Simon to look at merging.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
