Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8CAYP98012018
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 06:34:26 -0400
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8CAYDwE025408
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 06:34:13 -0400
Received: by rn-out-0910.google.com with SMTP id k32so587172rnd.7
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:34:13 -0700 (PDT)
Message-ID: <3192d3cd0809120334r1fc41715ldcac02e0d3d39b25@mail.gmail.com>
Date: Fri, 12 Sep 2008 10:34:12 +0000
From: "Christian Gmeiner" <christian.gmeiner@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
In-Reply-To: <3192d3cd0809101046t62b3cb48w2c1d2af4b471b6b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3192d3cd0809100508v7da001d1oacd8fe076be5db5@mail.gmail.com>
	<3192d3cd0809101046t62b3cb48w2c1d2af4b471b6b0@mail.gmail.com>
Subject: Re: Extending current adv717x drivers
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

I have looked for a plan how to get all my wishes in the kernel an I came to
this roadmap:

1) Add support for v4l2 to all i2c used chips of the zoran driver
2) Switch zoran dirver to use 4vl2 for en/decoders
3) Remove v4l1 stuff from all i2c used chips of the zoran driver

If I am at this point, I can start thinking about how to extend the drivers, for
my needs.

Hope you agree with this three step plan.
greets

2008/9/10 Christian Gmeiner <christian.gmeiner@gmail.com>:
> So...
>
> I have stared to convert the adv7175 driver to v4l2 but I am not sure
> if its okay. Also there exist
> a driver which must be changed to the new api.
>
> So please give me feedback....
>
>
> 2008/9/10 Christian Gmeiner <christian.gmeiner@gmail.com>:
>> Hi all,
>>
>> I am one of the supporters of the dxr3 drivers for Linux [0]. The big
>> goal is it to get the driver ready
>> for the mainline kernel. As this needs lot of work to be done, I will
>> start with one of the top items
>> of my todo list. Extending current adv717x drivers with new functionality.
>>
>> As you can see here [1] and [2] the adv717x driver offers some more
>> functions, which are needed
>> for the dxr3 driver - e.g. switching pixel port between 8-bit
>> multiplexed YCrCb and 16 bit YCrCb.
>>
>> The current drivers used v4l1 include and so I had a look at the v4l2
>> api but I am not sure how such
>> a driver can be switched to v4l2. If this is not the case, whats the
>> best way to "merge" dxr3s driver
>> with the in-kernel driver?
>>
>> [0] http://dxr3.sf.net
>> [1] http://dxr3.sourceforge.net/hg/em8300-nboullis/file/37328a436d49/modules/adv717x.c
>> [2] http://dxr3.sourceforge.net/hg/em8300-nboullis/file/37328a436d49/modules/adv717x.h
>>
>>
>> Thanks for your help,
>> --
>> BSc, Christian Gmeiner
>>
>
>
>
> --
> Christian Gmeiner, B.Sc.
>



-- 
Christian Gmeiner, B.Sc.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
