Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9GJTKLk019567
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 15:29:20 -0400
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9GJTAAQ003023
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 15:29:11 -0400
Received: by gv-out-0910.google.com with SMTP id n8so94236gve.13
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 12:29:10 -0700 (PDT)
Message-ID: <37219a840810161229p3f0b1048v9dfccd857bffd813@mail.gmail.com>
Date: Thu, 16 Oct 2008 15:29:10 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "David Ellingsworth" <david@identd.dyndns.org>
In-Reply-To: <30353c3d0810161217l33b3726frc1a2d99a912e6ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
	<30353c3d0810161217l33b3726frc1a2d99a912e6ed@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: [patch] radio-mr800: remove warn- and err- messages
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

> 2008/10/16 Alexey Klimov <klimov.linux@gmail.com>:
>> Hello, all
>>
>> radio-mr800: remove warn and err messages
>>
>> Patch removes warn() and err()-statements in radio/radio-mr800.c,
>> because of removing this macros from USB-subsystem.
>>
>> --
>> Best regards, Klimov Alexey
>>

On Thu, Oct 16, 2008 at 3:17 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> I NACK this patch, please reformat to use dev_warn and dev_err rather
> than using printk. Ideally all drivers should use the dev_ macros when
> possible and the pr_ macros otherwise. See the device.h and kernel.h
> for more information.
>
> Regards,
>
> David Ellingsworth

David,

Quoting policy on this mailing list is to write your reply below the
quoted text -- please stick with this for the future.

Meanwhile, I agree with David, in that the macros should be corrected
to the official macros, rather than simply being deleted.

Also, a patch wont go very far without a sign-off.  Please see the
following for the requirements on a patch for kernel submission:

http://linuxtv.org/hg/v4l-dvb/file/tip/README.patches

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
