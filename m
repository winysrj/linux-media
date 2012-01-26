Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48639 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab2AZJHh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 04:07:37 -0500
Message-ID: <4F2117D6.20702@iki.fi>
Date: Thu, 26 Jan 2012 11:07:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Claus Olesen <ceolesen@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: 290e locking issue
References: <CAGa-wNOCn6GDu0DGM7xNrVagp0sdNeif25vuE+sPyU3aaegGAw@mail.gmail.com>
In-Reply-To: <CAGa-wNOCn6GDu0DGM7xNrVagp0sdNeif25vuE+sPyU3aaegGAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/26/2012 12:16 AM, Claus Olesen wrote:
> just got 3.2.1-3.fc16.i686.PAE
> the issue that the driver had to be removed for the 290e to work after
> a replug is gone.
> the issue that a usb mem stick cannot be mounted while the 290e is
> plugged in still lingers.
> one workaround is to unplug the 290e and wait a little (no need to
> also remove the driver).

What it prints to the system log? Use tail -f /var/log/messages or dmesg.


Antti
-- 
http://palosaari.fi/
