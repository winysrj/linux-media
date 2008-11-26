Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAQ9AmDW006751
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 04:10:48 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAQ9AbhL012399
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 04:10:38 -0500
Received: by wf-out-1314.google.com with SMTP id 25so382261wfc.6
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 01:10:37 -0800 (PST)
Message-ID: <62e5edd40811260110pacffdf7v15e4ddabc587399@mail.gmail.com>
Date: Wed, 26 Nov 2008 10:10:37 +0100
From: "=?ISO-8859-1?Q?Erik_Andr=E9n?=" <erik.andren@gmail.com>
To: "Chia-I Wu" <olvaffe@gmail.com>
In-Reply-To: <20081126074633.GA11305@m500.domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081126074633.GA11305@m500.domain>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] gspca-stv06xx: Overhaul the HDCS driver.
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

2008/11/26 Chia-I Wu <olvaffe@gmail.com>:
> Hi Erik,
>
> This patch (against r9689) overhauls HDCS driver and make 046d:0840
> work.  Please help review and apply, if it is ok.  Thanks.
>
> --
> Regards,
> olv
>

Thanks, I'll review and commit it ASAP.
Do you still get a black and white image or does it work in color?

Regards,
Erik

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
