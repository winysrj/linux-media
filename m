Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17K3VCn023851
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 15:03:31 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.180])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m17K3Al3012400
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 15:03:11 -0500
Received: by wa-out-1112.google.com with SMTP id j37so28377waf.7
	for <video4linux-list@redhat.com>; Thu, 07 Feb 2008 12:03:10 -0800 (PST)
Message-ID: <1e5fdab70802071203ndbce13an1fa226d5ec3e4ca1@mail.gmail.com>
Date: Thu, 7 Feb 2008 12:03:10 -0800
From: "Guillaume Quintard" <guillaume.quintard@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20080207174703.5e79d19a@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
	<20080207174703.5e79d19a@gaivota>
Cc: video4linux-list@redhat.com
Subject: Re: Question about saa7115
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

On Feb 7, 2008 11:47 AM, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> On Wed, 6 Feb 2008 17:44:05 -0800
> On embedded processors, you generally attach devices directly to the CPU i2c
> bus. In this case, you'll need to implement a host v4l2 module for your
> processor, and use it to access the i2c device.
>

Ok, that's what I feared :-)

anyway, in the saa711x_probe function (in saa7115.c), the "if
(adapter->class & I2C_CLASS_TV_ANALOG)" test always fails as
I2C_CLASS_TV_ANALOG is 2 and adapter->class is 1 (lm sensors), is that
normal ? shouldn't class be 2 ?

Regards

-- 
Guillaume

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
