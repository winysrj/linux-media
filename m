Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:60499 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZKDGUW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 01:20:22 -0500
Message-ID: <4AF11D25.1080607@freemail.hu>
Date: Wed, 04 Nov 2009 07:20:21 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: Re: [PATCH 3/3] gspca pac7302/pac7311: separate the two subdrivers
References: <4AEE04DE.2060300@freemail.hu>
In-Reply-To: <4AEE04DE.2060300@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Jef,

although I tested my patch on my development computer together with Labtec
Webcam 2200 (gspca_pac7302 driver) it seems that the patch may cause regression
on some computers. For example I tested the gspca_pac7302 driver from
http://linuxtv.org/hg/~jfrancois/gspca/ on top of Linux kernel 2.6.32-rc5 on
an EeePC 901. I get the following error message in dmesg:

[ 4476.992201] usb 3-2: new full speed USB device using uhci_hcd and address 11
[ 4477.230485] usb 3-2: New USB device found, idVendor=093a, idProduct=2626
[ 4477.230507] usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 4477.231139] usb 3-2: configuration #1 chosen from 1 choice
[ 4477.417456] Linux video capture interface: v2.00
[ 4477.437131] gspca: main v2.7.0 registered
[ 4477.443214] gspca: probing 093a:2626
[ 4477.453491] gspca: /dev/video0 created
[ 4477.453541] gspca: probing 093a:2626
[ 4477.453549] gspca: intf != 0
[ 4477.453598] gspca: probing 093a:2626
[ 4477.453605] gspca: intf != 0
[ 4477.453755] usbcore: registered new interface driver pac7302
[ 4477.453771] pac7302: registered
[ 4489.552153] gspca: set alt 8 err -71

I bisected the problem on EeePC 901 and the changeset 13373:99c23949b411
(gspca - pac7302/pac7311: Separate the two subdrivers.) was marked as the first bad
commit.

On my development computer the same configuration works correctly:

[ 7872.020222] usb 3-1: new full speed USB device using uhci_hcd and address 4
[ 7872.251240] usb 3-1: configuration #1 chosen from 1 choice
[ 7872.744755] Linux video capture interface: v2.00
[ 7872.785032] gspca: main v2.7.0 registered
[ 7872.797061] gspca: probing 093a:2626
[ 7872.807577] gspca: /dev/video0 created
[ 7872.809747] usbcore: registered new interface driver pac7302
[ 7872.809798] pac7302: registered

Is the separated driver working for you?
Do you have any idea what could went wrong? Maybe some timing problem?

Regards,

	Márton Németh

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> All PAC7311 specific functions remain in pac7311.c. All PAC7302 specific
> functions are moved to pac7302.c. The USB device table is also divided into
> two parts. This makes it possible to remove the sensor specific decisions
> from different functions and also remove sensor infromation from the USB
> device table.
> 
> The common functions are just copied to both subdrivers. These common
> functions can be separated later to a common file or helper module.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> Cc: Thomas Kaiser <thomas@kaiser-linux.li>
> Cc: Theodore Kilgore <kilgota@auburn.edu>
> Cc: Kyle Guinn <elyk03@gmail.com>
