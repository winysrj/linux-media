Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:50627 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbZK2LTo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 06:19:44 -0500
Message-ID: <4B1258D2.7060706@freemail.hu>
Date: Sun, 29 Nov 2009 12:19:46 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca main: reorganize loop
References: <4B124BDF.50309@freemail.hu> <20091129113834.6b47767a@tele>
In-Reply-To: <20091129113834.6b47767a@tele>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Sun, 29 Nov 2009 11:24:31 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> From: Márton Németh <nm127@freemail.hu>
>>
>> Eliminate redundant code by reorganizing the loop.
>>
>> Signed-off-by: Márton Németh <nm127@freemail.hu>
>> ---
>> diff -r 064a82aa2daa linux/drivers/media/video/gspca/gspca.c
>> --- a/linux/drivers/media/video/gspca/gspca.c	Thu Nov 26
>> 19:36:40 2009 +0100 +++
>> b/linux/drivers/media/video/gspca/gspca.c	Sun Nov 29 11:09:33
>> 2009 +0100 @@ -623,12 +623,12 @@ if (ret < 0)
>>  			goto out;
>>  	}
>> -	ep = get_ep(gspca_dev);
>> -	if (ep == NULL) {
>> -		ret = -EIO;
>> -		goto out;
>> -	}
>>  	for (;;) {
>> +		ep = get_ep(gspca_dev);
>> +		if (ep == NULL) {
>> +			ret = -EIO;
>> +			goto out;
>> +		}
>>  		PDEBUG(D_STREAM, "init transfer alt %d",
>> gspca_dev->alt); ret = create_urbs(gspca_dev, ep);
>>  		if (ret < 0)
>> @@ -677,12 +677,6 @@
>>  			ret =
>> gspca_dev->sd_desc->isoc_nego(gspca_dev); if (ret < 0)
>>  				goto out;
>> -		} else {
>> -			ep = get_ep(gspca_dev);
>> -			if (ep == NULL) {
>> -				ret = -EIO;
>> -				goto out;
>> -			}
>>  		}
>>  	}
>>  out:
> 
> Hello Márton,
> 
> As you may see, in the loop, get_ep() is called only when isoc_nego()
> is not called. So, your patch does not work.

You are right, I overseen that.

Is there any subdriver where the isoc_nego() is implemented? I couldn't find
one. What would be the task of the isoc_nego() function? Should it set
the interface by calling usb_set_interface() as the get_ep() does? Should
it create URBs for the endpoint?

Although I found the patch where the isoc_nego() was introduced
( http://linuxtv.org/hg/v4l-dvb/rev/5a5b23605bdb56aec86c9a89de8ca8b8ae9cb925 )
it is not clear how the "ep" pointer is updated when not the isoc_nego() is
called instead of get_ep() in the current implementation.

Regards,

	Márton Németh
