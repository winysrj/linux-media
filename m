Return-path: <linux-media-owner@vger.kernel.org>
Received: from pindarots.xs4all.nl ([82.161.210.87]:37157 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaIKK4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Sep 2014 06:56:08 -0400
Message-ID: <54117FBA.4080503@xs4all.nl>
Date: Thu, 11 Sep 2014 12:55:54 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
MIME-Version: 1.0
To: Mathias Nyman <mathias.nyman@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	USB list <linux-usb@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: 3.15.6 USB issue with pwc cam
References: <53DCE329.4030106@xs4all.nl> <53EA2DA2.4060605@redhat.com> <53EA350F.2040403@xs4all.nl> <6676742.btapbsDqkp@avalon> <53EA4057.4020103@xs4all.nl> <53EA4177.7000406@xs4all.nl> <53ECB86D.6090102@linux.intel.com>
In-Reply-To: <53ECB86D.6090102@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-08-14 15:23, Mathias Nyman wrote:
> The error:
> [53009.847233] xhci_hcd 0000:02:00.0: ERROR: unexpected command completion code 0x11.
> 
> Means we got a parameter error, one of the values the xhci driver sends to the controller
> in the configure endpoint command is invalid.

Are my recent additions to
https://bugzilla.kernel.org/show_bug.cgi?id=70531 for kernel 3.16.2 related?

Kind regards,
Udo

