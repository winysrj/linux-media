Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fuel7.com ([74.222.0.51]:59555 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab3AHWtp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jan 2013 17:49:45 -0500
Message-ID: <50ECA285.2000909@fuel7.com>
Date: Tue, 08 Jan 2013 14:49:41 -0800
From: William Swanson <william.swanson@fuel7.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Ken Petit <ken@fuel7.com>
Subject: Re: [PATCH] omap3isp: Add support for interlaced input data
References: <1355796739-2580-1-git-send-email-william.swanson@fuel7.com> <20121227182709.5e89a61a@redhat.com> <50E732FC.10203@fuel7.com> <1489481.HbZGQ48duQ@avalon>
In-Reply-To: <1489481.HbZGQ48duQ@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/07/2013 04:20 AM, Laurent Pinchart wrote:
> What do you get in the memory buffers ? Are fields captured in separate
> buffers or combined in a single buffer ? If they're combined, are they
> interleaved or sequential in memory ?

I believe the data is combined in a single buffer, with alternate fields 
interleaved.

-William
