Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3P7rPC9031168
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 03:53:25 -0400
Received: from node01.cambriumhosting.nl (node01.cambriumhosting.nl
	[217.19.16.162])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3P7r70Z018841
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 03:53:07 -0400
Message-ID: <49F2C15A.3010106@powercraft.nl>
Date: Sat, 25 Apr 2009 09:52:58 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <49F189BC.5090606@powercraft.nl> <49F1ADF3.2030901@iki.fi>
	<49F1AFC9.2040405@powercraft.nl> <49F1BA30.6060702@iki.fi>
In-Reply-To: <49F1BA30.6060702@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [not working] Conceptronic USB 2.0 Digital TV Receiver -
 CTVDIGRCU - Device Information
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Antti Palosaari wrote:
> On 04/24/2009 03:25 PM, Jelle de Jong wrote:
>> I got an USB ID 14aa:0160 Conceptronic USB2.0 DVB-T CTVDIGRCU V2.0 but I
>> have no idea what chipsets it contains. Could somebody extract the
>> drivers to be sure? (see my first mail for driver web pages)
>> http://www.conceptronic.net/site/desktopdefault.aspx?tabindex=0&tabid=420&pc=CTVDIGRCU
> 
> There is no drivers for device USB-ID 14aa:0160.
> 
> ; Copyright (C) Wideviewer Corporation, 2005 All Rights Reserved.
> ;
> ; USB DVB-T Adapter
> ; WideViewer DVB-T WT-225U
> 
> ; The Vendor ID =14AA, and the Product ID =0226
> %DevModel.DeviceDesc%=DevModel.Dev,USB\VID_14AA&PID_0226&MI_00
> 
> According to google search it could be Realtek.
> http://ubuntuforums.org/showthread.php?t=822291&page=2
> 
> regards
> Antti

Would somebody be willing to get this device to work with the upstream
v4l systems? I can sent the device to you. If not I can also return the
device back to the store. Just sent me an email.

Cheers,

Jelle

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
