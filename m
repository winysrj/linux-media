Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm23-vm0.bullet.mail.ukl.yahoo.com ([217.146.177.37]:21249 "HELO
	nm23-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752935Ab2DFUMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 16:12:05 -0400
Message-ID: <4F7F4CAF.4010501@yahoo.com>
Date: Fri, 06 Apr 2012 21:06:07 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [REGRESSION] Linux 3.3 DVB userspace ABI broken for xine (FE_SET_FRONTEND)
References: <1333580430.41460.YahooMailNeo@web121705.mail.ne1.yahoo.com>
In-Reply-To: <1333580430.41460.YahooMailNeo@web121705.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The following commit has broken the DVB ABI for xine:

http://git.linuxtv.org/linux-2.6.git/commitdiff/e399ce77e6e8f0ff2e0b8ef808cbb88fc824c610

author: Mauro Carvalho Chehab <mchehab@redhat.com>
  Sun, 1 Jan 2012 19:11:16 +0000 (16:11 -0300)
committer: Mauro Carvalho Chehab <mchehab@redhat.com>
  Wed, 4 Jan 2012 19:30:02 +0000 (17:30 -0200)

This var were used during DVBv3 times, in order to keep a copy
of the parameters used by the events. This is not needed anymore,
as the parameters are now dynamically generated from the DVBv5
structure.

So, just get rid of it. That means that a DVBv5 pure call won't
use anymore any DVBv3 parameters.


The problem is that xine is expecting every event after a successful 
FE_SET_FRONTEND ioctl to have a non-zero frequency parameter, regardless of 
whether the tuning process has LOCKed yet. What used to happen is that the 
events inherited the initial tuning parameters from the FE_SET_FRONTEND call. 
However, the fepriv->parameters_out struct is now not initialised until the 
status contains the FE_HAS_LOCK bit.

You might argue that this behaviour is intentional, except that if an 
application other than xine uses the DVB adapter and manages to set the 
parameters_out.frequency field to something other than zero, then xine no longer 
has any problems until either the adapter is replugged or the kernel modules 
reloaded. This can only mean that the fepriv->parameters_out struct still 
contains the (stale) tuning information from the previous application.

So can we please restore the original ABI behaviour, and have 
fepriv->parameters_out initialised by FE_SET_FRONTEND again?

Cheers,
Chris
