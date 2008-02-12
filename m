Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1CJP7s8004582
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 14:25:07 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.168])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1CJOkEx016934
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 14:24:47 -0500
Received: by wf-out-1314.google.com with SMTP id 28so248162wfc.6
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 11:24:45 -0800 (PST)
Message-ID: <f62701100802121124n713ea7fbx1add8ae862c3c866@mail.gmail.com>
Date: Tue, 12 Feb 2008 11:24:45 -0800
From: "Trent Piepho" <xyzzy@speakeasy.org>
To: "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <20080212105126.31b1a351@hyperion.delvare>
MIME-Version: 1.0
References: <20080212105126.31b1a351@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] saa7134: Don't support
	I2C_M_NOSTART
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

On Feb 12, 2008 1:51 AM, Jean Delvare <khali@linux-fr.org> wrote:

> I2C adapters should only support I2C_M_NOSTART if they really have to
> (i.e. if they are connected to a broken I2C device which needs this
> deviation from the standard I2C protocol.) As no media chip driver
> uses I2C_M_NOSTART, I don't think that the saa7134 driver needs to
> support it.I2C_M_NOSTART,


There is a chip used on some Osprey bt878 cards, X9221 POT, that does need
I2C_M_NOSTART.

I don't know of any saa7134 cards using that part, but the problem with
removing this code is that the datasheets for saa713x chips isn't
available.  In the m920x case, it's all from reverse engineering.  Suppose
someone does want to support a device that needs this, how will they add
support for it at that time if they don't know how the I2C controller works?
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
