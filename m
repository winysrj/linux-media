Return-path: <mchehab@pedra>
Received: from yop.chewa.net ([91.121.105.214]:37988 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab1EXP7y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 11:59:54 -0400
From: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
Reply-To: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
To: Steve Kerrison <steve@stevekerrison.com>
Cc: linux-media@vger.kernel.org, vlc-devel@videolan.org
Subject: Re: dvb: one demux per tuner or one demux per demod?
References: <719f9c4d1bd57d5b2711bc24a9d5c3b1@chewa.net>
	 <1306238734.7397.102.camel@ares>
In-Reply-To: <1306238734.7397.102.camel@ares>
Content-Type: text/plain; charset=utf-8
Content-ID: <1306252793.5194.3.camel@Nokia-N900-51-1>
Date: Tue, 24 May 2011 18:59:54 +0300
Message-Id: <1306252794.5194.4.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

    Hello,

----- Message d'origine -----
> I believe you can only use one frontend at once per adapter (this is
> certainly enforced in the cxd2820r module), so I don't see how it would
> cause a problem for mappings. I think a dual tuner device would register
> itself as two adapters, wouldn't it?

That would be one scheme: there would only ever be one demux per adapter then. But from archives of this very mailing list, I gather that say HVR 3000 shows up as two frontends (DVB-T and DVB-S) with a demux each... Not consistent if true (I do not have such a device to check).

For seamless setup in userspace, I need a consistent mapping scheme, whatever that is. Ideally, I would be able to distinguish multiproto frontends from dual tuners from dual tuners with dual antenna. At the very least, I need a way to find the demux that corresponds to a frontend. And until DMX_OUT_TSDEMUX_TAP works correctly, to a dvr.

Otherwise, user needs to configure frontend AND demux, which is really unfriendly and error-prone.

-- 
Rémi
