Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:41649 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1LVJDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 04:03:13 -0500
Date: Thu, 22 Dec 2011 10:03:00 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: "Full Name" <danewson@excite.com>
Cc: linux-media@vger.kernel.org
Subject: Re: EasyCAP with identifiers
Message-ID: <20111222100300.538532fb@skate>
In-Reply-To: <20111221131455.14056@web002.roc2.bluetie.com>
References: <20111221131455.14056@web002.roc2.bluetie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Le Wed, 21 Dec 2011 13:14:55 -0500,
"Full Name" <danewson@excite.com> a écrit :

> I just got an EasyCAP usb device with component and S-video inputs, and it doesn't match what I was expecting from reading lists about drivers.

Be careful, there are several devices that the commercial name
"EasyCAP" but that internally aren't the same thing. We had the
experience of a device labelled "EasyCAP", which was working fine with
the easycap driver in drivers/staging. We bought another one from
Amazon, also labeled EasyCAP, and even though it looked exactly the
same externally, the hardware inside is completely different and is not
supported by the easycap driver in drivers/staging.

Regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
