Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.248.54]:37144 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab0CCQmp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 11:42:45 -0500
Message-ID: <4B8E9182.2010906@online.no>
Date: Wed, 03 Mar 2010 17:42:42 +0100
From: Hendrik Skarpeid <skarp@online.no>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org,
	Nameer Kazzaz <nameer.kazzaz@gmail.com>
Subject: Re: DM1105: could not attach frontend 195d:1105
References: <4B7D83B2.4030709@online.no> <201003030110.32834.liplianin@me.by> <4B8E1FF1.8050605@online.no> <201003031749.24261.liplianin@me.by>
In-Reply-To: <201003031749.24261.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Igor M. Liplianin wrote:
>
> Now to find GPIO's for LNB power control and ... watch TV :)
>
>   
Yep. No succesful tuning at the moment. There might also be an issue 
with the reset signal and writing to GPIOCTR, as the module at the 
moment loads succesfully only once.
As far as I can make out, the LNB power control is probably GPIO 16 and 
17, not sure which is which, and how they work.
GPIO15 is wired to tuner #reset

