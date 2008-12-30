Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUMWxDj019087
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 17:32:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBUMWhOL004850
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 17:32:43 -0500
Date: Tue, 30 Dec 2008 20:32:35 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Fabio Belavenuto" <belavenuto@gmail.com>
Message-ID: <20081230203235.1b7eecf3@pedra.chehab.org>
In-Reply-To: <8ef00f5a0812171449o19fe5656wec05889b738e7aed@mail.gmail.com>
References: <8ef00f5a0812171449o19fe5656wec05889b738e7aed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

On Wed, 17 Dec 2008 20:49:33 -0200
"Fabio Belavenuto" <belavenuto@gmail.com> wrote:

> Add support for radio driver TEA5764 from NXP.
> This chip is connected in pxa I2C bus in EZX phones
> from Motorola, the chip is used in phone model A1200.
> This driver is for OpenEZX project (www.openezx.org)
> Tested with A1200 phone, openezx kernel and fm-tools

Hi Fabio,

I've committed the patch. Thanks!

I had to do a few changes, since V4L now have their own fops definition, due to
a patch that I've just merged. 

Could you please test and confirm if the changes I made didn't affect the driver?

Ah, I also fixed 3 small codingsyle violations.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
