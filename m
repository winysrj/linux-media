Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.190]:16203 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZKQTzq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 14:55:46 -0500
Received: by gv-out-0910.google.com with SMTP id r4so118205gve.37
        for <linux-media@vger.kernel.org>; Tue, 17 Nov 2009 11:55:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B02FDA4.5030508@infradead.org>
References: <20091022211330.6e84c6e7@hyperion.delvare>
	 <20091023051025.597c05f4@caramujo.chehab.org>
	 <1a297b360910221329o4b832f4ewaee08872120bfea0@mail.gmail.com>
	 <4B02FDA4.5030508@infradead.org>
Date: Tue, 17 Nov 2009 14:55:51 -0500
Message-ID: <829197380911171155j36ba858ejfca9e4c36689ab62@mail.gmail.com>
Subject: Re: Details about DVB frontend API
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 17, 2009 at 2:46 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> I don't like the idea of creating structs grouping those parameters. While for
> certain devices this may mean a more direct approach, for others, this may
> not make sense, due to the way their API's were implemented (for example,
> devices with firmware may need several calls to get all those info).

There is some value in providing grouping the results in a single
request - in many cases the data is based off of the same internal
registers, and Manu's proposed approach allows for a more "atomic"
response.  The fact that we currently do the status, SNR, strength,
and UNC/BER in separate calls is one reason that people sometimes see
inconsistent results in the output of tools like zap.  As an example,
they can see lines in the zap output where the lock is lost but SNR
appears fine.

In the case where the driver servicing the query needs to do three
calls, it could be slightly more expensive, but only if we believe
that it is commonplace to ask for a subset of the stats.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
