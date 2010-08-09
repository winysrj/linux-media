Return-path: <matti.j.aaltonen@nokia.com>
Received: from smtp.nokia.com ([192.100.122.233]:35284 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab0HIHeN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 03:34:13 -0400
Subject: Re: [PATCH v7 0/5] TI WL1273 FM Radio driver.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Valentin Eduardo <eduardo.valentin@nokia.com>,
	mchehab@redhat.com
In-Reply-To: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 10:33:55 +0300
Message-ID: <1281339235.2296.17.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

It starts to look like the ALSA codec could be
accepted on the ALSA list pretty soon.
So I'd be very interested to hear from you if
the rest of the driver still needs fixes...

By the way, now the newest wl1273 firmware supports
a special form of hardware seek,  they call it the
'bulk search' mode. It can be used to search for all
stations that are available and at first the number of found 
stations is returned. Then the frequencies can be fetched 
one by one. Should we add a 'seek mode' field to hardware 
seek? Or do you have a vision of how it should be handled?

Thanks,
Matti

