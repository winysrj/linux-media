Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAPDDtj0001378
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 08:13:55 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAPDDin1003565
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 08:13:44 -0500
Received: by wf-out-1314.google.com with SMTP id 25so2649960wfc.6
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 05:13:44 -0800 (PST)
Message-ID: <62e5edd40811250402r3f34c20draa5934d048381d4b@mail.gmail.com>
Date: Tue, 25 Nov 2008 13:02:16 +0100
From: "=?ISO-8859-1?Q?Erik_Andr=E9n?=" <erik.andren@gmail.com>
To: "Chia-I Wu" <olvaffe@gmail.com>
In-Reply-To: <20081125113930.GD18787@m500.domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <492B15E1.2080207@gmail.com> <20081125082002.GC18787@m500.domain>
	<62e5edd40811250322r5f87b35ub6223ead720263a3@mail.gmail.com>
	<20081125113930.GD18787@m500.domain>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, noodles@earth.li,
	qce-ga-devel@lists.sourceforge.net
Subject: Re: Please test the gspca-stv06xx branch
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

2008/11/25 Chia-I Wu <olvaffe@gmail.com>:
> On Tue, Nov 25, 2008 at 12:22:02PM +0100, Erik Andrén wrote:
>> > * stv06xx_write_sensor sends an extra packet unconditionally.  It causes
>> >  the function call return error.
>> Do you mean the extra packet to register 0x1704?
>> It's needed for my quickca
> Yes.  qc-usb sends an entra packet when GET_PRODUCTID(qc)==0x0850.  Does
> your quickcam have product id 0x0850?
>> Wow, thanks for the patch.
>> I'll review and probably commit it later today.
> The patch is primitive and I am planning some refactorings.  I will
> submit again when it's ready.  Maybe you could help review it then :)
>
Focus on the hdcs specific parts, I'll take care of that the LED and
extra packet only is used with the quickcam web.

Regards,
Erik

> --
> Regards,
> olv
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
