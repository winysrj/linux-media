Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIDETbO004191
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 08:14:29 -0500
Received: from co203.xi-lite.net (co203.xi-lite.net [149.6.83.203])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBIDDv6Z000930
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 08:13:57 -0500
Message-ID: <494A4C93.4040202@parrot.com>
Date: Thu, 18 Dec 2008 14:13:55 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <494A150F.6010602@parrot.com>
	<Pine.LNX.4.64.0812181219100.5510@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0812181219100.5510@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: soc-camera : add new flags
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

Guennadi Liakhovetski a écrit :
> On Thu, 18 Dec 2008, Matthieu CASTET wrote:
> 
>> Hi,
>>
>> I am trying to use soc-camera for our camera IP.
>>
>> Our IP allow to chose if the synchronization is done according to  ITU-R
>> BT601 or ITU-R BT656.
>> Can new flag be added to negotiate the synchronization standard between
>> host and sensor.
> 
> Yes, sure, send a patch. Just add required 
> SOCAM_SYNC_{GATED,NONGATED,BT601,BT656} (or whatever you'd like to call 
> them) flags, and extend soc_camera_bus_param_compatible() to verify them.
> 
Ok

>> Our IP also allow to select if the data on the bus is transmitted on the
>> CbYCrY order or YCbYCr order.
>> Can new flag be added to negotiate the synchronization standard between
>> host and sensor.
> 
> Different statement but the same question? If you wanted to ask about 
> colour format then just use different YUYV / UYVY / ... fourcc codes.
How do you differentiate color format of the bus and the color format
output by v4l ?

In our case the bus format can be YUYV or UYVY, but the host camera IP
can only output YUV422P/YUV420/YVU420.



Matthieu

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
