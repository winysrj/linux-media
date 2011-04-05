Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58415 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1DEDl4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 23:41:56 -0400
Date: Mon, 4 Apr 2011 22:41:48 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH 7/7] [mpeg] cx88: don't use atomic_t for core->users
Message-ID: <20110405034123.GA7420@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
 <20110327152810.GA32106@elie>
 <20110402093856.GA17015@elie>
 <20110405032014.GA4498@elie>
 <20110405033114.GH4498@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405033114.GH4498@elie>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jonathan Nieder wrote:

> [Subject: [PATCH 7/7] [mpeg] cx88: don't use atomic_t for core->users]

The subject should say [media] rather than [mpeg].  I fixed it locally
and then sent the wrong patch; sorry for the nonsense.
