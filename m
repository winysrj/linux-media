Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIKDv1K010002
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 15:13:57 -0500
Received: from mail-qy0-f21.google.com (mail-qy0-f21.google.com
	[209.85.221.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBIKDf6O006997
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 15:13:41 -0500
Received: by qyk14 with SMTP id 14so559194qyk.3
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 12:13:41 -0800 (PST)
Message-ID: <494ABD00.8070106@gmail.com>
Date: Thu, 18 Dec 2008 18:13:36 -0300
From: =?ISO-8859-1?Q?F=E1bio_Belavenuto?= <belavenuto@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <8ef00f5a0812171449o19fe5656wec05889b738e7aed@mail.gmail.com>
	<200812181252.24661.hverkuil@xs4all.nl>
In-Reply-To: <200812181252.24661.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add TEA5764 radio driver
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

Hans Verkuil escreveu:
> Hi Fabio,
>
> On Wednesday 17 December 2008 23:49:33 Fabio Belavenuto wrote:
>   
>> Add support for radio driver TEA5764 from NXP.
>> This chip is connected in pxa I2C bus in EZX phones
>> from Motorola, the chip is used in phone model A1200.
>> This driver is for OpenEZX project (www.openezx.org)
>> Tested with A1200 phone, openezx kernel and fm-tools
>>
>> Signed-off-by: Fabio Belavenuto <belavenuto@gmail.com>
>>
>>  drivers/media/radio/Kconfig         |   19 +
>>  drivers/media/radio/Makefile        |    1 +
>>  drivers/media/radio/radio-tea5764.c |  641
>> +++++++++++++++++++++++++++++++++++ 3 files changed, 661 insertions(+), 0
>> deletions(-)
>>
>>     
>
> I'm sorry, but this isn't the right approach. This chip is a radio tuner and 
> as such can be used in many other products. So the tea5764 driver should be 
> implemented as a tuner driver instead. See drivers/media/common/tuners for 
> other such drivers, including the close cousins tea5761 and tea5767.
>
> Next to that you need a v4l radio driver for this platform that loads the 
> tuner module and sets it up correctly.
>
> Basically this driver needs to be split into a tuner driver and a v4l driver 
> for this platform.
>
> The big advantage is that the tea5764 driver can be reused in other 
> products, and also that it is easy to change the v4l driver if another 
> tuner chip is chosen in the future.
>
> BTW, it might be possible that the tea5764 is very similar to the existing 
> tea radio drivers. In that case you might want to consider adding support 
> for this new variant to an existing driver, rather than creating a new 
> driver. I've never looked at the datasheets for these chips, so I don't 
> know how feasible that is.
>
> Regards,
>
> 	Hans
>
>   

Thank you, I understand, I will do so.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
