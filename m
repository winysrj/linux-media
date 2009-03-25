Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2PAHnhm015533
	for <video4linux-list@redhat.com>; Wed, 25 Mar 2009 06:17:49 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2PAHRsw002905
	for <video4linux-list@redhat.com>; Wed, 25 Mar 2009 06:17:28 -0400
Received: from g225196243.adsl.alicedsl.de ([92.225.196.243]
	helo=[192.168.0.124]) by mail.uni-paderborn.de with esmtpsa
	(TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.63 chapek-ix)
	id 1LmQAo-0006nd-4X
	for video4linux-list@redhat.com; Wed, 25 Mar 2009 11:17:27 +0100
Message-ID: <49CA0542.3090403@campus.upb.de>
Date: Wed, 25 Mar 2009 11:19:46 +0100
From: David Woitkowski <jarrn@campus.upb.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <49C9698C.10607@campus.upb.de>
	<d9def9db0903241802j2c39d30an27ea1ff2006b4ff7@mail.gmail.com>
In-Reply-To: <d9def9db0903241802j2c39d30an27ea1ff2006b4ff7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Cinergy Hybrid T USB XS (0ccd:0042) not working
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

Markus Rechberger schrieb:
> On Wed, Mar 25, 2009 at 12:15 AM, David Woitkowski <jarrn@campus.upb.de> wrote:
>> I'm currently fiddling around with my Terratec Cinergy Hybrid T USB XS
>>
>> $ lsusb
>> Bus 008 Device 007: ID 0ccd:0042 TerraTec Electronic GmbH Cinergy Hybrid
>> T XS
>>
>> $ uname -r
>> 2.6.27-11-generic
>> (it's a ubuntu 8.10 machine)
> 
> I have that device here, I guess it's an issue with the zl10353 or
> mt352 which is in the kernel because it already worked for a very long
> time :-)
> I'll check it within the next 2 days.

Okay, thanks for your quick response. Tell me if you need more 
information on that issue.

David

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
