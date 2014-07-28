Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.inunum.li ([83.169.19.93]:39917 "EHLO
	lvps83-169-19-93.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945AbaG1H74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 03:59:56 -0400
Message-ID: <53D602FF.8070006@InUnum.com>
Date: Mon, 28 Jul 2014 09:59:59 +0200
From: Michael Dietschi <michael.dietschi@InUnum.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.sourceforge.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: omap3isp with DM3730 not working?!
References: <53D12786.5050906@InUnum.com> <CA+2YH7v8bQG4K2Gz8aB9_BOHwuK_1nGDxU102S7EBnsMGEuwKA@mail.gmail.com> <20140728072043.GW16460@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140728072043.GW16460@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari, Enrico and others,

first of all I want to thank you for your help but I have to admit that 
I made a stupid error while struggling with image capturing and the ISP 
which has led to some false information - I had misconfigured the video 
source :(

The corrected facts are:
     * Capturing does work with Gumstix Overo with a DM3730 and a 
TVP5151 chip
     * It does not work with a LogicPD Torpedo DM3730 and a TVP5150AM1 chip
     * I configured the Torpedo's pinmux exactly like on the Overo
     * ...but the only interrupt I am getting is "HS_VS_IRQ"

Please apologize for the confusion and do not stop helping me...

Kind regards,
Michael
