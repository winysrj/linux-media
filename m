Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7G8aCJJ002042
	for <video4linux-list@redhat.com>; Sun, 16 Aug 2009 04:36:12 -0400
Received: from smtp.bluecom.no (smtp.bluecom.no [193.75.75.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n7G8ZvHv005583
	for <video4linux-list@redhat.com>; Sun, 16 Aug 2009 04:35:57 -0400
Received: from localhost.localdomain (c7F6F47C1.dhcp.bluecom.no
	[193.71.111.127])
	by smtp.bluecom.no (Postfix) with ESMTP id 0A23415B4098
	for <video4linux-list@redhat.com>;
	Sun, 16 Aug 2009 10:35:22 +0200 (CEST)
Message-ID: <4A87C4EC.6030309@ntnu.no>
Date: Sun, 16 Aug 2009 10:35:56 +0200
From: Haavard Holm <haavard.holm@ntnu.no>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <4A872D3F.6020003@ntnu.no>	<1250383433.28382.2.camel@localhost.localdomain>
	<20090816080309.3f19a067@tele>
In-Reply-To: <20090816080309.3f19a067@tele>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: Varying frame rate
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

On 08/16/2009 08:03 AM, Jean-Francois Moine wrote:
> On Sun, 16 Aug 2009 03:43:52 +0300
> Maxim Levitsky<maximlevitsky@gmail.com>  wrote:
>
>    
>> On Sat, 2009-08-15 at 23:48 +0200, Haavard Holm wrote:
>>      
> 	[snip]
>    
>>> My obeservation is : Depending on what my camera focus on, the
>>> framerate varies from 5 to 15 fps. I have tried several times, same
>>> result.
>>>        
> 	[snip]
>    
>> I have observed similar issues with uvc camera on my aspire one (low
>> frame rate while the illumination is low)
>>
>> Probably this is a hardware issue, and maybe there is a control to
>> turn this off.
>>      
> Hello,
>
> The frame rate depends on the exposure time. If auto exposure is set,
> you may have such a behaviour.
>    

 From a c-program - how do I turn off auto exposure ?

Best

Håvard Holm
> Best regards.
>
>    

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
