Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8B0riNe013944
	for <video4linux-list@redhat.com>; Wed, 10 Sep 2008 20:53:45 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8B0rW7Z000912
	for <video4linux-list@redhat.com>; Wed, 10 Sep 2008 20:53:33 -0400
Received: by ti-out-0910.google.com with SMTP id 24so37873tim.7
	for <video4linux-list@redhat.com>; Wed, 10 Sep 2008 17:53:31 -0700 (PDT)
Message-ID: <48C86B2C.1070700@gmail.com>
Date: Thu, 11 Sep 2008 08:49:48 +0800
From: jianpu <james.s.pu@gmail.com>
MIME-Version: 1.0
To: gert.vervoort@hccnet.nl
References: <48C7AB77.4070701@gmail.com>
	<03e3cf39db553255525915ca0e5919f1.squirrel@webmail.hccnet.nl>
In-Reply-To: <03e3cf39db553255525915ca0e5919f1.squirrel@webmail.hccnet.nl>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7121 driver?
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

gert.vervoort@hccnet.nl wrote:
> Op Wo, 10 september, 2008 1:11 pm schreef jianpu:
>   
>> hi, is  there any saa7121 driver  for linux?  i  will use  saa7121 chip,
>> but  i  can't  find  a  driver.  there  is  just  a  saa7121.h in  the
>> kernel. Thank you in advance
>>     
>
> The header file is being used by the Stradis MPEG-2 decoder driver:
> drivers/media/video/stradis.c and in this file there is a function
> initialize_saa7121().
>
>    Gert
>
>
>
>
>
>   
Thanks,  Gert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
