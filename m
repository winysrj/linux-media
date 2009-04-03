Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n33FAXPW014365
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 11:10:33 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.28])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n33FADdj027861
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 11:10:14 -0400
Received: by yx-out-2324.google.com with SMTP id 8so655525yxm.81
	for <video4linux-list@redhat.com>; Fri, 03 Apr 2009 08:10:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d9def9db0904030755i1ea5c514p23f2556f37578a48@mail.gmail.com>
References: <49D610CC.6070405@powercraft.nl>
	<412bdbff0904030747s3d1e956al168cc75b0208a3f0@mail.gmail.com>
	<d9def9db0904030755i1ea5c514p23f2556f37578a48@mail.gmail.com>
Date: Fri, 3 Apr 2009 11:10:13 -0400
Message-ID: <412bdbff0904030810i477b2cffp2f753c9ad66b9564@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: request list of usb dvb-t devices that work with vanilla 2.6.29
	kernel
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

On Fri, Apr 3, 2009 at 10:55 AM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> There are already some business customers who deployed Micronas based solutions
> in a legal way.
>
>> 2.  A lack of interest on the part of developers with access to DVB-T.
>>  While support for ATSC based em28xx devices has grown considerably in
>> the last year, there doesn't seem to be any developers with DVB-T who
>> are interested in doing the work.  Many of the devices in question
>> could be made to work with relatively little effort, but a developer
>> needs to do the work to add the device profile (including the GPIOs)
>> and iron out any integration bugs.  There haven't been any developers
>> with both the hardware and access to DVB-T interested in stepping up
>> to the task.
>>
>
> We currently make use of the crossover driver solution which moves the
> drivers into userland
> and even makes them work with the existing in-kernel as well as with
> other unix based operating
> systems. There are plenty of advantages starting with we can provide
> one single driver for multiple
> kernel versions - as long as the USB ID is in the driver the userland
> crossoversolution will work with it
> and improve its functionality.
>
> Regards,
> Markus

Just to be clear so that there is no confusion for other readers,
Markus is talking about a closed source product offering.  For people
who don't care about open versus closed source, then this is certainly
an option for them to explore.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
