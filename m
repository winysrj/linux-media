Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m99J06Tv011276
	for <video4linux-list@redhat.com>; Thu, 9 Oct 2008 15:00:06 -0400
Received: from unifiedpaging.messagenetsystems.com
	(www.digitalsignage.messagenetsystems.com [24.123.23.170] (may
	be forged))
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m99Ix2tY018736
	for <video4linux-list@redhat.com>; Thu, 9 Oct 2008 14:59:03 -0400
Message-ID: <48EE5488.7030706@messagenetsystems.com>
Date: Thu, 09 Oct 2008 14:59:20 -0400
From: Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
MIME-Version: 1.0
To: Ming Liu <mliu@migmasys.com>
References: <20081009160014.DA2F761AA01@hormel.redhat.com>
	<48EE4FE4.6080002@migmasys.com>
In-Reply-To: <48EE4FE4.6080002@migmasys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: USB grabber
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

Ming Liu wrote:
> Hello,
>
> I am working on a USB grabber from Campusa. The item number of this 
> grabber is VC-211A with a S/N 0025544.
> It relies on an EM 2820 chip.
>
> I have a DSL-N system with kernel 2.6.12, and the grabber is not 
> reflected on the dmesg.
>
> Is there any driver available for this grabber? Any example that I can 
> follow to make it work?
>
> Thank you for advance.
>
> Sincerely yours
> Ming
>
>
> -- 
> video4linux-list mailing list
> Unsubscribe 
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>
Ming:

I use a USB Analyzer from Totalphase www.totalphase.com.  It works with 
Winblows and Linux as it utilizes userspace libusb-win32 and libusb 
drivers respectively.  There are two flavors.  A USB 1.1 unit that is 
~$400 and a USB 2.0 unit that is ~$1200.  I have the USB 2.0 unit and I 
love it.  Free lifetime upgrades for firmware and application software.  
USB realtime capture display and USB Class decoding is on the way.

Best Regards,
-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
