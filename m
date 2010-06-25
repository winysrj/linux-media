Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.195]:54915 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab0FYVdM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jun 2010 17:33:12 -0400
Message-ID: <4C252074.5060609@vorgon.com>
Date: Fri, 25 Jun 2010 14:32:36 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: ERROR: cKbdRemote: Invalid argument
References: <4C241CBA.7040707@vorgon.com>
In-Reply-To: <4C241CBA.7040707@vorgon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Got remote back with new hg drivers.

On 6/24/2010 8:04 PM, Timothy D. Lenz wrote:
> Not sure what caused this, but the remote was working and I did an
> apt-get update/upgrade and then it wasn't. Now the syslog is getting
> this repeating. Don't seem to have to use the remote for another entry
> to be added to the log.
>
> Jun 24 19:36:33 x64VDR vdr: [4903] ERROR: cKbdRemote: Invalid argument
>
> Using Debian Squeeze. remote is on a nexus-s and using ir_kbd_i2c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
