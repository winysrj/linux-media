Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1HGcnTI014629
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 11:38:49 -0500
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1HGcdhs025043
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 11:38:39 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1081860yxm.81
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 08:38:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902110810.46825.hverkuil@xs4all.nl>
References: <8ef00f5a0812171449o19fe5656wec05889b738e7aed@mail.gmail.com>
	<20081231081243.0cecad1d@pedra.chehab.org> <495D7A51.40102@gmail.com>
	<200902110810.46825.hverkuil@xs4all.nl>
Date: Tue, 17 Feb 2009 13:38:38 -0300
Message-ID: <8ef00f5a0902170838o7557c93bl89e75055aae1db3c@mail.gmail.com>
From: Fabio Belavenuto <belavenuto@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add TEA5764 radio driver
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

> Hi Fábio,
>
> Any progress on this?
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>

Hi,

The tea5764 tuner driver is ready, but am having problems with
radio-tea5764 driver to load the tuner driver and the
i2c_clients_command call with the command TUNER_SET_TYPE_ADDR, the
tuner driver is not registered and makes the probe, I am investigating
the tree v4l2.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
