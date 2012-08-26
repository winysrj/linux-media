Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38470 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab2HZQqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Aug 2012 12:46:08 -0400
Message-ID: <503A52BD.90603@iki.fi>
Date: Sun, 26 Aug 2012 19:45:49 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH] Add support to Avermedia Twinstar double tuner in af9035
References: <1535656.ZrASkjgG1J@jar7.dominio>
In-Reply-To: <1535656.ZrASkjgG1J@jar7.dominio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/2012 10:05 PM, Jose Alberto Reguero wrote:
> This patch add support to the Avermedia Twinstar double tuner in the
> af9035 driver.
>
> This time the patch inline because it was rejected. Also patch was
> malformed.
>
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net
> <mailto:jareguero@telefonica.net>>
>
> Jose Alberto

Hello Jose, and thank you very much to hack this important and missing 
piece of AF9035 driver functionality.

I looked it quickly and here is the comments so far. I will try to 
review it more carefully tomorrow.

* your patch is very hard to read/review as you used some diff option 
that does not show function name whom code is changed

* there is two new configuration parameters for af9033 demod. I don't 
understand why. As I don't see any need / use for those I want you to 
remove those. Configurations structures are something not to add any 
extra parameters "just for fun". Use "ts_mode != AF9033_TS_MODE_USB" 
instead of "second". Other parameter "tuner_address" is not used at all 
for af9033.

* MXL5007T is not my driver. There seems to be new parameters no_probe 
and no_reset. Those sounds also something that could be avoided. But I 
didn't looked that code and I am not sure. Add at least comment why 
those are used as such parameters deviates from normal use.


Could you also sent small sniff for me where is dual tuner used?


regards
Antti


-- 
http://palosaari.fi/
