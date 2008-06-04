Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m54NFWNi027673
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 19:15:32 -0400
Received: from mailhub3.uq.edu.au (mailhub3.uq.edu.au [130.102.148.131])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m54NFGru016762
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 19:15:18 -0400
In-Reply-To: <43192.2143.qm@web35602.mail.mud.yahoo.com>
References: <43192.2143.qm@web35602.mail.mud.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <50DB802A-A6E7-4E9C-B2BF-0841F4DD6886@uq.edu.au>
Content-Transfer-Encoding: 7bit
From: Christoph Willing <c.willing@uq.edu.au>
Date: Thu, 5 Jun 2008 09:15:10 +1000
To: Sam Logen <starz909@yahoo.com>
Cc: video4linux-list@redhat.com,
	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: Question - Component input via software card
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


On 05/06/2008, at 8:33 AM, Sam Logen wrote:

>
> --- Daniel Gimpelevich
> <daniel@gimpelevich.san-francisco.ca.us> wrote:
>
>> Sam Logen <starz909 <at> yahoo.com> writes:
>>
>>>  Would it be possible to connect component cables
>> from
>>> a high def. video source to the video and audio
>>> composite plugs of the capture card, and have a
>>> program process the three streams together as
>> video
>>> streams instead of video and audio streams, then
>> save
>>> the result in a file?
>>
>> That would not be possible with any off-the-shelf
>> composite capture card, but it
>> would be possible to design your own capture
>> hardware that could use the same
>> plugs for either audio or component video. Just
>> getting a Hauppauge HD-PVR would
>> likely be cheaper.


Another relatively cheap option for HD component input is the  
Blackmagic Intensity Pro - see:
	http://www.blackmagic-design.com/products/intensity/
It has HDMI input too.

Unfortunately they don't provide a Linux driver and have stated  
they're not interested in doing so. Any chance of producing a driver  
without their help?



chris


Christoph Willing
University of Queensland




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
