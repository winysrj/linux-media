Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51420 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbbCPRpI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 13:45:08 -0400
Message-ID: <550716A1.7020304@iki.fi>
Date: Mon, 16 Mar 2015 19:45:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] dw2102: combine su3000_state and s6x0_state into
 dw2102_state
References: <1426526046-2063-1-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1426526046-2063-1-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 07:14 PM, Olli Salonen wrote:
> Two separate state structs are defined for different devices inside the dw2102. Combine them,
> as both only contain one element. This will also make it easier to implement the next patch
> in the patch series.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti
-- 
http://palosaari.fi/
