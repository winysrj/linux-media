Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.uludag.org.tr ([193.140.100.216]:53654 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbZJUUJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 16:09:43 -0400
Message-ID: <4ADF6A8A.3070109@pardus.org.tr>
Date: Wed, 21 Oct 2009 23:09:46 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
References: <Pine.LNX.4.44L0.0910211052200.2847-100000@iolanthe.rowland.org> <200910211927.00298.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200910211927.00298.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Probably because hal opens the device to query its capabilities and closes it 
> right after. The driver submits the interrupt URB when the first user opens 
> the device and cancels it when the last user closes the device.
>  
>   

So who's guilty now?

:)
