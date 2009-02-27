Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1RKN7SC013749
	for <video4linux-list@redhat.com>; Fri, 27 Feb 2009 15:23:07 -0500
Received: from outbound3.ucsd.edu (outbound3.ucsd.edu [132.239.1.207])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1RKLrqC020730
	for <video4linux-list@redhat.com>; Fri, 27 Feb 2009 15:21:53 -0500
Message-ID: <49A84B5A.8020007@ucsd.edu>
Date: Fri, 27 Feb 2009 12:21:46 -0800
From: Clinton Winant <cwinant@ucsd.edu>
MIME-Version: 1.0
To: "U. Artie Eoff" <uartie@gmail.com>
References: <6b3e6cdb0902271139w176708c9t67b32dca960aa6c4@mail.gmail.com>	<412bdbff0902271142i5c7157cetd28124007224b890@mail.gmail.com>
	<6b3e6cdb0902271207k77e41cabo11fb3263ef39fe5d@mail.gmail.com>
In-Reply-To: <6b3e6cdb0902271207k77e41cabo11fb3263ef39fe5d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: ASUS My Cinema-PHC3-100/NAQ/FM/AV/RC Support?
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

I do have the U3100-atsc dongle working withh a eee pc and xandros.
After a fair amount of digging around, I found these two drivers on the 
asus site:

v4ldvbpb_1.7_i386.deb

kaffeine-dtv_0.8.7-2_i386.deb

It sort of works,

U. Artie Eoff wrote:
> Thanks for the quick reply...
>
> The only difference that I'm aware of so far is that the 3100 is a USB
> dongle tuner and the PHC3-100 is a PCI internal.  I'm not sure if the
> PHC3-100 has the Micronas DRX-J... can I find this info on the card?  If so,
> I'll have to look when I get home later.
>
> Anyway, here is the product link for my card:
> http://www.asus.com/products.aspx?l1=18&l2=83&l3=794
> ...and product image:
> http://www.asus.com/prog_content/middle_enlargement.aspx?model=2524
>
> Thanks,
>
> Artie
>
>
> On Fri, Feb 27, 2009 at 12:42 PM, Devin Heitmueller <
> devin.heitmueller@gmail.com> wrote:
>
>   
>> On Fri, Feb 27, 2009 at 2:39 PM, U. Artie Eoff <uartie@gmail.com> wrote:
>>     
>>> I recently purchased a ASUS My Cinema-PHC3-100/NAQ/FM/AV/RC ATSC tv tuner
>>> card.  I've done some searching to see what kind of support is available
>>>       
>> for
>>     
>>> using it under Linux.  There is nothing out there that mentions it will
>>>       
>> work
>>     
>>> or how to get it to work.  And it does not appear that my Fedora OS
>>>       
>> detects
>>     
>>> it installed.  Could someone start me off with some steps on getting it
>>> configured (i.e. drivers, detecting, loading, configuring, etc.).  I
>>> consider myself a somewhat advanced user of Linux, but have never done
>>>       
>> any
>>     
>>> direct work with tuner cards or general low-level hardware configuration
>>> under Linux.  So, don't hesitate to explain in technical terms if it is
>>> easier.
>>>       
>> Assuming you're referring to the same ASUS My Cinema 3100 I'm thinking
>> of, that's a device with a Micronas DRX-J, which won't see any Linux
>> support anytime soon (due to licensing issues).
>>
>> Regards,
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller
>> http://www.devinheitmueller.com
>> AIM: devinheitmueller
>>
>>     
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
