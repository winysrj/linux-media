Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbZDIRhc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 13:37:32 -0400
Message-ID: <49DE3257.7010009@e-tobi.net>
Date: Thu, 09 Apr 2009 19:37:27 +0200
From: Tobi <listaccount@e-tobi.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Userspace issue with DVB driver includes
References: <49DDA100.1030205@e-tobi.net> <20090409074534.2cf32df0@pedra.chehab.org> <49DE2301.5090406@e-tobi.net>
In-Reply-To: <49DE2301.5090406@e-tobi.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tobi wrote:

> I've applied both patches to 2.6.29.1, but the problem still remains.
> 
> It's hard to figure out, who to blame for this.

The root of the problem seems to be a clash between linux/types.h which
defines some POSIX types also defined in glibc's stdint.h. I'm not sure,
who to blame for this glibc or the kernel...
The problem seems not to be restricted to the DVB drivers, so this is
probably the wrong list, but any comments are welcome!

Tobias
