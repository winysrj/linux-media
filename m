Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3OCN8BM010957
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 08:23:08 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [217.30.184.167])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3OCMpcm024655
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 08:22:51 -0400
Message-ID: <49F1AF15.8000304@iki.fi>
Date: Fri, 24 Apr 2009 15:22:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
References: <49F189BC.5090606@powercraft.nl> <49F1ADF3.2030901@iki.fi>
In-Reply-To: <49F1ADF3.2030901@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [not working] Conceptronic USB 2.0 Digital TV Receiver -
 CTVDIGRCU - Device Information
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

On 04/24/2009 03:17 PM, Antti Palosaari wrote:
> On 04/24/2009 12:43 PM, Jelle de Jong wrote:
>> Hello everybody,
>>
>> Apparently I was feeling a bit masochistic today, because I bought a new
>> usb dvb-t device with the hope it would work on my 2.6.26 kernel because
>> the 2.6.29 is extreme instable and my Digittrade DVB-T USB Stick (Afatech
>> DVB-T) (af9015.fw) does not work with mplayer which is a requirement
>> for me.
>>
>> So I bought a Conceptronic USB 2.0 Digital TV Receiver - CTVDIGRCU, but
>> it does not work. Would somebody willing to get this device working? I
>> can sent the device to you if you like.
>>
>> The device information is attached in this email.
>
> It is supported.

Oops, it is not supported. You have hw version 2, supported one is hw 
version 3. I will add this usb id soon. Thanks.

> http://linuxtv.org/hg/~anttip/af9015/rev/d4274bbb8605
>
> Please install latest v4l-dvb -drivers.

regards
Antti
-- 
http://palosaari.fi/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
