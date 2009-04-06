Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbZDFKzR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 06:55:17 -0400
Date: Mon, 6 Apr 2009 07:54:58 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mike Isely <isely@pobox.com>
Cc: isely@isely.net, Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>, Andy Walls <awalls@radix.net>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
Message-ID: <20090406075458.082d723a@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0904051340570.32738@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	<20090405010539.187e6268@hyperion.delvare>
	<200904050746.47451.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.0904051340570.32738@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 13:48:02 -0500 (CDT)
Mike Isely <isely@isely.net> wrote:

> My impression (at least for pvrusb2-driven devices) is that the later IR 
> receivers require a completely different driver to work properly; one 
> can't just bolt additional features into ir-kbd-i2c for this.  

This is the old approach: adding more stuff into ir-kbd-i2c. The new approach
is to let ir-kbd-i2c to prepare for IR, but filling the protocol decoding
routines and IR names after having it bound on i2c bus. So, the IR routines
will be properly filled by the bridge driver (pvrusb2, in this case).

> In lirc's case, a different driver is in fact used.  But you know this already.
> 
> I haven't looked at ir-kbd-i2c in a while, but one other thing I 
> seriously did not like about it was that the mapping of IR codes to key 
> events was effectively hardcoded in the driver.  That makes it difficult 
> to make the same driver work with different kinds of remotes.  Even if 
> the bridge driver (e.g. pvrusb2) were to supply such a map, that's still 
> wrong because it's within the realm of possibility that the user might 
> actually want to use a different remote transmitter (provided it is 
> compatible enough to work with the receiver hardware).

The hardcoded keytables are just the default ones for that keyboard. As I've
shown already in this thread, it can be easily replaced on userspace, and we
have already an userspace tool on v4l2-apps that replaces those tables.

> The lirc architecture solves this easily via a conf file in userspace.  In fact, 
> lirc can map multiple mappings to a single receiver, permitting it to 
> work concurrently with more than one remote.  But is such a thing even 
> possible with ir-kbd-i2c?  I know this is one reason people tend to 
> choose lirc.

Multiple mappings based on what userspace app you're using can't be done
internally. However, you can keep using lirc with event driver for those
cases where you want to have multiple mappings, and this works fine.

The only drawback i saw when I used lirc the last time (a long time ago) is
that, when you remove an usb device, it used to flood the logs with errors
(several errors by second, warning that event interface disappeared). Probably
they already solved this issue. 

Cheers,
Mauro
