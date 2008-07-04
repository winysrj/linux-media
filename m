Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m64Bk1IW023056
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 07:46:01 -0400
Received: from smtp0.lie-comtel.li (smtp0.lie-comtel.li [217.173.238.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m64BjnF2032171
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 07:45:50 -0400
Message-ID: <486E0D71.9020106@kaiser-linux.li>
Date: Fri, 04 Jul 2008 13:45:53 +0200
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <486E023A.6010801@hhs.nl>
In-Reply-To: <486E023A.6010801@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
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

Hans de Goede wrote:
> The proper fix for this would be to lower the compression balance 
> setting when
> in 352x288 mode. The problem with this is that when the compression 
> balance
> gets lowered below 0x80, the pac207 starts using a different compression
> algorithm for some lines, these lines get prefixed with a 0x2dd2 prefix
> and currently we do not know how to decompress these lines, so for now
> we use a minimum exposure value of 5
Hello Hans

Can you post some frames with a lower compression balance, please? Then 
other people can take a look at the decoding ;-)

Thomas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
