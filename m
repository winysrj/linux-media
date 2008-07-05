Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m65JoXA5027302
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 15:50:33 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m65JoIH0030467
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 15:50:19 -0400
Message-ID: <486FD209.5020709@hhs.nl>
Date: Sat, 05 Jul 2008 21:56:57 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thomas Kaiser <linux-dvb@kaiser-linux.li>
References: <486E023A.6010801@hhs.nl> <486E0D71.9020106@kaiser-linux.li>
In-Reply-To: <486E0D71.9020106@kaiser-linux.li>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	"bertrik@sikken.nl >> Bertrik Sikken" <bertrik@sikken.nl>
Subject: Re: PATCH: gspca-pac207-fix-daylight-frame-decode-errors.patch
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

Thomas Kaiser wrote:
> Hans de Goede wrote:
>> The proper fix for this would be to lower the compression balance 
>> setting when
>> in 352x288 mode. The problem with this is that when the compression 
>> balance
>> gets lowered below 0x80, the pac207 starts using a different compression
>> algorithm for some lines, these lines get prefixed with a 0x2dd2 prefix
>> and currently we do not know how to decompress these lines, so for now
>> we use a minimum exposure value of 5
> Hello Hans
> 
> Can you post some frames with a lower compression balance, please? Then 
> other people can take a look at the decoding ;-)
> 

Done, if you go here:
http://people.atrpms.net/~hdegoede/

You will see about 20 imgXX.raw's, which are pac207 compressed bayer images, 
including lines starting with the 0x2dd2 prefix.

When decoded they should show a hand (mine) at the top of the screen holding a 
lucky lucky comic in front of the cam.

Note this is not me being shy, but I needed a high contrast image which was 
hard to compress to trigger the bug :)

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
