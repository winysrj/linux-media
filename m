Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:20418 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759947Ab1D1OSW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 10:18:22 -0400
Message-ID: <4DB97725.2070501@maxwell.research.nokia.com>
Date: Thu, 28 Apr 2011 17:18:13 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Yordan Kamenov <ykamenov@mm-sol.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1 v3] libv4l: Add plugin support to libv4l
References: <cover.1297680043.git.ykamenov@mm-sol.com> <234f9f1fbf05f602d2a079962305e050976f1c58.1297680043.git.ykamenov@mm-sol.com> <4DB961A3.70000@redhat.com>
In-Reply-To: <4DB961A3.70000@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans de Goede wrote:
> Hi,

Hi Hans, Yordan,

> First of all my apologies for taking so long to get around to
> reviewing this.
> 
> Over all it looks good, I've put some small remarks inline, if
> you fix these I can merge this. I wonder though, given the recent
> limbo around Nokia's change of focus, if there are any plans to
> actually move forward with a plugin using this... ?

Yes, there are. That hasn't changed a bit.

> The reason I'm asking is that adding the plugin framework if nothing
> is going to use it seems a bit senseless.

I agree with that. I also hope others would find the plugin framework
useful as well. :-)

A minor comment on the patch itself: there are a few checkpatch.pl
warnings from it, mostly lines over 80 characters, but also others.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
