Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m76Fk4Bv012572
	for <video4linux-list@redhat.com>; Wed, 6 Aug 2008 11:46:04 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m76FjKLi016969
	for <video4linux-list@redhat.com>; Wed, 6 Aug 2008 11:45:54 -0400
Received: by yx-out-2324.google.com with SMTP id 31so163577yxl.81
	for <video4linux-list@redhat.com>; Wed, 06 Aug 2008 08:45:54 -0700 (PDT)
Message-ID: <3634de740808060845x14e00908hd177201c73414162@mail.gmail.com>
Date: Wed, 6 Aug 2008 21:15:54 +0530
From: John <john.maximus@gmail.com>
To: "Jalori, Mohit" <mjalori@ti.com>
In-Reply-To: <8AA5EFF14ED6C44DB31DA963D1E78F0DB58C686C@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3634de740807172215v52a624ga09449e81bb684fe@mail.gmail.com>
	<8AA5EFF14ED6C44DB31DA963D1E78F0DB58C686C@dlee02.ent.ti.com>
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: RE: omap3 camera patches
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

Hello Mohit,
   Using the patches on the omap git kernel. patch applies cleanly.

   Seems like the camera clocks aren't set properly.

   Messages like "Clock cam_mclk didn't enable in 100000 tries" are
displayed during
   boot.

   have you tried with latest git kernel

   trying out with 2.6.26-rc6 results in the same error.

/John


On Sat, Jul 26, 2008 at 8:20 AM, Jalori, Mohit <mjalori@ti.com> wrote:
>> -----Original Message-----
>> From: John [mailto:john.maximus@gmail.com]
>> Sent: Friday, July 18, 2008 12:15 AM
>> To: video4linux-list@redhat.com
>> Subject:
>>
>> Hello,
>>    looking at the OMAP3 camera patches posted sometime back.
>>    I manually applied these patches on a existing OMAP3 2.6.22 kernel.
>>    am trying to port an existing SOC micron driver to OMAP3 on a
>> custom board.
>>    am not seeing any interrupts.
>>
>>   Is anyone using the current camera patches for OMAP3. Is this
>> working?
>>
>>   Are there any existing sensor drivers that use these patches. I find
>> there are no sensor
>>   driver for OMAP3.
>
> I have sent the sensor and lens driver patches. They are also based on 2.6.26. I verified these by applying the original 16 patches and then these 4 new ones.
>
>>
>>
>> Regards,
>>
>> John
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
