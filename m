Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22951 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbaHNNK5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 09:10:57 -0400
Message-ID: <53ECB86D.6090102@linux.intel.com>
Date: Thu, 14 Aug 2014 16:23:57 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	USB list <linux-usb@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: 3.15.6 USB issue with pwc cam
References: <53DCE329.4030106@xs4all.nl> <53EA2DA2.4060605@redhat.com> <53EA350F.2040403@xs4all.nl> <6676742.btapbsDqkp@avalon> <53EA4057.4020103@xs4all.nl> <53EA4177.7000406@xs4all.nl>
In-Reply-To: <53EA4177.7000406@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/2014 07:31 PM, Udo van den Heuvel wrote:
> On 2014-08-12 18:27, Hans Verkuil wrote:
>> It was a bit confusing, but he has two problems: one pwc, one (the warning) for
>> uvc.
> 
> Indeed.
> Do I need to provide additional info to help find the root cause(s)?
> 
>

Could you help me take a look at the xhci side.

The error:
[53009.847233] xhci_hcd 0000:02:00.0: ERROR: unexpected command completion code 0x11.

Means we got a parameter error, one of the values the xhci driver sends to the controller
in the configure endpoint command is invalid.

This error is causing the "Not enough bandwidth" entries in the log as well, not
really a bandwidth error.

Can you add dynamic debugging, mount debugfs, and do:
echo -n 'module xhci_hcd =p' > /sys/kernel/debug/dynamic_debug/control

Then plug in your usb, and send me the output. 
It should print out the whole input context (all parameters) used in the configure endpoint command 

-Mathias
