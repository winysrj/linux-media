Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm6.bullet.mail.ird.yahoo.com ([77.238.189.63]:47873 "HELO
	nm6.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755867Ab2DFKtL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 06:49:11 -0400
Received: from volcano.underworld (volcano.underworld [192.168.0.3])
	by wellhouse.underworld (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id q36An6hq012589
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Fri, 6 Apr 2012 11:49:08 +0100
Message-ID: <4F7ECA22.7040604@yahoo.com>
Date: Fri, 06 Apr 2012 11:49:06 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DVB ioctl FE_GET_EVENT behaviour broken in 3.3
References: <4F7CDA41.5020001@googlemail.com>
In-Reply-To: <4F7CDA41.5020001@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The reason that DVB playback with xine is broken in 3.3 is that the userspace 
semantics of FE_GET_EVENT have changed. Xine tunes into a DVB channel as follows:

* discards stale frontend events by calling FE_GET_EVENT until there is none left.
* calls FE_SET_FRONTEND with the new frequency.
* starts polling for new frontend events by calling FE_GET_EVENT again.

Xine assumes that *every* FE_GET_EVENT after calling FE_SET_FRONTEND will have 
dvb_frontend_event.parameters.frequency set to the new frequency, if this 
channel exists. However, under Linux 3.3, at least the first new event with a 
newly-plugged-in device has a frequency parameter of zero. I am assuming that 
Linux is populating the frequency parameter from an internal data structure 
because xine behaves normally once some other DVB application manages to set it 
to something other than zero. And xine then continues to behave normally until I 
unplug the DVB adapter and plug in back in again.

So the question is: why is there no frequency for this first FE_GET_EVENT? Are 
the parameters incomplete, or shouldn't this event have been sent in the first 
place?

Cheers,
Chris
