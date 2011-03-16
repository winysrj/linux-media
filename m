Return-path: <mchehab@pedra>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:56089 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab1CPUb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 16:31:57 -0400
Subject: Re: [ANNOUNCE] usbmon capture and parser script
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg KH <greg@kroah.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
Date: Wed, 16 Mar 2011 21:20:24 +0100
In-Reply-To: <20110316194758.GA32557@kroah.com>
References: <4D8102A9.9080202@redhat.com> <20110316194758.GA32557@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1300306845.1954.7.camel@t41.thuisdomein>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-03-16 at 12:47 -0700, Greg KH wrote:
> Very cool stuff.  You are away of:
> 	http://vusb-analyzer.sourceforge.net/
> right?
> 
> I know you are doing this in console mode, but it looks close to the
> same idea.

Perhaps there should be some references to vusb-analyzer and similar
tools in Documentation/usb/usbmon.txt (it now only mentions "usbdump"
and "USBMon"). I remember looking for a tool like that (ie, a parser)
for quite some time before stumbling onto vusb-analyzer.


Paul Bolle

