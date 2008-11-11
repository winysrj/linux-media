Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABJuQd2011304
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 14:56:26 -0500
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABJuDEG030043
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 14:56:13 -0500
Message-ID: <4919E47E.4000603@hhs.nl>
Date: Tue, 11 Nov 2008 21:01:02 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
References: <20080816050023.GB30725@thumper>	<20080816083613.51071257@mchehab.chehab.org>	<7813ee860808160513g2f0e3602q9f3aed45d66ef165@mail.gmail.com>	<20081105203114.213b599a@pedra.chehab.org>	<20081111184200.cb9a2ba4.ospite@studenti.unina.it>
	<20081111191516.20febe64.ospite@studenti.unina.it>
In-Reply-To: <20081111191516.20febe64.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

Hi,

I'll the real technical reply-ing to Jean Francois Moine, who knows the gspca 
bulk code a lot better then I do.

Antonio Ospite wrote:
> On Tue, 11 Nov 2008 18:42:00 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
> 
>> Actually I've started a port of this driver to gspca as an exercise.

Thanks, good work! Did this reduce the driver in size, iow do you think it 
makes writing usb webcam driver easy, any improvements we could make?

> And here's the direct link to the file, sorry for the tarball:
> http://shell.studenti.unina.it/~ospite/tmp/gspca_ov534-20081111-1733/ov534.c
> 
>> I tried to (ab)use gpsca infrastructure for bulk transfers, the driver is
>> quite essential but it works acceptably well, for now, even if I still
>> loose fames because of some bug.
>>
>> The driver needs the attached changes (or any better equivalent)
>> to gspca bulk transfers code.
> 
> I forgot to say that the changes are against linux-2.6.28-rc4 from linus
> git tree.
> 

If you do gspca based drivers, you will want to use jfmoine's tree as a base:
http://linuxtv.org/hg/~jfrancois/gspca/

Use "hg clone http://linuxtv.org/hg/~jfrancois/gspca/" to get it. hint if you 
don't have the hg command it is part of mercurial.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
