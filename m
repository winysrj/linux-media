Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIKD5kn009652
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 15:13:05 -0500
Received: from mail-qy0-f21.google.com (mail-qy0-f21.google.com
	[209.85.221.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBIKClnV006357
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 15:12:47 -0500
Received: by qyk14 with SMTP id 14so558764qyk.3
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 12:12:47 -0800 (PST)
Message-ID: <494ABCCA.2040103@gmail.com>
Date: Thu, 18 Dec 2008 18:12:42 -0300
From: =?ISO-8859-1?Q?F=E1bio_Belavenuto?= <belavenuto@gmail.com>
MIME-Version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>
References: <8ef00f5a0812171449o19fe5656wec05889b738e7aed@mail.gmail.com>
	<1229565443.8079.56.camel@tux.localhost>
In-Reply-To: <1229565443.8079.56.camel@tux.localhost>
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

Alexey Klimov escreveu:
> Hello, Fabio
> May i tell some suggestion here ?
>
>   
Yes, I appreciate.
> So, you used printk + KBUILD_MODNAME here and then you used it in code.
> As i know(may be i'm wrong) that using KBUILD_MODNAME here is bad.
> Better way is doing something like this:
>
> #define TEA5764_DRIVER_NAME "radio-tea5764"
>
> (defined driver name should be unique)
>
> #define PINFO(format, ...)					\
> 	printk(KERN_INFO TEA5764_DRIVER_NAME": " 		\
> 		DRIVER_VERSION ": " format "\n", ## __VA_ARGS__)
> Later, you can(should?) use TEA5764_DRIVER_NAME in static const struct
> i2c_device_id tea5764_id and in static struct i2c_driver
> tea5764_i2c_driver.
>
> But, really good way is using dev_info, dev_warn, dev_err macros. You
> can look for examples in dsbr100.c or radio-mr800.c. Or in other
> drivers.
>
>   
Thank you, I will use this constant and macros dev_*.
>  
>   
> It will be really nice to hear what other developers think about making
> header file for structures and a lot of defines. Should it go to
> separate .h file ?
>
>
>   
I study on the use of headers, I thought it was complicated to create 
more headlines.
>
> Here. You can insert TEA5764_DRIVER_NAME instead of "radio-tea5764".
>
>   
Ok.
> Please, reformat the patch. All rest code looks good for my eyes.
>
>
>   
Thank you, I will.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
