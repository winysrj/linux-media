Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39103 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab2AXLsN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 06:48:13 -0500
Message-ID: <4F1E9A78.7020203@iki.fi>
Date: Tue, 24 Jan 2012 13:48:08 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "Hawes, Mark" <MARK.HAWES@au.fujitsu.com>
CC: linux-media@vger.kernel.org
Subject: Re: HVR 4000 hybrid card still producing multiple frontends for single
 adapter
References: <44895934A66CD441A02DCF15DD759BA0011CAE69@SYDEXCHTMP2.au.fjanz.com>
In-Reply-To: <44895934A66CD441A02DCF15DD759BA0011CAE69@SYDEXCHTMP2.au.fjanz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/24/2012 06:41 AM, Hawes, Mark wrote:
> Hi,
>
> I have a HVR 4000 hybrid card  which provides both DVB-S2 and DVB-T capabilities on the one adapter. Using the current media tree build updated with the contents of the linux media drivers tarball dated 22/01/2012 the drivers for this card are still generating two frontends on the adapter as below:
>
>> Jan 23 12:16:44 Nutrigrain kernel: [    9.346240] DVB: registering adapter 1 frontend 0 (Conexant CX24116/CX24118)...
>> Jan 23 12:16:44 Nutrigrain kernel: [    9.349110] DVB: registering adapter 1 frontend 1 (Conexant CX22702 DVB-T)...
>
> I understand that this behaviour is now deprecated and that the correct behaviour should be to generate one front end with multiple capabilities. Can this please be corrected.

Same applies for many other devices too. For example some older Anysee 
E7 models have two chip and two frontends whilst new one have only one. 
Also TechnoTrend CT3650 and Hauppauge WinTV.

Maybe it those are implemented later as one frontend, it not clear for me.


Antti
-- 
http://palosaari.fi/
