Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:47850 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab1FAJtq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 05:49:46 -0400
Message-ID: <4DE60B36.9040507@iki.fi>
Date: Wed, 01 Jun 2011 12:49:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Steve Kerrison <steve@stevekerrison.com>,
	linux-media@vger.kernel.org
Subject: Re: [bug-report] unconditionally calling cxd2820r_get_tuner_i2c_adapter()
 from em28xx-dvb.c creates a hard module dependency
References: <87vcwpnavc.fsf@nemi.mork.no>
In-Reply-To: <87vcwpnavc.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/01/2011 12:45 PM, Bjørn Mork wrote:
> Don't know the proper fix.  My naïve quick-fix was just to move struct
> cxd2820r_priv into cxd2820r.h and making the function static inlined.
> However, I do see that you may not want the struct in cxd2820r.h.  But I
> trust that you have a brilliant solution to the problem :-)

Actually I don't have any idea about that. Help is welcome.

regards
Antti

-- 
http://palosaari.fi/
