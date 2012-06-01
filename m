Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33443 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844Ab2FATwH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jun 2012 15:52:07 -0400
Received: from dyn3-82-128-188-130.psoas.suomi.net ([82.128.188.130] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1SaXtF-00081f-5J
	for linux-media@vger.kernel.org; Fri, 01 Jun 2012 22:52:05 +0300
Message-ID: <4FC91D64.6090305@iki.fi>
Date: Fri, 01 Jun 2012 22:52:04 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Fwd: [Bug 827538] DVB USB device firmware requested in module_init()
References: <bug-827538-199927-UDXT6TGYkq@bugzilla.redhat.com>
In-Reply-To: <bug-827538-199927-UDXT6TGYkq@bugzilla.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



-------- Original Message --------
Subject: [Bug 827538] DVB USB device firmware requested in module_init()
Date: Fri, 01 Jun 2012 19:44:17 +0000
From: bugzilla@redhat.com
To: crope@iki.fi

https://bugzilla.redhat.com/show_bug.cgi?id=827538

Kay Sievers <kay@redhat.com> changed:

            What    |Removed                     |Added
----------------------------------------------------------------------------
                  CC|                            |gansalmon@Gmail.com,
                    |                            |itamar@ispbrasil.com.br,
                    |                            |kernel-maint@redhat.com,
                    |                            |madhu.chinakonda@gmail.com
           Component|udev                        |kernel
            Assignee|udev-maint@redhat.com       |kernel-maint@redhat.com
             Summary|DVB USB device firmware     |DVB USB device firmware
                    |downloading takes 30        |requested in module_init()
                    |seconds                     |

--- Comment #1 from Kay Sievers <kay@redhat.com> ---
This is very likely a kernel driver issue.

Drivers must not load firmware in the module_init() path, or device
probe()/bind() path. This creates a deadlock in the event handling.

We used to silently try to work around that, but recently started
to log this error explicitely.

The firmware should in general be requested asynchronously, or at the first
open() of the device.

Details are here:
   http://thread.gmane.org/gmane.linux.network/217729

-- 
You are receiving this mail because:
You reported the bug.
