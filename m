Return-path: <linux-media-owner@vger.kernel.org>
Received: from hosted-by.2is.nl ([62.221.193.103]:52457 "EHLO jcz.nl"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbZETMEX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 08:04:23 -0400
Message-ID: <4A13F031.5050901@jcz.nl>
Date: Wed, 20 May 2009 13:57:37 +0200
From: Jaap Crezee <jaap@jcz.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] DVB-S2 frontend doesn't work!
References: <8566f5bc0905140646x6aaeb3ecq14e3c2c72b176e7@mail.gmail.com>	<20090515231609.0ba14254@bk.ru> <8566f5bc0905200456l2a88831w626d770852312bc6@mail.gmail.com>
In-Reply-To: <8566f5bc0905200456l2a88831w626d770852312bc6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

armel frey wrote:
> but szap-s2 lock dvb-s signal but not dvb-s2...
> someone have an idea???

try szap-s2 -S 1 (set delivery system to DVB-S2).

regards,

Jaap Crezee
