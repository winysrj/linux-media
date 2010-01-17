Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:53096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0AQQ2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 11:28:38 -0500
Received: by fg-out-1718.google.com with SMTP id 22so288447fge.1
        for <linux-media@vger.kernel.org>; Sun, 17 Jan 2010 08:28:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <245243.78544.qm@web32707.mail.mud.yahoo.com>
References: <802509.22940.qm@web32703.mail.mud.yahoo.com>
	 <245243.78544.qm@web32707.mail.mud.yahoo.com>
Date: Sun, 17 Jan 2010 11:28:36 -0500
Message-ID: <829197381001170828t33b63c0ayf9b26472f702dd90@mail.gmail.com>
Subject: Re: Kworld 315U and SAA7113?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Franklin Meng <fmeng2002@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 17, 2010 at 2:05 AM, Franklin Meng <fmeng2002@yahoo.com> wrote:
> I retested my device and tried several different GPIO sequences but so far every time I change between the Analog and digital interface, the SAA7113 needs to be reinitialized.  I tried leaving both the digital and analog interfaces enabled by setting the GPIO to 7c but then the LG demod does not initialize.
>
> Either way it looks like I will have to reinitialize the device after switching between interfaces.
>
> Other than that do you want me to remove the suspend GPIO?  Since I don't have the equipment to measure the power, I don't know for a fact if the device really has been put in a suspend state or not.

Hello Franklin,

Just to be clear, I'm not proposing that you remove the suspend logic.
 I was suggesting that you should be breaking the change into three
separate patches, so that if a problem arises we can isolate whether
it is a result of the power management changes.  Having a separate
patch is especially valuable because you are touching other drivers
which are shared by other products.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
