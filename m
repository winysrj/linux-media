Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:46590 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab0JEONl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Oct 2010 10:13:41 -0400
Message-ID: <4CAB309D.5020309@linuxtv.org>
Date: Tue, 05 Oct 2010 16:05:17 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Confusing dmx_pes_type_t in dmx.h
References: <4CAAC57B.4000604@hoogenraad.net>
In-Reply-To: <4CAAC57B.4000604@hoogenraad.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05.10.2010 08:28, Jan Hoogenraad wrote:
> The file dmx.h declares dmx_pes_type_t which is ONLY used in this header
> file.
> It is easy to make mistakes, as its member DMX_PES_OTHER resembles a
> similar symbol in demux.h from enum dmx_ts_pes:  DMX_TS_PES_OTHER
> 
> One problem was found because of Hans' compiler upgrade.
> 
> I think it would be safer (because it is easy to make mistakes) to
> remove  dmx_pes_type_t from dmx.h.

The file dmx.h defines the interface for userspace applications, hence
dmx_pes_type_t must not be removed. Instead, removing enum dmx_ts_pes
from demux.h seems to be useful to me.

Regards,
Andreas
