Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB91Ihdg014490
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 20:18:43 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB91HH1X025978
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 20:18:27 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1008940fga.7
	for <video4linux-list@redhat.com>; Mon, 08 Dec 2008 17:18:27 -0800 (PST)
Message-ID: <30353c3d0812081620v1e633530qa3539888c18a1cda@mail.gmail.com>
Date: Mon, 8 Dec 2008 19:20:18 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Alexey Klimov" <klimov.linux@gmail.com>
In-Reply-To: <208cbae30812081410i37ad8da8ue43f907ad9a54b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228752855.1809.93.camel@tux.localhost>
	<30353c3d0812081403p11f1fcaam1b15a2650f05bcdf@mail.gmail.com>
	<208cbae30812081410i37ad8da8ue43f907ad9a54b@mail.gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] radio-mr800: correct unplug, fix to previous patch
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

On Mon, Dec 8, 2008 at 5:10 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
> On Tue, Dec 9, 2008 at 1:03 AM, David Ellingsworth
> <david@identd.dyndns.org> wrote:
>> This patch looks good, but I think it should remove the now unused
>> user member of the amradio struct as well.
>
> Should i remake this patch now ? Or make one more patch ?
>

I'd make a separate patch. Leaving the users member variable doesn't
cause any harm; removing it is just a driver simplification/cleanup.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
