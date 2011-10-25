Return-path: <linux-media-owner@vger.kernel.org>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:33148 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1JYJZU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Oct 2011 05:25:20 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by stevekerrison.com (Postfix) with ESMTP id 91C2716423
	for <linux-media@vger.kernel.org>; Tue, 25 Oct 2011 10:25:17 +0100 (BST)
Received: from stevekerrison.com ([127.0.0.1])
	by localhost (stevekez.vm.bytemark.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MXhqdcs06yif for <linux-media@vger.kernel.org>;
	Tue, 25 Oct 2011 10:25:14 +0100 (BST)
Received: from [10.0.97.47] (unknown [195.26.247.141])
	(Authenticated sender: steve@stevekerrison.com)
	by stevekerrison.com (Postfix) with ESMTPSA id CFF7F162C2
	for <linux-media@vger.kernel.org>; Tue, 25 Oct 2011 10:25:14 +0100 (BST)
Subject: Re: Display hotplug
From: Steve Kerrison <steve@stevekerrison.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1319534660.2847.57.camel@ares>
References: <CAAMvbhF0GJDxePwhRBmMRQaCH-EN7Cv1AKhgLO99sjdnba+v7A@mail.gmail.com>
	 <1319534660.2847.57.camel@ares>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Oct 2011 10:25:13 +0100
Message-ID: <1319534713.2847.59.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

When I plug my laptop's (Toshiba R630, Intel i3 with integrated on-die
graphics) HDMI port into a TV, the display manager in Ubuntu is able to
detect it and, after a click or two, mirror or extended-desktop to it.

So I would say the answer is... it already does. It's more likely that
your distribution doesn't have the tools you need to do what you want,
or the driver for your graphics device needs some work :)

And I don't think this problem falls into the remit of linux-media;
graphics drivers are dealt with elsewhere, aren't they?
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Tue, 2011-10-25 at 10:09 +0100, James Courtier-Dutton wrote:
> Hi,
> 
> Does anyone know when X will support display hotplug?
> I have a PC connected via HDMI to a TV.
> Unless I turn the TV on first, I have to reboot the PC before it
> displays anything on the HDMI TV.
> 
> Kind Regards
> 
> James
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

