Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:49954 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab1EZW6Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 18:58:25 -0400
Message-ID: <4DDEDB0E.30108@iki.fi>
Date: Fri, 27 May 2011 01:58:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Nicolas WILL <nico@youplala.net>
CC: linux-media@vger.kernel.org,
	Steve Kerrison <steve@stevekerrison.com>
Subject: Re: PCTV nanoStick T2 290e support - Thank you!
References: <1306445141.14462.0.camel@porites>
In-Reply-To: <1306445141.14462.0.camel@porites>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/27/2011 12:25 AM, Nicolas WILL wrote:
> Just installed mine for MythTV.
>
> Works great on the first try!
>
> Many, many thanks!

Thank you for the feedback!

:)

It will get also remote controller support and I also changed LNA (low 
noise amplifier) behind module parameter. After those patches [1] are 
applied, in few day, you can enable LNA loading module manually:
modprobe em28xx_dvb options=1
,if needed.

> Nico

[1] http://git.linuxtv.org/anttip/media_tree.git

Antti
-- 
http://palosaari.fi/
