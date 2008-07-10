Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6ADQc2H018434
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 09:26:38 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6ADQSNv002023
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 09:26:28 -0400
Received: by py-out-1112.google.com with SMTP id a29so1783932pyi.0
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 06:26:28 -0700 (PDT)
Message-ID: <d9def9db0807100626q22a679a3k5da17300e917c067@mail.gmail.com>
Date: Thu, 10 Jul 2008 15:26:27 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <20080710151215.1b86a0e4@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710132337.11ca4706@hyperion.delvare>
	<d9def9db0807100533u4a765210k8cce4b5ce5bec703@mail.gmail.com>
	<20080710151215.1b86a0e4@hyperion.delvare>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] tvaudio: Stop I2C driver ID abuse
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

On Thu, Jul 10, 2008 at 3:12 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Markus,
>
> On Thu, 10 Jul 2008 14:33:29 +0200, Markus Rechberger wrote:
>> On Thu, Jul 10, 2008 at 1:23 PM, Jean Delvare <khali@linux-fr.org> wrote:
>> > The tvaudio driver is using "official" I2C device IDs for internal
>> > purpose. There must be some historical reason behind this but anyway,
>> > it shouldn't do that. As the stored values are never used, the easiest
>> > way to fix the problem is simply to remove them altogether.
>> >
>> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
>>
>> how would you identify what chip driver is attached in the
>> attach_inform callback, using string compare to the name?
>> using the ID was more comfortable actually, but I understand your
>> point for removing it too.
>
> attach_inform doesn't know anything about struct CHIPDESC as defined by
> the tvaudio driver, in which the IDs in question were stored. The
> driver ID which attach_inform knows and cares about is
> client->driver-id, which is properly set to I2C_DRIVERID_TVAUDIO by the
> tvaudio driver. My patch doesn't change that.
>

ah thanks, I mistaked that one.

Markus

> Note that my patch is really only removing dead code. These IDs were
> simply never used.
>
> Thanks,
> --
> Jean Delvare
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
