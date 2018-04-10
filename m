Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36929 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753097AbeDJO6U (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 10:58:20 -0400
Date: Tue, 10 Apr 2018 11:58:15 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Josef Wolf <jw@raven.inka.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Confusion about API: please clarify
Message-ID: <20180410115815.51ac801b@vento.lan>
In-Reply-To: <20180410104327.GA28895@raven.inka.de>
References: <20180410104327.GA28895@raven.inka.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Apr 2018 12:43:27 +0200
Josef Wolf <jw@raven.inka.de> escreveu:

> Hello,
> 
> The linuxtv wiki pages state that the current v5 API (also called S2API) is
> tag/value based:
> 
>   https://www.linuxtv.org/wiki/index.php/Development:_Linux_DVB_API_history_and_future
>   https://www.linuxtv.org/wiki/index.php/S2API
> 
> But in the API documentation (version 5.10), I can't find anything that looks
> like tag/value.

That refers basically to DVB frontend API. Please see:
	https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/dvb/dvbproperty.html

> Can anyone clarify, what the current state of the API is and where to find
> up-to-date documentation?

The updated documentation for all media APIs we maintain are always at:

		https://www.linuxtv.org/downloads/v4l-dvb-apis-new/

It is updated daily as new features are added at the source code.


Thanks,
Mauro
