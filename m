Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:65181 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbZKQVsv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 16:48:51 -0500
Date: Tue, 17 Nov 2009 22:48:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Details about DVB frontend API
Message-ID: <20091117224854.38069ea7@hyperion.delvare>
In-Reply-To: <829197380911171155j36ba858ejfca9e4c36689ab62@mail.gmail.com>
References: <20091022211330.6e84c6e7@hyperion.delvare>
	<20091023051025.597c05f4@caramujo.chehab.org>
	<1a297b360910221329o4b832f4ewaee08872120bfea0@mail.gmail.com>
	<4B02FDA4.5030508@infradead.org>
	<829197380911171155j36ba858ejfca9e4c36689ab62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Nov 2009 14:55:51 -0500, Devin Heitmueller wrote:
> On Tue, Nov 17, 2009 at 2:46 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > I don't like the idea of creating structs grouping those parameters. While for
> > certain devices this may mean a more direct approach, for others, this may
> > not make sense, due to the way their API's were implemented (for example,
> > devices with firmware may need several calls to get all those info).
> 
> There is some value in providing grouping the results in a single
> request - in many cases the data is based off of the same internal
> registers, and Manu's proposed approach allows for a more "atomic"
> response.  The fact that we currently do the status, SNR, strength,
> and UNC/BER in separate calls is one reason that people sometimes see
> inconsistent results in the output of tools like zap.  As an example,
> they can see lines in the zap output where the lock is lost but SNR
> appears fine.
> 
> In the case where the driver servicing the query needs to do three
> calls, it could be slightly more expensive, but only if we believe
> that it is commonplace to ask for a subset of the stats.

For what it's worth, we have solved this problem in hwmon driver the
following way: we cache related values (read from the same register or
set of registers) for ~1 second. When user-space requests the
information, if the cache is fresh it is used, otherwise the cache is
first refreshed. That way we ensure that data returned to nearby
user-space calls are taken from the same original register value. One
advantage is that we thus did not have to map the API to the hardware
register constraints and thus have the guarantee that all hardware
designs fit.

I don't know if a similar logic would help for DVB.

-- 
Jean Delvare
