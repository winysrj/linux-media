Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9KGj5YF032077
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 12:45:05 -0400
Received: from unifiedpaging.messagenetsystems.com
	(mail.emergencycommunicationsystems.com [24.123.23.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9KGisL8028868
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 12:44:54 -0400
Message-ID: <48FCB570.2050906@messagenetsystems.com>
Date: Mon, 20 Oct 2008 12:44:32 -0400
From: Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <48FAA9A1.3090906@myecho.ca> <48FC9F9D.5030107@linuxtv.org>
In-Reply-To: <48FC9F9D.5030107@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: hvr950q analog support
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

Steven Toth wrote:
> Jacek Pawlowski wrote:
>> Hi,
>> The digital part for hvr950a works fine (driver au0828).  From other 
>> posts it looks like the analog part is nor ready yet.  Will be  the 
>> analog part for HVR950q (2040:7200) ready soon (or maybe it is 
>> already available and I just don't know how to set it up :-) - I am 
>> running 2.6.26.5-28.fc8 x86_64
>
> Nobody is working on analog support, as far as I know.
>
> - Steve
>
> -- 
> video4linux-list mailing list
> Unsubscribe 
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>
I have both the HVR950 and HVR950Q.  Analog works fine on the HVR950 as 
does terrestrial digital (8VSB ATSC).  However, on the HVR950Q only 
digital works for both terrestrial (8VSB ATSC) and cable (QAM256).  Are 
there any plans to have someone work on analog for the HVR950Q?

-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
