Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3P8QL5a010087
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 04:26:21 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [217.30.184.167])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3P8Q5Gh018881
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 04:26:05 -0400
Message-ID: <49F2C917.4060803@iki.fi>
Date: Sat, 25 Apr 2009 11:25:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
References: <49F189BC.5090606@powercraft.nl> <49F1ADF3.2030901@iki.fi>
	<49F1AFC9.2040405@powercraft.nl> <49F1BA30.6060702@iki.fi>
	<49F2C15A.3010106@powercraft.nl>
In-Reply-To: <49F2C15A.3010106@powercraft.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 04/25/2009 10:52 AM, Jelle de Jong wrote:
> Would somebody be willing to get this device to work with the upstream
> v4l systems? I can sent the device to you. If not I can also return the
> device back to the store. Just sent me an email.

I can try. At least some basic driver stub which just works is possible 
to do usually even without specs if tuner chip have one that does have 
Linux driver. Most likely it does have tuner that is supported because 
almost every DVB-T silicon tuner have some kind of driver currently.

regards
Antti
-- 
http://palosaari.fi/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
