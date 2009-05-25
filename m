Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:47929 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZEYJDc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 05:03:32 -0400
Message-ID: <4A1A5E24.20201@unsolicited.net>
Date: Mon, 25 May 2009 10:00:20 +0100
From: David <david@unsolicited.net>
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
	USB list <linux-usb@vger.kernel.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dbrownell@users.sourceforge.net, leonidv11@gmail.com,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
 down
References: <4A1967A2.4050906@unsolicited.net>	<Pine.LNX.4.44L0.0905242208260.15195-100000@netrider.rowland.org> <20090524203902.594a0eec.zaitcev@redhat.com>
In-Reply-To: <20090524203902.594a0eec.zaitcev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pete Zaitcev wrote:
> On Sun, 24 May 2009 22:10:50 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> wrote:
>
>   
>> Pete, you should look at this.  It appears to be a problem with the DMA
>> mapping in usbmon.  Probably the same sort of thing you were working on
>> about a week ago (trying to access device memory).
>>     
>
> Indeed it looks the same. Is this an AMD CPU?
>   
yes, a Phenom.

> I wonder if CONFIG_HAVE_DMA_API_DEBUG does it (enabled with a select
> in arch/x86/Kconfig). Strange that it started happening now.
>   
That is enabled. I'll switch it off and give it another go.

David
