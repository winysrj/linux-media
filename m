Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55304 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab3AXIoW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 03:44:22 -0500
Message-ID: <5100F440.90302@iki.fi>
Date: Thu, 24 Jan 2013 10:43:44 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add lock to af9035 driver for dual mode
References: <45300900.lplt0zG7i2@jar7.dominio> <510065E9.7070702@iki.fi> <1411603.1yOyLSGzvX@jar7.dominio>
In-Reply-To: <1411603.1yOyLSGzvX@jar7.dominio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/24/2013 02:15 AM, Jose Alberto Reguero wrote:
> On Jueves, 24 de enero de 2013 00:36:25 Antti Palosaari escribió:
>> On 01/24/2013 12:34 AM, Jose Alberto Reguero wrote:
>>> Add lock to af9035 driver for dual mode.
>>
>> May I ask why you do that?
>>
>> regards
>> Antti
>>
>
> Just to avoid interference between the two demods.
>
> Jose Alberto

... and how you can see that interference? What should I do that I can 
see these problems you are trying to fix with that patch.

regards
Antti


-- 
http://palosaari.fi/
