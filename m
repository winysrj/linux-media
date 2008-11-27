Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARI2Umv013157
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 13:02:30 -0500
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mARI20MK028125
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 13:02:01 -0500
Message-ID: <492EE208.7010903@hhs.nl>
Date: Thu, 27 Nov 2008 19:08:08 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
References: <492B15E1.2080207@gmail.com> <20081125082002.GC18787@m500.domain>	
	<492E7906.905@redhat.com>
	<62e5edd40811270351o7ae92605ra2e46ec5e9ee94fa@mail.gmail.com>
In-Reply-To: <62e5edd40811270351o7ae92605ra2e46ec5e9ee94fa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Hans de Goede <hdegoede@redhat.com>, video4linux-list@redhat.com,
	noodles@earth.li, qce-ga-devel@lists.sourceforge.net
Subject: Re: Please test the gspca-stv06xx branch
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

Erik Andrén wrote:
> 2008/11/27 Hans de Goede <hdegoede@redhat.com>:

<snip>

>> I've solved this be creating 2 separate stv06xx_write_sensor functions:
>> typedef u8 u8_pair[2];
>> typedef u16 u16_pair[2];
>>
>> int stv06xx_write_sensor_bytes(struct sd *sd, const u8_pair *data, int len);
>> int stv06xx_write_sensor_words(struct sd *sd, const u16_pair *data, int
>> len);
>>
>> These functions get passed one or more u8 / u16  pairs where pair[0] is an
>> register-address and pair[1] is the value to write to that register, note
>> that for stv06xx_write_sensor_words() the addresses are in reality still 8
>> bits, they are gettings stored in an u16 for easier coding.
> 
> This is an alternate way of solving the same problem. I think this
> approach is more convoluted without any real gain.
> First you must multiplex the data and addresses by putting them
> together and then demultiplex them in the function.
> Not ideal but also not a big deal.
> 


The gain here is that it is easy to define a single table with address, value 
pairs to init the sensor. Like you've done in stv06xx_vv6410.h, my patch now 
uses that table directly and unmodifed. Imagine what this table would look like 
if you had 2 separate tables for addresses and values, then the resulting table 
declaration_S_ in stv06xx_vv6410.h would make it very hard to see which value 
gets written to which register, so IMHO there is a real and big gain here.

<snip>

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
