Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0L3EBIH015636
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 22:14:12 -0500
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0L3E5GV008134
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 22:14:05 -0500
Received: by yx-out-2324.google.com with SMTP id 31so1369350yxl.81
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 19:14:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <96DA7A230D3B2F42BA3EF203A7A1B3B50128BC0919@dlee07.ent.ti.com>
References: <A24693684029E5489D1D202277BE89441DD73588@dlee02.ent.ti.com>
	<96DA7A230D3B2F42BA3EF203A7A1B3B50128BC0919@dlee07.ent.ti.com>
Date: Wed, 21 Jan 2009 04:14:04 +0100
Message-ID: <d9def9db0901201914ib5cb281q699d1ee2d0bbd20a@mail.gmail.com>
From: Markus Rechberger <mrechberger@gmail.com>
To: "Curran, Dominic" <dcurran@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: Appropriate interface ?
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

On Wed, Jan 21, 2009 at 1:49 AM, Curran, Dominic <dcurran@ti.com> wrote:
>
> Hi
> I apologies for slightly off-topic question.
>
> I have a camera which consists of three separate i2c slave devices on the same i2c bus:
>  - sensor              (V4L2 interface)
>  - piezo len driver    (V4L2 interface)
>  - EEPROM (512 bytes)         ?
>
> The EEPROM is written with factory settings (sensor & lens info).
> It is meant to be read-only.
>
> Can anyone suggest an appropriate interface to usermode for the EEPROM ?
> Should I implement sysfs interface ?
> Or is there something more appropriate.
>

you might use i2c-dev, you should be able to discover the correct i2c
node through sysfs.

regards,
Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
