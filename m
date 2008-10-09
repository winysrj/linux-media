Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m99KQewp029679
	for <video4linux-list@redhat.com>; Thu, 9 Oct 2008 16:26:40 -0400
Received: from smtp103.biz.mail.re2.yahoo.com (smtp103.biz.mail.re2.yahoo.com
	[68.142.229.217])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m99KQMXX008654
	for <video4linux-list@redhat.com>; Thu, 9 Oct 2008 16:26:22 -0400
Message-ID: <48EE68EB.1060008@migmasys.com>
Date: Thu, 09 Oct 2008 16:26:19 -0400
From: Ming Liu <mliu@migmasys.com>
MIME-Version: 1.0
To: Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
References: <20081009160014.DA2F761AA01@hormel.redhat.com>
	<48EE4FE4.6080002@migmasys.com>
	<48EE6460.1010709@messagenetsystems.com>
In-Reply-To: <48EE6460.1010709@messagenetsystems.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: USB grabber
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

Thank you any way.

After fighting with it in DSL-N for such a long time, I plugged it into 
another fudora system with kernel 2-6-22. The em28XX driver can pick it 
up automatically. Since I have very limited resources and can not afford 
a big OS, I prefer to compile the driver for my DSL-N. However, I got a 
feeling form my search that I will have to use kernel higher than 2-6-16 
to use the driver. So I am looking for a solution for old kernels. I 
prefer kernel 2-4-26 for DSL, or 2-6-12 for DSL-N.

Thank you.

Sincerely yours
Ming

Robert Vincent Krakora wrote:
> Ming Liu wrote:
>> Hello,
>>
>> I am working on a USB grabber from Campusa. The item number of this 
>> grabber is VC-211A with a S/N 0025544.
>> It relies on an EM 2820 chip.
>>
>> I have a DSL-N system with kernel 2.6.12, and the grabber is not 
>> reflected on the dmesg.
>>
>> Is there any driver available for this grabber? Any example that I 
>> can follow to make it work?
>>
>> Thank you for advance.
>>
>> Sincerely yours
>> Ming
>>
>>
>> -- 
>> video4linux-list mailing list
>> Unsubscribe 
>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>>
> Oops...you mean a video grabber...my bad...
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
