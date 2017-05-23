Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48139 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031439AbdEWVsD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 17:48:03 -0400
Subject: Re: [PATCH v3 2/2] v4l: async: Match parent devices
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <cover.33d4457de9c9f4e5285e7b1d18a8a92345c438d3.1495473356.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6154c8f092e1cb4f5286c1f11f4a846c821b53d6.1495473356.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170523130222.GE29527@valkosipuli.retiisi.org.uk>
 <f56ce770-c7cc-1613-194f-e5f9a944dc4e@ideasonboard.com>
 <20170523214018.GG29527@valkosipuli.retiisi.org.uk>
 <20170523214352.GH29527@valkosipuli.retiisi.org.uk>
Cc: Kieran Bingham <kbingham@kernel.org>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <66cef4a0-e237-b84c-94b1-4efd76118f9f@ideasonboard.com>
Date: Tue, 23 May 2017 22:47:58 +0100
MIME-Version: 1.0
In-Reply-To: <20170523214352.GH29527@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/05/17 22:43, Sakari Ailus wrote:
> On Wed, May 24, 2017 at 12:40:19AM +0300, Sakari Ailus wrote:
>>>  * When all devices use endpoint matching, this code can be simplified, and the
>>>  * parent comparisons can be removed.
> 
> Oh, and this I'm not so sure about --- we'll need to match lens controllers
> and flash drivers. There are no endpoints in those devices. Let's see how it
> goes when we get there...
> 

Sure, would you like me to post a v4 of just this patch?

The parent checks should always be safe, so this feels like less of a workaround
now, and if it provides support for other use cases perhaps it could survive
longer term.
--
Kieran
