Return-path: <linux-media-owner@vger.kernel.org>
Received: from dev.henes.no ([212.4.45.42]:51342 "EHLO dev.henes.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826Ab2CGRsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 12:48:41 -0500
Subject: Re: Technotrend TT-Connect CT 3650 and dvb_ca
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: =?iso-8859-1?Q?Johan_Hen=E6s?= <johan@henes.no>
In-Reply-To: <1331137433.4765.3.camel@localhost>
Date: Wed, 7 Mar 2012 18:48:37 +0100
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1E8BE07F-9F35-4BC8-BB96-B254A93B897F@henes.no>
References: <4F56763C.50806@henes.no> <1331137433.4765.3.camel@localhost>
To: martinmaurer@gmx.at
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Mar 7, 2012, at 5:23 PM, Martin MAURER wrote:

> Hi Johan,
> 
> I have a similar problem which happens every few days with this card.
> For me it helps to remove and reinsert the kernel module whenever this
> happens.
> "rmmod -f dvb_usb_ttusb2 && modprobe dvb_usb_ttusb2"


Thanks a lot, Martin !

My challenge is that it happens every time i try to watch an encrypted channel.... :-(

Best,

Johan