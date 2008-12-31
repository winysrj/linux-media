Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBV9rXwN013983
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 04:53:33 -0500
Received: from smtp-vbr13.xs4all.nl (smtp-vbr13.xs4all.nl [194.109.24.33])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBV9qlOs012440
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 04:52:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Wed, 31 Dec 2008 10:52:40 +0100
References: <8ef00f5a0812171449o19fe5656wec05889b738e7aed@mail.gmail.com>
	<20081230203235.1b7eecf3@pedra.chehab.org>
In-Reply-To: <20081230203235.1b7eecf3@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812311052.40693.hverkuil@xs4all.nl>
Cc: Fabio Belavenuto <belavenuto@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Tuesday 30 December 2008 23:32:35 Mauro Carvalho Chehab wrote:
> On Wed, 17 Dec 2008 20:49:33 -0200
>
> "Fabio Belavenuto" <belavenuto@gmail.com> wrote:
> > Add support for radio driver TEA5764 from NXP.
> > This chip is connected in pxa I2C bus in EZX phones
> > from Motorola, the chip is used in phone model A1200.
> > This driver is for OpenEZX project (www.openezx.org)
> > Tested with A1200 phone, openezx kernel and fm-tools
>
> Hi Fabio,
>
> I've committed the patch. Thanks!
>
> I had to do a few changes, since V4L now have their own fops definition,
> due to a patch that I've just merged.
>
> Could you please test and confirm if the changes I made didn't affect the
> driver?
>
> Ah, I also fixed 3 small codingsyle violations.

Hi Mauro,

Did you see my review of this driver?

(http://lists-archives.org/video4linux/26062-add-tea5764-radio-driver.html)

IMHO this driver shouldn't be added in this form. It's up to you of course 
to decide this, but I just want to make sure you read my posting.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
