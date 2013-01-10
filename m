Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36043 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab3AJLNr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 06:13:47 -0500
Message-ID: <50EEA240.4060803@iki.fi>
Date: Thu, 10 Jan 2013 13:13:04 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hamad Kadmany <hkadmany@codeaurora.org>
CC: linux-media@vger.kernel.org
Subject: Re: [dvb] Question on dvb-core re-structure
References: <000801cdef1f$70667580$51336080$@codeaurora.org>
In-Reply-To: <000801cdef1f$70667580$51336080$@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/2013 12:44 PM, Hamad Kadmany wrote:
> Hi,
>
> With the new structure of dvb-core (moved up one directory), previous
> DVB/ATSC adapters were moved to media/usb, media/pci and media/mmc.
>
> For SoC that supports integrated DVB functionality, where should the
> adapter's code be located in the new structure? I don't see it fit any of
> the above three options.

I could guess that even for the SoCs there is some bus used internally. 
If it is not one of those already existing, then create new directly 
just like one of those existing and put it there.

regards
Antti

-- 
http://palosaari.fi/
