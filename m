Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:54377 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZEYM3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 08:29:06 -0400
Message-ID: <4A1A8E53.9060108@unsolicited.net>
Date: Mon, 25 May 2009 13:25:55 +0100
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
References: <4A1967A2.4050906@unsolicited.net>	<Pine.LNX.4.44L0.0905242208260.15195-100000@netrider.rowland.org> <20090524203902.594a0eec.zaitcev@redhat.com> <4A1A5E24.20201@unsolicited.net>
In-Reply-To: <4A1A5E24.20201@unsolicited.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David wrote:
>
>> I wonder if CONFIG_HAVE_DMA_API_DEBUG does it (enabled with a select
>> in arch/x86/Kconfig). Strange that it started happening now.
>>   
>>     
> That is enabled. I'll switch it off and give it another go.
>
>   
While CONFIG_HAVE_DMA_API_DEBUG was set, DMA_API_DEBUG was not, so I
guess there's nothing I can do to test?
